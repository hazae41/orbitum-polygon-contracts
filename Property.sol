pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Factory {
    ERC20 public token;
    
    mapping(string => address) propertyByName;
    
    constructor(address _token){
        token = ERC20(_token);
    }
    
    event Create(string name, address owner);
    
    /**
     * Create a new property
     **/
    function create(string calldata _name) external returns (Property) {
        require(propertyByName[_name] == address(0));
        
        Property property = new Property(msg.sender, _name);
        propertyByName[_name] = address(property);
        emit Create(_name, msg.sender);
        
        return property;
    }
    
    /**
     * Retrieve an existing property
     **/
    function get(string calldata _name) external view returns (Property) {
        address addr = propertyByName[_name];
        require(addr != address(0));
        return Property(addr);
    }
}

contract Token is ERC20 {
    address public controller;
    
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        controller = msg.sender;
    }
    
    function mint(address recipient, uint amount) external {
        require(msg.sender == controller);
        _mint(recipient, amount);
    }
    
    function burn(address recipient, uint amount) external {
        require(msg.sender == controller);
        _burn(recipient, amount);
    }
}

contract Property {
    address public owner;
    Factory public factory;
    Token public token;

    constructor(
        address _owner,
        string memory _name
    ) {
        owner = _owner;
        factory = Factory(msg.sender);
        
        string memory fname = factory.token().name();
        string memory name = string(abi.encodePacked(fname,": ", _name));
        
        string memory fsymbol = factory.token().symbol();
        string memory symbol = string(abi.encodePacked(fsymbol,".", _name));
        
        token = new Token(name, symbol);
    }
    
    /**
     * Get the current price of the property
     **/
    function price() public view returns (uint) {
        return token.totalSupply();
    }
    
    event Deposit(address indexed account, uint amount);
    
    /**
     * Deposit some tokens and increase the price
     **/
    function deposit(uint amount) external {
        require(factory.token().transferFrom(
            msg.sender, address(this), amount));
        token.mint(msg.sender, amount);
        emit Deposit(msg.sender, amount);
    }
    
    event Withdraw(address indexed account, uint amount);
    
    /**
     * Withdraw some tokens and decrease the price
     **/
    function withdraw(uint amount) external {
        require(factory.token()
            .transfer(msg.sender, amount));
        token.burn(msg.sender, amount);
        emit Withdraw(msg.sender, amount);
    }
    
    event Buy(address indexed buyer);
    
    /**
     * Buy the property at the current price
     **/
    function buy() external {
        require(msg.sender != owner);
        
        require(factory.token().transferFrom(
            msg.sender, owner, price()));
            
        owner = msg.sender;
        emit Buy(msg.sender);
    }
    
    event Transfer(address indexed target);
    
    /**
     * Transfer the property to someone
     **/
    function transfer(address target) external {
        require(msg.sender == owner);
        require(target != address(0));
        
        owner = target;
        emit Transfer(target);
    }
}
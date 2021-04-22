pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Factory {
    ERC20 public token;
    
    mapping(string => address) propertyByName;
    
    constructor(address _token){
        token = ERC20(_token);
    }
    
    function create(string calldata _name) external returns (Property) {
        require(propertyByName[_name] == address(0));
        
        Property property = new Property(msg.sender, _name);
        propertyByName[_name] = address(property);
        
        return property;
    }
    
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
    )  {
        owner = _owner;
        factory = Factory(msg.sender);
        string memory fsymbol = factory.token().symbol();
        string memory symbol = string(abi.encodePacked(fsymbol,".", _name));
        token = new Token(_name, symbol);
    }
    
    function price() external view returns (uint) {
        return token.totalSupply();
    }
    
    event Deposit(address indexed account, uint amount);
    
    function deposit(uint amount) external {
        require(factory.token().transferFrom(
            msg.sender, address(this), amount));
        token.mint(msg.sender, amount);
        emit Deposit(msg.sender, amount);
    }
    
    event Withdraw(address indexed account, uint amount);
    
    function withdraw(uint amount) external {
        require(factory.token().transferFrom(
            address(this), msg.sender, amount));
        token.burn(msg.sender, amount);
        emit Withdraw(msg.sender, amount);
    }
    
    event Buy(address indexed buyer);
    
    function buy() external {
        require(msg.sender != owner);
        
        uint _price = token.totalSupply();
        require(factory.token().transferFrom(
            msg.sender, address(this), _price));
        token.mint(owner, _price);
            
        owner = msg.sender;
        emit Buy(msg.sender);
    }
    
    event Transfer(address indexed target);
    
    function transfer(address target) external {
        require(msg.sender == owner);
        require(target != address(0));
        
        owner = target;
        emit Transfer(target);
    }
}
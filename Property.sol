pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Factory {
    ERC20 private $token;
    
    mapping (string => Property) private $properties;
    
    constructor(ERC20 _token){
        $token = _token;
    }
    
    function token() external view returns (ERC20) {
        return $token;
    }
    
    event Create(string indexed name, address indexed creator);
    
    function create(string calldata _name) external returns (Property) {
        require($properties[_name] == Property(address(0)));
        
        Property _property = new Property(_name, msg.sender, $token);
        $properties[_name] = _property;
        emit Create(_name, msg.sender);
        
        return _property;
    }
    
    function get(string calldata _name) external view returns (Property) {
        Property property = $properties[_name];
        require(address(property) != address(0));
        return property;
    }
}

contract Property is ERC20 {
    address private $owner;
    ERC20 private $token;
    
    constructor(
        string memory _name,
        address _owner,
        ERC20 _token
    ) ERC20(_name, $token.symbol()) {
        $token = _token;
        $owner = _owner;
    }
    
    function owner() external view returns (address) {
        return $owner;
    }
    
    event Deposit(address indexed account, uint amount);
    
     /**
     * @dev Deposit some tokens and increase the price
     **/
    function deposit(uint _amount) external {
        require(_amount > 0, "Property: invalid amount");
        require($token.transferFrom(msg.sender, address(this), _amount));
        _mint(msg.sender, _amount);
        emit Deposit(msg.sender, _amount);
    }
    
    event Withdraw(address indexed account, uint amount);
    
    /**
     * @dev Withdraw some tokens and decrease the price
     **/
    function withdraw(uint _amount) external {
        require(_amount > 0, "Property: invalid amount");
        require($token.transfer(msg.sender, _amount));
        _burn(msg.sender, _amount);
        emit Withdraw(msg.sender, _amount);
    }
    
    event Buy(address indexed previous, address indexed next);
    
    /**
     * @dev Buy the property at the current price
     **/
    function buy() external {
        require(msg.sender != $owner);
        require($token.transferFrom(msg.sender, $owner, totalSupply()));
            
        emit Buy($owner, msg.sender);
        $owner = msg.sender;
    }
    
    event Send(address indexed previous, address indexed next);
    
    /**
     * @dev Send the property to someone
     **/
    function send(address _target) external {
        require(msg.sender == $owner);
        require(_target != address(0));
        
        emit Buy($owner, _target);
        $owner = _target;
    }
}
pragma solidity ^0.8.0;

import "./Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Factory is Ownable {
    IERC20 public token = IERC20(0x37829530298c28CB7695c172c891eb9CA4F9A0f7);
    
    uint public price = 1 * 10**18;
    
    constructor(){
        owner = msg.sender;
    }
    
    event Price(uint price);
    
    function setPrice(uint _price) external {
        require(msg.sender == owner);
        emit Price(_price);
        price = _price;
    }
    
    event Create(address indexed property, address indexed owner);
    
    function create() external returns (address) {
        require(token.transferFrom(msg.sender, owner, price));
        
        Property property = new Property(msg.sender);
        
        emit Create(address(property), msg.sender);
        
        return address(property);
    }

}

contract Property is Ownable {
    Factory public factory;
    IERC20 public token;
    
    mapping(address => uint) balances;
    
    constructor(address _owner){
        owner = _owner;
        factory = Factory(msg.sender);
        token = factory.token();
    }
    
    function price() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
    
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
    
    event Deposit(address indexed account, uint amount);
    
    function deposit(uint amount) external {
        require(amount > 0);
        
        require(token.transferFrom(msg.sender, address(this), amount));
        
        balances[msg.sender] += amount;
        
        emit Deposit(msg.sender, amount);
    }
    
    event Withdraw(address indexed account, uint amount);
    
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount);
        
        require(token.transfer(msg.sender, amount));
        
        balances[msg.sender] -= amount;
        
        emit Withdraw(msg.sender, amount);
    }

    event Buy(address indexed owner, uint price);
    
    function buy() external {
        require(msg.sender != owner);
        
        uint amount = token.balanceOf(address(this));
        uint fee = amount / 100;
        
        require(token.transferFrom(msg.sender, factory.owner(), fee));
        require(token.transferFrom(msg.sender, owner, amount - fee));
        
        owner = msg.sender;
        
        emit Buy(owner, amount);
    }
}
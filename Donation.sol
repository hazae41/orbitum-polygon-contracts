pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Donation {
    IERC20 public token;
    address payable oracle;
    
    constructor(address _token, address payable _oracle){
        token = IERC20(_token);
        oracle = _oracle;
    }
    
    mapping (string => uint) public pendings;
    
    event Transfer(address indexed sender, string uri, uint amount, uint gas);
    
    /**
     * Called by the user
     **/
    function transfer(string memory uri, uint amount) external payable {
        require(msg.value > 0);
        require(token.transferFrom(msg.sender, address(this), amount));
        emit Transfer(msg.sender, uri, amount, msg.value);
        oracle.transfer(msg.value);
        pendings[uri] += amount;
    }
    
    /**
     * Called by the oracle
     **/
    function flush(string memory uri, address target) external {
        require(msg.sender == oracle);
        uint amount = pendings[uri];
        require(amount > 0);
        require(token.transfer(target, amount));
        pendings[uri] = 0;
    }
}
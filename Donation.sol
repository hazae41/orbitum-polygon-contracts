pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Donation {
    IERC20 public token;
    address oracle;
    
    constructor(address _token, address _oracle){
        token = IERC20(_token);
        oracle = _oracle;
    }
    
    mapping (uint => uint) posts;
    
    event Post(uint indexed id, uint amount, uint gas);
    
    /**
     * Called by the user
     **/
    function post(uint id, uint amount) external payable {
        require(msg.value > 0);
        require(token.transferFrom(msg.sender, oracle, amount));
        emit Post(id, amount, msg.value);
        posts[id] = amount;
    }
    
    /**
     * Called by the oracle
     **/
    function _post(uint id, address target) external {
        require(msg.sender == oracle);
        uint amount = posts[id];
        require(amount > 0);
        require(token.transferFrom(oracle, target, amount));
        posts[id] = 0;
    }
}
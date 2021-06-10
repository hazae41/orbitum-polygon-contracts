pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Donation {
    IERC20 public token;
    address oracle;
    
    constructor(address _token, address _oracle){
        token = IERC20(_token);
        oracle = _oracle;
    }
    
    mapping (string => uint) public pendings;
    
    event Transfer(string indexed uri, uint amount, uint gas);
    
    /**
     * Called by the user
     **/
    function transfer(string memory uri, uint amount) external payable {
        require(msg.value > 0);
        require(token.transferFrom(msg.sender, oracle, amount));
        emit Transfer(uri, amount, msg.value);
        pendings[uri] = amount;
    }
    
    /**
     * Called by the oracle
     **/
    function _transfer(string memory uri, address target) external {
        require(msg.sender == oracle);
        uint amount = pendings[uri];
        require(amount > 0);
        require(token.transferFrom(oracle, target, amount));
        pendings[uri] = 0;
    }
}
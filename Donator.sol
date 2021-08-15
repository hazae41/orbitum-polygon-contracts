pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Donator {
    event Donation(IERC20 indexed token, address indexed sender, address indexed receiver, string uri, uint amount);
    
    function donate(IERC20 token, address payable receiver, string memory uri, uint amount) external {
        require(amount > 0);
        require(token.transferFrom(msg.sender, receiver, amount));
        emit Donation(token, msg.sender, receiver, uri, amount);
    }
}
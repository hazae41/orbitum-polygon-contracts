pragma solidity ^0.8.0;

abstract contract Ownable {
    address public owner;

    constructor () {
        owner = msg.sender;
    }
    
    event Transfer(address indexed owner);
    
    function transfer(address newOwner) public virtual {
        require(newOwner != owner);
        require(newOwner != address(0));
        owner = newOwner;
        emit Transfer(owner);
    }
}
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20Pausable, Ownable {
    constructor() ERC20("Orbitum", "ORBTM") {
        _mint(msg.sender, 1000000 * 10**18);
    }
    
    event Mint(address account, uint amount, string reason);
    
    function mint(address account, uint amount, string calldata reason) public onlyOwner {
        _mint(account, amount);
        Mint(account, amount, reason);
    }
    
    function pause() public onlyOwner {
        _pause();
    }
    
    function unpause() public onlyOwner {
        _unpause();
    }
}
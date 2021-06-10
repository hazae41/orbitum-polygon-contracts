pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Ownable.sol";

contract Token is ERC20, Ownable {
    constructor() ERC20("Orbitum", "ORBTM") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}
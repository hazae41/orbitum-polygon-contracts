pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Donator {
    IERC20 private $token;
    
    constructor(IERC20 _token){
        $token = _token;
    }
    
    function token() external view returns (IERC20) {
        return $token;
    }
    
    event Donation(address indexed sender, address indexed receiver, string uri, uint amount);
    
    function donate(address payable _receiver, string memory _uri, uint _amount) external {
        require(_amount > 0, "Donator: invalid amount");
        require($token.transferFrom(msg.sender, _receiver, _amount));
        emit Donation(msg.sender, _receiver, _uri, _amount);
    }
}
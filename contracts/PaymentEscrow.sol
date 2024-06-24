// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import { AccessControl } from '@openzeppelin/contracts/access/AccessControl.sol';
import { ReentrancyGuard } from '@openzeppelin/contracts/utils/ReentrancyGuard.sol';

contract PaymentEscrow is AccessControl, ReentrancyGuard{
    bytes32 public constant FUND_MANAGER_ROLE = keccak256('FUND_MANAGER_ROLE');

    error INVALID_RECIPIENT;
    error INVALID_ASSET_AMOUNT;

    event Pay(
        address indexed recipient,
        uint256 indexed amount,
        uint256 indexed timestamp

    );

    event Deposit(
        address indexed sender,
        uint256 indexed amount,
        uint256 indexed timestamp

    );

    constructor(){
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(FUND_MANAGER_ROLE, msg.sender);
    }

    function releaseCUSD(address payable _recipient, uint256 _amount) onlyRole(FUND_MANAGER_ROLE) nonReentrant external{
        if(_recipient == address(0)) revert INVALID_RECIPIENT();
        if(_amount == 0) revert INVALID_ASSET_AMOUNT();

        (bool sent, bytes memory data) = _recipient.call{value: _amount}(""); //msg.value
        require(sent, "Failed to send Asset");
    }

    function deposit() nonReentrant external{

    }

    function getEscrowBalance() nonReentrant external{
        return address(this).balance;
    }

    
    receive() external payable {}

    fallback() external payable {}
}
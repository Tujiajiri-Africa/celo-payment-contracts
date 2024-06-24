// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import { AccessControl } from '@openzeppelin/contracts/access/AccessControl.sol';
import { ReentrancyGuard } from '@openzeppelin/contracts/utils/ReentrancyGuard.sol';

contract PaymentEscrow is AccessControl, ReentrancyGuard{
    bytes32 public constant FUND_MANAGER_ROLE = keccak256('FUND_MANAGER_ROLE');

    constructor(){
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(FUND_MANAGER_ROLE, msg.sender);
    }

    function releaseCUSD() onlyRole(FUND_MANAGER_ROLE) nonReentrant external{

    }

    function deposit() nonReentrant external{

    }

    function getEscrowBalance() nonReentrant external{

    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import { AccessControl } from '@openzeppelin/contracts/access/AccessControl.sol';
import { ReentrancyGuard } from '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import { SafeERC20 } from '@openzeppelin/contracts/token/ERC20/util/SafeERC20.sol';

contract PaymentEscrow is AccessControl, ReentrancyGuard{
    using SafeERC20 for IERC20;

    bytes32 public constant FUND_MANAGER_ROLE = keccak256('FUND_MANAGER_ROLE');

    address private immutable cUSD = 0x765DE816845861e75A25fCA122bb6898B8B1282a;

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

        emit Pay({
            recipient: _recipient,
            amount: _amount,
            timestamp: block.timestamp
        });
    }

    function deposit() nonReentrant external{

    }

    function getEscrowCUSDBalance() nonReentrant external return(uint256 balance){
        balance = IERC20(cUSD).balanceOf(address(this));
    }

    receive() external payable {
        emit Deposit({
            sender: msg.sender,
            amount: msg.value,
            timestamp: block.timestamp
        });
    }

    fallback() external payable {}
}
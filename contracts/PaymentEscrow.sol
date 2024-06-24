// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import { AccessControl } from '@openzeppelin/contracts/access/AccessControl.sol';
import { ReentrancyGuard } from '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import { SafeERC20 } from '@openzeppelin/contracts/token/ERC20/util/SafeERC20.sol';
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PaymentEscrow is AccessControl, ReentrancyGuard{
    using SafeERC20 for IERC20;

    bytes32 public constant FUND_MANAGER_ROLE = keccak256('FUND_MANAGER_ROLE');

    address private immutable cUSD = 0x765DE816845861e75A25fCA122bb6898B8B1282a;
    address private immutable cEUR = 0xd8763cba276a3738e6de85b4b3bf5fded6d6ca73;
    address private immutable cREAL = 0xe8537a3d056DA446677B9E9d6c5dB704EaAb4787;
    address private immutable CELO = 0x471EcE3750Da237f93B8E339c536989b8978a438;

    address private immutable cUSD_USD_PRICE_FEED_ADDRESS = 0xe38A27BE4E7d866327e09736F3C570F256FFd048;
    address private CELO_USD_PRICE_FEED_ADDRESS = 0x0568fD19986748cEfF3301e55c0eb1E729E0Ab7e;
    address private immutable USDT_USD_ALFAJORES_PRICE_FEED_ADDRESS = 0x7bcB65B53D5a7FfD2119449B8CbC370c9058fd52;

    AggregatorV3Interface internal celocUSDMainnetPriceFeed;
    AggregatorV3Interface internal alfajoresPriceFeed;
    AggregatorV3Interface internal celoUSDMainnetPriceFeed;

    error INVALID_RECIPIENT;
    error INVALID_ASSET_AMOUNT;
    error INSUFFIENT_ESCROW_BALANCE;

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

    event OffRamp(
        address indexed recipient,
        address indexed asset,
        uint256 indexed amount,
        uint256 timestamp
    );

    constructor(){
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(FUND_MANAGER_ROLE, msg.sender);

        celocUSDMainnetPriceFeed = AggregatorV3Interface(cUSD_USD_PRICE_FEED_ADDRESS);
        celoUSDMainnetPriceFeed = AggregatorV3Interface(CELO_USD_PRICE_FEED_ADDRESS);
        alfajoresPriceFeed = AggregatorV3Interface(USDT_USD_ALFAJORES_PRICE_FEED_ADDRESS);
    }

    function release(address payable _recipient, uint256 _amount) onlyRole(FUND_MANAGER_ROLE) nonReentrant external{
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

    function executeERC20Payment(address _asset, address _beneficiary, uint256 _amount) external onlyRole(FUND_MANAGER_ROLE) nonReentrant{
        uint256 balance = IERC20(_asset).balanceOf(address(this));
        if(balance < _amount) revert INSUFFIENT_ESCROW_BALANCE();
        if(_beneficiary == address(0)) revert INVALID_RECIPIENT();

        IERC20(_asset).safeTransfer(_beneficiary, _amount);

        emit OffRamp({
            recipient: _beneficiary,
            asset: _asset, 
            amount: _amount,
            timestamp: block.timestamp
        });
    }

    function deposit() nonReentrant external{

    }

    function getEscrowCUSDBalance() nonReentrant external returns(uint256 balance){
        balance = IERC20(cUSD).balanceOf(address(this));
    }

    function getUserCUSDBalance(address _user) external returns(uint256 balance){
        balance = IERC20(cUSD).balanceOf(_user);
    }

    function getcUSDPrice() external view returns(uint256){
       // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = celocUSDMainnetPriceFeed.latestRoundData();
        return answer;
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
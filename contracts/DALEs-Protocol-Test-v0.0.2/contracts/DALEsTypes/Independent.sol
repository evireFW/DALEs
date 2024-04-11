pragma solidity ^0.8.8;
import "./Basic.sol";

contract Independent is Basic{
    bytes public dalesType = "independent";

    constructor(address _owner,address _erc20Factory) public {
        owner = _owner;
        erc20Factory = _erc20Factory;
    }
}
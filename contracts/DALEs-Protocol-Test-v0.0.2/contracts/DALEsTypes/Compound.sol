pragma solidity ^0.8.8;
import "./Basic.sol";

contract Compound is Basic{
    bytes public dalesType = "compound";

    constructor(address _owner,address _erc20Factory) public {
        owner = _owner;
        erc20Factory = _erc20Factory;
    }
}
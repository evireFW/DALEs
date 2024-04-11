pragma solidity ^0.8.8;
import "./Basic.sol";
import "../lib/TokenSet";

contract League is Basic{
    using Set for Set.Address;
    bytes public dalesType = "league";
    Set.Address[] dalesList;

    constructor(address _owner,address _erc20Factory) public {
        owner = _owner;
        erc20Factory = _erc20Factory;
    }

    function getDALEsListLength() public view returns(uint) {
        
        return dalesList.length();
    }

    function getAddressByIndex(uint index) public view returns(address) {
        
        return dalesList.at(index);
    }

    function getAddressList(uint index) public view returns(Set.Address[] memory) {
        
        return dalesList;
    }
}
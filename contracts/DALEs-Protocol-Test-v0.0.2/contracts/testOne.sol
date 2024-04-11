pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract TestOne {
   
    uint public number;
    address public caller;
    address public testAddress;
    
    struct T{
        uint256 a;
        address b;
    }
    
    mapping(uint256 => T) public tmap;
    
    function setNumber(uint index) public {
        caller = msg.sender;
        number = index;
    }
    
    function setMulNumber(uint index,address addr) public {
        testAddress = addr;
        number = index;
    }
    
    function setStruct(T memory t) public {
        tmap[0] = t;
    }
    
}
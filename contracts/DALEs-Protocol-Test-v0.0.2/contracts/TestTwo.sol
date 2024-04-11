
pragma solidity ^0.6.0;


contract TestTwo {
   
    uint public number;
    address public testOne;
    
    function setNumber(uint index) public {
        number = index;
    }
    
    constructor(address addr) public {
        testOne = addr;
    }
    
    //encodeWithSignature one argument
    function callFunc222222(uint index) public {
        bytes memory payload = abi.encodeWithSignature("setNumber(uint256)", index);

        (bool success, bytes memory returnData) = testOne.call(payload);

        require(success);
      
    }
    
     function callFunc333333(uint index) public {
       bytes memory callData = abi.encodePacked(bytes4(keccak256(bytes("setNumber(uint256)"))),abi.encode(index));

         (bool successes,bytes memory returnData) = testOne.call(callData);

        require(successes);
      
    }
    
    function callFunc4444444(uint index,address addr) public {
       bytes memory callData = abi.encodePacked(bytes4(keccak256(bytes("setMulNumber(uint256,address)"))),abi.encode(index,addr));

         (bool successes,bytes memory returnData) = testOne.call(callData);

        require(successes);
      
    }
    
    function encodeOne(uint index) public  view returns(bytes memory){
       
      return abi.encode(index);
    }
    
    function encodeMul(uint index,uint index2) public  view returns(bytes memory){
       
      return abi.encode(index,index2);
    }

}

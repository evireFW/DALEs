//Actors define the role of a certain wallet address in the ecosystem, it can be employees or
//anybody from a governamental entity.

pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;
import "../interface/IERC20.sol";
import {Set} from "../lib/TokenSet.sol";

contract DALEsActors{
    using Set for Set.Address;
    address public creator;
   
    uint public actorId;
    
    mapping(address => string) public actorName;
    mapping(address => uint) public joinTime;

    Set.Address applying;
    Set.Address actor;
    
    constructor(address _creator) public {
        creator =_creator;
    }
    
    modifier onlyManage(){
        require(msg.sender == creator || moderators[msg.sender], "No permisstion");
        _;
    }
    
    function applyJoin(address addr) public returns(bool){
        require(!actor.contains(addr),"Is actor");
        require(!applying.contains(addr),"Applying");
        applying.add(addr);
        return true;
    }
    
    function approveApply(address addr) public returns(bool){
        require(msg.sender == creator || auth.hasAuthority(msg.sender,"DALEsManage","approveApply"));
        applying.remove(addr);
        actor.add(addr);
        return true;
    }

    function getApplyingLength() public view returns(uint){
        return applying.length();
    }
    
    function getApplyingByIndex(uint index) public view returns(address){
        return applying.at(index);
    }
    
    function getActorLength() public view returns(uint){
        return actors.length();
    }
    
    function getActorByIndex(uint index) public view returns(address){
        return actors.at(index);
    }
    

    
    
}



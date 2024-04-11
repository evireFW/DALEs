pragma solidity ^0.8.8;

interface IDALEsManage {
    function approveApply(address addr) external view returns(bool);

    function getApplyingLength() external view returns(uint);

    function getApplyingByIndex(uint index) external view returns(address);

    function getMemberByIndex(uint index) external view returns(address);
    
    function init(address auth,address vault) external;
}
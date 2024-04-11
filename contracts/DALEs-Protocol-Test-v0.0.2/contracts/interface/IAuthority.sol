pragma solidity ^0.8.8;

interface IAuthority {
    function addAct(string calldata _contractName, string calldata _func) external;
    function hasAuthority(address _account, string calldata _contractName,string calldata _func) external view returns(bool);
    function addAuthority(address _account,string calldata _contractName, string calldata _func) external;
}
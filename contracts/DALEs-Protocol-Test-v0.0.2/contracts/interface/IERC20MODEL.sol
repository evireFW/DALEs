pragma solidity ^0.8.8;

interface IERC20MODEL {
    function creatToken(string memory tokenName_,string memory symbol_,uint8 decimals_, address owner_,uint totalSupply_) external returns(address);
}
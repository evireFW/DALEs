pragma solidity ^0.8.8;
import "./Basic.sol";


contract Linkable is Basic{
    bytes public dalesType = "linkable";
    address public higherAddress;
    address public lowerAddress;
    bool public linkAble;
    constructor(address _owner,address _erc20Factory,bool _linkAble) public {
        owner = _owner;
        erc20Factory = _erc20Factory;
        linkAble = _linkAble;
    }

    function creatDALEs(string memory _name,string memory _logo,string memory _des,address _token, uint _support) external override {
        require(msg.sender != address(0), "Invalid address");
        address _manage = address(new DALEsManage(msg.sender,address(this),_name,_logo,_des,_support));
        address _auth = address(new Authority(msg.sender,_manage));
        address _vault = address(new Vault(msg.sender,address(this),_manage, _auth));
        
        DALEsInfo memory addr = DALEsInfo({
            name: _name,
            logo: _logo,
            des: _des,
            authority: _auth,
            manage: _manage,
            vault: _vault
        });
        
        array.push(addr);
        userDALEss[msg.sender].push(index);
        index++;
        IDALEsManage(_manage).init(_auth,_vault);
        IVault(_vault).addToken(_token);
    }
}
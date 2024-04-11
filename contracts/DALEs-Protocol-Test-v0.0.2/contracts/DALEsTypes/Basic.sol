pragma solidity ^0.8.8;


contract Basic{
    address public owner;
    address public erc20Factory;
    uint public index;
    
    struct DALEsInfo{
        string name;
        string logo;
        string des;
        address authority;
        address manage;
        address vault;
    }
    mapping(address => uint[]) public userDALEss;
    DALEsInfo[] public array;
    
    modifier onlyOnwer(){
        require(msg.sender == owner, "only owner");
        _;
    }
    
    function creatDALEs(string memory _name,string memory _logo,string memory _des,address _token, uint _support) external virtual {
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
    
    function getArrayLength() public view returns(uint){
        return array.length;
    }
    
    function getDALEsInfo(uint index) public view returns(DALEsInfo memory){
        return array[index];
    }
    
    // function _init_contracts(string memory _name,string memory _logo, string memory _des) internal {
        
    // }
    
    function getOwnedDALEss() public view returns(uint[] memory){
        return userDALEss[msg.sender];
    }
}
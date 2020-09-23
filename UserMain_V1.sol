pragma solidity >=0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;
import "SysAdminProxyInterface.sol";

contract UserMain_V1{
    
    // user struct data tempolate
    struct Account{
        string userName;
        string name;
        address publicKey;
        string picHash;  // link to the ipfs
        string descrip_ContactHash;
        uint role;
    }
    
    event UpdateAccount(string indexed _userName, string _name, address indexed _publicKey, string _picHash, string descrip_ContactHash,uint _role);
    //event UpdateAccount(string indexed _userName, string _name, string _picHash, string descrip_ContactHash, uint _role);
    
    // lists of the username to the user detials
    mapping(string => Account) public accountList;
    
    address private SysAdminContractAddress;
    
    address private nextVerContractAddress;

    
    // declare the sysadmin contract type variable
    SysAdminProxy SysAdmin;
    
    
    //modifier
    modifier isUserExists(string memory _userName){
        require(bytes(accountList[_userName].userName).length != 0, "  User is already exists..");
        _;
    }
    
    
    // constructor of the contract
    constructor(address _add) public{
        
        // body of the constructor
        SysAdminContractAddress = _add;
    }
    
    
    // **** why do we need this ---- Remove this 
    /*
    function getSysAdminContractAddress() view public returns(address){
        require(msg.sender == SysAdminContractAddress, " The user is not the sysadmin ");
        address addrs = SysAdminContractAddress;
        return addrs;
    } */
    
    // **** why do we need this ---- Remove this 
    /*
    function setSysAdminContractAddress(address _add) public returns(bool){
        require(msg.sender == SysAdminContractAddress, " The user is not the sysadmin ");
        SysAdminContractAddress = _add;
        return true;
    }*/
    
    // **** why do we need this ---- Remove this 
    /*
    function setNextVerContractAddress(address _add) public returns(bool) {
        require(msg.sender == SysAdminContractAddress," The user is not the sysadmin ");
        nextVerContractAddress = _add;
        return true;
    }*/
    
     // **** why do we need this ---- Remove this 
     /*
    function getNextVerContractAddress() public view returns(address) {
        require(msg.sender == SysAdminContractAddress," The user is not the sysadmin ");
        return nextVerContractAddress;
    }*/
    
    
    // function to import the already existed account
    function importAccount(address _add)  public returns(string[] memory){
        
        SysAdmin = SysAdminProxy(SysAdminContractAddress);
        require(SysAdmin.isAddressExists(_add) == true, " The address is not registered in the eco-system ");
        
        string[] memory userNames = SysAdmin.getUserName(_add);
        
        return userNames;
        
    }
    
    
    // function to update the user
    // **** check if the msg.sender is the owner of the username -
    function updateAccount(string memory _userName, string memory _name, string memory _picHash, string memory _descrip_ContactHash, uint _role) public {
        
        SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, " The username and address are not matching ");
        require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        //require(SysAdmin.isUserNameExists(_userName) == true, " The userName is not registered in the eco-system ");
        
        
        // fetch the asset from the blockchain
        if(bytes(_name).length != 0){
            accountList[_userName].name = _name;
        }
        
        if(bytes(_picHash).length != 0){
            accountList[_userName].picHash = _picHash;
        }
        
        if(bytes(_descrip_ContactHash).length != 0){
            accountList[_userName].descrip_ContactHash = _descrip_ContactHash;
            
        }
        
        if(_role == 0){
            accountList[_userName].role = _role;
        }
        
        // emit the event with the updated details to store in the graph node
        emit UpdateAccount(_userName, _name, msg.sender, _picHash, _descrip_ContactHash, _role);
    }
    
    
    // **** function to view the user
    function viewAccount(string memory _userName) view public isUserExists(_userName) returns(bool){
        
        // return the user details
        return true;
    }
    
    
    // **** Remove this and put it in the system admin 
    /*
    function upgradeTO(string memory _userName) public returns(bool){
        
        // call the function of the next version smart contract
        
    }*/
    
}

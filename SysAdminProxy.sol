pragma solidity >=0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

contract SysAdmin {
    
   // maps address to the userName of the candidate
   mapping(address => string[]) public users;
   
   // userName to the address
   mapping(string => address) userNameAddress;
   
   // stores all the usernames in the eco-system
   mapping(string => bool) public userNames;
   
   // username => role
   mapping(string => uint) public userRoles;
   
   // stores the address's of admins
   mapping(address => bool) public admins;
   
   // version to the contract address
   mapping(string => address) public assetVer;
   
   // version to the contract address
   mapping(string => address) public userVer;
   
   // list of all contract addresses deployed on network
   mapping(address => bool) public contractAddresses;     
   
   // userName to his role
   //mapping(string => uint) public role;
   
   //
   modifier isLegitimateContractAddr(address _add){
       require(contractAddresses[_add] == true, " The call is not from the legitimate contract ");
       _;
   }
   
   // to add the admins
   function addAdmin(address _add) public returns(bool){
       require(msg.sender == admin, " The user is not the user...");
       admins[_add] = true;
       return true;
   }
    

   // stores the owner 
   address private admin;
   
   
   // constructor for this function
   constructor() public {
       admin = msg.sender;
   }
   
   // fetch the user detials and return
   function isUserNameExists(string memory _userName) view public returns(bool){
       return userNames[_userName];
   }
   
   // set the user detials
   function registerUserName(string memory _userName, address _add) public isLegitimateContractAddr(_add) {
       require(userNames[_userName] != true, "  User already registered with this ethereum address");
       userNames[_userName] = true;
   }
   
   // fetch the user detials and return
   function getUserNameAddr(string memory _userName, address _add) view public isLegitimateContractAddr(_add) returns(address){
       return userNameAddress[_userName];
   }
   
   // set the user detials
   function registerUserNameAddr(string memory _userName, address _add) public isLegitimateContractAddr(_add) returns(bool){
       require(userNameAddress[_userName] != address(0), "  User already registered with this ethereum address");
       userNameAddress[_userName] = msg.sender;
       return true;
   }
   
   
   // fetch the user detials and return
   function isAddressExists(address _add) view public returns(bool){
       if(users[_add].length != 0){
           return true;
       }
       else{
           return false;
       }
   }
   
   // set the user detials
   function mapAddToUserName(string memory _userName, address _add) public isLegitimateContractAddr(_add){
      require(userNames[_userName] == true, "  UserName has to first register on the chain ");
      
      bool flag = false;
      
      for(uint i=0; i<users[msg.sender].length; i++){
          
          if(keccak256(bytes(users[msg.sender][i])) == keccak256(bytes(_userName))){
              flag = true;
              break;
          }
      }
      
      require(flag != true," The username has been already mapped to the eth address ");
      users[msg.sender].push(_userName);
   }
   
   // 
   function setContractAddress(address _add) public returns(bool){
       require(msg.sender == admin, " The user is not the admin, so cannot set the contract addresses ");
       contractAddresses[_add] = true;
       return true;
   }
   
   
   // -> check wehther the version exists or not before
   function setAssetVersionAddress(string memory ver,address _add) public returns(bool){
       require(msg.sender == admin, " The user is not the admin, so cannot set the asset contract version ");
       assetVer[ver] = _add;
       return true;
   }
   
   
   // -> check wehther the version exists or not before
   function setUserVersionAddress(string memory ver,address _add) public returns(bool){
       require(msg.sender == admin, " The user is not the admin, so cannot set the asset contract version ");
       userVer[ver] = _add;
       return true;
   }
   
   
   // 
   function getAssetVersionAddress(string memory ver) view public returns(address){
      return assetVer[ver];
   }
   
   
   // 
   function getUserVersionAddress(string memory ver) view public returns(address){
      return userVer[ver];
   }
   
   // 
   function setRole(string memory _userName,uint _role) public  isLegitimateContractAddr(msg.sender) returns(bool){
       require(contractAddresses[msg.sender] == true," The eth address is not registered in the eco-system ");
       role[_userName] = _role;
   }
   
   //
   function getRole(string memory _userName) view public returns(uint){
       require(contractAddresses[msg.sender] == true," The eth address is not registered in the eco-system ");
       uint _role = role[_userName];
       return _role;
   }
   
   //
   function getUserName(address _add) public view returns(string[] memory){
       return users[_add];
   }
   
   
   // to upgrade the new address of the implementation contract (i.e.. new version)
   function upgradeTo(address _add) public {
       
   }
   
   
   
   /*
   fallback () payable public {
       
       address _impl = implContract;
       bytes memory data = msg.data;
       
       assembly{
           let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
           let size := returndatasize
           let ptr := mload(0x40)
           returndatacopy(ptr, 0, size)
           switch result
           case 0 { revert(ptr, size) }
           default { return(ptr, size) }
           
       }
   } */
   
    
}
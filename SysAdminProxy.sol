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
   mapping(string => uint) public role;
   
   // maps productID to the userName
   mapping(string => string) public productOwner;
   
   //  categories 
   mapping(string => bool) public categories;
   
   event NewCategory(string indexed _category);
   
   /*
   modifier isLegitimateContractAddr(address _add){
       require(contractAddresses[_add] == true, " The call is not from the legitimate contract ");
       _;
   }
   */
   
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
   
   // function to create the user
    // **** use msg.sender and check if the public address is the msg.sender -
    // **** In registerUserName and registerUserNameAddr should not send sysadmincontractAddress as the argument -
    // **** cannot send publickey as the aregument -
    // **** cannot register a user from here -
    function createAccount(string memory _userName, uint _role) public {
        
        require(getUserNameAddr(_userName) == msg.sender, " The username and address are not matching ");
        
        registerUserName(_userName);
        
        registerUserNameAddr(_userName);

        mapAddToUserName(_userName);
        
        setRole(_userName,_role);
        
        // emit the event to store the new user details in the graph
        //emit NewAccount(_userName, _name, _publicKey, _picHash, _descrip_ContactHash,_role);
    }
    
   
   // fetch the user detials and return
   function isUserNameExists(string memory _userName) view public returns(bool){
       return userNames[_userName];
   }
   
   // set the user detials
   function registerUserName(string memory _userName) public {
       require(userNames[_userName] != true, "  User already registered with this ethereum address");
       userNames[_userName] = true;
   }
   
   // fetch the user detials and return
   function getUserNameAddr(string memory _userName) view public returns(address){
       return userNameAddress[_userName];
   }
   
   // set the user detials
   // **** should be != address(0)
   function registerUserNameAddr(string memory _userName) public returns(bool){
       require(userNameAddress[_userName] == address(0), "  User already registered with this ethereum address");
       userNameAddress[_userName] = msg.sender;
       return true;
   }
   
   
   // check whether the address exists or not
 
   function isAddressExists(address _add) view public returns(bool){
       if(users[_add].length != 0){
           return true;
       }
       else{
           return false;
       }
   }
   
   // set the user detials
   // **** check if the username exists or not -- change the comment --- the default value of the bool in solidity is false.
   // din understand the above comment - chimbili
   function mapAddToUserName(string memory _userName) public {
      require(userNameAddress[_userName] == msg.sender, "  UserName has not mapped to the sender address ");
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
   
   // **** why to keep this
   function setContractAddress(address _add) public returns(bool){
       require(msg.sender == admin, " The user is not the admin, so cannot set the contract addresses ");
       contractAddresses[_add] = true;
       return true;
   }
   
   
   // **** check whether the version exists or not before -
   function setAssetVersionAddress(string memory ver,address _add) public returns(bool){
       require(msg.sender == admin, " The user is not the admin, so cannot set the asset contract version ");
       require(assetVer[ver] != _add, " The version already exists ");
       assetVer[ver] = _add;
       return true;
   }
   
   
   // **** check wehther the version exists or not before -
   function setUserVersionAddress(string memory ver,address _add) public returns(bool){
       require(msg.sender == admin, " The user is not the admin, so cannot set the asset contract version ");
       require(userVer[ver] != _add, " The version already exists ");
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
   
   // **** why to have this --- cannot be changed later on  ---- what is the contractAddresses for - 
   function setRole(string memory _userName,uint _role) public returns(bool){
       require(userNameAddress[_userName] == msg.sender, "  UserName has not mapped to the sender address ");
       role[_userName] = _role;
   }
   
      // **** why to have this --- cannot be changed later on  ---- what is the contractAddresses for - 
   function getRole(string memory _userName) view public returns(uint){
       // require(contractAddresses[msg.sender] == true," The eth address is not registered in the eco-system ");
       uint _role = role[_userName];
       return _role;
   }
   
   // 
   function getUserName(address _add) public view returns(string[] memory){
       return users[_add];
   }
   
   // **** should we keep the products global ---- mostly not 
   // **** not checking if the priduct is owned by the msg.sender 
   function setProductOwner(string memory _userName, string memory _productID) public returns(bool) {
       
       require(contractAddresses[msg.sender] == true, " The contract is not registered in the network ");
       productOwner[_productID] = _userName;
   }
   
   // **** mostly will not keep this 
   function getProductOwner(string memory _productID) public view returns(string memory) {
      return productOwner[_productID];
   }
   
   // to add the new category
   // **** default value for bool is false 
   function addCategory(string memory _category) public returns(bool) {
       require(categories[_category] != true, " The category already exists " ) ;
       categories[_category] = true;
       emit NewCategory(_category);
       return true;
   }
   
   // to check whether an category exists in the list
   function isCategoryExists(string memory _category) public view returns(bool) {
       if(categories[_category] == false){
           return false;
       }
       else{
           return true;
       }
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

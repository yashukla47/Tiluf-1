pragma solidity >=0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

contract SysAdminProxy {
   
   // checks the userNAme exists or not
   function isUserNameExists(string memory _userName) view public returns(bool){}
   
   //
   function registerUserName(string memory _userName) public {}
   
   // fetch the user detials and return
   function getUserNameAddr(string memory _userName) view public  returns(address){}
   
   // set the user detials
   function registerUserNameAddr(string memory _userName, address _add) public returns(bool){}
   
   
   // fetch the user detials and return
   function isAddressExists(address _add) view public returns(bool){ }
   
   // set the user detials
   function mapAddToUserName(string memory _userName, address _add) public {}
   
   // 
   function setContractAddress(address _add) public returns(bool){}
   
   
   // 
   function setAssetVersionAddress(string memory ver,address _add) public returns(bool){}
   
   
   // 
   function setUserVersionAddress(string memory ver,address _add) public returns(bool){}
   
   
   // 
   function getAssetVersionAddress(string memory ver) view public returns(address){}
   
   
   // 
   function getUserVersionAddress(string memory ver) view public returns(address){}
   
   // 
   function setRole(string memory _userName,uint _role) public returns(bool){}
   
   //
   function getRole(string memory _userName)  public returns(uint){}
   
   //
   function getUserName(address _add) public view returns(string[] memory){}
   
   //
   function setProductOwner(string memory _userName, string memory _productID) public returns(bool) {}
   
   //
   function getProductOwner(string memory _productID) public view returns(string memory) {}
   
   // to add the new category
   function addCategory(string memory _category) public returns(bool) {}
   
   // to check whether an category exists in the list
   function isCategoryExists(string memory _category) public view returns(bool) {}
   
   
   // to upgrade the new address of the implementation contract (i.e.. new version)
   function upgradeTo(address _add) public {}
   
   
}

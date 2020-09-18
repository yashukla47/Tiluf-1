pragma solidity >=0.5.0 <0.8.0;
import "SysAdminProxyInterface.sol";

contract AssetLogic{
    
    //
    struct History{
        string owner;   // userName
        uint block;     // block at which this is owned by the above user
    }
    
    
    // asset data struct
    struct Product{
        string owner;  // should be the username
        string productID;
        string productName;
        string category;
        string picHash;
        string brandName;
        string brandPicHash;
        History[] history;
        string _3DHash;
        string _2DHash;
        string descrip_highlights;
        uint price;
        bool forSale;
        bool newProduct;
        //address contractAddre;
    }
    
    
    event NewProduct(string indexed _owner, string indexed _productID, string _productName, string _category, string _picHash, string _brandName, string _brandPicHash,History _history,string _3DHash, string _2DHash,string _descrip_highlights,uint32 _price,bool _forSale,bool _newProduct);
    event UpdateAsset(string indexed _productID,string indexed _name,uint _price,string _descrip);
    event TransferProduct(string indexed _productID,string indexed _owner);
    event SellProduct(string indexed _productID,bool _forSale,History _history);
    event BuyProduct(string indexed _productID,string indexed _owner,History _history,bool _forSale);
    
    address public SysAdminContractAddress;
    
    
    address private nextVerContractAddress;
    
    // declare the sysadmin contract type variable
    SysAdminProxy SysAdmin;
    
    // stores the lists of all the assets with their id as key and asset as value
    mapping(string => Product) public products;
    
    // constructor of the contract
    constructor(address _add) public  {
        SysAdminContractAddress = _add;
    }
    
    //
    function getSysAdminContractAddress() view public returns(address){
        require(msg.sender == SysAdminContractAddress, " The user is not the sysadmin ");
        address addrs = SysAdminContractAddress;
        return addrs;
    }
    
    //
    function setSysAdminContractAddress(address _add) public returns(bool){
        require(msg.sender == SysAdminContractAddress, " The user is not the sysadmin ");
        SysAdminContractAddress = _add;
        return true;0
    }
    
    
    function setNextVerContractAddress(address _add) public returns(bool) {
        require(msg.sender == SysAdminContractAddress," The user is not the sysadmin ");
        nextVerContractAddress = _add;
        return true;
    }
    
    
    function getNextVerContractAddress() view public returns(address) {
        require(msg.sender == SysAdminContractAddress," The user is not the sysadmin ");
        return nextVerContractAddress;
    }
    
    // creates the asset
    function createProduct(string memory _userName,string memory _owner, string memory _productID, string memory _productName, string memory _category, string memory _picHash, string memory _brandName, string memory _brandPicHash,string memory _3DHash, string memory _2DHash,string memory _descrip_highlights,uint32 _price,bool _forSale) public returns(bool){
        
        SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        
        require(SysAdmin.isUserNameExists(_userName) == true, " The userName is not registered in the eco-system ");
        require(SysAdmin.getRole == 0, " Only designers are allowed to create the asset ");
        
        History memory _history = History(_userName,0);
        
        // create the new asset data from the received parameters
            Product memory newProduct = Product(_owner,_productID,_productName,_category,_picHash,_brandName,_brandPicHash,_history,_3DHash,_2DHash,_descrip_highlights,_price,_forSale,true);
        
        // save to the state variable and also register the assets location in the list
        products[_productID] = newProduct;
        
        // emit the event to store it in graph
        emit NewProduct(_owner,_productID,_productName,_category,_picHash,_brandName,_brandPicHash,_history,_3DHash,_2DHash,_descrip_highlights,_price,_forSale);
        
    }
    
    
    // updates the asset details
    function updateProduct(string memory _userName,string memory _owner, string memory _productID, string memory _name, string memory _descrip, uint32 _price) public {
        
        SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        //require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        require(SysAdmin.isUserNameExists(_userName) == true, " The userName is not registered in the eco-system ");
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), " The user is not the owner of the product.. ");
        
        // fetch the asset from the blockchain
        if(keccak256(bytes(products[_productID].name)) != keccak256(bytes(_name))){
            products[_id].name = _name;
        }
        else if(keccak256(bytes(products[_productID].descrip)) != keccak256(bytes(_descrip))){
            products[_productID].descrip = _descrip;
        }
        else if(products[_productID].price != _price){
            products[_productID].price = _price;
        }
        else{
            // nothing
        }
        
        // emit the event for the updation in the graph
        emit UpdateAsset(_id,_name,_price,_descrip);
    }
    
    
    // fetches the asset from the list
    function viewAsset(string calldata _id,string calldata _owner) view external {
        
        // return the asset details
        
    }
    
    
    // transfers the asset to the specified user
    function transferProduct(string memory _userName, string memory _productID, string memory _buyer) public {
        
        SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        require(SysAdmin.isUserNameExists(_userName) == true, " The user is not registered in the eco-system ");
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), " The user is not the owner of the product.. ");
        require(SysAdmin.isUserNameExists(_buyer) == true, " The buyer is not registered in the eco-system ");
        
        // change the owner detials of that asset
        products[_productID].owner = _buyer;
        History memory history = History(_buyer,0);
        products[_productID].history.push(history);
        
        // emit the event 
        emit TransferProduct(_productID,_buyer,history);
        
        
    }
    
    
    
    
    // transfers the asset details by calling the updateAsset func of the Storage.sol contract
    function sell(string memory _productID, string memory _userName) public  {
        
        SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        require(SysAdmin.isUserNameExists(_userName) == true, " The userName is not registered in the eco-system ");
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), " The user is not the owner of the product.. ");
        
        if(products[_productID].forSale != true){
            products[_productID].forSale = true;
        }
        
        // emit the event when asset got called
        emit SellProduct(_productID,products[_productID].forSale);
    }
    
    
    // fetches the all assets owned by the user from GRAPH node
    function viewMyAssets(string memory _userName) public{
        // get the details from the graph node
    }
    
    
    // buy the product
    function buy(string memory _userName, string memory _productID) public payable  {
        
        SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        //require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        require(SysAdmin.isUserNameExists(_userName) == true, " The userName is not registered in the eco-system ");
        require(msg.value >= products[_productID].price," The user doesnt have enough funds ");
        require(products[_productID].forSale == true, " The product is not for sale ");
        
        // transfer the ether to the seller
        string memory sellerUsername = products[_productID].owner;
        
        address sellerAddr = SysAdmin.getUserNameAddr(sellerUsername);
        
        sellerAddr.transfer(msg.value);
        
        // update the asset owner details in the blockchain
        products[_productID].owner = _userName;
        
        History memory history = History(_userName,0);
        
        // add history of the newly bought user to the product history
        products[_productID].history.push(history);
        
        // make the product as not for sale
        products[_productID].forSale = false;
        
        // emit the event when asset is bought by sender
        emit BuyProduct(_productID,_userName,history,false);
        
    }
    
    
    // fabricates the asset
    function fabricate() external {
        
    }
    
    
    // for tailoring
    function tailor() external {
        
    }
    
    
    function upgrade(string calldata roductID, address newContract) external {
        
    }

    
    // gets the 
}


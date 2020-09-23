pragma solidity >=0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;
import "SysAdminProxyInterface.sol";

contract AssetLogic{
    
    //
    struct History{
        string owner;   // userName
        uint blockNumber;     // block at which this is owned by the above user
        uint timestamp;
    }
    
    
    // asset data struct
    // **** talk about the history 
    struct Product{
        string owner;  // should be the username
        string productID;
        string productName;
        string category;
        string picHash;
        string brandName;
        string brandPicHash;
        //History[] history;
        string _3DHash;
        string _2DHash;
        string descrip_highlights;
        uint price;
        bool forSale;
        bool newAsset;  
        uint hisCount;
        mapping(uint => History) history;
        //address contractAddre;
    }
    
    
    event NewProduct(string indexed _owner, string indexed _productID, string _productName, string _category, string _picHash, string _brandName, string _brandPicHash,History _history,string _3DHash, string _2DHash,string _descrip_highlights,uint32 _price,bool _forSale,bool _newProduct);
    event UpdateProduct(string indexed _owner,string indexed _productID, string _productName, string _category, string _picHash, string _brandName, string _brandPicHash, string __3DHash, string __2DHash, string _descrip_highlights);
    event TransferProduct(string indexed _productID,string indexed _owner, History _history);
    event SellProduct(string indexed _productID,bool _forSale,uint _price);
    event BuyProduct(string indexed _productID,string indexed _owner,History _history,bool _forSale);
    
    address public SysAdminContractAddress;
    
    address private nextVerContractAddress;
    
    // declare the sysadmin contract type variable
    SysAdminProxy private SysAdmin = SysAdminProxy(SysAdminContractAddress);
    
    // stores the lists of all the assets with their id as key and asset as value
    mapping(string => Product) public products;
    
    // constructor of the contract
    constructor(address _add) public  {
        SysAdminContractAddress = _add;
    }
    
    // **** what is this
    // *** remove this ###
    /*
    function getSysAdminContractAddress() view public returns(address){
        require(msg.sender == SysAdminContractAddress, " The user is not the sysadmin ");
        address addrs = SysAdminContractAddress;
        return addrs;
    }
    */
    
    // ****remove this ###
    /*
    function setSysAdminContractAddress(address _add) public returns(bool){
        require(msg.sender == SysAdminContractAddress, " The user is not the sysadmin ");
        SysAdminContractAddress = _add;
        return true;
    }
    */
    
    // ***** remove and implement next version for each product 
    function setNextVerContractAddress(address _add) public returns(bool) {
        require(msg.sender == SysAdminContractAddress," The user is not the sysadmin ");
        nextVerContractAddress = _add;
        return true;
    }
    
    // ***** remove and implement next version for each product 
    function getNextVerContractAddress() view public returns(address) {
        require(msg.sender == SysAdminContractAddress," The user is not the sysadmin ");
        return nextVerContractAddress;
    }
    
    // creates the asset 
    // ***** Remove require for the address -
    // **** Check if the uername is owned by the msg.sender -
    // ***** Perfect the History the block number issue 
    // ***** get role issue need to send the user name -- no parameters -
    // 
    // **** if for sale then ask for price also - handle this in front end
<<<<<<< HEAD
    function createProduct(string memory _userName, string memory _productID, string memory _productName, string memory _category, string memory _picHash, string memory _brandName, string memory _brandPicHash,string memory __3DHash, string memory __2DHash,string memory _descrip_highlights,uint32 _price,bool _forSale) public returns(bool) {
=======
    function createProduct(string memory _userName, string memory _productID, string memory _productName, string memory _category, string memory _picHash, string memory _brandName, string memory _brandPicHash,string memory _3DHash, string memory _2DHash,string memory _descrip_highlights,uint32 _price,bool _forSale) public returns(bool){
>>>>>>> f6c7444d2b90300557f4280cc77b65b8fa661f42
        
        //SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, " The username and address are not matching ");
        require(SysAdmin.getRole(_userName) == 0, " Only designers are allowed to create the asset ");
        require(bytes(SysAdmin.getProductOwner(_productID)).length == 0, " The product ID already exists ");
        
        History memory _history = History(_userName,block.number,now);
        
        // create the new asset data from the received parameters
<<<<<<< HEAD
        //Product memory newProduct = Product(_userName,_productID,_productName,_category,_picHash,_brandName,_brandPicHash,new History[](),__3DHash,__2DHash,_descrip_highlights,_price,_forSale,true);
         Product memory newProduct;
        
        
        newProduct.owner = _userName;
        newProduct.productID = _productID;
        newProduct.productName = _productName;
        newProduct.category = _category;
        newProduct.picHash = _picHash;
        newProduct.brandName = _brandName;
        newProduct.brandPicHash = _brandPicHash;
        //newProduct.history = new History[](1);
        newProduct._3DHash = __3DHash;
        newProduct._2DHash = __2DHash;
        newProduct.descrip_highlights = _descrip_highlights;
        newProduct.price = _price;
        newProduct.forSale = _forSale;
        newProduct.newAsset = true;
        newProduct.hisCount = 0;
        //newProduct.history[0] = _history;
=======
        Product memory newProduct = Product(_userName,_productID,_productName,_category,_picHash,_brandName,_brandPicHash,[_history],_3DHash,_2DHash,_descrip_highlights,_price,_forSale,true);
>>>>>>> f6c7444d2b90300557f4280cc77b65b8fa661f42
        
        // save to the state variable and also register the assets location in the list
        products[_productID] = newProduct;
        
<<<<<<< HEAD
        Product storage p = products[_productID];
        p.history[0] = _history;
        
       SysAdmin.setProductOwner(_userName,_productID);
        
        // emit the event to store it in graph
        emit NewProduct(_userName,_productID,_productName,_category,_picHash,_brandName,_brandPicHash,_history,__3DHash,__2DHash,_descrip_highlights,_price,_forSale,true);
=======
        SysAdmin.setProductOwner(_userName,_productID);
        
        // emit the event to store it in graph
        emit NewProduct(_userName,_productID,_productName,_category,_picHash,_brandName,_brandPicHash,_history,_3DHash,_2DHash,_descrip_highlights,_price,_forSale,true);
>>>>>>> f6c7444d2b90300557f4280cc77b65b8fa661f42
        
    }
    
    
    // updates the asset details
    // **** choose if we define the SysAdmin globally and it cannot changed or it should be able to be changed for each product - for yash's reference
    // **** check if the owner of the username is the address or not -
    // **** check for the null value of the feilds 
    // **** include the for sale logic in the update function 
    function updateProduct(string memory _userName, string memory _productID, string memory _productName, string memory _category, string memory _picHash, string memory _brandName, string memory _brandPicHash, string memory __3DHash, string memory __2DHash, string memory _descrip_highlights) public {
        
        //SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        //require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, " The username and address are not matching ");
        //require(SysAdmin.isUserNameExists(_userName) == true, " The userName is not registered in the eco-system ");
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), " The user is not the owner of the product.. ");
        
        // fetch the asset from the blockchain
        if(bytes(_productName).length != 0){
            products[_productID].productName = _productName;
        }
        
        if(bytes(_category).length != 0){
            products[_productID].category = _category;
        }
        
        if(bytes(_picHash).length != 0){
            products[_productID].picHash = _picHash;
        }
        
        if(bytes(_brandName).length != 0){
            products[_productID].brandName = _brandName;
        }
        
        if(bytes(_brandPicHash).length != 0){
            products[_productID].brandPicHash = _brandPicHash;
        }
        
        if(bytes(__3DHash).length != 0){
            products[_productID]._3DHash = __3DHash;
        }
        
        if(bytes(__2DHash).length != 0){
            products[_productID]._2DHash = __2DHash;
        }
        
        if(bytes(_descrip_highlights).length != 0){
            products[_productID].descrip_highlights = _descrip_highlights;
        }
        
        // emit the event for the updation in the graph
        emit UpdateProduct(products[_productID].owner,_productID,_productName,_category,_picHash,_brandName,_brandPicHash,__3DHash,__2DHash,_descrip_highlights);
    }
    
    
    // fetches the asset from the list
    // for the flow
    function viewAsset(string calldata _id,string calldata _owner) view external {
        
        // return the asset details
        
    }
    
    
    // transfers the asset to the specified user
    // ***** remove --- is address exists -
    // ***** check  is the owner of the user is the msg.sender -
    // ***** update the history part logic 
    function transferProduct(string memory _userName, string memory _productID, string memory _buyer) public {
        
        //SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        //require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, " The username and address are not matching ");
        //require(SysAdmin.isUserNameExists(_userName) == true, " The user is not registered in the eco-system ");
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), " The user is not the owner of the product.. ");
        require(SysAdmin.isUserNameExists(_buyer) == true, " The buyer is not registered in the eco-system ");
        
        // change the owner detials of that asset
        products[_productID].owner = _buyer;
        History memory _history = History(_buyer,block.number,now);
        products[_productID].hisCount++; 
        products[_productID].history[products[_productID].hisCount] = _history;
        
        // emit the event 
        emit TransferProduct(_productID,_buyer,_history);
        
        
    }
    
    
    
    
    // transfers the asset details by calling the updateAsset func of the Storage.sol contract
    // **** check if the msg.sender is the owner of the username and the product  -
    // **** ask for the price also while keeping it for sale 
    // **** mostly keep the sell and not for sell in the update product details part and if it is for sale then price should be mentioned 
    function sell(string memory _productID, string memory _userName, uint _price, bool _sell) public  {
        
        //SysAdmin = SysAdminProxy(SysAdminContractAddress);
        
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, " The username and address are not matching ");
        //require(SysAdmin.isAddressExists(msg.sender) == true, " The address is not registered in the eco-system ");
        //require(SysAdmin.isUserNameExists(_userName) == true, " The userName is not registered in the eco-system ");
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), " The user is not the owner of the product.. ");
        
        if(_sell == true){
            
            require(_price > 0, " The price is not mentioned  " );
            if(products[_productID].forSale != _sell){
                products[_productID].forSale = _sell;
            }
            
            products[_productID].price = _price;
        }
        
        else{
            products[_productID].forSale = _sell;
        }
        
        
        
        // emit the event when asset got called
        emit SellProduct(_productID,products[_productID].forSale,_price);
    }
    
    
    // fetches the all assets owned by the user from GRAPH node
    // **** this cannot happen 
    // **** for the flow 
    // 
    function viewMyAssets(string memory _userName) public{
        // get the details from the graph node
    }
    
    
    // buy the product
    // **** correct the history logic 
    // **** check wheather the username belongs to the specific address msg.sender -
    function buy(string memory _userName, string memory _productID) public payable  {
        
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, " The username and address are not matching ");
        require(msg.value >= products[_productID].price," The user doesnt have enough funds ");
        require(products[_productID].forSale == true, " The product is not for sale ");
        
        // transfer the ether to the seller
        string memory sellerUsername = products[_productID].owner;
        
        address payable sellerAddr = address(uint160(SysAdmin.getUserNameAddr(sellerUsername)));
        
        sellerAddr.transfer(msg.value);
        
        // update the asset owner details in the blockchain
        products[_productID].owner = _userName;
        
        // update he new product owner in SysAdmin contract
        SysAdmin.setProductOwner(sellerUsername,_productID);
        
<<<<<<< HEAD
        History memory _history = History(_userName,block.number,now);
=======
        History memory history = History(_userName,0);
>>>>>>> f6c7444d2b90300557f4280cc77b65b8fa661f42
        
        // add history of the newly bought user to the product history
        products[_productID].hisCount++; 
        products[_productID].history[products[_productID].hisCount] = _history;
        
        // make the product as not for sale
        products[_productID].forSale = false;
        
        // emit the event when asset is bought by sender
        emit BuyProduct(_productID,_userName,_history,false);
        
    }
    
    
    // fabricates the asset
    // *** decide the logic for the fabrication
    function fabricate() external {
        
    }
    
    
    // for tailoring
    // *** deceide the logic for Tailoring 
    function tailor() external {
        
    }
    
    
    function upgrade(string calldata roductID, address newContract) external {
        
    }

    
    // gets the 
    
    
}
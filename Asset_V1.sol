pragma solidity >=0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;
import "SysAdminProxyInterface.sol";
import "AssetUpgradeToInterface.sol";

contract AssetLogic{
    
    // struct for the History
    struct History{
        string owner;   // userName
        uint blockNumber;
        uint timestamp; //  timestamp at which this is owned by the above user
    }
    
    
    // asset data struct
    struct Product{
        string owner;  // should be the username
        string productID;
        string productName;
        string category;
        string picHash;
        string brandUserName;
        string _3DHash;
        string _2DHash;
        string liveHash;
        string descripHighlightsHash;
        string status;                 // checks the status of the free, forsale, notForSale 
        uint price;        
        uint numberOfTransfers;
        mapping(uint => History) history;
        
        address upgradedcontractAddress;
       
    }
    
    
    address public SysAdminProxyAddress;
    
    
    
    // declare the sysadmin contract type variable
    SysAdminProxy public SysAdmin;
    
    //declare upgraded contract 
    AssetUpgradeToInterface upgradedToContract;
    
    // stores the lists of all the assets with their id as key and asset as value
    mapping(string => Product) public products;
    
    
    event NewProduct(string indexed _owner, string indexed _productID, string _productName, string _category, string _picHash, string _brandName, string _brandPicHash,History _history,string _3DHash, string _2DHash,string _descrip_highlights,uint32 _price,bool _forSale,bool _newProduct, uint numberOftransfers);
    event UpdateProduct(string indexed _owner,string indexed _productID, string _productName, string _category, string _picHash, string _brandName, string _brandPicHash, string __3DHash, string __2DHash, string _descrip_highlights);
    event TransferProduct(string indexed _productID,string indexed _owner, History _history);
    event SellProduct(string indexed _productID, string status, uint _price);
    event BuyProduct(string indexed _productID,string indexed _owner, History _history);
    
   
    
    // constructor of the contract
    constructor(address _add) public  {
        SysAdminProxyAddress = _add;
        SysAdmin = SysAdminProxy(SysAdminProxyAddress);
    }
    
    
    
    
    // creates the asset 
    function createProduct(string memory _userName, string memory _productID, string memory _productName, string memory _category, string memory _picHash, string memory _brandName, string memory _livehash,string memory _3DHash, string memory _2DHash, string memory _descripHighlightsHash, uint32 _price, bool _forSale) public returns(bool){
        
        
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, " the caller doesnot holds the username ");
        
        require(SysAdmin.role[_username] == "designer", " Only designers are allowed to create the asset ");
        
        require(bytes(products[_productID]).length != 0, " The product ID already exists ");
        
        if (_forSale == true )
        {
            require ( _price > 0, "open for sale but price not mentioned");
        }
        
        History memory _history = History (_userName, block.number, block.timestamp);
        
        // create the new asset 
        Product  newProduct;
        
        newProduct.owner = _userName;
        newProduct.productID = _productID;
        newProduct.productName = _productName;
        newProduct.category = _category;
        newProduct.picHash = _picHash;
        newProduct.brandName = _brandName;
        
        newProduct._3DHash = __3DHash;
        newProduct._2DHash = __2DHash;
        newProduct.descripHighlightsHash= _descripHighlightsHash;
        newProduct.price = _price;
        newProduct.forSale = _forSale;
        
        newProduct.numberOfTransfers = 0;

        products[_productID] = newProduct;
        
        newProduct.history[0] = _history;
        
        
        // emit the event to store it in graph
        emit NewProduct(_userName, _productID,_productName,_category,_picHash, _brandName, _history, _3DHash, _2DHash, _descripHighlightsHash, _price, _forSale, true, 0, 0x0);
        
    }
    
    
    // updates the asset details
    function updateProduct(string memory _userName, string memory _productID, string memory _productName, string memory _category, string memory _picHash, string memory _designerUserName, string memory __3DHash, string memory __2DHash, string memory _liveHash, string memory _descripHighlightsHash, bool _Status, uint price ) public {
        
        
        require(products[_productID].numberOfTransfers == 0, "the product cannot be updated, it's already sold at least once ")
 
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), " The user is not the owner of the product ");
 
        require(products[_productID].upgradedcontractAddress != address(0x0), "the product is already upgraded to another version")

        
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, "The address is not the holder of the username");

        
        
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
        
        if(bytes(_designerUserdName).length != 0){
            products[_productID].brandName = _brandName;
        }
        
        
        if(bytes(__3DHash).length != 0){
            products[_productID]._3DHash = __3DHash;
        }
        
        if(bytes(__2DHash).length != 0){
            products[_productID]._2DHash = __2DHash;
        }
        
        if(bytes(_liveHash).length != 0){
            products[_productID].liveHash = _liveHash;
        }
        
        if(bytes(_descripHighlightsHash).length != 0){
            products[_productID].descripHighlightsHash = _descripHighlightsHash;
        }
        
        
        
        // emit the event for the updation in the graph
        emit UpdateProduct(products[_productID].owner,_productID,_productName,_category,_picHash,_brandName,_brandPicHash,__3DHash,__2DHash,_descripHighlightsHash);
    }
    
    
    
    
    
    // transfers the asset to the specified user
    function transferProduct(string memory _userName, string memory _productID, string memory _receiver) public {
        
        require(products[_productID].upgradedcontractAddress != address(0x0), "the product is upgraded to another version")


        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, "The address is not the holder of the username");
        
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), "The user is not the owner of the product");
        
        require(SysAdmin.isUserNameExists(_receiver) == true, "The buyer is not registered in the eco-system");
        
        // change the owner detials of that asset
        products[_productID].owner = _receiver;
        
        History memory history = History(_receiver, block.number, block.timestamp);
        
        products[_productID].liveHash = "";
        
        products[_productID].numberOfTransfers += 1;  
        
        products[_productID].history[products[_productID].numberOfTransfers] = _history;
        
        // emit the event 
        emit TransferProduct( _productID, _receiver, history);
        
        
    }
    
    
    
    
    // transfers the asset details by calling the updateAsset func of the Storage.sol contract
    function sell(string memory _productID, string memory _userName, uint _price, string _status) public  {
        

        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, " The username and address are not matching ");
       
        require(keccak256(bytes(products[_productID].owner)) == keccak256(bytes(_userName)), " The user is not the owner of the product.. ");
        
        require(products[_productID].upgradedcontractAddress != address(0x0), "the product is upgraded to another version")

        
        if(keccak256(bytes(_status)) == keccak256(bytes(forSale)){
            
            require(_price > 0, " The price is not mentioned  " );
          
            products[_productID].status = _status;
        }
        
        
        
        // emit the event when asset got called
        emit SellProduct(_productID,products[_productID].status, _price);
    }
    
   
    
    
    // buy the product
    function buy(string memory _buyerName, string memory _buyerName, string memory _productID) public payable  {
        
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, "The address is not the holder of the username");
        
        require(msg.value >= products[_productID].price," Not enough funds");
        
        require(keccak256(bytes(_status)) == keccak256(bytes(forSale), " The product is not for sale ");
        
        require(products[_productID].upgradedcontractAddress != address(0x0), "the product is upgraded to another version")

        // transfer the ether to the seller
        string memory sellerUsername = products[_productID].owner;
        
        address payable sellerAddr = address(uint160(SysAdmin.getUserNameAddr(sellerUsername)));
        
        sellerAddr.transfer(msg.value);
        
        // update the asset owner details in the blockchain
        products[_productID].owner = _buerName;
        
        
       
        products[_productID].numberOftransfers += 1;  
        
        products[_productID].history[products[_productID].hisCount] = _history;
        
        products[_productID].liveHash = "";
        
        History memory history = History(_receiver, block.number, block.timestamp);
        
        
        // add history of the newly bought user to the product history
        products[_productID].history[products[_productID].numberOfTransfers = _history;
        
        // make the product as not for sale
        products[_productID].status = "notForSale"
        
        // emit the event when asset is bought by sender
        emit BuyProduct(_productID, _buerName, history);
        
    }
    
    function upgrade(string memory _productID, string memory _userName, address _upgradedcontractAddress) public {
        
        require(SysAdmin.getUserNameAddr(_userName) == msg.sender, "the caller is not allowed to upgrade the product");
        
        require(products[_productID].upgradedcontractAddress != address(0x0), "the product is already upgraded to another version")
        
        upgradedContract = AssetUpgradeInterface(_upgradedcontractAddress)
        
        // calls the UpgradeToThis contract on the upgraded contract 
        upgradedContract.UpgradeToThis( _productID, products[_productID].owner)
        
        products[_productID].upgradedcontractAddress = _upgradedcontractAddress;
        
        // history logic 
        
        // **** event 
    }
    
    
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SupplyChain {
    //Smart Contract owner will be the person who deploys the contract only he can authorize various roles like retailer, Manufacturer,etc
    address public Owner;

    // this constructor will be called when smart contract will be deployed on blockchain
    constructor() public{
        Owner = msg.sender;
    }

    //Roles (flow of Food supply chain)
    // Supplier; //This is where Manufacturer will get raw materials to make products
    // Transporter; //This is the middle man
    // Manufacturer;  //Various WHO guidelines should be followed by this person
    // Distributor; //This guy distributes the products to retailers
    // Retailer; //Normal customer buys from the retailer

    //modifier to make sure only the owner is using the function
    modifier onlyByOwner() {
        require(msg.sender == Owner);
        _;
    }

    //stages of a product in Food supply chain
    enum STAGE {
        Init,
        Supplier,
        TransporterToManfacturer,
        Manufacture,
        TransporterToDistributor,
        Distributor,
        TransporterToRetailer,
        Retailer
    }
    //using this we are going to track every single product the owner orders
    //Product count
    uint256 public productCtr = 0;
    //Raw material supplier count
    uint256 public rmsCtr = 0;
    //Transporter count
    uint256 public traCtr = 0;
    //Manufacturer count
    uint256 public manCtr = 0;
    //distributor count
    uint256 public disCtr = 0;
    //retailer count
    uint256 public retCtr = 0;

    //To store information about the product
    struct product {
        uint256 id; //unique product id
        string quantity; //product quantity
        string description; // about product
        string location; // product location
        uint256 SUPPid; //id of the supplier for this particular product
        uint256 TRAid; //id of the transporter for this particular product
        uint256 MANid; //id of the Manufacturer for this particular product
        uint256 DISid; //id of the distributor for this particular product
        uint256 RETid; //id of the retailer for this particular product
        STAGE stage; //current product stage
    }

    //To store all the product on the blockchain
    mapping(uint256 => product) public ProductStock;

    //To show status to client applications
    function showStage(uint256 _productID)
    public
    view
    returns (string memory)
    {
        require(productCtr > 0);
        if (ProductStock[_productID].stage == STAGE.Init)
            return "Product Ordered";
        else if (ProductStock[_productID].stage == STAGE.Supplier)
            return "Supply Stage";
        else if (ProductStock[_productID].stage == STAGE.TransporterToManfacturer)
            return "Transporter To Manfacturer Stage";
        else if (ProductStock[_productID].stage == STAGE.Manufacture)
            return "Manufacturing Stage";
        else if (ProductStock[_productID].stage == STAGE.TransporterToDistributor)
            return "Transporter To Distributor Stage";
        else if (ProductStock[_productID].stage == STAGE.Distributor)
            return "Distribution Stage";
        else if (ProductStock[_productID].stage == STAGE.TransporterToRetailer)
            return "Transporter To Retailer Stage";
        else if (ProductStock[_productID].stage == STAGE.Retailer)
            return "Retail Stage";

    }

    //To store information about  supplier
    struct supplier {
        address addr;
        uint256 id; //user id
        string fname; // first name
        string lname; // last name
        string role; //role of the user
        string location; // user's location

    }

    //To store all the raw material suppliers on the blockchain
    mapping(uint256 => supplier) public SUPP;

    //To store information about transporter
    struct transporter {
        address addr;
        uint256 id; //user id
        string fname; // first name
        string lname; // last name
        string role; //role of the user
        string location; // user's location
    }

    //To store all the transporters on the blockchain
    mapping(uint256 => transporter) public TRA;


    //To store information about manufacturer
    struct manufacturer {
        address addr;
        uint256 id; //user id
        string fname; // first name
        string lname; // last name
        string role; //role of the user
        string location; // user's location
    }

    //To store all the manufacturers on the blockchain
    mapping(uint256 => manufacturer) public MAN;

    //To store information about distributor
    struct distributor {
        address addr;
        uint256 id; //user id
        string fname; // first name
        string lname; // last name
        string role; //role of the user
        string location; // user's location
    }

    //To store all the distributors on the blockchain
    mapping(uint256 => distributor) public DIS;

    //To store information about retailer
    struct retailer {
        address addr;
        uint256 id; //user id
        string fname; // first name
        string lname; // last name
        string role; //role of the user
        string location; // user's location
    }

    //To store all the retailers on the blockchain
    mapping(uint256 => retailer) public RET;

    //To add suppliers. Only contract owner can add a new supplier
    function addSUPP(
        address _addr,
        uint256 _id,
        string memory _fname,
        string memory _lname,
        string memory _role,
        string memory _location
    ) public onlyByOwner() {
        rmsCtr++;
        SUPP[rmsCtr] = supplier(_addr, _id, _fname, _lname, _role, _location);
    }
    //To add transporter. Only contract owner can add a new supplier
    function addTRA(
        address _addr,
        uint256 _id,
        string memory _fname,
        string memory _lname,
        string memory _role,
        string memory _location
    ) public onlyByOwner() {
        rmsCtr++;
        TRA[traCtr] = transporter(_addr, _id, _fname, _lname, _role, _location);
    }

    //To add manufacturer. Only contract owner can add a new manufacturer
    function addManufacturer(
        address _addr,
        uint256 _id,
        string memory _fname,
        string memory _lname,
        string memory _role,
        string memory _location
    ) public onlyByOwner() {
        manCtr++;
        MAN[manCtr] = manufacturer(_addr, _id, _fname, _lname, _role, _location);
    }

    //To add distributor. Only contract owner can add a new distributor
    function addDistributor(
        address _addr,
        uint256 _id,
        string memory _fname,
        string memory _lname,
        string memory _role,
        string memory _location
    ) public onlyByOwner() {
        disCtr++;
        DIS[disCtr] = distributor(_addr, _id, _fname, _lname, _role, _location);
    }

    //To add retailer. Only contract owner can add a new retailer
    function addRetailer(
        address _addr,
        uint256 _id,
        string memory _fname,
        string memory _lname,
        string memory _role,
        string memory _location
    ) public onlyByOwner() {
        retCtr++;
        RET[retCtr] = retailer(_addr, _id, _fname, _lname, _role, _location);
    }

    //To supply raw materials from supplier to the manufacturer by transporter
    function supply(uint256 _productID) public {
        require(_productID > 0 && _productID <= productCtr);
        uint256 _id = findSUPP(msg.sender);
        require(_id > 0);
        require(ProductStock[_productID].stage == STAGE.Init);
        ProductStock[_productID].TRAid = _id;
        ProductStock[_productID].stage = STAGE.Supplier;
    }

    //To check if Supplier is available in the blockchain
    function findSUPP(address _address) private view returns (uint256) {
        require(rmsCtr > 0);
        for (uint256 i = 1; i <= rmsCtr; i++) {
            if (SUPP[i].addr == _address) return SUPP[i].id;
        }
        return 0;
    }
    //To supply raw materials from supplier to the manufacturer by transporter
    function toManfacturer (uint256 _productID) public {
        require(_productID > 0 && _productID <= productCtr);
        uint256 _id = findTRA(msg.sender);
        require(_id > 0);
        require(ProductStock[_productID].stage == STAGE.Supplier);
        ProductStock[_productID].TRAid = _id;
        ProductStock[_productID].stage = STAGE.TransporterToManfacturer;
    }

    //To check if transporter is available in the blockchain
    function findTRA(address _address) private view returns (uint256) {
        require(traCtr > 0);
        for (uint256 i = 1; i <= traCtr; i++) {
            if (TRA[i].addr == _address) return TRA[i].id;
        }
        return 0;
    }


    //To manufacture product
    function Manufacturing(uint256 _productID) public {
        require(_productID > 0 && _productID <= productCtr);
        uint256 _id = findMAN(msg.sender);
        require(_id > 0);
        require(ProductStock[_productID].stage == STAGE.TransporterToManfacturer);
        ProductStock[_productID].MANid = _id;
        ProductStock[_productID].stage = STAGE.Manufacture;
    }

    //To check if Manufacturer is available in the blockchain
    function findMAN(address _address) private view returns (uint256) {
        require(manCtr > 0);
        for (uint256 i = 1; i <= manCtr; i++) {
            if (MAN[i].addr == _address) return MAN[i].id;
        }
        return 0;
    }

    //To supply product from Manufacturer to distributor by the transporter
    function toDistributor(uint256 _productID) public {
        require(_productID > 0 && _productID <= productCtr);
        uint256 _id = findTRA(msg.sender);
        require(_id > 0);
        require(ProductStock[_productID].stage == STAGE.Manufacture);
        ProductStock[_productID].DISid = _id;
        ProductStock[_productID].stage = STAGE.TransporterToDistributor;
    }

    // To distribute product
    function Distribution(uint256 _productID) public {
        require(_productID > 0 && _productID <= productCtr);
        uint256 _id = findDIS(msg.sender);
        require(_id > 0);
        require(ProductStock[_productID].stage == STAGE.TransporterToDistributor);
        ProductStock[_productID].DISid = _id;
        ProductStock[_productID].stage = STAGE.Distributor;
    }
    //To check if distributor is available in the blockchain
    function findDIS(address _address) private view returns (uint256) {
        require(disCtr > 0);
        for (uint256 i = 1; i <= disCtr; i++) {
            if (DIS[i].addr == _address) return DIS[i].id;
        }
        return 0;
    }


    //To supply products from distributor to retailer
    function toRetailer(uint256 _productID) public {
        require(_productID > 0 && _productID <= productCtr);
        uint256 _id = findTRA(msg.sender);
        require(_id > 0);
        require(ProductStock[_productID].stage == STAGE.Distributor);
        ProductStock[_productID].RETid = _id;
        ProductStock[_productID].stage = STAGE.TransporterToRetailer;
    }
    //To supply products from distributor to retailer
    function Retail(uint256 _productID) public {
        require(_productID > 0 && _productID <= productCtr);
        uint256 _id = findRET(msg.sender);
        require(_id > 0);
        require(ProductStock[_productID].stage == STAGE.TransporterToRetailer);
        ProductStock[_productID].RETid = _id;
        ProductStock[_productID].stage = STAGE.Retailer;
    }

    //To check if retailer is available in the blockchain
    function findRET(address _address) private view returns (uint256) {
        require(retCtr > 0);
        for (uint256 i = 1; i <= retCtr; i++) {
            if (RET[i].addr == _address) return RET[i].id;
        }
        return 0;
    }



    // To add new products to the stock
    function addProduct(uint256 _id, string memory _quantity, string memory _description, string memory _location)
    public
    onlyByOwner()
    {
        require((rmsCtr > 0) && (manCtr > 0) && (disCtr > 0) && (retCtr > 0));
        productCtr++;
        ProductStock[productCtr] = product(
            _id,
            _quantity,
            _description,
            _location,
            0,
            0,
            0,
            0,
            0,
            STAGE.Init
        );
    }
}


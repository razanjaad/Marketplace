pragma solidity ^0.5.0; // solidity version

contract Marketplace {
    string public name; // state variable to save it to blockchain
    uint public productCount = 0;  //how many products in the mapping

    //mapping for products like a hash table contain the id of product and the product
    mapping(uint => Product) public products;



    // a model for the new product must contains these info.
    struct Product{
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
);
    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public { //run only one time
        name = "Razan Marketplace"; // set the value name
    }

    function createProduct(string memory _name, uint _price) public {
        // Require a name
        require(bytes(_name).length > 0);
        //require a valid price
        require(_price > 0);
        //Increment Product Count
        productCount++;
        // create a product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        //Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);

    }
    function purchaseProduct(uint _id) public payable {
        //Fetch the Product
        Product memory _product = products[_id];
        //Fetch the Owner
        address payable _seller = _product.owner;
        //Make sure the product a valid id
        require(_product.id > 0 && _product.id <= productCount);
        //Require that there is enough Ether in the transaction
        require(msg.value >= _product.price);
        //Require that the product has not been purchased already
        require(!_product.purchased);
        //Require that the buyer is not the seller
        require(_seller != msg.sender);
        //Purchase it which means transfer the ownership to the buyer
        _product.owner = msg.sender;
        //Mark as Purchased
        _product.purchased = true;
        // Update the product
        products[_id] = _product;
        // pay the seller by sending them Ether
        address(_seller).transfer(msg.value);
        //Trigger an event
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);

    }
}

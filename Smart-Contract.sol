// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "hardhat/console.sol";


contract MarketBid{

    

   struct User{
       address user_id;
       string image;
       string username;
       string email;
       string password;
       uint256 balance;
       uint256[] cart_product;
       uint256 timestamp;

   }

   struct Product{
       address owner;
       address creater;
       string title;
       string description;
       string image;
       uint256 price;
       uint deadline;
       address[] owners_history;
       uint256[] price_history;
       uint256 timestamp;


   }


   struct Wllet_transaction {
       address wllet_id;
       address from;
       address to;
       uint256 amount;
   }

   // Table to Storge users 
   mapping (address =>User) public listOfUser;

   //Table to Storge products 
   mapping (uint256 =>Product) public listOfProduct;  

   address[] public listOfAddres_User;
   uint256 public  countOf_product;
   uint256 public countOf_user;

   function Create_User(address _owner,string memory _image,string memory _username ,string memory _email , string memory _password , uint _amount) public {

    //check of this account unique
    require(_owner != listOfUser[_owner].user_id,"This account already exists");

    require(_amount >= 0,"Your balance must be greater or equal to 0" );


    User storage user = listOfUser[_owner];

    listOfAddres_User.push(_owner);
    //Add user
    user.user_id = _owner;
    user.username = _username;
    user.email = _email;
    user.image = _image;
    user.password = _password;
    user.balance = _amount;
    user.timestamp = block.timestamp;

    countOf_user++;
   }



   
   function Create_Product(address _owner,uint256 _price, string memory _title, string memory _description,uint256 _deadline, string memory _image ) public {

    //check of this product not expired deadline 
    require(_deadline < block.timestamp, "The deadline should be a date in the future.");

    //check of this account unique
    require(_owner == listOfUser[_owner].user_id,"You cannot build a product without registration");

    Product storage product = listOfProduct[countOf_product];
    //Add Product
    product.owner= _owner;
    product.creater = _owner;
    product.title = _title;
    product.description = _description;
    product.image = _image;
    product.deadline = _deadline;
    product.price= _price;
    product.timestamp = block.timestamp;
    product.price_history.push(_price);
    product.owners_history.push(_owner);
    
    listOfUser[_owner].cart_product.push(countOf_product);

    countOf_product++;

   }



    
    function Buy_Product(address _onwer,uint _amount ,uint256 id) public {

       
       require(_onwer == listOfUser[_onwer].user_id,"You cannot buy product wihtout registration ");
       require(_amount > listOfProduct[id].price," you can  not buy this product");
       require(_amount < listOfUser[_onwer].balance,"you balance not enough");

       listOfProduct[id].price=_amount;
       listOfProduct[id].price_history.push(_amount);
       listOfProduct[id].owners_history.push(_onwer);
       listOfProduct[id].owner = _onwer;
       listOfUser[_onwer].cart_product.push(id);
       listOfUser[_onwer].balance-=_amount;
    } 


    function getAllUser() public view returns (User[] memory ) 
    {
        User[] memory allUser = new User[](countOf_user);

        for(uint i = 0; i < countOf_user; i++) {
            User storage item = listOfUser[listOfAddres_User[i]];

            allUser[i] = item;
        }

        return allUser;
    }


    function getAllProduct() public view returns (Product[] memory ) 
    {
        Product[] memory allProduct = new Product[](countOf_product);

        for(uint i = 0; i < countOf_product; i++) {
            Product storage item = listOfProduct[i];

            allProduct[i] = item;
        }

        return allProduct;
    }

    function get_username(address user) public  view returns(string memory){

        return listOfUser[user].username;
    }


}


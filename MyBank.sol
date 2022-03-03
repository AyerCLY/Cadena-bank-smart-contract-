// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

//@dev bank with withdraw and deposit function

contract Bank {
    address public bankOwner; // Identify state var: bankOwner, data type is "address" and is public 
    string public bankName; // Identify state var bankName, data type is "string" and is public 
    mapping(address => uint) public customerBalance; // We create a mapping named CustomerBalance with the keys being the wallet address of our customers and value the amount of Ether they deposit in Wei.
    //if we enter user account address , it will show their bank balance

    constructor() { //define our constructor function to initialize our state variables
        bankOwner = msg.sender; // msg. is a global var, accept properties like 'sender', 'value'. Bank owner must be equal to msg.sender
    }

    function depositMoney() public payable { // visibility specifier of public which allows the function to be called internally or externally. 
    //Then we have our modifier payable. As the name implies we need this modifier to recieve money in our contract.
        require (msg.value != 0, "You have to deposit some amount of money!"); // check to ensure the user is not sending us zero wei
        customerBalance[msg.sender] += msg.value; // see if 'msg.sender' exists and add the deposit amount to their balance 
    }

    function setBankName(string memory _name) external { // it won't be calling in our contract, so use ecternal to save gas fee
        // add "_" in front of parameters has become a convention
        require (msg.sender == bankOwner, "You must be the Bank Owner to set the name of the bank"); // check so only bank owner can change the bank name
        bankName = _name;
    }

    //I think this function should name 'transfermoney' instead
    function withdrawMoney (address payable _to, uint256 _total) public { //customer have to enter the wallet address and withdraw amount
        require (_total <= customerBalance[msg.sender], "You have insuffient funds to withdraw");// chseck if the account has sufficient amount of money to withdraw
        customerBalance[msg.sender] -= _total; // deduct the withdraw amount from customer's account balance
        _to.transfer(_total); // transfer money to customer's address
        //the transfer function is built into Solidity and transfers money to an address
    }

    function getCustomerBalance() external view returns (uint256) { // create a getter to get the balance of the wallet calling our contract
        return customerBalance[msg.sender];
    }

    function getBankBalance() public view returns (uint256) { //create another getter function to get the balance of the entire bank
        require (msg.sender == bankOwner, "Only bank owner can check the bank balance");
        return address(this).balance;// this represents a "contract instance" object for the current contract. The balance function is part of the "address" object. 'https://ethereum.stackexchange.com/questions/58298/this-balance-vs-addressthis-balance'
        //'address(this).balance' which explicitly converts this (the current contract instance) to an address object.
    }  
}

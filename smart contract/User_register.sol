// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;

contract User_register {

    struct User {
        string name ;
        uint WalletBalance;
    }

    event UserAdded(address userAddress, string name);

    mapping ( address => User ) public users ; 
    uint public numUsers = 0;
    address public manager ; //system owner
   
    constructor () {
        manager = msg.sender; 
    }
    
    function getContractAddress() public view returns (address) {
        return address(this);
    }
   
    function addUser (address userAddress, string memory name) public restricted returns ( uint ){
        require(bytes(users[userAddress].name).length == 0, "User already exists!");
        require(userAddress != address(0x0), "Invalid user address!");

        User memory u;
        u. name = name ;
        users[userAddress] = u;
        numUsers++;
        
        emit UserAdded(userAddress, name);
        
        return numUsers;
    }

     modifier restricted () {
        require(msg.sender == manager, "Can only be executed by the manager");
        _;
    }
    
}



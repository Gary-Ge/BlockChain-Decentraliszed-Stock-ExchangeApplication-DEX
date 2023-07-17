// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract User_register {

    struct User {
        string name ;
        uint WalletBalance;
    }


    mapping ( address => User ) public users ; 
    uint public numUsers = 0;
    address public manager ; //system owner
   
    constructor () {
        manager = msg. sender ; 
    }
   
   
    function addUser ( address userAddress , string memory name ) public restricted returns ( uint ){
        User memory u;
        u. name = name ;
        users [ userAddress ] = u;
        numUsers ++;
        return numUsers ;
    }

     modifier restricted () {
        require ( msg . sender == manager , " Can only be executed by the manager ");
        _;
    }
 
}
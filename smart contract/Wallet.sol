// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Wallet{
    address payable public owner; //Wallet owner

    constructor(){
        owner = payable(msg.sender);
    
    }

    receive() external payable {}

    function withdraw(uint _amount) external{
        require(msg.sender == owner, "Only the owner can call this method.");
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external  view returns (uint){
        return address(this).balance;
    }


}
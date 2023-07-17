// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Buy_and_Sale_Cyptos {
    address public owner; //system owner
    mapping(address => uint) public BTCBalances;
    mapping(address => uint) public DogeBalances;

    constructor(){
        owner = msg.sender;
        BTCBalances[address(this)] = 100;
        DogeBalances[address(this)] = 100;
    }

    function getBTCBalance() public view returns (uint){
        return BTCBalances[address(this)];
    }

    function getDogeBalance() public view returns (uint){
        return DogeBalances[address(this)];
    }

    //function repurchase_fm_ext_exchange(uint amount) public {
        //require(msg.sender==owner, "Only the owner an repuchase from the system");
        //BTCBalances[address(this)] += amount;
        //DogeBalances[address(this)] += amount;
    //}

    function puchaseBTC(uint amount) public payable {
        require(msg.value >= amount * 2 ether, "You must pay at least 2 ether per BTC");
        require(BTCBalances[address(this)] >= amount, "Not enough BTC");
        BTCBalances[address(this)] -= amount;
        BTCBalances[msg.sender] += amount;
    }

       function puchaseDoge(uint amount) public payable {
        require(msg.value >= amount * 0.5 ether, "You must pay at least 0.5 ether per Doge");
        require(DogeBalances[address(this)] >= amount, "Not enough Doge");
        DogeBalances[address(this)] -= amount;
        DogeBalances[msg.sender] += amount;
    }
}
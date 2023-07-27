# BlockChain Decentraliszed Currency ExchangeApplication：DEX

#Demo 1 User Registration

The backend is a simple Python web server that uses the Flask framework to interact with an Ethereum smart contract and a DynamoDB database. 

## Prerequisites

The application requires the following software and libraries:
1. Solidity version ^0.7.6
2. An Ethereum wallet Metamask 
3.Ethereum RPC client Infura
4. Python 3.8+
5. Flask
6. Boto3
7. Web3.py
8. An AWS Account with DynamoDB and the necessary access credentials
9. Access to an Ethereum node. This program uses the Goerli test network.

##Installation Instructions

In the backend,before running the program, you must first install all the required libraries. You can do this with the following command:
```
pip install flask boto3 web3
```

## Running the Application

1.After installing the required libraries, you can run the backend application. 
2.Secondly,on solidity,please call the add_user function and input your User Address and Name,then these two information will be listened by flask and sent to the DynamoDB.
3.In addition to the 1, 2 steps,you can also do registration through URL mapping.This application exposes two routes:
http://127.0.0.1:5000/user/<address>. This route returns the user associated with a given Ethereum address.
http://127.0.0.1:5000/adduser/<address>/<name>. This route adds a new user to the database with a specified Ethereum address and name.
You can test these routes by replacing <address> and <name> with a valid Ethereum address and a user name respectively.

## Important Note

Please ensure to change the Ethereum account and private key information with your own account's information. Also, replace the DynamoDB keys and region with your own information before running the application.


#Demo 2 Token Swap

This contract interfaces with the Uniswap v3 swap router to execute single asset swaps between Link and WETH tokens.

## Prerequisites

The application requires the following software and libraries:
1.Solidity version ^0.7.6
2. An Ethereum wallet Metamask 

##Functions

getLinkBalance(address): Returns the balance of Link tokens for a specified address.
getWethBalance(address): Returns the balance of WETH tokens for a specified address.
swapExactInputSingleLinkToWeth(uint256): Executes a swap from Link to WETH with an exact input amount.
swapExactInputSingleWethToLink(uint256): Executes a swap from WETH to Link with an exact input amount.
swapExactOutputSingleLinkToWeth(uint256, uint256): Executes a swap from Link to WETH with an exact output amount.
swapExactOutputSingleWethToLink(uint256, uint256): Executes a swap from WETH to Link with an exact output amount.

## Running the Application
1.Go to https://faucets.chain.link/goerli to get some LINK token
2.Go to Matemask to transfer some LINK token to the SC for swap
3.Call the swapExactInputSingleLinkToWeth to exchange Link to WETH,if the transaction is success, the WETH token will be sent to your wallet directly.
4.Now you can repeat the previous steps to call other 3 functions.

# BlockChain-Decentraliszed-Stock-ExchangeApplication-DEX
BlockChain Decentraliszed Stock ExchangeApplication：DEX,

We use the  DynamoDB,a fully managed NoSQL database service provided by Amazon Web Services (AWS). 

For solidity
If you want to register, please deploy the register_Gary.sol smart contract on solidity and get the SC address and ABI,please remember to deploy your SC on environment: Injected Provider-MetaMask


For userdatabase.py
Line 7:Don't change aws_access_key_id and aws_secret_access_key, they are the key information to connect to my database
Line 155:'chainId': 11155111 is connected to Sepolia

You can change these:
Line12:https://sepolia.infura.io/v3/9a4b375633ea4a87a4e7478223ae27fa is a URL that points to an Infura Ethereum node


Line 14 and 15: contract_address and contract_abi
(you can call getContractAddress function to get the contract address and when you conmpile the file,you can copy the ABI )

Line 143 and 146:In the add user function,private_key and nonce is connected to my metaMask,please change it to your account information

Then,for example,input http://127.0.0.1:5000/adduser/0x5b9F7F1672000a655748645D8299B0AAab357d45/Gary on your google and you will add a user to our dataset,0x5b9F7F1672000a655748645D8299B0AAab357d45 is the user address and Gary is the username

If you want to check whether the registration is successful or not,please input this URL http://127.0.0.1:5000/user/0x5b9F7F1672000a655748645D8299B0AAab357d45

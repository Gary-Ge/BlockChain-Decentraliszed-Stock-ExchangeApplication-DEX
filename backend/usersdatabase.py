from flask import Flask, jsonify
import boto3
from web3 import Web3

app = Flask(__name__)
# mydatabase message,aws_access_key_id and aws_secret_access_key is my database key, please don't change it
dynamodb = boto3.resource('dynamodb', region_name='ap-southeast-2',aws_access_key_id='AKIA6PA7QZHMG6LFTSHQ',
    aws_secret_access_key='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')
table = dynamodb.Table('Users')
#Use the HTTPProvider provider to specify the HTTP connection of the Ethereum node
# https://sepolia.infura.io/v3/9a4b375633ea4a87a4e7478223ae27fa is a URL that points to an Infura Ethereum node.
web3 = Web3(Web3.HTTPProvider('https://sepolia.infura.io/v3/9a4b375633ea4a87a4e7478223ae27fa'))
# the contract address and contract abi
contract_address = '0x3F2d999752A549C2Bf13f56452B54C8FbBa6FA53'
contract_abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			}
		],
		"name": "addUser",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": False,
		"inputs": [
			{
				"indexed": False,
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			},
			{
				"indexed": False,
				"internalType": "string",
				"name": "name",
				"type": "string"
			}
		],
		"name": "UserAdded",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "getContractAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "manager",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "numUsers",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "users",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "WalletBalance",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
contract = web3.eth.contract(address=contract_address, abi=contract_abi)

# here you can use url like http://127.0.0.1:5000/user/0x5b9F7F1672000a655748645D8299B0AAab357d45 to get user in our database
@app.route('/user/<address>')
def get_user(address):
    response = table.get_item(Key={'userAddress': address})
    if 'Item' in response:
        return jsonify(response['Item'])
    else:
        return jsonify({'error': 'User not found'}), 404
# here you can use url like http://127.0.0.1:5000/adduser/0x5b9F7F1672000a655748645D8299B0AAab357d45/Gary to add user to our database
@app.route('/adduser/<address>/<name>')
def add_user(address, name):
    # Your private key
	# the metamask account and value, you can change it
    private_key = "6dc81a8bca9fbdafa6369359b20f9840cf82557d3f016a350ba80e8c7ab3637d"

    # Get the nonce
    nonce = web3.eth.get_transaction_count('0x5b9F7F1672000a655748645D8299B0AAab357d45', 'pending')

    # Build a transaction that invokes this contract's function `addUser`
    txn_dict = {
        'to': contract_address,
        'value': 0,  # It is better to specify this even if not needed
        'gas':1000000,
        'gasPrice':web3.to_wei('1', 'gwei'),
        'nonce': nonce,
        'chainId': 11155111,  # sepolia test net
        'data': contract.encodeABI(fn_name="addUser", args=[address, name])
    }

    # Sign the transaction
    signed_txn = web3.eth.account.sign_transaction(txn_dict, private_key)

    # Send the transaction
    tx_hash = web3.eth.send_raw_transaction(signed_txn.rawTransaction)

    # Wait for the transaction to be mined, and get the transaction receipt
    tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)

    # If the transaction was successful, store the new user address in DynamoDB
    if tx_receipt['status'] == 1:
        # Store the user address in DynamoDB
        table.put_item(Item={'userAddress': address, 'name': name})

        return jsonify({'userAddress': address, 'name': name})

    # If the transaction failed, return an error
    else:
        return jsonify({'error': 'Transaction failed'}), 500






if __name__ == '__main__':
    app.run(debug=True)



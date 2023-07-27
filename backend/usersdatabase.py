from flask import Flask, jsonify
import boto3
from web3 import Web3
import threading
import time

app = Flask(__name__)
# mydatabase message,aws_access_key_id and aws_secret_access_key is my database key, please don't change it
dynamodb = boto3.resource('dynamodb', region_name='ap-southeast-2',aws_access_key_id='AKIA6PA7QZHMG6LFTSHQ',
    aws_secret_access_key='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')
table = dynamodb.Table('Users')
#Use the HTTPProvider provider to specify the HTTP connection of the Ethereum node
web3 = Web3(Web3.HTTPProvider('https://goerli.infura.io/v3/9a4b375633ea4a87a4e7478223ae27fa'))
# the contract address and contract abi
contract_address = '0xDdee5f4eB11EDe5c32E01CC7DF2c9fE31AFa496A'
contract_abi =[
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "spender",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "amount",
                "type": "uint256"
            }
        ],
        "name": "approve",
        "outputs": [
            {
                "internalType": "bool",
                "name": "",
                "type": "bool"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "account",
                "type": "address"
            }
        ],
        "name": "balanceOf",
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
                "name": "recipient",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "amount",
                "type": "uint256"
            }
        ],
        "name": "transfer",
        "outputs": [
            {
                "internalType": "bool",
                "name": "",
                "type": "bool"
            }
        ],
        "stateMutability": "nonpayable",
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
    private_key = "d82181e66f7184759116f845832ccae2576db73c0f072a129f6d9e9578e79f8c"

    # Get the nonce
    nonce = web3.eth.get_transaction_count('0x5b9F7F1672000a655748645D8299B0AAab357d45', 'pending')

    # Build a transaction that invokes this contract's function `addUser`
    txn_dict = {
        'to': contract_address,
        'value': 0,  # It is better to specify this even if not needed
        'gas':1000000,
        'gasPrice':web3.to_wei('10', 'gwei'),
        'nonce': nonce,
        'chainId': 5,  # sepolia test net
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

def handle_event(event):
    data = event['data'].hex()
    user_address = '0x' + data[26:66]
    name_length = int(data[66:130], 16) * 2
    name = bytes.fromhex(data[130:130 + name_length]).decode()
    table.put_item(Item={'userAddress': user_address, 'name': name})


def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
        time.sleep(poll_interval)

def start_listening():
    event_signature_hash = web3.keccak(text="UserAdded(address,string)").hex()
    event_filter = web3.eth.filter({
        "address": contract_address,
        "topics": [event_signature_hash],
        "fromBlock": "latest"
    })
    log_loop(event_filter, 2)



if __name__ == '__main__':
    listener = threading.Thread(target=start_listening)
    listener.start()

    app.run(debug=True)

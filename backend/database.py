import sqlite3
from web3 import Web3

# 连接到数据库
conn = sqlite3.connect('user_database.db')
cursor = conn.cursor()

# 连接到以太坊节点
#w3 = Web3(Web3.HTTPProvider('<your_ethereum_node_url>'))

# 加载智能合约 ABI
#contract_address = '<your_contract_address>'  # 替换为合约地址
#contract_abi = [...]  # 替换为智能合约 ABI

# 获取智能合约实例
#contract = w3.eth.contract(address=contract_address, abi=contract_abi)

# 创建用户表
cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        address TEXT UNIQUE,
        registered INTEGER
    )
''')
conn.commit()

# 注册用户
#def register_user(address):
    #contract.functions.register().transact({'from': address})
    #cursor.execute("INSERT INTO users (address, registered) VALUES (?, 1)", (address,))
    #conn.commit()
def register_user(address):
    cursor.execute("INSERT INTO users (address, registered) VALUES (?, 1)", (address,))
    conn.commit()

# 验证用户是否已注册
#def is_registered_user(address):
    #return cursor.execute("SELECT COUNT(*) FROM users WHERE address = ? AND registered = 1", (address,)).fetchone()[0] > 0
def register_user(address):
    cursor.execute("SELECT COUNT(*) FROM users WHERE address = ?", (address,))
    count = cursor.fetchone()[0]
    if count == 0:
        cursor.execute("INSERT INTO users (address, registered) VALUES (?, 1)", (address,))
        conn.commit()
        return True
    else:
        return False
# 关闭数据库连接
def close_connection():
    cursor.close()
    conn.close()

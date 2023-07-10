from database import *

# 连接到数据库
conn = sqlite3.connect('user_database.db')
cursor = conn.cursor()

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
is_registered = register_user('0x123456782...')  # 替换为要注册的用户地址
print(f"Registration successful: {is_registered}")


# 关闭数据库连接
cursor.close()
conn.close()


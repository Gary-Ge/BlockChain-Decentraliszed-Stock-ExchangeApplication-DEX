import sqlite3

# 连接到数据库
conn = sqlite3.connect('user_database.db')
cursor = conn.cursor()

# 执行查询
cursor.execute("SELECT * FROM users")
rows = cursor.fetchall()

# 打印结果
for row in rows:
    print(row)

# 关闭数据库连接
cursor.close()
conn.close()

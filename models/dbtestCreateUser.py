from MongoDBMgr import MongoDBMgr
from User_Helper import UserHelper
from User import User

# MongoDB 連線資訊
mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"

# 初始化 DB 管理器
db_mgr = MongoDBMgr(db_name,mongo_uri)

# 初始化使用者助手
user_helper = UserHelper(db_mgr)

# 創建新使用者
new_user = User(name='Evan', email='EEEE@example.com', birth='1990-01-01', password='password123', sex='male')
result = user_helper.create_user(new_user)
print(result)



# # 使用 email 和 password 登入
# logged_in_user = User.get_user_by_email_and_password(mongo_mgr, 'EEEE@example.com', 'password123')
# if logged_in_user:
#     print(logged_in_user.get_user_data() + " 登入成功 ")
# else:
#     print('登入失敗')

# # 更新使用者名稱
# user.update_name(mongo_mgr, 'EEEE Newname')

# # 關閉 MongoDB 連接
# mongo_mgr.close()

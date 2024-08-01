from MongoDBMgr import MongoDBMgr
from User_Helper import UserHelper
from User import User

# 初始化 MongoDBMgr 實例
uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name, uri)

# 初始化 UserHelper 實例
helper = UserHelper(mongo_mgr)

#create user
# name = "ashley"
# email = "123@gmail"
# password = "123456789"

# new_user = User(name,email,password)
# create_result = helper.create_user(new_user)
# print(create_result)
# print(new_user.get_user_data())

#----------------------------------------------------
#update user
# update_name = "ashley123"
# update_result = helper.update_user_field("66abaa64c8cd27a58c4a8260","Name",update_name)
# print(update_result)

#----------------------------------------------------
#get user by email & password
# email = "123@gmail"
# password = "123456789111"
# get_by_EP_result = helper.get_user_by_email_and_password(email,password)
# print(get_by_EP_result)





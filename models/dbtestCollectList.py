# dbtestCreateCL.py
from MongoDBMgr import MongoDBMgr
from User_Helper import UserHelper
from Collect_List_Helper import Collect_List_Helper

# MongoDB 連線資訊
mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"

# 初始化 UserHelper 和 Collect_List_Helper
db_mgr = MongoDBMgr(db_name,mongo_uri)
user_helper = UserHelper(db_mgr)
cl_helper = Collect_List_Helper(db_mgr)

# 創建收藏列表
user_id = "66444b8fb92ec708c91009ad"
cl = cl_helper.create_CL_by_UserId(user_id, "最新的收藏")
print(cl.get_CL_data())

# 移除收藏列表
# remove_result = cl_helper.remove_CL(cl.id)
# print(remove_result)

# 獲取用戶所有收藏列表
all_cl = cl_helper.get_All_CL_by_UserId(user_id)
for cl in all_cl:
    print(cl.get_CL_data())

# 關閉 MongoDB 連接
db_mgr.client.close()

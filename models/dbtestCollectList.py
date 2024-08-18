from bson import ObjectId
# dbtestCreateCL.py
from MongoDBMgr import MongoDBMgr
from User_Helper import UserHelper
from Collect_List_Helper import Collect_List_Helper
from Collect_List import Collect_List

# MongoDB 連線資訊
mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"

# 初始化 UserHelper 和 Collect_List_Helper
db_mgr = MongoDBMgr(db_name,mongo_uri)
user_helper = UserHelper(db_mgr)
cl_helper = Collect_List_Helper(db_mgr)

# 創建收藏列表
user_id = "66435b426b52ed9b072dc0dd"
cl_id = "6685fefabac4f8150822deb7"
Name='最新的收藏9'
collection = ''
cl = cl_helper.get_CL_by_UserId_and_ClId(user_id,cl_id)
return_data = cl_helper.update_CL_data(cl_id,"name","new_value")
print(return_data)
# if cl :
#     print(cl.get_CL_data())
# new_CL = Collect_List("",user_id, Name, collection)

# cl_helper.create_CL_by_UserId(new_CL)
# print(new_CL.get_CL_data())


# # 移除收藏列表
# remove_result = cl_helper.remove_CL(cl.id)
# print(remove_result)

# user_id=ObjectId("66435b426b52ed9b072dc0dd")
# videoName = '我的收藏清單'

# # 獲取用戶所有收藏列表
# all_cl = cl_helper.get_All_CL_by_UserId(user_id)
# print(all_cl[0])
# print(cl_helper.get_All_CL_by_UserId(user_id))
# all_cl[1].remove_video(cl_helper,"66436c17b92ec708c91009a8")
# cl_helper.remove_CL("668415feb88546a74f87af6c") 
# id = all_cl[3].get_id()
# cl_helper.remove_CL(id)
# for cl in all_cl:
#     new_cl = Collect_List("",user_id, Name, collection)
#     print(cl.get_CL_data())
    # cl.update_name(cl_helper,"newName")
# all_cl = cl_helper.get_All_CL_by_UserId(user_id)

# print(all_cl[1].get_CL_data())
# print(all_cl[1].get_user_id())
# print(all_cl[1].get_name())
# print(all_cl[1].get_collection())
    

# cl = cl_helper.get_CL_by_UserId_and_Name( user_id, videoName)
# print(cl.get_CL_data())
# cl.add_video(cl_helper,ObjectId('66436c17b92ec708c91009a7'))

# 關閉 MongoDB 連接
db_mgr.client.close()

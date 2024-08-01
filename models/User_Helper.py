from bson import ObjectId
import sys
sys.path.append(r'..')
from User import User 

class UserHelper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr

    # def get_collection(self, collection_name):
    #     """獲取指定名稱的集合"""
    #     return self.db_mgr.get_collection(collection_name)

    def create_user(self, user):
        user_collection = self.db_mgr.get_collection('User')
        if user_collection.find_one({"Email": user.email}):
            return {"success": False, "message": "Email 已被註冊"}
        else:
            user_data = {
                "Name": user.name,
                "Email": user.email,
                "Password": user.password
            }
            result = user_collection.insert_one(user_data)
            user.set_id(result.inserted_id)
            return {"success": True, "message": "註冊成功"}

    def update_user_field(self, user_id, field_name, new_value):
        user_collection = self.db_mgr.get_collection('User')
        result = user_collection.update_one(
            {"_id": ObjectId(user_id)},
            {"$set": {field_name: new_value}}
        )
        if result.matched_count > 0:
            return {"success": True, "message": "更新成功"}
        else:
            return {"success": False, "message": "找不到用戶"}

    def get_user_by_email_and_password(self, email, password):
        users_collection = self.db_mgr.get_collection('User')
        user_data = users_collection.find_one({"Email": email, "Password": password})
        if user_data:
            return {
                "success": True,
                "message": "取得成功",
                "email": user_data['Email'],
                "password": user_data['Password']
            }
        else:
            return {
                "success": False,
                "message": "用戶不存在或密碼錯誤"
        }
    # login

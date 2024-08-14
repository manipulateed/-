from bson import ObjectId
import sys
sys.path.append(r'..')
#from User import User
import logging 

class UserHelper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr
        self.logger = logging.getLogger(__name__)

    def create_user(self, user):
        user_collection = self.db_mgr.get_collection('User')
        if user_collection.find_one({"Email": user.email}):
            return {"success": False, "message": "Email has existed"}
        else:
            user_data = {
                "Name": user.name,
                "Email": user.email,
                "Password": user.password
            }
            result = user_collection.insert_one(user_data)
            user.set_id(result.inserted_id)
            return {"success": True, "message": "signup success"}

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
        self.logger.info(f"Attempting to find user with email: {email}")
        user_data = users_collection.find_one({"Email": email, "Password": password})
        if user_data:
            self.logger.info(f"User found: {user_data}")
            return {
                "success": True,
                "message": "取得成功",
                "id": str(user_data['_id']),  # 將 ObjectId 轉換為字符串
                "email": user_data['Email'],
                "name": user_data['Name'],
                "password": user_data['Password']
            }
        else:
            self.logger.warning(f"User not found for email: {email}")
            return {
                "success": False,
                "message": "用戶不存在或密碼錯誤"
            }

    def get_user_by_id(self, user_id):
        users_collection = self.db_mgr.get_collection('User')
        self.logger.info(f"Attempting to find user with id: {user_id}")
        try:
            object_id = ObjectId(user_id)
            user_data = users_collection.find_one({"_id": object_id})
            if user_data:
                self.logger.info(f"User found: {user_data}")
                return {
                    "success": True,
                    "message": "取得成功",
                    "id": str(user_data['_id']),
                    "email": user_data['Email'],
                    "name": user_data['Name'],
                    "password": user_data['Password']
                }
            else:
                self.logger.warning(f"User not found for id: {user_id}")
                return {
                    "success": False,
                    "message": "找不到用戶"
                }
        except Exception as e:
            self.logger.error(f"Error when fetching user by id: {str(e)}")
            return {
                "success": False,
                "message": f"查詢用戶時發生錯誤: {str(e)}"
            }
    # login

from bson import ObjectId
from User import User 

class UserHelper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr

    def get_collection(self, collection_name):
        """獲取指定名稱的集合"""
        return self.db_mgr.get_collection(collection_name)

    def create_user(self, user):
        user_collection = self.get_collection('User')
        if user_collection.find_one({"Email": user.email}):
            return {"success": False, "message": "Email 已被註冊"}
        else:
            user_data = {
                "Name": user.name,
                "Email": user.email,
                "Birthday": user.birth,
                "Password": user.password,
                "Sex": user.sex
            }
            result = user_collection.insert_one(user_data)
            user.set_id(result.inserted_id)
            return {"success": True, "message": "註冊成功"}

    def update_user_field(self, user_id, field_name, new_value):
        user_collection = self.get_collection('User')
        result = user_collection.update_one(
            {"_id": ObjectId(user_id)},
            {"$set": {field_name: new_value}}
        )
        if result.matched_count > 0:
            return {"success": True, "message": "更新成功"}
        else:
            return {"success": False, "message": "找不到用戶"}

    @staticmethod
    def get_user_by_email_and_password(db_mgr, email, password):
        users_collection = db_mgr.get_collection('User')
        user_data = users_collection.find_one({"Email": email, "Password": password})
        if user_data:
            user = User(
                name=user_data['Name'],
                email=user_data['Email'],
                birth=user_data['Birthday'],
                password=user_data['Password'],
                sex=user_data['Sex']
            )
            user.set_id(user_data['_id'])
            return user
        else:
            return None
    # login

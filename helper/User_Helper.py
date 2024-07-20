from pymongo import MongoClient
from bson import ObjectId
from bigproject.models.User import User

class User_Helper:
    def __init__(self, mongo_uri, db_name):
        self.client = MongoClient(mongo_uri)
        self.db = self.client[db_name]

    def get_collection(self, collection_name):
        return self.db[collection_name]

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
    def get_user_by_email_and_password(helper, email, password):
        users_collection = helper.get_collection('User')
        user_data = users_collection.find_one({"Email": email, "Password": password})
        if user_data:
            user = User(
                name=user_data['Name'],
                email=user_data['Email'],
                birth=user_data['Birthday'],
                password=user_data['Password'],
                sex=user_data['Sex']
            )
            return user
        else:
            return None

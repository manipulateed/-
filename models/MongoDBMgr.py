from pymongo import MongoClient
import json

class MongoDBMgr:
    def __init__(self, db_name, uri):
        """初始化MongoDB連接"""
        self.client = MongoClient(uri)
        self.db = self.client[db_name]

    def get_collection(self, collection_name):
        """獲取指定名稱的集合"""
        return self.db[collection_name]

    def close(self):
        """關閉MongoDB連接"""
        self.client.close()

# 使用範例
uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"

# 初始化MongoDB管理器
mongo_mgr = MongoDBMgr(db_name, uri)

# # 獲取集合
# collection = mongo_mgr.get_collection("Muscle_Area")
# # for document in collection.find():
# #     print(document)

# # 操作集合，例如插入文檔
# collection.insert_one({"Name": "腳趾"})
# print("close")

# # 關閉連接
# mongo_mgr.close()

from bson import ObjectId
from Collect_List import Collect_List

class Collect_List_Helper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr
    
    def create_CL_by_UserId(self, user_id, name):
        collection = self.db_mgr.get_collection('Collect_List')
        cl_data = {
            "user_id": ObjectId(user_id),
            "name": name,
            "collection": []
        }
        result = collection.insert_one(cl_data)
        cl = Collect_List(
            id=result.inserted_id,
            user_id=user_id,
            name=name,
            collection=[]
        )
        return cl

    def remove_CL(self, cl_id):
        collection = self.db_mgr.get_collection('Collect_List')
        result = collection.delete_one({"_id": ObjectId(cl_id)})
        if result.deleted_count > 0:
            return {"success": True, "message": "移除成功"}
        else:
            return {"success": False, "message": "找不到收藏列表"}

    def get_All_CL_by_UserId(self, user_id):
        collection = self.db_mgr.get_collection('Collect_List')
        cl_data_list = collection.find({"user_id": ObjectId(user_id)})
        cl_list = []
        for cl_data in cl_data_list:
            cl = Collect_List(
                id=cl_data['_id'],
                user_id=cl_data['user_id'],
                name=cl_data['name'],
                collection=cl_data['collection']
            )
            cl_list.append(cl)
        return cl_list

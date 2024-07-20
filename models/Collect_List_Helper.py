from bson import ObjectId
from Collect_List import Collect_List

class Collect_List_Helper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr
    
    def create_CL_by_UserId(self, cl):
        collection = self.db_mgr.get_collection('Collect_List')
        cl_data = {
            "User_Id": ObjectId(cl.user_id),
            "Name": cl.name,
            "Collect_Video": []
        }
        result = collection.insert_one(cl_data)
        cl.set_id(result.inserted_id)
        return {"success": True, "message": "新增成功"}

    def update_CL_data(self, cl_id, type, new_value):
        collection = self.db_mgr.get_collection('Collect_List')
        if type == 'name':
            collection.update_one({'_id': cl_id}, {'$set': {'Name': new_value}})
        elif type == 'add_video':
            collection.update_one({'_id': cl_id}, {'$addToSet': {'Collect_Video': ObjectId(new_value)}})
        elif type == 'remove_video':
            collection.update_one({'_id': cl_id}, {'$pull': {'Collect_Video': ObjectId(new_value)}})
        else:
            return {"success": False, "message": "invalid field name"}

        return {"success": True, "message": "修改成功"}
        

    def remove_CL(self, cl_id):
        collection = self.db_mgr.get_collection('Collect_List')
        result = collection.delete_one({"_id": ObjectId(cl_id)})
        if result.deleted_count > 0:
            return {"success": True, "message": "移除成功"}
        else:
            return {"success": False, "message": "找不到收藏列表"}

    def get_All_CL_by_UserId(self, user_id):
        collection = self.db_mgr.get_collection('Collect_List')
        cl_data_list = collection.find({"User_Id": ObjectId(user_id)})
        cl_list = []
        for cl_data in cl_data_list:
            cl = Collect_List(
                id=cl_data['_id'],
                user_id=cl_data['User_Id'],
                name=cl_data['Name'],
                collection=cl_data['Collect_Video']
            )
            cl_list.append(cl)
        return cl_list
    
    def get_CL_by_UserId_and_Name(self, user_id, name):
        collection = self.db_mgr.get_collection('Collect_List')
        cl = collection.find_one({"User_Id": ObjectId(user_id), "Name": name})
        if cl:
            return cl
        else:
            return None

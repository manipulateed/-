from bson import ObjectId
from Sour_Record import Sour_Record

class Sour_Record_Helper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr

    def create_sour_record(self, sour_record):
        sour_record_collection = self.db_mgr.get_collection('Sour_Record')
        sour_record_data = {
            "User_Id": ObjectId(sour_record.user_id),
            "Videos": [ObjectId(video_id) for video_id in sour_record.videos],
            "Title": sour_record.title,
            "Reason": sour_record.reason,
            "Time": sour_record.time
        }
        result = sour_record_collection.insert_one(sour_record_data)
        sour_record.set_id(result.inserted_id)
        return {"success": True, "message": "痠痛紀錄創建成功"}

    def update_sour_record(self, record_id, field_name, new_value):
        sour_record_collection = self.db_mgr.get_collection('Sour_Record')
        result = sour_record_collection.update_one(
            {"_id": ObjectId(record_id)},
            {"$set": {field_name: new_value}}
        )
        if result.matched_count > 0:
            return {"success": True, "message": "更新成功" }
        else:
            return {"success": False, "message": "找不到紀錄"}

    def delete_sour_record(self, record_id):
        sour_record_collection = self.db_mgr.get_collection('Sour_Record')
        result = sour_record_collection.delete_one({"_id": ObjectId(record_id)})
        if result.deleted_count > 0:
            return {"success": True, "message": "刪除成功"}
        else:
            return {"success": False, "message": "找不到紀錄"}

    def get_All_Sour_Record_by_UserId(self, user_id):
        sour_record_collection = self.db_mgr.get_collection('Sour_Record')
        cursor = sour_record_collection.find({"User_Id": ObjectId(user_id)})
        all_records = []
        for document in cursor:
            record = Sour_Record(
                id=document['_id'],
                user_id=document['User_Id'],
                title=document['Title'],
                reason=document['Reason'],
                time=document['Time'],
                videos=document['Videos']
            )
            all_records.append(record)
        return all_records
    
    def get_Sour_Record_by_Id(self, sour_record_id):
        sour_record_collection = self.db_mgr.get_collection('Sour_Record')
        sour_record_data = sour_record_collection.find_one({"_id": ObjectId(sour_record_id)})

        if sour_record_data:
            sour_record = Sour_Record(
                id=sour_record_data["_id"],
                user_id=sour_record_data["User_Id"],
                title=sour_record_data["Title"],
                reason=sour_record_data["Reason"],
                time=sour_record_data["Time"],
                videos=sour_record_data.get("Videos", [])
            )
            return sour_record.get_Sour_Record_data()
        else:
            return None
    
    def get_Videos_by_Sour_Record_Id(self, id):
        """根據痠痛紀錄的 ID 獲取影片 ID 列表"""
        sour_record_collection = self.db_mgr.get_collection('Sour_Record')
        document = sour_record_collection.find_one({"_id": ObjectId(id)})
        if document:
            return document.get('Videos', [])
        else:
            return {"success": False, "message": "找不到痠痛紀錄"}

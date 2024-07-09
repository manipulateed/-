import json
from bson import ObjectId

class Chat_Record_Helper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr

    def get_collection(self, collection_name):
        """獲取指定名稱的集合"""
        return self.db_mgr.get_collection(collection_name)
    
    def save_to_db(self, chat_record):
        chat_collection = self.get_collection('Chat_Record')
        chat_collection.insert_one({
            "User_Id": ObjectId(chat_record.user_id),
            "Message": chat_record.message,
            "Suggested_Video_Id": [ObjectId(vid) for vid in chat_record.suggested_video_ids],
            "Possible_Reasons": chat_record.possible_reasons,
            "Last_Update_TimeStamp": chat_record.timestamp
        })
        return {"success": True, "message": "聊天紀錄已成功存入資料庫"}
      
    def update_message(self, chat_record, new_message):
        chat_record.update_message(new_message)
        chat_collection = self.db_mgr.get_collection('Chat_Record')
        result = chat_collection.update_one(
            {"User_Id": chat_record.user_id},
            {
                "$push": {"Message": new_message},
                "$set": {"Last_Update_TimeStamp": chat_record.timestamp}
            }
        )
        if result.modified_count > 0:
            return {"success": True, "message": "Message 更新成功"}
        else:
            return {"success": False, "message": "Message 更新失敗"}
        
    def get_all_chat_records_by_user_id(self, user_id):
        chat_collection = self.db_mgr.get_collection('Chat_Record')
        records = chat_collection.find({"User_Id": ObjectId(user_id)})
        return list(records)

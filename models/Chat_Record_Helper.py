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
    
        # 處理 Suggested_Videos
        suggested_videos = []
        for video in chat_record.suggested_videos:
            suggested_video = {
                "Keyword": video["Keyword"],
                "Video_id": [ObjectId(vid) for vid in video["Video_id"]]
            }
        suggested_videos.append(suggested_video)

        # 創建要插入的文檔
        document = {
            "User_Id": ObjectId(chat_record.user_id),
            "Name": chat_record.name,
            "Message": chat_record.message,
            "Suggested_Videos": suggested_videos,
            "Last_Update_TimeStamp": chat_record.timestamp,
            "Finished": chat_record.finished
        }

        # 插入文檔
        result = chat_collection.insert_one(document)

        if result.inserted_id:
            return {"success": True, "message": "聊天紀錄已成功存入資料庫", "id": str(result.inserted_id)}
        else:
            return {"success": False, "message": "存入資料庫時發生錯誤"}
      
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
        return [self._format_record(record) for record in records]
    
    def get_Chat_Record_by_id(self, record_id):
        chat_collection = self.db_mgr.get_collection('Chat_Record')
        record_data = chat_collection.find_one({"_id": ObjectId(record_id)})
        return self._format_record(record_data) if record_data else None
    
    def _format_record(self, record):
        if record:
            record['_id'] = str(record['_id'])
            record['User_Id'] = str(record['User_Id'])
            record['Suggested_Video_Id'] = [str(vid) for vid in record['Suggested_Video_Id']]
            
            # 完整格式化 Message 字段
            if 'Message' in record:
                formatted_messages = []
                for message in record['Message']:
                    formatted_message = {
                        'Role': message.get('Role', ''),
                        'Content': message.get('Content', ''),
                        'Date': message.get('Date', ''),
                        'Time': message.get('Time', '')
                    }
                    # 如果 Date 或 Time 是 datetime 對象，進行格式化
                    if isinstance(formatted_message['Date'], datetime):
                        formatted_message['Date'] = formatted_message['Date'].strftime("%Y-%m-%d")
                    if isinstance(formatted_message['Time'], datetime):
                        formatted_message['Time'] = formatted_message['Time'].strftime("%H:%M")
                    formatted_messages.append(formatted_message)
                record['Message'] = formatted_messages
            
            # 格式化 Last_Update_TimeStamp
            if 'Last_Update_TimeStamp' in record:
                record['Last_Update_TimeStamp'] = record['Last_Update_TimeStamp'].isoformat() if isinstance(record['Last_Update_TimeStamp'], datetime) else record['Last_Update_TimeStamp']

        return record

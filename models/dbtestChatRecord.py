from datetime import datetime
from MongoDBMgr import MongoDBMgr 
from Chat_Record_Helper import Chat_Record_Helper  
from Chat_Record import Chat_Record  
from bson import ObjectId
# 初始化 MongoDBMgr 實例
uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name, uri)

# 初始化 Chat_Record_Helper 實例
helper = Chat_Record_Helper(mongo_mgr)

# 創建一個 Chat_Record 實例
user_id = '66435c496b52ed9b072dc0e4'
# message = [
#     {"Role": "User", "Content": "我腰部感覺很痠", "Date": "2024-05-03", "Time": "08:30"},
#     {"Role": "AI", "Content": "您可能需要休息一下，也可以嘗試這些訓練影片", "Date": "2024-05-03", "Time": "08:35"},
#     {"Role": "User", "Content": "好的，謝謝", "Date": "2024-05-03", "Time": "08:40"}
# ]
# suggested_videos = [{"伸展":['66436c17b92ec708c91009a4', '66436c17b92ec708c91009a5', '66436c17b92ec708c91009a6']},{"姿勢":['66436c17b92ec708c91009a4', '66436c17b92ec708c91009a5', '66436c17b92ec708c91009a6']}]       
# formatted_suggested_videos = []
# for video in suggested_videos:
#     key = list(video.keys())[0]
#     formatted_video = {
#         "Keyword": key,
#         "Video_id": video[key]
#     }
#     formatted_suggested_videos.append(formatted_video)

# suggested_video_ids = ['66436c17b92ec708c91009a4', '66436c17b92ec708c91009a5', '66436c17b92ec708c91009a6']
# possible_reasons = ['過度運動', '姿勢不良', '長時間坐姿']
# timestamp = datetime(2024, 5, 12, 5, 0, 0)

# chat_record = Chat_Record(user_id, '長時間坐姿', message, formatted_suggested_videos, timestamp, "true")
# print(chat_record.get_chat_record_data())
# # # 1. 測試保存聊天紀錄到資料庫
# helper.save_to_db(chat_record)
# # print(save_result)
# print("finish")
# # 更新 Message
# new_message = [
#     {"Role": "User", "Content": "我現在感覺好一些了", "Date": "2024-05-04", "Time": "10:00"},
#     {"Role": "AI", "Content": "很好！記得保持適當休息", "Date": "2024-05-04", "Time": "10:05"}
# ]
# update_result = helper.update_message(mongo_mgr, new_message)
'''
update_result = chat_record.update_message(mongo_mgr, {"Role": "User", "Content": "我現在感覺好一些了", "Date": "2024-05-04", "Time": "10:00"})

update_result = chat_record.update_message(mongo_mgr, {"Role": "AI", "Content": "很好！記得保持適當休息", "Date": "2024-05-04", "Time": "10:05"})
'''

# print(update_result)

chat_collection = helper.get_collection('Chat_Record')
records = chat_collection.find({"User_Id": ObjectId(user_id)})
def _format_record(record):
        print(record)
        if record:
            record['_id'] = str(record['_id'])
            record['User_Id'] = str(record['User_Id'])
            
            
            record['name'] = str(record['name'])
            # message2 = Message("ai","654321","12.31","12.45")
            # message = [message1.get_Message_data(), message2.get_Message_data()]
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
                        formatted_message['Time'] = formatted_message['Time'].strftime("%H:%M:%S")
                    formatted_messages.append(formatted_message)
                record['Message'] = formatted_messages
         
            formatted_suggested_videos = []
            for video in record['Suggested_Videos']:
                keyword = video.get('Keyword', '')
                video_ids = [str(vid) for vid in video.get('Video_id', [])]  # 將 ObjectId 轉成字串
                formatted_suggested_videos.append({
                    "Keyword": keyword,
                    "Video_id": video_ids
                })
            
            # 格式化 Last_Update_TimeStamp
            if 'Last_Update_TimeStamp' in record:
                record['Last_Update_TimeStamp'] = record['Last_Update_TimeStamp'].isoformat() if isinstance(record['Last_Update_TimeStamp'], datetime) else record['Last_Update_TimeStamp']
            
            if str(record['Finished'] == "true"):
                record['Finished'] = "yes"
            else:
                record['Finished'] = "no"
                
            
            record1 = Chat_Record(record['_id'], record['User_Id'], record['Name'], record['Message'], formatted_suggested_videos, record['Last_Update_TimeStamp'], record['Finished'])
        return record1.get_chat_record_data()
all = []
for record in records:
    print(record)
    all.append(_format_record(record))
    print(all)

print(all)

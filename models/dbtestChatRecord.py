from datetime import datetime
from MongoDBMgr import MongoDBMgr 
from Chat_Record_Helper import Chat_Record_Helper  
from Chat_Record import Chat_Record  

# 初始化 MongoDBMgr 實例
uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name, uri)

# 初始化 Chat_Record_Helper 實例
helper = Chat_Record_Helper(mongo_mgr)

# 創建一個 Chat_Record 實例
user_id = '66435c6d6b52ed9b072dc0e5'
message = [
    {"Role": "User", "Content": "我腰部感覺很痠", "Date": "2024-05-03", "Time": "08:30"},
    {"Role": "AI", "Content": "您可能需要休息一下，也可以嘗試這些訓練影片", "Date": "2024-05-03", "Time": "08:35"},
    {"Role": "User", "Content": "好的，謝謝", "Date": "2024-05-03", "Time": "08:40"}
]
suggested_video_ids = ['66436c17b92ec708c91009a4', '66436c17b92ec708c91009a5', '66436c17b92ec708c91009a6']
possible_reasons = ['過度運動', '姿勢不良', '長時間坐姿']
timestamp = datetime(2024, 5, 12, 5, 0, 0)

chat_record = Chat_Record(user_id, message, suggested_video_ids, possible_reasons, timestamp)
print(chat_record.get_chat_record_data())
# # 1. 測試保存聊天紀錄到資料庫
helper.save_to_db(chat_record)
# print(save_result)
print("finish")
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
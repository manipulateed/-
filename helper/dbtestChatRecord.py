from MongoDBMgr import MongoDBMgr
import sys
#sys.path.insert(0,'/C:/Users/e2002/Desktop/畢業專題/bigproject/')
sys.path.append(r'..')
from models.Chat_Record import Chat_Record

uri = "mongodb+srv://evan:evan1204@sourpass88.8nozy6p.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name, uri)

chat_record = Chat_Record(
    user_id='66435bfb6b52ed9b072dc0e3',
    message=[
        {"Role": "User", "Content": "我腰部感覺很痠", "Date": "2024-05-03", "Time": "08:30"},
        {"Role": "AI", "Content": "您可能需要休息一下，也可以嘗試這些訓練影片", "Date": "2024-05-03", "Time": "08:35"},
        {"Role": "User", "Content": "好的，謝謝", "Date": "2024-05-03", "Time": "08:40"}
    ],
    suggested_video_ids=['66436c17b92ec708c91009a4', '66436c17b92ec708c91009a5', '66436c17b92ec708c91009a6'],
    possible_reasons=['過度運動', '姿勢不良', '長時間坐姿'],
    timestamp = '2024-05-12T05:00:00',
)
result = chat_record.save_to_db(mongo_mgr)
print(result)

# 更新 Message
# new_message = [
#     {"Role": "User", "Content": "我現在感覺好一些了", "Date": "2024-05-04", "Time": "10:00"},
#     {"Role": "AI", "Content": "很好！記得保持適當休息", "Date": "2024-05-04", "Time": "10:05"}
# ]
# update_result = chat_record.update_message(mongo_mgr, new_message)
'''
update_result = chat_record.update_message(mongo_mgr, {"Role": "User", "Content": "我現在感覺好一些了", "Date": "2024-05-04", "Time": "10:00"})

update_result = chat_record.update_message(mongo_mgr, {"Role": "AI", "Content": "很好！記得保持適當休息", "Date": "2024-05-04", "Time": "10:05"})
'''

# print(update_result)
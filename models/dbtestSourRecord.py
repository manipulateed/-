from MongoDBMgr import MongoDBMgr
from Sour_Record import Sour_Record
from Sour_Record_Helper import Sour_Record_Helper

uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name, uri)
helper = Sour_Record_Helper(mongo_mgr)

videos=["664369e6b92ec708c9100992","664369e6b92ec708c9100993","664369e6b92ec708c9100994"]

# SR = Sour_Record( " ",'66435b426b52ed9b072dc0dd',videos,"大腿痛" ,"理由",'2024-05-12T05:00:00')
# print(SR.get_Sour_Record_data())   

# result = helper.create_sour_record(SR)
# print(result)
helper.update_sour_record("66912646ed127c9b5f445ad4" , "Title" , "深蹲拉傷")
# allsr = helper.get_All_Sour_Record_by_UserId("66435b426b52ed9b072dc0dd")
# for sr in allsr:
#     print(sr.get_Sour_Record_data())

# video = helper.get_Videos_by_Sour_Record_Id("6690aae937f1d132e8989695")
# print(video)
# for video_id in video:
#     print(video_id)
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
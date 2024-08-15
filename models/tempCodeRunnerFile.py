message = [
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
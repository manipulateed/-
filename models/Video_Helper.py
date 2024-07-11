from bson import ObjectId
from Video import Video

class Video_Helper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr
    
    def create_video(self, video):
        video_collection = self.db_mgr.get_Collection('Video')
        #有需要去check是否重複儲存video嗎 --> 我覺得不用
        video_data = {
            "Name":video.name,
            "URL":video.url
        }
        result = video_collection.insert_one(video_data)
        video.set_id(result.inserted_id)
        return{"success": True, "message":"影片新增成功"}

    def remove_Video(self,video_id):
        video_collection = self.db_mgr.get_Collection('Video')
        result = video_collection.delete_one({"_id":ObjectId(video_id)})
        if result.delete_count > 0:
            return{"success": True, "message": "移除成功"}
        else:
            return {"success": False, "message": "找不到收藏列表"}
        
    def get_Video_Data(self,video_id): #取得video資訊
        video_collection = self.db_mgr.get_Collection('Video')
        video_data = video_collection.fine_one({"_id":ObjectId(video_id)})
        if video_data:
            return video_data
        else:
            return None



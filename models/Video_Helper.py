from bson import ObjectId
from .Video import Video
import requests

class Video_Helper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr
    
    def create_video(self, video):
        video_collection = self.db_mgr.get_collection('Video')
        existing_video = video_collection.find_one({"url": video.url})
        if existing_video:
            return {"success": False, "message": "資料庫已有這支影片", "video_id": str(existing_video['_id'])}
    
        video_data = {
            "title": video.title,
            "description": video.description,
            "url": video.url
        }
        insert_result = video_collection.insert_one(video_data)
        if insert_result.inserted_id:
            return {"success": True, "message": "影片新增成功", "video_id": str(insert_result.inserted_id)}
        else:
            return {"success": False, "message": "影片新增失敗", "video_id": None}
    
    def search_and_Create_Videos(self, keyword, max_results=5):
        videos = self.search_Youtube_Videos(keyword, max_results)
        created_videos=[] #儲存新創建的影片 -> 未曾儲存在資料庫的
        output_videos=[] #儲存所有keyword搜尋到的影片，含已存在以及新創建的

        video_collection = self.db_mgr.get_collection('Video')

        for video_data in videos:
            existing_video = video_collection.find_one({"url": video_data['url']})
            output_video = {
                "title": video_data['title'],
                "description": video_data['description'],
                "url": video_data['url'],
                "status": "existing" if existing_video else "new"
            }

            if not existing_video: #新的影片
                video = Video(
                    id = "",
                    title=video_data['title'],
                    description=video_data['description'],
                    url=video_data['url']
                )
                result = self.create_video(video)
                if result['success']:
                    created_videos.append(result)
                    output_video["video_id"] = result['video_id']
            else:
                output_video["video_id"] = str(existing_video['_id'])

            output_videos.append(output_video)
        print(output_videos)
        return{
            "created_videos": created_videos,
            "output_videos": output_videos
        }

    def search_Youtube_Videos(self, keyword, max_results=5):
        url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBtqh_uCgnbs9iC6mW9g-mzyGt1Zmpwz8U&q="+keyword+"&type=video&part=snippet&maxResults=2"

        payload = {}
        headers = {}

        response = requests.request("GET", url, headers=headers, data=payload)

        result = response.json()

        videos = []
        for item in result.get("items", []):
            video_id = item["id"]["videoId"]
            title = item["snippet"]["title"]
            description = item["snippet"]["description"]
            video_url = f"https://www.youtube.com/watch?v={video_id}"
            videos.append({"title": title, "description": description, "url": video_url})

        return videos

    def remove_Video(self,video_id):
        video_collection = self.db_mgr.get_Collection('Video')
        result = video_collection.delete_one({"_id":ObjectId(video_id)})
        if result.delete_count > 0:
            return{"success": True, "message": "移除成功"}
        else:
            return {"success": False, "message": "找不到收藏列表"}
        
    def get_Video_Data_by_VideoID(self,video_id): #取得video資訊
        video_collection = self.db_mgr.get_collection('Video')
        video_data = video_collection.find_one({"_id":ObjectId(video_id)})
        if video_data:
            video = Video(
                id=str(video_data["_id"]),
                title=video_data["title"],
                url=video_data["url"],
                description=video_data['description']
            )
            return video.get_video_data()
        else:
            return None

    '''
    def create_video(self, video):
        video_collection = self.get_Collection('Video')
        existing_video = video_collection.find_one({"URL": video.url})
        if video_collection.find_one({"url":video.url}): #判斷資料庫是否有這支影片
            return {"success":False, "message":"資料庫已有這支影片", "video_id": str(existing_video['_id'])}
        else:
            video_data = {
                "Name":video.name,
                "URL":video.url
            }
            result = video_collection.insert_one(video_data)
            video.set_id(result.inserted_id)
            return{"success": True, "message":"影片新增成功", "video_id": str(result.inserted_id)}
    '''


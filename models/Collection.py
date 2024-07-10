import json
import Video
class Collection:
    def __init__(self, video: Video):
        self.id = id
        self.video = video
      
    @staticmethod    
    def create_collection_by_CLId(CL_id, video: Video):
        pass

    #helper
    def remove_collection(self):
        pass

    @staticmethod
    def get_All_by_CLId(CL_id):
        pass

    def get_collection_data(self):
        collection_data = {
            "id": self.id,
            "video": self.video.get_video_data_dict()
        }
        return json.dumps(collection_data)


# 應該不需要這個class
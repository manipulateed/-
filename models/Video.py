import json
class Video:
    def __init__(self, id, name, url):
        self.id = id
        self.name = name
        self.url = url
      
    #helper    
    def create_Video(self):
        pass

    #helper
    def remove_Video(self):
        pass

    @staticmethod
    def get_All():
        pass

    def get_video_data(self):
        video_data = {
            "id": self.id,
            "name": self.name,
            "url": self.url
        }
        return json.dumps(video_data)
    
    def get_video_data_dict(self):
        video_data = {
            "id": self.id,
            "name": self.name,
            "url": self.url
        }
        return video_data



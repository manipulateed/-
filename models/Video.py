import json
class Video:
    def __init__(self, id, name, url):
        self.id = id
        self.name = name
        self.url = url

    def set_id(self, id):
        self.id = id
    def set_name(self, name):
        self.name = name

    def get_id(self):
        return self.id
    def get_name(self):
        return self.name
    
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



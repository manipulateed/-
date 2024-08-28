import json
class Video:
    def __init__(self, id, title, description, url):
        self.id = id
        self.description = description
        self.title = title
        self.url = url

    def set_id(self, id):
        self.id = id
    def set_title(self, title):
        self.title = title
    def set_description(self, description):
        self.description = description
    def set_url(self, url):
        self.url = url

    def get_id(self):
        return self.id
    def get_title(self):
        return self.title
    def get_description(self):
        return self.description
    def get_url(self):
        return self.url
    
    def get_video_data(self):
        video_data = {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "url": self.url
        }
        return video_data
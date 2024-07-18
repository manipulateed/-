import json
class Sour_Record:
    def __init__(self, id, user_id, videos , title, reason, time):
        self.id = id
        self.user_id = user_id
        self.videos = videos
        self.title = title
        self.reason = reason
        self.time = time
      
    def set_id(self, id):
        self.id = id
    def set_user_id(self, user_id):
        self.user_id = user_id
    def set_videos(self ,videos):
        self.videos = videos
    def set_title(self, title):
        self.title = title
    def set_reason(self, reason):
        self.reason = reason
    def set_time(self, time):
        self.time = time
    

    def get_id(self):
        return self.id
    def get_user_id(self):
        return self.user_id
    def get_videos(self):
        return self.videos
    def get_title(self):
        return self.collection
    def get_reason(self):
        return self.reason
    def get_time(self):
        return self.time

    @staticmethod  
    def get_All_Sour_Record_by_UserId(user_id):
        pass

    def get_Sour_Record_data(self):
        sour_record_data = {
            "id": str(self.id), 
            "user_id": str(self.user_id),
            "videos": str(self.videos),
            "title": self.title,
            "reason": self.reason,
            "time": self.time
        }
        return json.dumps(sour_record_data)


import json
class Sour_Record:
    def __init__(self, id, user_id, videos , reason, time):
        self.id = id
        self.user_id = user_id
        self.videos = videos
        self.reason = reason
        self.time = time
      
    def set_id(self, id):
        self.id = id
    def set_user_id(self, user_id):
        self.user_id = user_id
    def set_videos(self ,videos):
        self.videos = videos
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
    def get_reason(self):
        return self.reason
    def get_time(self):
        return self.time

    def get_Sour_Record_data(self):
        sour_record_data = {
            "id": str(self.id), 
            "user_id": str(self.user_id),
            "videos": self.videos,
            "reason": self.reason,
            "time": self.time
        }
        return sour_record_data
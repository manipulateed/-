import json
from bson import ObjectId
from datetime import datetime
class Chat_Record:
    def __init__(self,id,user_id, name, message, suggested_videos,timestamp, finished):
        self.id = id
        self.user_id = user_id
        self.name = name
        self.message = message
        self.suggested_videos = suggested_videos
        self.timestamp = timestamp
        self.finished = finished

    def update_message(self, new_message):
        self.message.append(new_message)
        self.timestamp = datetime.now().isoformat()

    def get_chat_record_data(self):
        return {
            "id": self.id,
            "user_id": str(self.user_id),
            "name" : self.name,
            "message": self.message,
            "suggested_videos": [(vid) for vid in self.suggested_videos],
            "last_update_timestamp": self.timestamp,
            "finished": self.finished
        }
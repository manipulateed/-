import json
from bson import ObjectId
from datetime import datetime
class Chat_Record:
    def __init__(self, user_id, message, suggested_video_ids, possible_reasons, timestamp):
        self.user_id = user_id
        self.message = message
        self.suggested_video_ids = suggested_video_ids
        self.possible_reasons = possible_reasons
        self.timestamp = timestamp

    def update_message(self, new_message):
        self.message.append(new_message)
        self.timestamp = datetime.now().isoformat()

    def get_chat_record_data(self):
        return {
            "user_id": str(self.user_id),
            "message": self.message,
            "suggested_video_ids": [str(vid) for vid in self.suggested_video_ids],
            "possible_reasons": self.possible_reasons,
            "last_update_timestamp": self.timestamp
        }
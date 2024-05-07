import json
class Chat_Record:
    def __init__(self, id, message, timestamp):
        self.id = id
        self.message = message
        self.timestamp = timestamp
      
    @staticmethod  
    def get_All_Chat_Record_by_RoomId(room_id):
        pass


    def get_Chat_Record_data(self):
        chat_record_data = {
            "id": self.id,
            "message": self.message,
            "timestamp": self.timestamp
        }
        return json.dumps(chat_record_data)



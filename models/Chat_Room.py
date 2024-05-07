import json
class Chat_Room:
    def __init__(self, id, create_time):
        self.id = id
        self.create_time = create_time
      
    @staticmethod  
    def get_All_Chat_Room_by_UserId(user_id):
        pass

    @staticmethod  
    def create_Chat_Room_by_UserId(user_id):
        pass

    def remove_Chat_Room(self):
        pass
    
    def get_Chat_Room_data(self):
        chat_room_data = {
            "id": self.id,
            "create_time": self.create_time
        }
        return json.dumps(chat_room_data)



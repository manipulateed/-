import json
class Message:
    def __init__(self, character, content, date, time):
        self.character = character
        self.content = content
        self.date = date
        self.time = time

    def set_character(self, character):
        self.character = character
    def set_content(self ,content):
        self.content = content
    def set_date(self, date):
        self.date = date
    def set_time(self, time):
        self.time = time

    def get_character(self):
        return self.user_id
    def get_content(self):
        return self.name
    def get_date(self):
        return self.date
    def get_time(self):
        return self.time

    def get_Message_data(self):
        Message_data = {
            "character": str(self.character),
            "content": self.content,
            "date": str(self.date),
            "time": str(self.time)
        }
        return Message_data
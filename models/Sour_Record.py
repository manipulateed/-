import json
class Sour_Record:
    def __init__(self, id, day, record):
        self.id = id
        self.day = day
        self.record = record
      
    @staticmethod  
    def get_All_Sour_Record_by_UserId(user_id):
        pass


    def get_Sour_Record_data(self):
        sour_record_data = {
            "id": self.id,
            "day": self.day,
            "record": self.record
        }
        return json.dumps(sour_record_data)



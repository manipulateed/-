import json
class Muscle:
    def __init__(self, id, name, describe, sour_reason):
        self.id = id
        self.name = name
        self.describe = describe
        self.sour_reason = sour_reason
      
    @staticmethod  
    def get_All_Muscle_by_AreaId(area_id):
        pass


    def get_Muscle_data(self):
        muscle_data = {
            "id": self.id,
            "name": self.name,
            "describe": self.describe,
            "sour_reanson": self.sour_reason
        }
        return json.dumps(muscle_data)



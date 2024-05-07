import json
class Muscle_Area:
    def __init__(self, id, name):
        self.id = id
        self.name = name
      
    @staticmethod  
    def get_All_Area():
        pass

    def get_Muscle_data(self):
        area_data = {
            "id": self.id,
            "name": self.name,
        }
        return json.dumps(area_data)



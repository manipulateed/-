import json
class Muscle:
    def __init__(self, id, name, category, description):
        self.id = id
        self.name = name
        self.category = category
        self.description = description
      
    @staticmethod  
    def get_All_Muscle_by_AreaId(area_id):
        pass


    def get_Muscle_data(self):
        muscle_data = {
            "id": self.id,
            "name": self.name,
            "category": self.category,
            "description": self.description
        }
        return json.dumps(muscle_data)



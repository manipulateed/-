import json
class Muscle_Area:
    def __init__(self, id, name, muscles):
        self.id = id
        self.name = name
        self.muscles = muscles

    def set_id(self, id):
        self.id = id
    def set_name(self,name):
        self.name = name
    def set_muscles(self, muscles):
        self.muscles = muscles

    def get_id(self):
        return self.id
    def get_name(self):
        return self.name
    def get_muscles(self):
        return self.muscles
      

    def get_Muscle_data(self):
        area_data = {
            "id": self.id,
            "name": self.name,
        }
        return json.dumps(area_data)

    @staticmethod  
    def get_All_Area():
        pass


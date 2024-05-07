import json
class Collect_List:
    def __init__(self, id, name, collection):
        self.id = id
        self.name = name
        self.collection = collection

    #helper
    def update_name(self, new_name):
        self.name = new_name
      
    @staticmethod   
    def create_CL_by_UserId(user_id, name):
        pass

    #helper
    def remove_CL(self):
        pass

    @staticmethod
    def get_All_CL_by_UserId(user_id):
        pass

    def get_CL_data(self):
        CL_data = {
            "id": self.id,
            "name": self.name,
            "collection": self.collection
        }
        return json.dumps(CL_data)



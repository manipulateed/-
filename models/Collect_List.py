import json
class Collect_List:
    def __init__(self, id, user_id, name, collection):
        self.id = None
        self.user_id = user_id
        self.name = name
        self.collection = collection

    def set_id(self, id):
        self.id = id

    def get_id(self):
        return self.id

    #helper
    def update_name(self, new_name):
        self.name = new_name

    def get_CL_data(self):
        CL_data = {
            "id": str(self.id),
            "user_id": str(self.user_id),
            "name": self.name,
            "collection": self.collection
        }
        return json.dumps(CL_data)



import json
class Collect_List:
    def __init__(self, id, user_id, name, collection):
        self.id = id
        self.user_id = user_id
        self.name = name
        self.collection = collection

    def set_id(self, id):
        self.id = id
    def set_user_id(self, user_id):
        self.user_id = user_id
    def set_name(self ,name):
        self.name = name
    def set_collection(self, collection):
        self.collection = collection

    def get_id(self):
        return self.id
    def get_user_id(self):
        return self.user_id
    def get_name(self):
        return self.name
    def get_collection(self):
        return self.collection

    #helper
    def update_name(self, helper, new_name):
        self.name = new_name
        return helper.update_CL_data(self.id, 'name', new_name)
    
    def add_video(self, helper, video_id):
        self.collection = video_id
        return helper.update_CL_data(self.id, 'add_video', video_id)

    def remove_video(self, helper, video_id):
        return helper.update_CL_data(self.id, 'remove_video', video_id)

    def get_CL_data(self):
        CL_data = {
            "id": str(self.id),
            "user_id": str(self.user_id),
            "name": self.name,
            "collection": str(self.collection)
        }
        return json.dumps(CL_data)
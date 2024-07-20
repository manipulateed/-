from bson import ObjectId
from Muscle import Muscle
'''
只會有get不會有create
get_Muscle_by_MuscleId() ->用於紀錄每個名稱點進去之後的病症的詳細解釋
get_MuscleNameList_by_category() -> 用於點進去部位後會顯示出來的各種病症/肌群名稱 
->好像要寫在muscle_area helper

'''
class Muscle_Helper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr
    
    def get_Muscle_by_Muscle_Id(self, muscle_id):
        muscle_collection = self.db_mgr.get_collection('Muscle')
        muscle_data = muscle_collection.find_one({"_id":ObjectId(muscle_id)})
        if muscle_data:
            muscle = Muscle(
                id = muscle_data['_id'],
                name = muscle_data['name'],
                category = muscle_data['category'],
                description = muscle_data['description']
            )
            return muscle.get_Muscle_data()
        else:
            return None
        
    def get_MuscleNameList_by_Category(self, category): 
        muscle_collection = self.db_mgr.get_collection('Muscle')
        muscle_list = muscle_collection.find({"category":category})
        muscleName_list =[]
        for muscle_data in muscle_list:
            muscle = Muscle(
                id=muscle_data['_id'],
                name=muscle_data['name']
            )
            muscleName_list.append(muscle)
        return muscleName_list



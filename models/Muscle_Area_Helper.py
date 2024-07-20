from bson import ObjectId
from Muscle_Area import Muscle_Area

class Muscle_Area_Helper:
    def __init__(self, db_mgr):
        self.db_mgr = db_mgr
    
    def get_Muscle_Area_Name_by_Id(self, muscle_area_id):
        muscle_area_collection = self.db_mgr.get_collection('Muscle')
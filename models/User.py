import json
class User:
    def __init__(self, name, email, birth, password, sex):
        self.name = name
        self.email = email
        self.birth = birth
        self.password = password
        self.sex = sex

    #helper
    def update_name(self, new_name):
        self.name = new_name
      
    #helper    
    def update_password(self, new_pass):
        self.password = new_pass

    #helper
    def create_User(self):
        pass

    #login
    @staticmethod
    def get_User_by_Email_and_Password(email, password):
        pass

    def get_user_data(self):
        user_data = {
            "name": self.name,
            "email": self.email,
            "password": self.password,
            "birthday": self.birth,
            "sex": self.sex
        }
        return json.dumps(user_data)



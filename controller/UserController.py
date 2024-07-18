from flask import Flask, request, jsonify
from models.MongoDBMgr import MongoDBMgr 
from models.User import User
from bigproject.helper.User_Helper import User_Helper
from bson import ObjectId
app

app = Flask(__name__)

mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name,mongo_uri)
user_helper = User_Helper(mongo_mgr)

@app.route('/api/user', methods=['POST'])
def create_user():
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')
    birth = data.get('birth')
    password = data.get('password')
    sex = data.get('sex')

    if not all([name, email, birth, password, sex]):
        return jsonify(status = '300', success=False, message='欄位不能有空值')

    user = User(name=name, email=email, birth=birth, password=password, sex=sex)
    result = user_helper.create_user(user)
    return jsonify(result, status = '200')

@app.route('/api/user', methods=['GET'])
def get_user():
    email = request.args.get('email')
    password = request.args.get('password')

    if not email or not password:
        return jsonify(status = '300', success=False, message='缺少必要的參數(email or password)')

    user = User_Helper.get_user_by_email_and_password(email, password)
    if user:
        user_data = {
            'id': str(user.get_id()),
            'name': user.name,
            'email': user.email,
            'birth': user.birth,
            'sex': user.sex
        }
        return jsonify(status = '200', success=True, message='用戶資料取得成功', response=user_data)
    else:
        return jsonify(status = '400', success=False, message='用戶名或密碼錯誤')

@app.route('/api/user/<user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.get_json()
    field_name = data.get('field_name')
    new_value = data.get('new_value')

    if not field_name or not new_value:
        return jsonify(success=False, message='欄位名稱和新值不能為空')

    user = UserHelper.get_user_by_email_and_password(data.get('email'), data.get('password'))
    if user and str(user.get_id()) == user_id:
        if field_name == 'Name':
            result = user.update_name(user_helper, new_value)
        elif field_name == 'Password':
            result = user.update_password(user_helper, new_value)
        else:
            result = user_helper.update_user_field(user_id, field_name, new_value)
        return jsonify(result, status = '200', message = '更改資料成功!')
    else:
        return jsonify(status = '400', success=False, message='找不到用戶')

@app.route('/api/user/<user_id>', methods=['DELETE'])
def delete_user(user_id):
    user_collection = user_helper.get_collection('User')
    result = user_collection.delete_one({"_id": ObjectId(user_id)})

    if result.deleted_count > 0:
        return jsonify(status = '200', success=True, message='用戶刪除成功')
    else:
        return jsonify(status = '400', success=False, message='找不到用戶')

if __name__ == '__main__':
    app.run(debug=True)

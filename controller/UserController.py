from flask import Flask, request, jsonify, Blueprint
import sys
sys.path.append(r'..')
from models.MongoDBMgr import MongoDBMgr 
#from models.User import User
from models.User_Helper import UserHelper
from models.User import User
from bson import ObjectId

user_bp = Blueprint('user_bp',__name__)

mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name,mongo_uri)
user_helper = UserHelper(mongo_mgr)

@user_bp.route('/user/create_user', methods=['POST'])
def create_user():
    data = request.get_json()
    print(f"Received data: {data}")  # 添加這行來打印接收到的數據

    name = data.get('name')
    email = data.get('email')
    password = data.get('password')

    if not all([name, email, password]):
        response = jsonify(status = '400', success=False, message='Missing required fields')
        print(f"Sending response: {response.get_data(as_text=True)}")  # 印response
        return response

    user = User(name=name, email=email, password=password)
    result = user_helper.create_user(user)

    if result['success'] :
        response = jsonify(status='200', success=True, message='User created successfully', response=result)
        print(f"Sending response: {response.get_data(as_text=True)}")  # 印response
        return response
    else:
        response = jsonify(status='400', success=False, message='Failed to create user', response=result)
        print(f"Sending response: {response.get_data(as_text=True)}")  # 印response
        return response

#用在account
@user_bp.route('/user/get_user_byUserID', methods=['GET'])
def get_user_byUserID():
    '''
    user_id = request.args.get('user_id')
    if user_id: 
        user_data = [{
            "name": "iris",
            "email": "iris.com",
            "password": "i",
        },{
            "name": "iris1",
            "email": "iris1.com",
            "password": "i1",
        }]
    
    #email = request.args.get('email')
    #password = request.args.get('password')

    #if not email or not password:
    #    return jsonify(status = '300', success=False, message='缺少必要的參數(email or password)')

    #user = UserHelper.get_user_by_email_and_password(email, password)
    #if user:
    #    user_data = {
    #        'id': str(user.get_id()),
    #        'name': user.name,
    #        'email': user.email,
    #    }
        return jsonify(status = '200', success=True, message='get user data successfully', response=user_data)

    else:
        return jsonify(status = '400', success=False, message='get user data')
    '''
    user_id = request.args.get('user_id')
    
    if not user_id:
        return jsonify(status='300', success=False, message='缺少必要的參數(user_id)')
    
    user = user_helper.get_user_by_id(user_id)  # 假設有這個方法來從數據庫獲取用戶
    if user['success']:
        user_data = {
            'id': str(user['id']),
            'name':  user['name'],
            'email':  user['email'],
            'password': user['password']  # 注意：在實際應用中不應該返回密碼
        }
        return jsonify(status='200', success=True, message='獲取用戶數據成功', response=[user_data])
    else:
        return jsonify(status='400', success=False, message='未找到用戶數據')

@user_bp.route('/user/update_user', methods=['PUT'])
def update_user():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify(success=False, message='缺少必要的參數(user_id)'), 300

    data = request.get_json()
    print(f"Received data: {data}")  # 添加這行來打印接收到的數據
    if not data:
        return jsonify(success=False, message='未提供有效的JSON數據'), 400

    field_name = data.get('field')
    new_value = data.get('new_value')

    if not field_name or new_value is None:
        return jsonify(success=False, message='欄位名稱和新值不能為空'), 400

    # 驗證用戶身份
    user_result = user_helper.get_user_by_id(user_id)
    if not user_result['success']:
        return jsonify(success=False, message=user_result['message']), 404

    if field_name == 'name':
        result = user_helper.update_user_field(user_id, 'Name', new_value)
    elif field_name == 'password':
        result = user_helper.update_user_field(user_id, 'Password', new_value)
    elif field_name == 'email':
        result = user_helper.update_user_field(user_id, 'Email', new_value)
    else:
        return jsonify(success=False, message='不支持的欄位名稱'), 400

    if result['success']:
        return jsonify(success=True, message='更改資料成功!'), 200
    else:
        return jsonify(success=False, message=result['message']), 400

#沒有delete user
@user_bp.route('/user/delete_user', methods=['DELETE'])
def delete_user():
    user_id = request.args.get('user_id')
    user_collection = user_helper.get_collection('User')
    result = user_collection.delete_one({"_id": ObjectId(user_id)})

    if result.deleted_count > 0:
        return jsonify(status = '200', success=True, message='用戶刪除成功')
    else:
        return jsonify(status = '400', success=False, message='找不到用戶')

if __name__ == '__main__':
    user_bp.run(debug=True)

@user_bp.route('/user/login', methods=['POST']) ###########################沒用到###############################
def get_user():
    data = request.get_json()
    print(f"Received data: {data}")  # 添加這行來打印接收到的數據
    
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify(status = '300', success=False, message='need email or password')

    user = user_helper.get_user_by_email_and_password(email, password) #尋找是否有這組信箱/密碼
    if user['success']:
        user_data = {
            'id': str(user['id']),  # 將 ObjectId 轉換為字符串
            'email': user['email'],
            'name' : user['name'],
            'password' : user['password']
        }
        response = jsonify(status='200', success=True, message='login success', response=user_data)
        print(f"Sending response: {response.get_data(as_text=True)}")  # 打印响应
        return response
    else:
        response = jsonify(status='400', success=False, message='login failed')
        print(f"Sending response: {response.get_data(as_text=True)}")  # 打印响应
        return response
    '''
    # email = request.args.get('email')
    # password = request.args.get('password')

    # if not email or not password:
    #     return jsonify(status = '300', success=False, message='缺少必要的參數(email or password)')

    # user = user_helper.get_user_by_email_and_password(email, password) #尋找是否有這組信箱/密碼
    # if user:
    #     user_data = {
    #         'id': str(user.get_id()),
    #         'name': user.name,
    #         'email': user.email,
    #     }
    #     return jsonify(status = '200', success=True, message='用戶資料取得成功', response=user_data)
    # else:
    #     return jsonify(status = '400', success=False, message='用戶名或密碼錯誤')
    '''

'''
    user_id = request.args.get('user_id')        
    data = request.get_json()
    field_name = data.get('field')
    #field_name = data.get('field_name')

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
'''
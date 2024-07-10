from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/login', methods=['POST'])
def receive_data():
    data = request.json #取得request到的json檔
    if data:
        print(f"Received data: {data}")
    else:
        print("No data received")
    return jsonify(success=True, received=data), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

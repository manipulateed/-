
        print(f"Received data: {data}")
    else:
        print("No data received")
    return jsonify(success=True, received=data), 200

if __name__ == '__main__': 
    app.run(host='0.0.0.0', port=8080)

#!/bin/bash
yum update -y
yum install -y python3 python3-pip
pip3 install flask

# Creating the Flask app
echo '
from flask import Flask
app = Flask(__name__)
@app.route("/")
def hello():
    return "<h1>Bonjour from EC2 Flask!</h1>"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
' > /home/ec2-user/app.py

# Keep the Flask app running in the background
nohup python3 /home/ec2-user/app.py > /home/ec2-user/flask.log 2>&1 &
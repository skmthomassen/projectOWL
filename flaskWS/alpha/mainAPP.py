from flask import Flask, render_template
import controller
import os, subprocess

CWD = os.getcwd()

app = Flask(__name__) #static_folder="/home/kim/projectOWL/flaskWS/alpha/static"

@app.route('/')
@app.route('/home')
def home():
   return render_template('home.html')

@app.route('/dragons')
def dragons():
   return render_template('dragons.html')

@app.route('/run_script')
def run_script():
    subprocess.call([CWD + "/controller.py"]) #/home/kim/projectOWL/flaskWS/alpha/
    return 'ok'


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')

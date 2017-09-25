from flask import Flask, render_template
import controller
import subprocess

app = Flask(__name__, static_folder="/home/kim/projectOWL/flaskWS/alpha/static") #

background_scripts = {}

@app.route('/')
@app.route('/home')
def home():
   return render_template('home.html')

@app.route('/dragons')
def dragons():
   return render_template('dragons.html')

@app.route('/run_script')
def run_script():
    subprocess.call(["/home/kim/projectOWL/flaskWS/alpha/controller.py"])

    return 'ok'


if __name__ == "__main__":
    app.run(debug=True)

from flask import Flask, render_template
from controlstreams import capture_thumbnails, start_recording, stop_recording
import os, subprocess

app = Flask(__name__)

IDLE = "idle"
ACTIVE = "active"
RECORDING_STATE = IDLE

@app.before_first_request
def setup_page():
    try:
        capture_thumbnails()
    except IOError as e:
        return 'Nope'

@app.route('/')
@app.route('/home')
def home():
   return render_template('home.html')

@app.route('/dragons')
def dragons():
   return render_template('dragons.html')

@app.route('/run_script')
def run_script():
    try:
        toggle_record()
    except IOError as e:
        return 'Nope'
    return 'ok'

@app.route('/start')
def start_rec():
    try:
        start_recording()
    except IOError as e:
        return 'Nope'
    return 'ok'

@app.route('/stop')
def stop_rec():
    try:
        stop_recording()
    except IOError as e:
        return 'Nope'
    return 'ok'

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')

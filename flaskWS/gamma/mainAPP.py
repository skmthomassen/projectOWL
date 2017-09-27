from flask import Flask, render_template, url_for, redirect
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

@app.route('/state')
def state():
    print("--RECORDING_STATE: " + RECORDING_STATE)
    if RECORDING_STATE is ACTIVE:
        print("-----------STATE-ACTIVE")
        return redirect( url_for('start_rec') )
    elif RECORDING_STATE is IDLE:
        print("-----------STATE-IDLE")
        return redirect( url_for('stop_rec') )

@app.route('/start_rec')
def start_rec():
    print("----------- ACTIVE")
    try:
        if start_recording():
            print("RECORDING_STATE = ACTIVE")
            RECORDING_STATE = ACTIVE
    except IOError as e:
        return 'Nope'
    return 'ok'

@app.route('/stop_rec')
def stop_rec():
    try:
        if stop_recording():
            RECORDING_STATE = IDLE
    except IOError as e:
        return 'Nope'
    return 'ok'

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')

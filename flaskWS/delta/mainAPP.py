from flask import Flask, render_template, url_for, redirect, Response
from controlstreams import capture_thumbnails, is_recording, start_recording, stop_recording
from controlstreams import ACTIVE, IDLE, RECORDING_STATE
import os, subprocess

app = Flask(__name__)

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

@app.route('/state')
def state():
	red = is_recording()
	print("---READSTATE - " + str(red) )
	if red:
		print("-----STATE-ACTIVE---")
		return '200'
	print("-----STATE-IDLE---")
	return '202'

#@app.route('/state')
#def state():
	#red = is_recording()
	#print("---READSTATE - " + str(red) )
	#if red:
		#print("-----STATE-ACTIVE---")
		#return Response('active', mimetype='text/plain')
	#elif not red:
		#print("-----STATE-IDLE---")
		#return Response('idle', mimetype='text/plain')
	#return 'ok'

@app.route('/start_rec')
def start_rec():
    print("--ACTIVATING RECORDING--")
    try:
        start_recording()
    except IOError as e:
        return '500'
    return '200'

@app.route('/stop_rec')
def stop_rec():
    try:
        stop_recording()
    except IOError as e:
        return '500'
    return '200'

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')

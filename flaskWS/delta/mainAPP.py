from flask import Flask, render_template, url_for, redirect, Response, send_from_directory
from controlstreams import is_cameras_available, capture_thumbnails, recording_time, is_recording, start_recording, stop_recording, serve_recording
#import controlstreams
import logging
from logging.handlers import RotatingFileHandler
from logging import Formatter

import os, subprocess

app = Flask(__name__)

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

#@app.errorhandler(500)
#def internal_server_error(error):
    #app.logger.error('Server Error: %s', (error))
    #return render_template('500.html'), 500

#@app.errorhandler(Exception)
#def unhandled_exception(e):
    #app.logger.error('Unhandled Exception: %s', (e))
    #return render_template('500.html'), 500

@app.before_first_request
def setup_page():
    if not is_cameras_available():
        print("Cant reach cams")
    try:
        capture_thumbnails()
    except IOError as e:
        pass
        #app.logger.error('ERROR: couldnt start capturing thumbs')
        #render_template("500.htm", error = str(e))

@app.route('/')
@app.route('/home')
def home():
    return render_template('home.html')

@app.route('/dragons')
def dragons():
    return render_template('dragons.html')

@app.route('/state')
def state():
    if is_recording():
        return 'active'
    return 'idle'

@app.route('/time')
def time():
    recTime = recording_time()
    timeStamp = str(recTime)
    #print("timestamp: " + str(timeStamp) )
    return timeStamp

@app.route('/start_rec')
def start_rec():
    try:
        start_recording()
    except IOError as e:
        app.logger.error('ERROR: couldnt start recording')
        render_template("500.htm", error = str(e))
    app.logger.info('A recording was started')
    return 'ok'

@app.route('/stop_rec')
def stop_rec():
    try:
        stop_recording()
    except IOError as e:
        app.logger.error('ERROR: couldnt stop recording')
        render_template("500.html", error = str(e))
    app.logger.info('A recording was stopped')
    return 'ok'

@app.route('/down_rec')
def down_rec():
    print("WILL start downloading now...")
    try:
        file = serve_recording()
    except IOError as e:
        app.logger.error('ERROR: couldnt start downloading')
        render_template("500.htm", error = str(e))
    app.logger.info('A download was started')
    return 'ok'

if __name__ == "__main__":
    logHandler = RotatingFileHandler('info.log', maxBytes=1000, backupCount=1)
    logHandler.setLevel(logging.INFO)
    app.logger.setLevel(logging.INFO)
    app.logger.addHandler(logHandler)
    logHandler.setFormatter(Formatter(
        '%(asctime)s %(levelname)s: %(message)s '
        '[in %(pathname)s:%(lineno)d]'
    ))
    app.run(debug=True, host='0.0.0.0')

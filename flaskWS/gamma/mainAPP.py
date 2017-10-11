from flask import Flask, render_template, url_for, redirect, Response, send_file, send_from_directory, abort
from controlstreams import is_cameras_available, capture_thumbnails, recording_time, is_recording, start_recording, stop_recording, list_recordings, make_tree
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
    files = list_recordings()
    return render_template('home.html', files=files)

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

@app.route('/down_last_rec')
def down_last_rec():
    print("WILL start downloading now...")
    try:
        file = serve_recording()
    except IOError as e:
        app.logger.error('ERROR: couldnt start downloading')
        render_template("500.htm", error = str(e))
    file = serve_recording()
    app.logger.info('A download was started')
    print("FILE: " + file)
    return send_file('/home/kim/projectOWL/flaskWS/delta/static/20171011-103652.tar.xz', as_attachment=True)
    #return send_from_directory(file, as_attachment=True)

@app.route('/get_tree')
def get_tree():
    list = make_tree()
    return list

@app.route('/download_recording')
def download_recording(path):
    return send_file(path, as_attachment=True)

#@app.route('/', defaults={'req_path': ''})
#@app.route('/<path:req_path>')
def dir_listing(req_path):
    BASE_DIR = '/home/kim/projectOWL/flaskWS/gamma/clips'
    # Joining the base and the requested path
    abs_path = os.path.join(BASE_DIR, req_path)
    # Return 404 if path doesn't exist
    if not os.path.exists(abs_path):
        return abort(404)
    # Check if path is a file and serve
    if os.path.isfile(abs_path):
        return send_file(abs_path)
    # Show directory contents
    files = os.listdir(abs_path)
    # return render_template('files.html', files=files)
    return render_template('home.html',files=files)

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

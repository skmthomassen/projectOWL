from flask import Flask, render_template
import os, subprocess

app = Flask(__name__) #static_folder="/home/kim/projectOWL/flaskWS/alpha/static"

@app.before_first_request
def setup_page():
    cmdTHUMBS = subprocess.Popen([ 'sh', 'static/capturethumbs.sh'], stdout=subprocess.PIPE)
    thumbsPID = cmdTHUMBS.pid
    fileThumb = open('static/PIDthumbs','w')
    fileThumb.write( str(thumbsPID) )
    fileThumb.close()

# @app.teardown_appcontext( 'teardown' )
# def teardown():
#     subprocess.call(['static/controlstreams.py'])

@app.route('/')
@app.route('/home')
def home():
   return render_template('home.html')

@app.route('/dragons')
def dragons():
   return render_template('dragons.html')

@app.route('/run_script')
def run_script():
    subprocess.call(['static/controlstreams.py'])
    return 'ok'

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')

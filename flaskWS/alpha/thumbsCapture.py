#!/usr/bin/env python

import subprocess
import os, errno
import datetime
import time

FFMPEG = "/usr/bin/ffmpeg"
CWD = os.getcwd()
thumbs = CWD + "/thumbs"

#Testing if cameras are available at given ip address
def isCamerasAvailable():
    b = False
    cmdPING2 = subprocess.run([ 'ping', '-q', '-c', '1', '192.168.0.202' ])
    cmdPING3 = subprocess.run([ 'ping', '-q', '-c', '1', '192.168.0.203' ])
    if cmdPING2.returncode == 0 and cmdPING3.returncode == 0:
        b = True
    else:
        print("One or both cameras are unreachable")
    return b

# Using FFMPEG, captures a single image from the cameras rtsp stream
def captureThumb ( ip, timestamp ):
    address = "rtsp://192.168.0." + ip + "/av0_1"
    fileName = thumbs + "/" + timestamp + "_" + ip + ".png"
    cmd = [ FFMPEG, '-y', '-hide_banner', '-loglevel', '-8',
            '-i', address,
            '-frames', '1', fileName ]
    subprocess.call(cmd)

def doRepeat():
    interval = 5
    starttime=time.time()
    while True:
        print ("tick")
        now = time.time()
        for f in os.listdir(thumbs):
            if os.stat(os.path.join(thumbs, f)).st_mtime < now - 60: #1day->86400
                os.remove(os.path.join(thumbs, f))
        timestamp = '{:%Y-%m-%d_%H:%M:%S}'.format(datetime.datetime.now())
        captureThumb("202", timestamp)
        captureThumb("203", timestamp)
        time.sleep(interval - ((time.time() - starttime) % interval))

if isCamerasAvailable:
    doRepeat()

















#try:
#    os.makedirs(thumbs)
#except OSError as e:
#    if e.errno != errno.EEXIST:
#        raise
#if not os.listdir("thumbs"):
#    print("THUMBS IS EMPTY")



#Bye!

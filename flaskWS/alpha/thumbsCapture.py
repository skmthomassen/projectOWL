#!/usr/bin/env python

import subprocess
import os, errno
import datetime
import time

FFMPEG = "/usr/bin/ffmpeg"
CWD = os.getcwd()
thumbs = CWD + "/static/thumbs"

# Using FFMPEG, captures a single image from the cameras rtsp stream
def captureThumb ( ip, ali ):
    address = "rtsp://192.168.0." + ip + "/av0_1"
    fileName = thumbs + "/" + ip + ali + ".png"
    cmd = [ FFMPEG, '-y', '-hide_banner', '-loglevel', '-8',
            '-i', address, '-frames', '1', fileName ]
    subprocess.call(cmd)

def doRepeat():
    interval = 5 #The amount of seconds elapsing between capturing a still
    starttime=time.time()
    while True:
        captureThumb( "202", "left" )
        captureThumb( "203", "right" )
        time.sleep(interval - ((time.time() - starttime) % interval))

if __name__ == "__main__":
    doRepeat()
















#Bye!

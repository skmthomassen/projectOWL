#!/usr/bin/env python

import thumbsCapture
import subprocess
from subprocess import Popen
import os, signal, time

#Testing if cameras are available at given ip address
def isCamerasAvailable():
    b = False
    cmdPING2 = subprocess.Popen([ 'ping', '-c', '1', '192.168.0.202'], stdout=subprocess.PIPE)
    cmdPING3 = subprocess.Popen([ 'ping', '-c', '1', '192.168.0.203'], stdout=subprocess.PIPE)
    while cmdPING2.poll() is None and cmdPING3.poll() is None:
        time.sleep(0.01)
    if cmdPING2.poll() == 0 and cmdPING3.poll() == 0:
        b = True
    else:
        print("One or both cameras are unreachable")
    return b

def doThumbsCapture():
    if isCamerasAvailable():
        thumbsCapture.doRepeat()

def doStopRecording( recObj ):
    recObj.terminate

def doStartRecording():
    if isCamerasAvailable():
        cmdREC = subprocess.Popen(['sh', 'recordstreams.sh'], stdout=subprocess.PIPE)
        return cmdREC


if __name__ == "__main__":
    doThumbsCapture()
    #recObj = doStartRecording()
    #doStartRecording()
    #doStopRecording( recObj )

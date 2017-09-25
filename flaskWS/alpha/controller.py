#!/usr/bin/env python

import thumbsCapture
import subprocess
from subprocess import Popen
import os, signal, time
import argparse

parser = argparse.ArgumentParser(description='Controlling the background processes of the ProjectOWLs little web server')

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

def doCaptureThumbs():
    if isCamerasAvailable():
        cmdTHUMBS = subprocess.Popen([ 'sh', 'captureThumbs.sh'], stdout=subprocess.PIPE)
        thumbsPID = cmdTHUMBS.pid
        fileThumb = open('PIDthumbs','w')
        fileThumb.write( str(thumbsPID) )
        fileThumb.close()

def doStopCaptureThumbs():
    fileThumbs = open('PIDthumbs','r')
    thumbsPID = fileThumbs.readline()
    os.kill(int(thumbsPID), signal.SIGTERM)

def doStartRecording():
    if isCamerasAvailable():
        cmdREC = subprocess.Popen(['sh', 'recordstreams.sh'], stdout=subprocess.PIPE, preexec_fn=os.setsid)
        recsPID = cmdREC.pid
        fileRec = open('PIDrecording','w')
        fileRec.write( str(recsPID) )
        fileRec.close()

def doStopRecording():
    fileRec = open('PIDrecording','r')
    recPID = fileRec.readline()
    os.killpg(int(recPID), signal.SIGTERM)
    time.sleep( 1 ) #Needs 2 SIGTERMS due to the way GNU parallel is constructed
    os.killpg(int(recPID), signal.SIGTERM)
    #os.kill(int(recPID), signal.SIGTERM)


if __name__ == "__main__":
    fileThumbs = open('PIDthumbs','r')
    thumbsPID = fileThumbs.readline()
    tx = os.path.isdir("/proc/" + thumbsPID)
    #print (tx)
    if not tx:
        doCaptureThumbs()
    #doStopCaptureThumbs()

    fileRec = open('PIDrecording','r')
    recPID = fileRec.readline()
    rx = os.path.isdir("/proc/" + recPID)
    if rx:
        doStopRecording()
    else:
        doStartRecording()
















###

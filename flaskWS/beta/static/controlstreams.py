#!/usr/bin/env python

import os, signal, time, subprocess

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

#Starting the recording script, saves its PID to a file
def doStartRecording():
    if isCamerasAvailable():
        cmdREC = subprocess.Popen(['sh', 'static/capturestreams.sh'], stdout=subprocess.PIPE, preexec_fn=os.setsid)
        recsPID = cmdREC.pid
        fileRec = open('static/PIDrecording','w')
        fileRec.write( str(recsPID) )
        fileRec.close()

#Stop recording by PID
def doStopRecording():
    fileRec = open('static/PIDrecording','r')
    recPID = fileRec.readline()
    os.killpg(int(recPID), signal.SIGTERM)
    time.sleep( 1 ) #Needs 2 SIGTERMS due to the way GNU parallel is constructed
    os.killpg(int(recPID), signal.SIGTERM)

if __name__ == "__main__":
    fileRec = open('static/PIDrecording','r')
    recPID = fileRec.readline()
    rx = os.path.isdir("/proc/" + recPID)
    if rx:
        doStopRecording()
    else:
        doStartRecording()

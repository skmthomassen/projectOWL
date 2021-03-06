#!/usr/bin/env python

import os, signal, time, subprocess, psutil
from glob import glob

#Testing if cameras are available at given ip address
def is_cameras_available():
    cmdPING2 = subprocess.Popen([ 'ping', '-c', '1', '192.168.0.202'], stdout=subprocess.PIPE)
    cmdPING3 = subprocess.Popen([ 'ping', '-c', '1', '192.168.0.203'], stdout=subprocess.PIPE)
    while cmdPING2.poll() is None and cmdPING3.poll() is None:
        time.sleep(0.01)
    if cmdPING2.poll() == 0 and cmdPING3.poll() == 0:
        return True
    else:
        print("One or both cameras are unreachable")
        return False

def capture_thumbnails():
    thumbsPID = openFile('PIDthumbs','r', '')
    thumbsPID = str(thumbsPID)
    if os.path.isdir("/proc/" + thumbsPID):
        os.killpg(int(thumbsPID), signal.SIGTERM)
    cmdTHUMBS = subprocess.Popen([ 'sh', 'capturethumbs.sh'], stdout=subprocess.PIPE)
    thumbsPID = cmdTHUMBS.pid
    thumbsPID = openFile('PIDthumbs','w', thumbsPID)

#Starting the recording script, saves its PID to a file
def is_recording():
    recPID = openFile('PIDrecording','r', '')
    if psutil.pid_exists(recPID):
        return True
    return False

def recording_time():
    startTime = openFile('startTime', 'r', '')
    nowTime = int(time.time())
    timeStamp = nowTime - startTime
    return timeStamp

#Starting the recording script, saves its PID to a file
def start_recording():
    #cmdREC = subprocess.Popen(['sh', 'capturestreams.sh'], stdout=subprocess.PIPE, preexec_fn=os.setsid)
    cmdREC
    try:
        cmdREC.wait(timeout=5)
    except:
        pass
    startTime = int(time.time())
    openFile('startTime','w', str(startTime) )
    recsExitCode = cmdREC.returncode
    if recsExitCode is 10:
        return False
    recsPID = cmdREC.pid
    openFile('PIDrecording','w', recsPID)
    if os.path.isdir("/proc/" + str(recsPID) ):
        return True

#Stop recording by PID
def stop_recording():
    recPID = openFile('PIDrecording', 'r', '')
    if psutil.pid_exists(recPID):
        recProc = psutil.Process(recPID)
        childProc = recProc.children()
        for p in childProc:
            p.terminate()
            time.sleep(1)
            p.terminate()
            p.wait()
        recProc.terminate()
        recProc.wait()

#Finds the most recent recording and returns its path
def serve_recording():
    allFileName = glob('clips/[0-9]*.tar.xz')
    if not allFileName:
        return False
    fullFileName = max(allFileName)
    #path, fileName = fullFileName.split('/')
    return str(fullFileName)


def openFile(fileName, rw, writeStr):
    if rw == 'r':
        try:
            fileRead = open( str(fileName), 'r' )
            fileStr = fileRead.readline()
            fileRead.close()
        except FileNotFoundError:
            print("File couldn't be opened: " + str(fileName) )
        fileInt = int(fileStr)
        return fileInt
    elif rw == 'w':
        try:
            fileRead = open(str(fileName), 'w')
            fileRead.write( str(writeStr) )
            fileRead.close()
        except FileNotFoundError:
            print("File couldn't be opened: " + str(fileName) )

#Either start or stop a recording, depending on whether a PID exists
def toggle_record():
    try:
        fileRec = open('PIDrecording','r')
        recPID = fileRec.readline()
        fileRec.close()
        rx = os.path.isdir("/proc/" + recPID)
        if rx:
            stop_recording()
        else:
            start_recording()
    except IOError:
        print("File PIDrecording couldn't be opened.5")

#if __name__ == "__main__":
    #toggle_record()
    #print("di start? " + str(start_recording()) )

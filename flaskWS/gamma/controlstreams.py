#!/usr/bin/env python

import os, signal, time, subprocess

IDLE = "idle"
ACTIVE = "active"
RECORDING_STATE = IDLE

def capture_thumbnails():
    try:
        fileThumb = open('PIDthumbs','r')
        thumbsPID = fileThumb.readline()
    except IOError as e:
        print("File PIDthumbs couldn't be opened.")
    if os.path.isdir("/proc/" + thumbsPID):
        os.killpg(int(thumbsPID), signal.SIGTERM)
    cmdTHUMBS = subprocess.Popen([ 'sh', 'capturethumbs.sh'], stdout=subprocess.PIPE)
    thumbsPID = cmdTHUMBS.pid
    try:
        fileThumb = open('PIDthumbs','w')
        fileThumb.write( str(thumbsPID) )
        fileThumb.close()
    except IOError as e:
        print("File PIDrecording couldn't be opened.")

#Starting the recording script, saves its PID to a file
def is_recording():
	try:
		fileRec = open('PIDrecording','r')
		recPID = fileRec.readline()
		fileRec.close()
	except IOError:
		print("File PIDrecording couldn't be opened.42")
	pr = os.path.isdir("/proc/" + recPID)
	print("PID of rec: " + str(recPID) )
	print("PR: " + str(pr) )
	if pr:
		return True
	elif not pr:
		return False

#Starting the recording script, saves its PID to a file
def start_recording():
	cmdREC = subprocess.Popen(['sh', 'capturestreams.sh'], stdout=subprocess.PIPE, preexec_fn=os.setsid)
	try:
		cmdREC.wait(timeout=5)
	except:
		pass
	recsExitCode = cmdREC.returncode
	if recsExitCode is 10:
		return False
	recsPID = cmdREC.pid
	try:
		fileRec = open('PIDrecording','w')
		fileRec.write( str(recsPID) )
		fileRec.close()
	except IOError:
		print("File PIDrecording couldn't be opened.1")
	try:
		fileRec = open('PIDrecording','r')
		recPID = fileRec.readline()
	except IOError:
		print("File PIDrecording couldn't be opened.2")
	if os.path.isdir("/proc/" + recPID):
		return True

#Stop recording by PID
def stop_recording():
    try:
        fileRec = open('PIDrecording','r')
        recPID = fileRec.readline()
        fileRec.close()
    except IOError:
        print("File PIDrecording couldn't be opened.3")
    os.killpg(int(recPID), signal.SIGTERM)
    time.sleep( 1 ) #Needs 2 SIGTERMS due to the way GNU parallel is constructed
    os.killpg(int(recPID), signal.SIGTERM)
    try:
        fileRec = open('PIDrecording','r')
        recPID = fileRec.readline()
    except IOError:
        print("File PIDrecording couldn't be opened.4")
    if os.path.isdir("/proc/" + recPID):
        return False
    return True

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

import os
import time
import struct
import requests
from subprocess import Popen
import pyaudio
import wave

def setGOP(ip, gop):
	print("set %s gop to %d" % (ip, gop))
	data = {
		"encoder" :	"2",
		"sys_cif" : "0",
		"advanced" : "1",
		"ratectrl" : "0",
		"quality" : "0",
		"iq" : "0",
		"rc" : "0",
		"bitrate" : "16384",
		"frmrate" : "30",
		"frmintr" : "1",
		"first" : "0",
		"vlevel2" : "1",
		"encoder2" : "0",
		"sys_cif2" : "2",
		"advanced2" : "1",
		"ratectrl2" : "0",
		"quality2" : "3",
		"iq2" : "3",
		"rc2" : "3",
		"bitrate2" : "1024",
		"frmrate2" : "30",
		"frmintr2" : "30",
		"first2" : "0",
		"maxfrmintr" : "200",
		"maxfrmrate" : "30",
		"nlevel" : "1",
		"nfluctuate" : "1"
	}
	if gop < 1:
		gop = 1
	if gop > 200:
		gop = 200
	data["frmintr"] = gop
	r = requests.post('http://'+ip+'/webs/videoEncodingCfgEx', data=data)
	#print(r.text)

def setBrightness(ip, v):
	print("set %s brightness to %d" % (ip, v))
	if v < 0:
		v = 0
	if v > 255:
		v = 255
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1001&paramctrl=%d&paramstep=0&paramreserved=0&UserID=32673532&UserID=32673532'%(v))
	#print(r.text)

def setContrast(ip, v):
	print("set %s contrast to %d" % (ip, v))
	if v < 0:
		v = 0
	if v > 255:
		v = 255
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1002&paramctrl=%d&paramstep=0&paramreserved=0&UserID=85911448&UserID=85911448'%(v))
	#print(r.text)

def setHue(ip, v):
	print("set %s hue to %d" % (ip, v))
	if v < 0:
		v = 0
	if v > 255:
		v = 255
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1003&paramctrl=%d&paramstep=0&paramreserved=0&UserID=85911448&UserID=85911448'%(v))
	#print(r.text)

def setSat(ip, v):
	print("set %s saturation to %d" % (ip, v))
	if v < 0:
		v = 0
	if v > 255:
		v = 255
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1004&paramctrl=%d&paramstep=0&paramreserved=0&UserID=85911448&UserID=85911448'%(v))
	#print(r.text)


def setSharpness(ip, v):
	print("set %s sharpness to %d" % (ip, v))
	if v < 0:
		v = 0
	if v > 255:
		v = 255
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1005&paramctrl=%d&paramstep=0&paramreserved=0&UserID=85911448&UserID=85911448'%(v))
	#print(r.text)

def setGamma(ip, v):
	print("set %s gamma to %d" % (ip, v))
	if v < 0:
		v = 0
	if v > 255:
		v = 255
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1009&paramctrl=%d&paramstep=0&paramreserved=0&UserID=85911448&UserID=85911448'%(v))
	#print(r.text)

def setBLC(ip, v):
	print("set %s blc to %d" % (ip, v))
	if v < 0:
		v = 0
	if v > 255:
		v = 255
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1017&paramctrl=%d&paramstep=0&paramreserved=0&UserID=85911448&UserID=85911448'%(v))
	#print(r.text)

def setWDR(ip, v):
	print("set %s wdr to %d" % (ip, v))
	if v < 0:
		v = 0
	if v > 255:
		v = 255
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1038&paramctrl=%d&paramstep=0&paramreserved=0&UserID=85911448&UserID=85911448'%(v))

def setExposure(ip, v):
	print("set %s exposure to %d" % (ip, v))
	if v < 0:
		v = 0
	r = requests.get('http://'+ip+'/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1058&paramctrl=%d&paramstep=0&paramreserved=0&UserID=85911448&UserID=85911448'%(v))

#WDR strength
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1038&paramctrl=98&paramstep=0&paramreserved=0&UserID=47836379&UserID=47836379

#image transparent
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1115&paramctrl=2&paramstep=0&paramreserved=0&UserID=92516639&UserID=92516639
#image truecolor
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1115&paramctrl=3&paramstep=0&paramreserved=0&UserID=77213532&UserID=77213532

#outdoor
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1116&paramctrl=0&paramstep=0&paramreserved=0&UserID=18039741&UserID=18039741
#indoor 1
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1116&paramctrl=1&paramstep=0&paramreserved=0&UserID=97747586&UserID=97747586
#indoor 2
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1116&paramctrl=2&paramstep=0&paramreserved=0&UserID=63223297&UserID=63223297

#exposure
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1058&paramctrl=12&paramstep=0&paramreserved=0&UserID=42845473
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1058&paramctrl=25&paramstep=0&paramreserved=0&UserID=63756248
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1058&paramctrl=30&paramstep=0&paramreserved=0&UserID=99794155
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1058&paramctrl=35&paramstep=0&paramreserved=0&UserID=53588597
#http://192.168.0.204/webs/btnSettingEx?flag=1000&paramchannel=0&paramcmd=1058&paramctrl=50&paramstep=0&paramreserved=0&UserID=97296272


"""
setGOP("192.168.0.204", 1)
time.sleep(1)
setGOP("192.168.0.204", 200)
time.sleep(1)
setBrightness("192.168.0.204", 0)
time.sleep(1)
setBrightness("192.168.0.204", 255)
time.sleep(1)
setContrast("192.168.0.204", 0)
time.sleep(1)
setContrast("192.168.0.204", 255)
time.sleep(1)
setHue("192.168.0.204", 0)
time.sleep(1)
setHue("192.168.0.204", 255)
time.sleep(1)
setSat("192.168.0.204", 0)
time.sleep(1)
setSat("192.168.0.204", 255)
time.sleep(1)
setSharpness("192.168.0.204", 0)
time.sleep(1)
setSharpness("192.168.0.204", 255)
time.sleep(1)
setGamma("192.168.0.204", 1)
time.sleep(1)
setGamma("192.168.0.204", 255)
time.sleep(1)
setGamma("192.168.0.204", 50)
setBLC("192.168.0.204", 1)
time.sleep(3)
setBLC("192.168.0.204", 255)
time.sleep(3)
setBLC("192.168.0.204", 50)
setWDR("192.168.0.204", 1)
time.sleep(3)
setWDR("192.168.0.204", 255)
time.sleep(3)
setWDR("192.168.0.204", 50)
setExposure("192.168.0.204", 8000)
time.sleep(3)
setExposure("192.168.0.204", 100)
time.sleep(3)
"""

recordtime = 30 * 60

#fire and forget
def faf(c):
	cmd = c.split(" ")
	#print(cmd)
	pid = Popen(cmd)
	#print("pid:", pid)
	return pid

#GOP
setGOP("192.168.0.202", 1)
setGOP("192.168.0.203", 1)
time.sleep(3)

#make folder
faf('mkdir -p sample')
#start recording
print("start recording")
faf('ffmpeg -hide_banner -loglevel 0 -rtsp_transport tcp -i rtsp://192.168.0.202/av0_0 -c:v copy -t %d -y sample/cam2.ts' % (recordtime))
faf('ffmpeg -hide_banner -loglevel 0 -rtsp_transport tcp -i rtsp://192.168.0.203/av0_0 -c:v copy -t %d -y sample/cam3.ts' % (recordtime))
#faf('ffmpeg -hide_banner -loglevel 0 -ac 1 -f alsa -i hw:1 -y -t %d sample/snd.aac' % (recordtime))

#let recording begin
time.sleep(3)

#set GOP up again
setGOP("192.168.0.202", 200)
setGOP("192.168.0.203", 200)

#wait recording out
time.sleep(recordtime + 3)

print("done")

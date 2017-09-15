#!/usr/bin/python3

from pygame import mixer # Load the required library
import subprocess
import time
import os

#
#LOADING THE SOUND THING
#
filetoplay = os.getcwd() + "/beep005.mp3"
print (filetoplay)

def play(audio_file):
    subprocess.call(["ffplay", "-hide_banner", "-loglevel", "-8", "-nodisp", "-autoexit", filetoplay])

#
#OTHER LOOP TRY
#
interval = 60
starttime=time.time()
#print ("Starting beep job...")
count = 0
while True:
  if count == 11:
    count = 0
  repeat = 0
  while repeat < count:
      #print ("repeat...", repeat)
      play(filetoplay)
      repeat += 1
  print ("count...", count)
  time.sleep(interval - ((time.time() - starttime) % interval))
  count += 1
#

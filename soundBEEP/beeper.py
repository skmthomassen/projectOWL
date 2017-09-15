#!/usr/bin/env python

from pygame import mixer # Load the required library
import time
import subprocess

#
#LOADING THE SOUND THING
#
#mixer.init()
#mixer.music.load('beep005.mp3')
filetoplay = '/home/kim/projectOWL/soundBEEP/beep005.mp3'

def play(audio_file):
    subprocess.call(["ffplay", "-hide_banner", "-loglevel", "-8", "-nodisp", "-autoexit", filetoplay])

#
#OTHER LOOP TRY
#
interval = 10
starttime=time.time()
print ("Starting beep job...")
count = 0
while True:
  if count == 11:
    count = 0
  repeat = 0
  while repeat < count:
      #print ("repeat...", repeat)
      play(filetoplay)
      repeat += 1
  #print ("count...", count)
  time.sleep(interval - ((time.time() - starttime) % interval))
  count += 1
#

#!/usr/bin/env python

from pygame import mixer # Load the required library
import os
import time

#
#LOADING THE SOUND THING
#
cwd = os.getcwd()
mixer.init()
#mixer.music.load('cwd/beep.mp3')
mixer.music.load('/home/kim/projectOWL/soundBEEP/beep005.mp3')

#
#OTHER LOOP TRY
#
n = 5
starttime=time.time()
print ("Starting beep job...")
count = 0
while True:
  #mixer.music.play()
  print ("beep...", count)
  time.sleep(n - ((time.time() - starttime) % n))
  count += 1
#

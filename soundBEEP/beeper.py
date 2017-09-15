#!/usr/bin/env python

from pygame import mixer # Load the required library
import time

#
#LOADING THE SOUND THING
#
mixer.init()
mixer.music.load('beep005.mp3')

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

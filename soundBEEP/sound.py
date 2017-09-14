

import math
#sudo apt-get install python-pyaudio
from pyaudio import PyAudio

#See http://en.wikipedia.org/wiki/Bit_rate#Audio
BITRATE = 100000 #number of frames per second/frameset.      

#See http://www.phy.mtu.edu/~suits/notefreqs.html
FREQUENCY = 587.33 #Hz, waves per second, 261.63=C4-note.
LENGTH = 0.4 #seconds to play sound

NUMBEROFFRAMES = int(BITRATE * LENGTH)
RESTFRAMES = NUMBEROFFRAMES % BITRATE
WAVEDATA = ''    

for x in range(NUMBEROFFRAMES):
   WAVEDATA += chr(int(math.sin(x / ((BITRATE / FREQUENCY) / math.pi)) * 127 + 128))    

#fill remainder of frameset with silence
for x in range(RESTFRAMES): 
    WAVEDATA += chr(128)

p = PyAudio()
stream = p.open(
    format=p.get_format_from_width(1),
    channels=1,
    rate=BITRATE,
    output=True,
    )
stream.write(WAVEDATA)
stream.stop_stream()
stream.close()
p.terminate()




# projectOWL

Project for a recording protoype, with different sub-projects for exploring different avenues of posibilities.

THE IPCAMS vs1:
-Prereqs:
	GNU parallel & FFMPEG
-recordstreams.sh TIME -> records from the IP adresses listed in camIPs file. Will split the stream into 60s segments. TIME given is the wanted recording time in seconds.
-sidebyside.sh SUFFIX_id -> merges the input video/audio sugested by the SUFFIX_id into a single video.
#Deprecated for sidebyside.sh
#concat.sh -> early version of a script for concatenating the clips listed i clips directory.
#merger.sh -> merges the output of concat.sh into a single stacked view output video. Takes a fuckton of time. 

THE JETSON BOARDS & econ E-CAMS vs1:
-Prereqs:
	gstreamer vs 1.0

TODO
load("GRANSYNTH")
load("FREEVERB")

bus_config("GRANSYNTH", "aux 0-1 out")
bus_config("FREEVERB", "aux 0-1 in", "out 0-1")

dur = 16

amp = maketable("line", 1000, 0,0, 1,1, 3,1, 4,0)
wave = maketable("wave", 2000, 1, .5, .3, .2, .1)
granenv = maketable("window", 2000, "hanning")
hoptime = maketable("line", "nonorm", 1000, 0,0.01, 2,0.05)
hopjitter = 0.0001
maxdur = maketable("line", "nonorm", 1000, 0,0.08, 1, 2, 2, 2)
pitch = maketable("line", "nonorm", 1000, 0,4, 3,6, 4, 5.4, 5, 5.4)
transpcoll = maketable("literal", "nonorm", 0, 0, .02, .03, .05, .07, .10)
pitchjitter = 1

GRANSYNTH(0, dur, amp*6000, wave, granenv, hoptime, hopjitter,
   .06, maxdur, 1, 1, pitch, transpcoll, pitchjitter, 14, 0, 0)

GRANSYNTH(0.14, dur, amp*6000, wave, granenv, hoptime, hopjitter,
   .06, maxdur, 1, 1, pitch + 0.002, transpcoll, pitchjitter, 21, 1, 1)

FREEVERB(0, 0, dur + 1, 1, 0.9, .03, 3, 70, 40, 30, 100)
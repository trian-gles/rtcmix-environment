load("GRANSYNTH")
load("FREEVERB")

bus_config("GRANSYNTH", "aux 0-1 out")
bus_config("FREEVERB", "aux 0-1 in", "out 0-1")

dur = 5

amp = maketable("line", 1000, 0,0, 1,1, 2,0.5, 3,1, 4,0)
wave = maketable("wave", 2000, 1, .5, .3, .2, .1)
granenv = maketable("window", 2000, "hanning")
hoptime = maketable("line", "nonorm", 1000, 0,0.01, 1,0.002, 2,0.01)
hopjitter = 0.01
mindur = .06
maxdur = .08
minamp = maxamp = 1

transpcoll = maketable("literal", "nonorm", 0, 0, .07, .12)
pitchjitter = 1

dyads = {}
dyads[0] = maketable("line", "nonorm", 1000, 0,6.2, 1,6.2, 2, 6.4)
dyads[1] = maketable("line", "nonorm", 1000, 0,6.2, 1,6.2, 2, 5.85)
dyads[2] = maketable("line", "nonorm", 1000, 0,6.75, 1,6.75, 2, 6.45)

for (i = 0; i < len(dyads); i += 1)
{
	pitch = dyads[i]
    st = (dur + 1) * i
    GRANSYNTH(st, dur, amp*6000, wave, granenv, hoptime, hopjitter,
       mindur, maxdur, minamp, maxamp, pitch + 440*0.01, transpcoll, pitchjitter, 14, 0, 0)

    st = st+0.14
    pitch = pitch+0.002
    GRANSYNTH(st, dur, amp*7000, wave, granenv, hoptime, hopjitter,
       mindur, maxdur, minamp, maxamp, pitch + 440*0.01, transpcoll, pitchjitter, 21, 1, 1)

}


FREEVERB(0, 0, (dur + 1) * len(dyads), 1, 0.9, .03, 3, 70, 40, 30, 100)



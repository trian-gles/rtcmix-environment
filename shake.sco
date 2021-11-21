load("FREEVERB")
load("MSHAKERS")
bus_config("MSHAKERS", "aux 0-1 out")
bus_config("FREEVERB", "aux 0-1 in", "out 0-1")



st = 0
    for (i = 0; i < 20; i = i+1)
    {
		pan = abs((i / 10) - 1)
       	MSHAKERS(st, 0.5, 20000, 1, 0.8, 0.5, 0.7, 11, pan)
       	st = st + 0.07 + i / 200
    }


FREEVERB(0, 0, 23, 1, 0.9, .03, 3, 70, 40, 30, 100)
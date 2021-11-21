load("WAVETABLE")
load("BUTTER")

bus_config("WAVETABLE", "aux 0-1 out")
bus_config("BUTTER", "aux 0-1 in", "out 0-1")

wave = maketable("wave", 1000, "saw")
env = maketable("line", 1000, 0, 0, 1, 1, 56, 0.5, 100, 0.5, 118, 0)
pitches = {60, 62, 67}
voices = 4


for (i = 0; i < len(pitches); i += 1)
 {
    freq = cpsmidi(pitches[i])

      //for each voice, create a different detuned and phase shifted WAVETABLE
    for (j = 0; j < voices; j = j + 1)
    {
      modded_freq = freq + rand()
      //the pitch will wobble a littttttle bit
      freq_tab = makeLFO("sine", abs(rand()) / 4 + 0.5, freq -2, freq + 2)
      WAVETABLE(abs(rand()) / 100, 20, 5000, freq_tab, j % 2, wave)
    }
}
lfo_speed = makeLFO("sine", 0.2, 0.6, 2)
cutoff_freq = makeLFO("sine", lfo_speed, 1778, 19000)
BUTTER(0, 0, 20, 1, "lowpass", 3, 1, 0, 0.5, 0, cutoff_freq, 90.0)
load("WAVETABLE")
load("BUTTER")

bus_config("WAVETABLE", "aux 0-1 out")
bus_config("BUTTER", "aux 0-1 in", "out 0-1")

wave = maketable("wave", 1000, 1, 0, .3, 0, .2, 0, .125)
env = maketable("line", 1000, 0, 0, 1, 1, 20, 0.01, 100, 0.01, 118, 0)
dur = .65
pitches = {60, 62, 67}
voices = 4
time = 0

float make_offbeats()
{
  sixteenth_note = dur / 4
  for (k = 0; k < 12; k += 1)
  {


    actual_time = time + sixteenth_note
      for (l = 0; l < 3; l = l + 1)
    {
      if (rand() < 0)
      {
        for (i = 0; i < len(pitches); i += 1)
        {
          freq = cpsmidi(pitches[i])
          for (j = 0; j < voices; j = j + 1)
          {

            WAVETABLE(actual_time + abs(rand()) / 200, dur + 0.1, 5000 * env, freq + rand(), j % 2, wave)
          }
        }
      }
      actual_time += sixteenth_note
    }
    time += dur
  }
  return 0
}



make_offbeats()
dur = .5
pitches = {59, 64, 66}
make_offbeats()

BUTTER(0, 0, 20, 1, "bandpass", 3, 1, 0, 0.5, 0, 478, 90.0)
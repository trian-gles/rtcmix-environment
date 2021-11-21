load("WAVETABLE")

wave = maketable("wave", 1000, 1, 0, .3, 0, .2, 0, .125)
env = maketable("line", 1000, 0, 0, 1, 1, 56, 0.5, 100, 0.5, 118, 0)
dur = .65
pitches = {60, 62, 67}
voices = 4
time = 0


float make_chords()
// Plays 12 downbeat chords
{
  for (k = 0; k < 12; k += 1)
  {
    for (i = 0; i < len(pitches); i += 1)
    {
      freq = cpsmidi(pitches[i])

      //for each voice, create a different detuned and phase shifted WAVETABLE
      for (j = 0; j < voices; j = j + 1)
      {
        WAVETABLE(time + abs(rand()) / 200, dur + 0.1, 5000 * env, freq + rand(), j % 2, wave)
      }
    }
    time += dur
  }
  return 0
}

make_chords()

//speed up and change the pitches
dur = .5
pitches = {59, 64, 66}
make_chords()
from pyo import *
import audiolazy



class HeartBeat:
    def __init__(self, voices=4, harms=24):
        self.voices = voices

        self.changed_freqs = True

        square_harms = [1 * (i % 2) / i for i in range(1, harms + 1)]
        self.square_table = HarmTable(square_harms)


        self.freqs = SigTo([midiToHz(freq) for freq in [60, 62, 67]], time=1)

        self.beat = Metro(time=.162 * 4).play()
        self.offbeats = Beat(time=.162, taps=16, w1=[100, 0], w2=[100], w3=[0, 45], poly=2).play()
        self.beat2 = Metro(time=1).play()
        self.trigfunc = TrigFunc(self.offbeats[0], function=self.play)
        self.offtrig = TrigFunc(self.offbeats[1], function=self.offbeat_play)
        self.trigfunc2 = TrigFunc(self.beat2, function=self.play2)

        self.env = Adsr(attack=0, decay=0.231, sustain=0.412, release=0.577, dur=1)

        self.slow_env_speed = Sine(freq= 0.1, mul = 0.1, add = 0.6)
        self.slow_env = LFO(freq=self.slow_env_speed, type=1, sharp=0)
        self.mute_env = Adsr(attack=0, decay=0.058, sustain=0.062, release=0, dur=1)

        self.players = [Osc(mul=self.env / self.voices, freq=list(map(lambda f: f * random.uniform(0.99, 1.01), self.freqs)),
                            table=self.square_table, phase=random.uniform(0, 1)).play() for _ in range(voices)]
        self.mute_players = [Osc(mul=self.mute_env / self.voices, freq=list(map(lambda f: f * random.uniform(0.99, 1.01), self.freqs)),
                            table=self.square_table, phase=random.uniform(0, 1)).play() for _ in range(voices)]

        self.high = SuperSaw([midiToHz(freq) for freq in [81, 62, 67]] + [midiToHz(freq) + random.uniform(0, 1) for freq in [81, 62, 67]], mul = 0.3, bal=0.9, detune=0.6)
        self.hipass = Biquad(self.high, freq=self.slow_env * 6000 + 11000)
        self.mute_pass = Biquad(self.mute_players, freq=392.0466, q=100.0000, type=0, mul=1.6538)
        self.mlp = ButHP(self.mute_pass, freq=325.5131, mul=1.9000)
        self.mlp.ctrl()
        self.mute_env.ctrl()

    def get_pyoobj(self):
        return self.hipass + self.mlp + sum(self.players)

    def offbeat_play(self):
        self.mute_env.play()

    def play(self):
        self.env.play()


    def change_freqs(self):
        # make this go back
        if self.changed_freqs:
            for i, freq in enumerate([59, 64, 66]):
                self.freqs[i].value = midiToHz(freq)
            self.beat.time = 0.11 * 4
            self.offbeats.time = 0.11
            self.slow_env_speed.mul = 4
            self.slow_env_speed.add = 10
            self.slow_env_speed.freq = 0.5
        else:
            for i, freq in enumerate([60, 62, 67]):
                self.freqs[i].value = midiToHz(freq)
            self.beat.time = .162 * 4
            self.offbeats.time = 0.162
            self.slow_env_speed.mul = 0.1
            self.slow_env_speed.add = 0.6
            self.slow_env_speed.freq = 0.1

        self.changed_freqs = not self.changed_freqs


    def play2(self):
        if random.randrange(0, 5) == 0:
            self.offbeats.new()
        self.slow_env.play()

    def ctrl(self):
        self.env.ctrl()
        self.beat.ctrl()
        self.beat2.ctrl([SLMap(0, 2, 'lin', 'time', 1)])
        self.high.ctrl()
        self.hipass.ctrl()
        self.slow_env.ctrl()


if __name__ == "__main__":
    s = Server().boot()
    s.recordOptions(dur=10, filename="../cardiovascular_environment.wav", fileformat=0, sampletype=1)
    t = SndTable("../rumble2.wav")
    rumble = TableRead(table=t, freq=t.getRate(), mul = 0.5)

    duck = SigTo(1, time = 2, init=1)

    t2 = SndTable("../shakers.wav")
    shuf = TableRead(table=t2, freq=t2.getRate())
    panpos = Sine(freq=0.2)
    shufpan = Pan(shuf, pan=panpos)
    (shufpan / 4).out()



    gran_tabs = [SndTable(f) for f in ["gran1.wav", "gran2.wav", "gran3.wav"]]
    b = TableRead(gran_tabs[1], freq=gran_tabs[1].getRate())
    last_sound = gran_tabs[0]

    fv = Freeverb(shuf + rumble + b, size=1, bal=1.0, mul=1.7).out()

    def rand_gran():
        global last_sound
        chosen_tab = last_sound
        while chosen_tab == last_sound:
            chosen_tab = random.choice(gran_tabs)
        b.table = chosen_tab
        b.freq = chosen_tab.getRate()
        last_sound = chosen_tab
        return b

    def play_sound(sound: TableRead):
        global t
        duck_hb()
        sound.out()
        t = TrigFunc(sound["trig"], return_hb)



    def duck_hb():
        duck.value = 0.25

    def return_hb():
        duck.value = 1


    hb = HeartBeat()
    (hb.get_pyoobj() * duck / 6).out()
    s.gui(locals())
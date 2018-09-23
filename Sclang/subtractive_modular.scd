(
~oscz = {arg freq = 20, out=0, amp=0.2, gate = 1,
	attack = 0.5, decay = 0.5, sustain = 0.5, release = 0.5,
	coarse = 0, fine = 0,
    oscType = 0, shape = 0.5; // Osctypes: sin, triangle, saw, square, noise
    var source, env, true_freq;
    env = EnvGen.kr(Env.adsr(attack,decay,sustain,release), gate: gate, doneAction: 2);
    true_freq = freq*coarse.midiratio + fine;
    source = Select.ar(oscType,[SinOsc.ar(true_freq,mul:amp), LFTri.ar(true_freq,mul:amp), Saw.ar(true_freq,mul:amp), Pulse.ar(true_freq,width:shape,mul:amp), WhiteNoise.ar(mul:amp)]);
    source;
};

~subtractor = {
    arg in, out = 0, freq = 220, gate = 1,
    attack = 0.5, decay = 0.5, sustain = 0.5, release = 0.5,
    cutoff = 1000;

    var source, env;

	env = EnvGen.kr(Env.adsr(attack,decay,sustain,release));//, gate: gate, doneAction: 2);
    source = in*env;
    source = LPF.ar(source, freq=cutoff);
	[source]!2 * env;
};
)
MIDIIn.connectAll
(
MIDIIn.connectAll;
~keys = (0..127).collect({
	nil;
});

)

x = {~oscz.value()}.play;

(
MIDIdef.freeAll;
MIDIdef(\noteOn, {
	arg a, b, c, d;
	[a,b,c,d].postln;
	~keys[b] = {~subtractor.(~oscz.(freq: b.midiratio, oscType: 1, sustain: 1), sustain: 1)}.play;
}, msgType: \noteOn);

MIDIdef(\noteOff, {
	arg a, b, c, d;
	[a,b,c,d].postln;
	~keys[b].release;
}, msgType: \noteOff);
)
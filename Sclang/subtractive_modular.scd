(
SynthDef.new(\oscz, {
    arg freq = 20, out=0, amp=0.2, gate = 1,
    attack = 0.5, decay = 0.5, sustain = 0.5, release = 0.5, coarse = 0, fine = 0,
    oscType = 0, shape = 0.5; // Osctypes: sin, triangle, saw, square, noise
    var source, env, true_freq;
    env = EnvGen.kr(Env.adsr(attack,decay,sustain,release), gate: gate, doneAction: 2);
    true_freq = freq*coarse.midiratio + fine;
    source = Select.ar(oscType,[SinOsc.ar(true_freq,mul:amp), LFTri.ar(true_freq,mul:amp), Saw.ar(true_freq,mul:amp), Pulse.ar(true_freq,width:shape,mul:amp), WhiteNoise.ar(mul:amp)]);
    Out.ar(out, [source]);
}).add;
)

(
SynthDef.new(\subtractor, {
    arg in, out = 0, freq = 220, gate = 1,
    attack = 0.5, decay = 0.5, sustain = 0.5, release = 0.5,
    cutoff = 1000;

    var source, env;

	env = EnvGen.kr(Env.adsr(attack,decay,sustain,release), gate: gate, doneAction: 2);
    source = In.ar(in)*env;
    source = LPF.ar(source, freq=cutoff);
    Out.ar(out, source!2);
}).add;
)

(
~keys = (0..127).collect({
	Group.new()
});
~b1 = Bus.audio(s, 1);
~b2 = Bus.audio(s, 2);
)

MIDIIn.connectAll;
(
MIDIdef.freeAll;
MIDIdef(\noteOn, {
	arg a, b, c, d;
	[a,b,c,d].postln;
	Synth.tail(~keys[b], \oscz, [\out, ~b1]);
	Synth.tail(~keys[b],\oscz, [\out, ~b1, \fine, 2]);
	Synth.tail(~keys[b], \subtractor, [\in,~b1, \out, 0]);
	~keys[b].set(\freq, b.midiratio, \attack,1, \decay,0.1, \sustain,0.5, \release,2, \amp, 0.5);
}, msgType: \noteOn);

MIDIdef(\noteOff, {
	arg a, b, c, d;
	[a,b,c,d].postln;
	~keys[b].set(\gate, 0);
}, msgType: \noteOff);
)
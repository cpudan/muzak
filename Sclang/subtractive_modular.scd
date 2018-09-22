(
SynthDef.new(\oscz, {
    arg freq = 20, out=0, amp=0.2, gate = 1,
    attack = 0.5, decay = 0.5, sustain = 0.5, release = 0.5, coarse = 0, fine = 0,
    oscType = 0, shape = 0.5; // Osctypes: sin, triangle, saw, square, noise
    var source, env, true_freq;
    env = EnvGen.kr(Env.adsr(attack,decay,sustain,release), gate: gate, doneAction: 2);
    true_freq = freq*coarse.midiratio + fine;
    source = Select.ar(oscType,[SinOsc.ar(true_freq,mul:amp), LFTri.ar(true_freq,mul:amp), Saw.ar(true_freq,mul:amp), Pulse.ar(true_freq,width:shape,mul:amp), WhiteNoise.ar(mul:amp)]);
	Out.ar(out, [source])
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
g = Group.new;
// z = Group.after(g);
~b1 = Bus.audio(s, 1);
~b2 = Bus.audio(s, 2);
)

(
~noise = 0;
~osc1 = Synth.tail(g, \oscz, [\out, ~b1]);
~osc2 = Synth.tail(g,\oscz, [\out, ~b1, \fine, 2]);
Synth.tail(g, \subtractor, [\in,~b1, \out, 0]);
g.set(\freq, 220, \attack,1, \decay,0.1, \sustain,0.5, \release,2);
)

g.set(\oscType,3);
~osc1.set(\oscType,1);
g.set(\cutoff,400);
~osc1.set(\coarse, 7);
~osc1.set(\fine, 0)

g.set(\freq,100);
g.set(\gate, 0);


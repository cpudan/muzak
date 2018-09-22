(
SynthDef.new(\oscz, {
    arg freq = 20, out=0, amp=0.2, gate = 1,
    attack = 0.5, decay = 0.5, sustain = 0.5, release = 0.5, coarse = 0, fine = 0;
    var source, env;
    env = EnvGen.kr(Env.adsr(attack,decay,sustain,release), gate: gate, doneAction: 2);
    source = Saw.ar(freq*coarse.midiratio + fine,mul:amp);
	Out.ar(out, [source])
}).add;
)
(
SynthDef.new(\subtractor, {
    arg in, out = 0, freq = 220, gate = 1,
    attack = 0.5, decay = 0.5, sustain = 0.5, release = 0.5,
    cutoff = 100;

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
Synth.tail(g, \oscz, [\out, ~b1]);
Synth.tail(g,\oscz, [\out, ~b1, \fine, 2]);
Synth.tail(g, \subtractor, [\in,~b1, \out, 0]);
g.set(\freq, 220, \attack,1, \decay,0.1, \sustain,0.5, \release,2);
)
g.set(\cutoff,900)
g.set(\freq,40);
g.set(\gate, 0);


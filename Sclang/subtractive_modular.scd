s.options.numOutputBusChannels = 8

(
SynthDef.new(\oscz, {
    arg freq = 20, out=0, amp=1, gate = 1;
    var source, env;
    source = SinOsc.ar(freq, amp);
	Out.ar(out, [source])
}).add;
)
(
SynthDef.new(\subtractor, {
    arg in_1, in_2, out = 0, gate = 1;

    var source, env;
	env = EnvGen.kr(Env.adsr, gate: gate, doneAction: 2);
	source = In.ar([in_1, in_2], 2);
    Out.ar(out, source*env);
}).add;
)

(
~b0 = Bus.audio(s, 2);
~b1 = Bus.audio(s, 1);
~b2 = Bus.audio(s, 1);
)

(
g = Group.new;
// z = Group.after(g);

Synth.head(g, \oscz, [\out, ~b1]);
Synth.head(g,\oscz, [\out, ~b2]);
g.set(\freq, 220);
Synth.tail(g, \subtractor,[\in_1, ~b1, \in_2, ~b2, \out, 0]);
)

g.set(\gate, 0);

x = Synth(\subtractor, args:[\i_coarse, #[-12], \i_fine, #[0]])

b = 5;

((1..b).collect({
    arg i;
    i.postln;
    i.midiratio.postln;
});)

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
    arg in_1, in_2, out = 0, freq = 220, gate = 1;

    var source, env;
	env = EnvGen.kr(Env.new([0,1,0.5,0], [1,1,1]), gate: gate, doneAction: 2);
	source = In.ar([in_1, in_2]*env, 2);
    Out.ar(out, source);
}).add;
)

(
g = Group.new;
// z = Group.after(g);
~b1 = Bus.audio(s, 1);
~b2 = Bus.audio(s, 2);
Synth.tail(g, \oscz, out: ~b1);
Synth.tail(g,\oscz, out: ~b2);
Synth.tail(g, \subtractor, out: 0);
g.set(\freq, 220);
)

g.set(\gate, 0);

x = Synth(\subtractor, args:[\i_coarse, #[-12], \i_fine, #[0]])

b = 5;

((1..b).collect({
    arg i;
    i.postln;
    i.midiratio.postln;
});)

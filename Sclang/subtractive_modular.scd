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
~keys = (0..127).collect({
	Group.new()
});
~b1 = Bus.audio(s, 1);
~b2 = Bus.audio(s, 2);
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
g.set(\freq, 220, \attack,1, \decay,0.1, \sustain,0.5, \release,2, \amp, 0.5);
)
g.set(\cutoff,900)
g.set(\freq,40);
g.set(\gate, 0);

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

MIDIIn.connectAll;
MIDIdef.cc(\test1, {arg ...args; args.postln}, 1); // match cc 1
MIDIdef.cc(\test2, {arg ...args; args.postln}, 1, 1); // match cc1, chan 1
MIDIdef.cc(\test3, {arg ...args; args.postln}, (1..10)); // match cc 1-10
MIDIdef.noteOn(\test4, {arg ...args;
	args.postln}
); // match any noteOn

MIDIdef.freeAll
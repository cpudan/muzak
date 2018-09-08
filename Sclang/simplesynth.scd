s.boot();

SynthDef.new(\NO, {
	arg out = 0, freq = 220, gate = 1;
	var source = SinOsc.ar(freq);
	source = source * EnvGen.kr(Env.new(), gate, doneAction: 2);
	Out.ar(out, source);
}).add;

OSCdef(\Noo, {
	arg msg, time, addr, port;
	msg.postln;
	Synth(\NO);
}, '/chat');

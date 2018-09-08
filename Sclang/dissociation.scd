/*
    Repression of soul.
    The spirit tries to escape but the mind shuts it out.
*/


(
// Setup of the soul
// Want to set up as a constant pattern running on its own buffer
// Low percussive booms with a tight envelope.
SynthDef(\soulsynth, {
    arg out=0, freq=220, amp=0.1, pan=0, gate=1;
    var source, env;
    // 3 oscillators. Slightly out of phase. 0.1 Hz apart
    source = [0,2,4].collect({arg m;
        SinOsc.ar(freq + SinOsc.ar(200, mul: 10), phase: m)
    });
	env = EnvGen.kr(Env.linen(0.02,0.2,0.08), doneAction: 2);
    source = Mix(source);
	source = [source, LPF18.ar(source, 200, 0.75)];
    Out.ar([0,1], source*env);
}).add;
Pdef(\soul,
	Pbind(
		\instrument, \soulsynth,
		\degree, Pseq([0, 0, 4, 4, 5, 5, 4, 2, 2, 2, 1, 1, 1,0], inf),
		\mtranspose, -18,
		\dur, Pseq(#[0.2], inf)
	)
);
)

Pdef(\soul, \dur)
(
    var freq;
    freq = 220;
    x = [2,3,4].collect({arg m; SinOsc.ar(freq*m);});
)
{Mix([2,3,4].collect({arg m; SinOsc.ar(100*m);}))!2}.play;

z.stop()

s.boot;

Pdef(\soul).play;
Pdef(\soul).stop;

Synth(\soulsynth)


// Want the mind to be in control.
// Running on a buffer that's always going to output.
// Not sure how to implement

/*
    Repression of soul.
    The spirit tries to escape but the mind shuts it out.
*/


(
// Setup of the soul
// Want to set up as a constant pattern running on its own buffer
// Low percussive booms with a tight envelope.
SynthDef(\soulsynth, {
    arg out=0, freq=220, amp=0.1, pan=0, gate=1,
	augg = 0.08, color = 100;
    var source, env;
    // 3 oscillators. Slightly out of phase. 0.1 Hz apart
    source = [0,2,4].collect({arg m;
        SinOsc.ar(freq + SinOsc.ar(200, mul: 10), phase: m)
    });
	env = EnvGen.kr(Env.linen(0.02,0.2,0.08), doneAction: 2);
    source = Mix(source);
	source = source * Saw.ar(freq, mul: source*Pulse.ar(freq*color*augg, 0.5, 8));
	source = [source]!2;
	source = LPF.ar(source, 440, 3);
    Out.ar([0,1], source*env);
}).add;
Pdef(\soul,
	Pbind(
		\instrument, \soulsynth,
		\degree, Pseq([0, 4, 5, 4, 2, 1], inf),
		\mtranspose, Pseq([Pseq([-12], 18), Pseq([Pseq([-12], 8),Pseq([-16], 3)], 5)], 1),
		\aug, Pseq([0.04, 0.01, 0.1, 0.02, 0.04], inf),
		\dur, Pseq(#[0.2, 0.3, 0.2], inf),
		\color, Pseq([Pseq([100], 2), Pseq([25], 2), Pseq([50], 1)], inf)
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

Pdef(\soul).play();
Pdef(\soul).stop();

Synth(\soulsynth)


// Want the mind to be in control.
// Running on a buffer that's always going to output.
// Not sure how to implement

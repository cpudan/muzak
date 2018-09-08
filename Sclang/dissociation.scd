/*
    Repression of soul.
    The spirit tries to escape but the mind shuts it out.
*/


(
// Setup of the soul
// Want to set up as a constant pattern running on its own buffer
SynthDef(\soulsynth, {
	arg out=0, freq=220, amp=0.1, pan=0, gate=1;
	// var source =
}).add;
Pdef(\soul,
	Pbind(
		\degree, Pseq(#[0, 0, 4, 4, 5, 5, 4, 3, 3, 2, 2, 1, 1, 0], 1),
		\dur, 0.05
	)
);
Pdef(\soul).play;
)
Pdef(\soul).stop;


// Want the mind to be in control.
// Running on a buffer that's always going to output.
// Not sure how to implement
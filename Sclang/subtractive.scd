(
SynthDef.new(\subtractor, {
    arg out = 0, freq = 220,
    // Coarse adjustment expects number of half-steps from freq
    i_coarse = #[0,0,0,0,0,0],
    // Fine adjustment expects offset in number of hz
    i_fine = #[0,0,0,0,0,0,0],
    // options: sin, saw, square, triangle
	shape = \sin,
    gate = 1;

    var source, env, n_osc;

    n_osc = i_coarse.size;

    env = EnvGen.kr(Env.new(), gate: gate, doneAction:2);
    source = (0..n_osc-1).collect({
        arg i, coarse = i_coarse[i], fine = i_fine[i];
		switch(shape,
			'sin', SinOsc.ar(freq + freq* coarse.midiratio + fine) * env,
			'saw', Saw.ar(freq + freq* coarse.midiratio + fine) * env
		);
    });

    source = [Mix(source)]!2;

    Out.ar(out, source);
}).add;
)

x = Synth(\subtractor, args:[\i_coarse, #[-12], \i_fine, #[0]])

b = 5;

((1..b).collect({
    arg i;
    i.postln;
    i.midiratio.postln;
});)
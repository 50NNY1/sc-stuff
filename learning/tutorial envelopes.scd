//simple env example, doesn't free resource
(
x = {
	var sig, env;
	env = Line.kr(1, 0, 0.25, doneAction:2);
	sig = Pulse.ar(ExpRand(30, 500)) * env;
}.play;
)

//with proper env function
(
y = {
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0, 1, 0.3, 0],
		[0.1, 0.5, 0.2],
		[0, -2, 5]), doneAction:2);
	sig = Pulse.ar(ExpRand(30,500)) * env;
}.play;
)


Env.new([0, 1, 0.3, 0],[0.1, 0.5, 0.2],[0, -2, 5], doneAction:2).plot;

//better, adsr.
(
z = {
	var sig, env;
	env = EnvGen.kr(Env.adsr(1,0.25,0,0), doneAction:2);
	sig = VarSaw.ar(Rand(200,8000)) * env;
}.play;
)

Env.adsr(1,0.25,0,0).plot
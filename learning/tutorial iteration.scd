// use of arg count and item in sc

(
x = Array.newClear(5);
[3,7,34,59,2.6].do{
	arg item, count; // HAS TO BE IN THIS ORDER??
	x[count] = item.squared;
}
)

// or more brief
(
z = [3,7,34,59,2.6].collect{
	arg item;
	item.squared;
}
)

z = [3,7,34,59,2.6].collect(_.squared)

//synth demo
(
SynthDef.new(\iter, {
	arg freq=40;
	var temp, sum, env;
	sum = 0;
	env = EnvGen.kr(
		Env.perc(0.01, 5, 1, -2),
		doneAction:2
	);
	10.do{
		temp = VarSaw.ar(
			freq * {Rand(0.99,1.02)}!2,
			{Rand(0.0, 1.0)}!2,
			{ExpRand(0.005, 0.05)}!2
		);
		sum = sum + temp;
	};
	sum = sum * 0.05 * env;
	Out.ar(0, sum);
}).add;
)

(
[66, 73, 80, 75].do{
	arg item;
	Synth.new(\iter, [\freq, item.midicps])
}
)

//another synth demo
(
SynthDef.new(\iter2, {
	arg freq = 200, vol = 1;
	var temp, sum;
	sum = 0;
	30.do{
		arg count;
		temp = SinOsc.ar(freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(0.98, 1.02)
		);
		temp = temp * LFNoise1.kr({Rand(0.5,8)}!2).exprange(0.01,1);
		sum = sum + temp;
	};
	sum = sum * 0.05 * vol;
	Out.ar(0, sum);
}).add;
)

(
~names = Array.newClear(3);
{
var scale = Scale.major.degrees;
var root = scale.choose;
[1, 2, 5].do{
	arg item, count;
	var note = (scale.wrapAt(root + item)) * 4;
	note.postln;
	~names[count] = Synth.new(\iter2, [\freq, note.midicps, \vol, {ExpRand(0.0, 1.0)}])
}
}.play;
)

~names[0].set(\freq, 51.midicps)
~names



x = {Blip.ar(200, 10, 0.5)}.play;
x.free;
s.plotTree;
dei


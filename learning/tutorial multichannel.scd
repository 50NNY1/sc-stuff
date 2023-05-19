// two array of ugens in function == stereo
x = {[SinOsc.ar(220), SinOsc.ar(330)]}.play;

x = {SinOsc.ar([220,330])}.play;

//using arrays like this in ugens works like this
(
x = {
	var sig, amp;
	amp = SinOsc.kr([7,1]).range(0, 1);
	sig = SinOsc.ar([220,330]);
	sig = sig * amp;
}.play;
)


/* Mix if using more than one channel.
note: can do !2 to duplicate objects
also we can just define shit in a synthdef to avoid all this,
cos Out.ar() does most of this 4 us. I think splay does something similar
though
*/
(
x = {
	var sig, amp;
	amp = SinOsc.kr([7, 4, 5, 0.2, 19]).range(0,1);
	sig = SinOsc.ar([220, 330, 500, 650, 850]);
	sig = sig * amp;
	//or could do Splay.ar(sig)
	Mix.new(sig)!2 * 0.1
}.play;
)

// example, use ! syntax to reiterate ugens
(
SynthDef.new(\multi, {
	var sig, amp;
	//iterate function
	amp = SinOsc.kr({exprand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({exprand(50,1200)}!8);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);
}).add;
)

(
var expRand1 = { ExpRand(1, 20) };
var expRand2 = { 12000 };
SynthDef.new(\stochHarm, {
	arg fund=220;
	var sig, amp;
	sig = SinOsc.ar({fund * ExpRand(1, 10)}!8);
	amp = LFNoise0.kr({ExpRand(0.2,12)}!8).range(0,1);
	sig = sig * amp;
	sig = FreeVerb.ar(sig, 0.2);
	sig = Splay.ar(sig) * 0.2;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\multi);
x = Synth.new(\stochHarm, [\fund, 80]);

{SinOsc.ar(440) / 3}.play;
s.freeAll;
s.quit

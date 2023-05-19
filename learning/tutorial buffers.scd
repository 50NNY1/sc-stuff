// working with different devices
Server.default.options.inDevice_(ServerOptions.devices[3])
Server.default.options.outDevice_(ServerOptions.devices[1])

//loading file into buffer
~b0 = Buffer.read(s, "/Users/sonnyholland/Documents/samples/imago meri/imago meri - piano (with velt)/kalimba+/kalimbaTexture3 @imagomeri - piano (with velt).wav")
~b0.play;

~b1 = Buffer.read(s, "/Users/sonnyholland/Documents/samples/imago meri/imago meri - piano (with velt)/velt/texture Bmaj @imagomeri - piano (with velt).wav")

//buffers for a whole repository
~kalimba = Array.new;
~folder = PathName.new("/Users/sonnyholland/Documents/samples/imago meri/imago meri - piano (with velt)/kalimba+/");

(
~folder.entries.do({
	arg path;
	~kalimba = ~kalimba.add(Buffer.read(s, path.fullPath))
});
)

~kalimba[3].play;

//SynthDef with buffers
(
SynthDef.new(\playbuf_test, {
	arg amp=1, out=0, buf, rate=1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, doneAction:2, loop:1);
	//check safety net with bufratescale, it protects from weird sample rates
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\playbuf_test, [\buf, ~kalimba[2], \rate, 0.5])

// use a group.

(
g = Group.new;
x = Synth.new(\playbuf_test, [\buf, ~kalimba[3], \rate, 1.5, \amp, 0.5], g);
y = Synth.new(\playbuf_test, [\buf, ~kalimba[2], \rate, 0.5, \amp, 0.5], g);
z = Synth.new(\playbuf_test, [\buf, ~kalimba[8], \rate, 0.25, \amp, 0.5], g);
)

//control ugens in group all together
g.set(\rate, 0.5);

//BUF RD - no looping
(
SynthDef.new(\bufrd, {
	arg amp=1, out=0, buf, start, end;
	var sig, ptr;
	ptr = Line.ar(start, end, BufDur.kr(buf), doneAction:2);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\bufrd, [\buf, ~kalimba[0], \start, ~kalimba[0].numFrames - 1, \end, 0]);

// w/ phasor so we can loop
(
SynthDef.new(\phasor_BufRD, {
	arg amp=1, out=0, buf, start, end, rate=1;
	var sig, ptr;
	ptr = Phasor.ar(0, BufRateScale.kr(buf) * rate, start, end); //note use .ar
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)
x = Synth.new(\phasor_BufRD, [\buf, ~kalimba[0], \start, 0, \end, ~kalimba[0].numFrames - 1, \rate, 0.25])

//could be cool to use a sine here to make shit go back and forth
(
SynthDef.new(\sineBufRd, {
	arg amp=1, out=0, buf, start, end, freq=1;
	var sig, ptr;
	ptr = SinOsc.ar(freq, 3pi/2).range(start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\sineBufRd, [\buf, ~kalimba[3], \start, 0, \end, ~kalimba[10].numFrames - 1, \freq, 0.1])


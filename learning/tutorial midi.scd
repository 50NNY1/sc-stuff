//instantiate shit
MIDIClient.init;
MIDIClient.destinations;
m = MIDIOut.new(0);

m.latency = 0;
m.noteOn(0,60,30);
m.noteOff(0, 60);

//short sequence
(
Routine({
	[35,49,56,63,66,73].reverse.do{
		arg nn;
		m.noteOn(0, nn, 25);
		0.5.wait;
	};
}).play;
)

(
Routine({
	[35,49,56,63,66,73].do{
		arg nn;
		m.noteOff(0, nn, 25);
		0.5.wait;
	};
}).play;
)
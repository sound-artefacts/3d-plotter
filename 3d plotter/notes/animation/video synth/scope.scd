(
~f = 48000 / 1024;
s.options.numWireBufs = 1024;
s.waitForBoot {
	var win, buf, sf;
	win = Window.new.bounds_(Rect(10,200,800,800));
	buf = Buffer.alloc(s, 512, 2);
	sf = { ScopeOut2.ar(In.ar(0,2), buf.bufnum, 2048, 2048) };
	s.sync;
	~scope = ScopeView.new(win, 800@800);
	~scope.bufnum = buf.bufnum;
	~scope.server = s;
	~scope.start;
	~scope.style = 2;
	~scope.background = Color.green;
	~scope.waveColors = [Color.white];
	s.sync;
	win.front;
	win.alwaysOnTop = true;
	sf.play(addAction:\addToTail);
	CmdPeriod.add { sf.play(addAction:\addToTail) };
	s.sync;
};
)


(
var f1=6,f2=8,f3=9,f4=12;

{Out.ar(0,Pan2.ar(SinOsc.ar(55*f1,phase:0.degrad,mul:f1.reciprocal),1))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55*f2,phase:0.degrad,mul:f2.reciprocal),1))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55*f3,phase:0.degrad,mul:f3.reciprocal),1))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55*f4,phase:0.degrad,mul:f4.reciprocal),1))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55.01*f1,phase:90.degrad,mul:f1.reciprocal),1.neg))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55.01*f2,phase:90.degrad,mul:f2.reciprocal),1.neg))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55.01*f3,phase:90.degrad,mul:f3.reciprocal),1.neg))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55.01*f4,phase:90.degrad,mul:f4.reciprocal),1.neg))}.play;
)

(
var f1=6,f2=8,f3=9,f4=12;

{Out.ar(0,Pan2.ar(SinOsc.ar(55*f1,phase:0.degrad,mul:f1.reciprocal),SinOsc.kr(0.1,0.degrad)))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55*f2,phase:0.degrad,mul:f2.reciprocal),SinOsc.kr(0.1,0.degrad)))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55*f3,phase:0.degrad,mul:f3.reciprocal),SinOsc.kr(0.1,0.degrad)))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55*f4,phase:0.degrad,mul:f4.reciprocal),SinOsc.kr(0.1,0.degrad)))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55.01*f1,phase:90.degrad,mul:f1.reciprocal),SinOsc.kr(0.1,90.degrad)))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55.01*f2,phase:90.degrad,mul:f2.reciprocal),SinOsc.kr(0.1,90.degrad)))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55.01*f3,phase:90.degrad,mul:f3.reciprocal),SinOsc.kr(0.1,90.degrad)))}.play;
{Out.ar(0,Pan2.ar(SinOsc.ar(55*f4,phase:90.degrad,mul:f4.reciprocal),SinOsc.kr(0.1,90.degrad)))}.play;
)

(


{Out.ar(0,SinOsc.ar(55,phase:0.degrad,mul:MouseX.kr(0.1,1)))}.play;
{Out.ar(1,SinOsc.ar(55,phase:90.degrad,mul:MouseY.kr(0.1,1)))}.play;
)

(
~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/uni/ksyme:cmrc/final/endfile/BWATVFBP9.wav",channels:0);
~c2 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/uni/ksyme:cmrc/final/endfile/BWATVFBP9.wav",channels:1);
)
(
	{Out.ar(0,PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:2))}.play;
	{Out.ar(1,PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:2))}.play;
)
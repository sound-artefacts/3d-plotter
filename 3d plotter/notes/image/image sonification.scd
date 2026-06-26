
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*32;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
//s.boot;
s.makeGui(w);
s.meter;
s.freqscope;
s.scope;

s.waitForBoot{

Buffer.freeAll;


/*(
var img = Image.open("/Users/amimid/Desktop/image1.jpg");
var width = img.width;
var height = img.height;
var color = img.getColor(0, 0).postln; // returns a Color object
width.postln;
height.postln;
//[color.red, color.green, color.blue].postln;
)*/

(
var img,c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;
img = Image.open("/Users/amimid/Desktop/image1.jpg");
~cx=[]; ~cy=[];  ~cz=[];

	img.height.do {
				img.width.do {
         color = img.getColor(xx, yy);
	[color.red, color.green, color.blue].postln;
			r=r++color.red;
			g=g++color.green;
         	b=b++color.blue;
xx=xx+1;
				};
				xx=0;
				yy=yy+1;
    };
			r=r+0.0001;  g=g+0.0001;  b=b+0.0001;

        ~cx=~cx++r;
		~cy=~cy++g;
		~cz=~cz++b;

)

(
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
////// wavetables

		//oscillator table
		(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(pi/496)); ~ph=992.collect{~n=~n+(pi/496);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);


		(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w1.loadCollection(wt);
//signal.plot;
		}.value;
);
);
		////sound

(
SynthDef.new(\synth,{
var fund,fu=256,n=0,sc=16256*2,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,threshold1,threshold2,threshold3,sig1,sig2,sig3;
var control1,control2,control3,b,b_x,b_y,b_z,polytope,mp;

fund=fu*(9/8);

	(20*20).do{
polytope=Cartesian(~cx.[n],~cy.[n],~cz.[n]);
mp=Spherical(sc,polytope.theta,  polytope.phi);
b_x=2.pow(mp.x.round(1) /16256);
b_y=2.pow(mp.y.round(1) /16256);
b_z=2.pow(mp.z.round(1) /16256);
mod_x=polytope.x;
mod_y=polytope.y;
mod_z=polytope.z;
phasex=(Complex(1,mod_x).theta*4);
phasey=(Complex(1,mod_y).theta*4);
phasez=(Complex(1,mod_z).theta*2);
freq1=(fund)*b_x;
freq2=(fund)*b_y;
freq3=(fund)*b_z;
amp1=b_x.reciprocal;
amp2=b_y.reciprocal;
amp3=b_z.reciprocal;

control1=SinOsc.ar(freq1,phase:phasex,mul:amp1);
control2=SinOsc.ar(freq2,phase:phasey,mul:amp2);
control3=SinOsc.ar(freq3,phase:phasez,mul:amp3);
sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:100).abs*
SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low/992),amp1));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:100).abs*
SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag/992),amp2));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:100).abs*
SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag/992),amp3));

threshold1=(((343/0.1)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.1)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.1)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=HPF.ar(sig1,50);sig2=HPF.ar(sig2, 50);sig3=HPF.ar(sig3, 50);
sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15);
sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15);
sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15);
Out.ar(0,sig1);Out.ar(1,sig2);Out.ar(0,sig3!2);
n=n+1;
				};

}).add;)
	30.wait;

	~synth=Synth.new(\synth);

}
)
//s.record(numChannels:2)


////durs
	/*	(
~azz=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~ell=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);

	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;

			~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];
			~r1=0; ~r2=0; ~r3=0;

					1.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~azz.[m1],~ell.[m1]).rotate(~r1).tilt(~r2).tumble(~r3).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~azz.[m2],~ell.[m2]).rotate(~r1).tilt(~r2).tumble(~r3).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~azz.[m3],~ell.[m3]).rotate(~r1).tilt(~r2).tumble(~r3).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
			//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
			//	~durz = ~dur3.collect { |x| if (x == 0) { Rest(2) } { x }};

			~dur=~dur++~dur1++~dur2++~dur3;

}.value;
);
*/
		////////2////sequencer
		/*(

			~seq1= Pseq(~dur, inf).asStream;
				~seq2 = Pseq(~dur2, inf).asStream;
				~seq3 = Pseq(~dur3, inf).asStream;
		//~system= Pseq(~r,inf).asStream;
			~tonb=0;
			~panwidth=1;
			~pass=992*1;
			~drive=992*2;
			~mox=0.7;
			~gg=1;
			~pon=0.01;
			~sphpan=(992*32).neg;
			~bband=(992*16).neg;
			~drn=0.1;
	~od=5.neg;
	~rev=0.8;
		//	thisThread.randSeed = 123;

~r1 = Routine({
    var i,m,l=0;
    60.do{
					//	thisThread.randSeed = ~val.asInteger;
							TempoClock.default.tempo_(1);

	~synth=Synth.new(\synth,[\gain,~gg,\drive,~drive,\fu,16,\sc,14,\low,~pass,\pan,~bband,\mix,~mox,\room,~rev,\pann,~sphpan,\x,2,\a,1,\spread,~panwidth,\pon,~pon,\pneuma,0,\namp,1,\drone,~od,\panx,0,
				\pany,0.1,\panz,0.1,\dron,~tonb,\mm,l]).register;

l=l+7;
      //  ~seq1.next.wait;
			(1).wait;

    }
		});


		)*/;


	~r1.play;
s.record;

	~r1.stop;



		TempoClock.default.tempo_(1/1);









/*
/tetrahedron
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
//////cube
(
~az=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////octahedron

(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////icosahedron
(
~az=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~el=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////dodecahedron

(
~az=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~el=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////Rhombic dodecahedron//// hull

(
~az=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~el=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////cuboctahedron//// core

(
~az=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~el=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)


///////////////Rhombic Triacontahedron//// hull
(
~az=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~el=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////icosidodecahedron//// core
(
~az=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~el=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)*/


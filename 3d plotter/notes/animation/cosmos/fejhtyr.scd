

(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*16;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);

//
(
s.waitForBoot{
//s.freqscope;
//s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	//Buffer.freeAll;


		///octahedron
	//	(
//~azz=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
//~ell=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
//);

			//tetr
		(
~azz=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~ell=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

				///vbap
/*(
~a = VBAPSpeakerArray.new(3,
[[~azz.[0],~ell.[0]], [~azz.[1],~ell.[1]], [~azz.[2],~ell.[2]], [~azz.[3],~ell.[3]],[~azz.[4],~el.[4]],[~azz.[5],~ell.[5]]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);*/

/////tetrahedron
		/*(
~a = VBAPSpeakerArray .new3,(
[[45.degrad,35.264390.neg.degrad], [135.neg.degrad,35.264390.neg.degrad], [45.neg.degrad,35.264390.degrad], [135.degrad,35.264390.degrad]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);*/


////sesor based randomnes
		// SerialPort.devices;
		// ~port = SerialPort.new("/dev/cu.usbserial-2240",9600);
		//
		// (
		// 	~charArray = [];
		// 	~getValues = Routine.new({
		//
		// 		var ascii;
		// 		{ascii = ~port.read.asAscii;
		// 			if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		// 			if(ascii == $a,{~val = ~charArray.collect(_.digit).convertDigits;
		// 				~charArray =[];
		// 			});
		// 		}.loop;
		//
		// 	}).play;
		// );


		///////L-system
	(
{
var dict = IdentityDictionary[\A -> "AB", \B -> "A"];
//These are the production rules of the L-system
var word = "A";
var string_temp = "";
var iter = 9;

//These are diction for the mapping of the alphabet to "artistic" parameters: degrees in a scale, beat occurrence, etc.

var dictnotes = IdentityDictionary[\A -> 0.5, \B -> 1];
 ~r=[];

//This iteration generates the system recursively

iter.do({

word.asArray.do({|i|
    string_temp = string_temp ++ dict[i.asSymbol];
});

word = string_temp;
	string_temp = "";
});

word.postln;

//Here we map the final system to the parameters as above

word.do({|i| ~r = ~r ++ dictnotes[i.asSymbol];});

~r.postln;
}.value
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


		/////scales

(
			{
				var nn=1.neg;
		~scalee=10.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
			}.value;
		);

		(
			{
				var nn=1.neg;
		~scaleee=10.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
			}.value;
		);

		~sc=[~scalee,~scaleee];
		////sound

(
SynthDef.new(\synth,{

	arg gain=1,low=992,tone1=0,tone2=0,tone3=0,x=1,pan=1,mix=0.3,a=1,panx=1,pany=1,panz=1,room=0.5,m=2,pon=1,
				fu=32,drive=1,spread=1,drone_amp=1,pann=0,az=0,el=0,azr=0,dron=0,drone=1,theta=0,rx=0,ry=0,rz=0,
				pneuma1=0,pneuma2=0,pneuma3=0,namp1=1,namp2=1,namp3=1,qq=0.0000001,qqq=0,spirit=0,
				attack=0.01,decay=4,curve=2.neg,gate=1,xx=1,yy=1,zz=1;

	var rq=1,cloud=5,band,azf=0,elf=0,q,r1,r2,r3,sq1,sq2,sq3,rotationx,rotationy,rotationz,core=(9/8).rand;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,bank=6,out1,out2,band_osc1,band_osc2,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var band_osc3,band_osc4,band_osc5,band_osc6,sig3,out3,cell_tria,b_x,b_y,b_z,polytope,gain1,gain2,gain3,env,azimuth,elevation;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez,phasex,phasey,phasez,rq1,rq2,rq3,rq4,rq5,rq6;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,mq,lfo,sph;
	var loc1,loc2,loc3,g=((1+5.sqrt)/2),s=(1+2.sqrt),tensor,dr;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,cx,cy,cz;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3,sph_object,lfon,axis;
	var r_axis, r_v, r, axisr,spr,rot,i,j,k,level=200,spx,spy,spz;
	var g_ch1,g_ch2,g_ch3,g_ch4,chan=~chan;
	var gn ,g_sum,g_avg ,ton1,ton2,ton3,laxis,sp,spl,g11,g22,g33,g44;
	var pon1,pon2,pon3,pon4,tonality;

fund=fu*(9/8);
lamdoma=(x.lag(0.01)+a.lag(0.01))/x.lag(0.01);


				tonality=Spherical(5,az.lag(0.01),el.lag(0.01));
//ton1=2.pow(tone1.lag(0.01) /992).round(0.0001)*2.pow(dron.lag(0.01)/992);
//ton2=2.pow(tone2.lag(0.01)/992).round(0.0001)*2.pow(dron.lag(0.01)/992);
//ton3=2.pow(tone3.lag(0.01) /992).round(0.0001)*2.pow(dron.lag(0.01)/992);
		//		ton=2.pow((tone.lag(0.01))/56).round(0.0001)*2.pow(dron.lag(0.01)/56);

ton1=2.pow(Select.kr(tonality.x, Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);
ton2=2.pow(Select.kr(tonality.y, Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);
ton3=2.pow(Select.kr(tonality.z, Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);

	env=EnvGen.ar(Env.sine(decay),gate:gate,doneAction:2);
			//	env=1;

						lfo=2.pow(pan/992);
				lfon=2.pow(pann/992);
					band=pan;

				mq=(m.lag(0.01)+1);
	spr=Cartesian(xx.max(0.01).lag(0.01),yy.max(0.01).lag(0.01),zz.max(0.01).lag(0.01));

				sph_object=spr;



				axis=Spherical(992,(sph_object.theta+azf).wrap(pi,pi.neg),  (sph_object.phi+elf).wrap((pi/2),(pi/2).neg));

				polytope=Cartesian(axis.x,axis.y,axis.z);

b_x=2.pow(polytope.x.round(1) /992).round(0.0001)*lamdoma;
b_y=2.pow(polytope.y.round(1) /992).round(0.0001)*lamdoma;
b_z=2.pow(polytope.z.round(1) /992).round(0.0001)*lamdoma;


anglex=(exp(Complex(0,1)*polytope.theta).real*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
angley=(exp(Complex(0,1)*polytope.theta).imag*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
anglez=(exp(Complex(0,1)*polytope.phi).imag).round(0.00001);

phase1=(Complex(1,anglex).theta*4).wrap(2pi.neg,2pi);
phase2=(Complex(1,angley).theta*4).wrap(2pi.neg,2pi);
phase3=(Complex(1,anglez).theta*2).wrap(2pi.neg,2pi);


//mod_anglex=SinOsc.ar(lfon,phase1).range(pi.neg,pi).lag(0.01);
//mod_angley=SinOsc.ar(lfon,phase2).range(pi.neg,pi).lag(0.01);
//mod_anglez=SinOsc.ar(lfon,phase3).range(35.264390.degrad,35.264390.degrad.neg).lag(0.01);

mod_anglex=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase1,mul:level).abs*SinOsc.ar(lfon,phase:phase1)),lfon*2.pow(low.lag(0.01)/992),1).range(panx*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase1,mul:level).abs*SinOsc.ar(lfon/8,phase:phase1)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(pi.neg,pi).lag(0.01);

mod_angley=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase2,mul:level).abs*SinOsc.ar(lfon,phase:phase2)),lfon*2.pow(low.lag(0.01)/992),1).range(pany*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase2,mul:level).abs*SinOsc.ar(lfon/8,phase:phase2)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(pi.neg,pi).lag(0.01);

mod_anglez=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase3,mul:level).abs*SinOsc.ar(lfon,phase:phase3)),lfon*2.pow(low.lag(0.01)/992),1).range(panz*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase3,mul:level).abs*SinOsc.ar(lfon/8,phase:phase3)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(35.264390.degrad,35.264390.degrad.neg).lag(0.01);


					(
	magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((polytope.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magqx=(((Complex(cos(((polytope.theta+mod_anglex)*mq).wrap(pi.neg,pi)),cos(((polytope.theta+mod_anglex)*mq).round(0.00001).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt);



 magqy=((((Complex(sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi)),
sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));
	);

					mx=(Cartesian(magx,0,0).rho);
					my=(Cartesian(0,magy,0).rho);
					mz=(Cartesian(0,0,magz).rho);
					mag=(Cartesian(mx,my,mz)) ;

		sph=Spherical(mag.rho,polytope.theta,polytope.phi);

loc1=mx;  loc2=magy;  loc3=magz;

phasex=Complex(1,sph.x).theta*4;
phasey=Complex(1,sph.y).theta*4;
phasez=Complex(1,sph.z).theta*2;


freq1=(fund*ton1)*b_x.lag(0.01);
freq2=(fund*ton2)*b_y.lag(0.01);
freq3=(fund*ton3)*b_z.lag(0.01);

					dr=2.pow(drone.lag(0.1)/12);

f1=(fund*ton1)*b_x.lag(0.01)*dr;
f2=(fund*ton2)*b_y.lag(0.01)*dr;
f3=(fund*ton3)*b_z.lag(0.01)*dr;

amp1=ton1.reciprocal*b_x.reciprocal;
amp2=ton2.reciprocal*b_y.reciprocal;
amp3=ton3.reciprocal*b_z.reciprocal;

g1=b_x.reciprocal*dr.reciprocal*ton1.reciprocal;
g2=b_y.reciprocal*dr.reciprocal*ton2.reciprocal;
g3=b_z.reciprocal*dr.reciprocal*ton3.reciprocal;

band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex).exprange(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey).exprange(496,16256);
band_osc3=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez).exprange(496,16256);
band_osc4=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex.neg).exprange(496,16256);
band_osc5=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey.neg).exprange(496,16256);
band_osc6=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez.neg).exprange(496,16256);

rq1=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex,mul:rq).exprange(0.1,1)]);
rq2=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey,mul:rq).exprange(0.1,1)]);
rq3=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez,mul:rq).exprange(0.1,1)]);
rq4=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex.neg,mul:rq).exprange(0.1,1)]);
rq5=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey.neg,mul:rq).exprange(0.1,1)]);
rq6=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez.neg,mul:rq).exprange(0.1,1)]);


control1=SinOsc.ar(freq1,phase:phasex,mul:amp1);
control2=SinOsc.ar(freq2,phase:phasey,mul:amp2);
control3=SinOsc.ar(freq3,phase:phasez,mul:amp3);


				//rectifier mod
				/*(
ds1=((LPF.ar((Osc.ar(~w1.bufnum,f1,phase:phasex,mul:level).abs*
					SinOsc.ar(f1,phase:phasex)),f1*2.pow(low.lag(0.01)/992),g1)).range(panx*g1,g1)
					+BPF.ar(BrownNoise.ar(qq.sqrt.reciprocal),f1*dr,qq,g1/dr));
ds2=((LPF.ar((Osc.ar(~w1.bufnum,f2,phase:phasey,mul:level).abs*
					SinOsc.ar(f2,phase:phasey)),f2*2.pow(low.lag(0.01)/992),g2)).range(pany*g2,g2)
					+BPF.ar(BrownNoise.ar(qq.sqrt.reciprocal),f2*dr,qq,g2/dr));
ds3=((LPF.ar((Osc.ar(~w1.bufnum,f3,phase:phasez,mul:level).abs*
					SinOsc.ar(f3,phase:phasez)),f3*2.pow(low.lag(0.01)/992),g3)).range(panz*g3,g3)
					+BPF.ar(BrownNoise.ar(qq.sqrt.reciprocal),f3*dr,qq,g3/dr));
				)*/

				(
ds1=((LPF.ar((Osc.ar(~w1.bufnum,f1,phase:phasex,mul:level).abs*
					SinOsc.ar(f1,phase:phasex)),f1*2.pow(low.lag(0.01)/992),g1)).abs
					*BPF.ar(LPF.ar((SoundIn.ar(0,50)*qq.sqrt.reciprocal),fund*dr),f1*dr,qq,g1/dr));
ds2=((LPF.ar((Osc.ar(~w1.bufnum,f2,phase:phasey,mul:level).abs*
					SinOsc.ar(f2,phase:phasey)),f2*2.pow(low.lag(0.01)/992),g2)).abs
					*BPF.ar(LPF.ar((SoundIn.ar(0,50)*qq.sqrt.reciprocal),fund*dr),f2*dr,qq,g2/dr));
ds3=((LPF.ar((Osc.ar(~w1.bufnum,f3,phase:phasez,mul:level).abs*
					SinOsc.ar(f3,phase:phasez)),f3*2.pow(low.lag(0.01)/992),g3)).abs
					*BPF.ar(LPF.ar((SoundIn.ar(0,50)*qq.sqrt.reciprocal),fund*dr),f3*dr,qq,g3/dr));
				);

ds1 = (ds1*2.pow(drive/992)).softclip;
ds2 =  (ds2*2.pow(drive/992)).softclip;
ds3 =  (ds3*2.pow(drive/992)).softclip;

				//sig
sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.01)/992),amp1).abs*(ds1));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.01)/992),amp2).abs*(ds2));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:level).abs*SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag(0.01)/992),amp3).abs*(ds3));

	sig1=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq1),band_osc4.lag(0.1),rq4)]);
	sig2=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq2),band_osc5.lag(0.1),rq5)]);
	sig3=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig3,BPF.ar(BRF.ar(sig3,band_osc3.lag(0.1),rq3),band_osc6.lag(0.1),rq6)]);

sig1 = (sig1*2.pow(drive/992)).softclip;
sig2 =  (sig2*2.pow(drive/992)).softclip;
sig3 =  (sig3*2.pow(drive/992)).softclip;


threshold1=(((343/0.15)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.15)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.15)/fund).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,80);
		sig2=HPF.ar(sig2, 80);
		sig3=HPF.ar(sig3, 80);

		sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

	///final out

				gain1=gain*rq1.sqrt.reciprocal*cloud.reciprocal*10*env;
					gain2=gain*rq2.sqrt.reciprocal*cloud.reciprocal*10*env;
					gain3=gain*rq3.sqrt.reciprocal*cloud.reciprocal*10*env;
						cloud.do{

					//sp= LFNoise2.ar(6).range(spread*pi.neg, spread*pi);
					//spl= LFNoise2.ar(6).range(spread*(pi/2).neg, spread*(pi/2));
					sp=azf;
					spl=elf;

g_ch1 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[0],~el[0]).x) +
 (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[0],~el[0]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[0],~el[0]).z)
);

g_ch2 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[1],~el[1]).x)+
(Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[1],~el[1]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[1],~el[1]).z)
);

g_ch3 = (
  (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[2],~el[2]).x)+
   (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[2],~el[2]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[2],~el[2]).z)
);

g_ch4 = (
(Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[3],~el[3]).x) +
 (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[3],~el[3]).y)+
   (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[3],~el[3]).z)
					);

g_ch1 = g_ch1.pow(spread.reciprocal);
g_ch2 = g_ch2.pow(spread.reciprocal);
g_ch3 = g_ch3.pow(spread.reciprocal);
g_ch4 = g_ch4.pow(spread.reciprocal);

//pon1=SinOsc.ar(pon*lfon,0).range(0.0001,1).lag(0.1);
//pon2=SinOsc.ar(pon*lfon,0.25pi).range(0.0001,1).lag(0.1);
//pon3=SinOsc.ar(pon*lfon,0.5pi).range(0.0001,1).lag(0.1);
//pon4=SinOsc.ar(pon*lfon,0.75pi).range(0.0001,1).lag(0.1);

pon1=SinOsc.ar(pon*lfon,0);
pon2=SinOsc.ar(pon*lfon,90.degrad);
/*(
Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
	sig1* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01)/cloud);
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01)/cloud);
Out.ar(2,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01)/cloud);
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01)/cloud);

Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01)/cloud);
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01)/cloud);
Out.ar(2,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01)/cloud);
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01)/cloud);

Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01)/cloud);
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01)/cloud);
Out.ar(2,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01)/cloud);
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01)/cloud);
				)*/

					Out.ar(0,WhiteNoise.ar(0.000001)!4);

					////stereo
					/*(
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*mx.lag(0.01))),0.9,0.01),
						SinOsc.ar(lfon*pon,0)));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*my.lag(0.01))),0.9,0.01),
						SinOsc.ar(lfon*pon,90.degrad)));
Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*mz.lag(0.01))),0.9,0.01)!2);
					)*/

	///three channel
					/*(
Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*mx.lag(0.01))),0.9,0.01));
Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*my.lag(0.01))),0.9,0.01));
Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*mz.lag(0.01))),0.9,0.01));
					)*/

										(
Out.ar(0,PanAz.ar(3,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*mx.lag(0.01))),0.9,0.01),
							pon1));
Out.ar(0,PanAz.ar(3,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*my.lag(0.01))),0.9,0.01),
							pon2));
Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*mz.lag(0.01))),0.9,0.01)!3);
					);

						azf = (azf+(2pi-(2pi/s))).wrap(pi.neg,pi);
		   elf = (elf+(pi-(pi/s))).wrap((pi/2).neg,(pi/2))
				};

}).add;);

2.wait;


////durs
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

		////////2////sequencer
		(

////synth parameters
			~gg=1;
			~panwidth=1;
			~feed=0.000001;
			~scalar=0;
			~ton=496*3;
			~oct=36.neg;
			~lx=1;
			~la=6;
			~drive=992*0.5;
			~mox=0.5;
			~room=0.5;
			~panner=1;
			~sphpan=(992*1);
			~bband=(992*16).neg;
			~rect=0;
			~strech=12;
			~detune=1;

////music parameters
			~val=12364.rand;
					~seq= Pseq(1 *~dur, inf).asStream;

~str = Routine({
    var i=0,m,l,az=0,el=0,expansion;
	var m1,m2,m3,r1,r2,r3,sphm,sphr,time=1/32,melody,rhythm;

    loop {
~val=1234.rand;
								thisThread.randSeed = ~val;
							i= ~cart.lag(0.01).size.rand;
				//	i=0;
	expansion=Cartesian(~cart.lag(0.01).[i].[0].round(0.00001),
						~cart.lag(0.01).[i].[1].round(0.00001),
						~cart.lag(0.00001).[i].[2].round(0.00001));
					rhythm=Spherical(1/8,expansion.theta,expansion.phi);
					melody=Spherical(5,expansion.theta,expansion.phi);
				r1=2.pow(rhythm.x.abs).round(time);
				r2=2.pow(rhythm.y.abs).round(time);
				r3=2.pow(rhythm.z.abs).round(time);
					m1=melody.x.round(1);
					m2=melody.y.round(1);
				    m3=melody.z.round(1);
					sphm=[m1,m2,m3];
					sphr=[r1,r2,r3];

		~synth=Synth.new(\synth,[\gain,~gg,\drive,~drive,\fu,32,\decay,~strech,
						\low,~drive,\pan,~bband,\mix,~mox,\room,~room,\pann,~sphpan,\x,~lx,\a,~la,\spread,~panwidth,
						\pon,~panner,\pneuma,0,\namp,1,\drone,~oct,\az,az,\el,el,
						\panx,~rect,\pany,~rect,\panz,~rect,\dron,~ton,\qq,~feed,\qqq,~scalar,\gate,1,
						\xx,~cart.lag(0.01).[i].[0].round(0.00001),
				        \yy,~cart.lag(0.01).[i].[1].round(0.00001),
						\zz,~cart.lag(0.01).[i].[2].round(0.00001)]).register;
	sphr.[0].wait;

		~synth=Synth.new(\synth,[\gain,~gg,\drive,~drive,\fu,32,\decay,~strech,
						\low,~drive,\pan,~bband,\mix,~mox,\room,~room,\pann,~sphpan,\x,~lx,\a,~la,\spread,~panwidth,
						\pon,~panner,\pneuma,0,\namp,1,\drone,~oct,\az,az,\el,el,
						\panx,~rect,\pany,~rect,\panz,~rect,\dron,~ton,\qq,~feed,\qqq,~scalar,\gate,1,
						\xx,~cart.lag(0.01).[i].[0].round(0.00001),
				        \yy,~cart.lag(0.01).[i].[1].round(0.00001),
						\zz,~cart.lag(0.01).[i].[2].round(0.00001)]).register;
	sphr.[1].wait;

		~synth=Synth.new(\synth,[\gain,~gg,\drive,~drive,\fu,32,\decay,~strech,
						\low,~drive,\pan,~bband,\mix,~mox,\room,~room,\pann,~sphpan,\x,~lx,\a,~la,\spread,~panwidth,
						\pon,~panner,\pneuma,0,\namp,1,\drone,~oct,\az,az,\el,el,
						\panx,~rect,\pany,~rect,\panz,~rect,\dron,~ton,\qq,~feed,\qqq,~scalar,\gate,1,
						\xx,~cart.lag(0.01).[i].[0].round(0.00001),
				        \yy,~cart.lag(0.01).[i].[1].round(0.00001),
						\zz,~cart.lag(0.01).[i].[2].round(0.00001)]).register;
						sphr.[2].wait;
    }
		});

/*(
	~temp= Routine({
					   var i=0,expansion,matter;
				loop{
						i= ~cart.lag(0.01).size.rand;
	expansion=Cartesian(~cart.lag(0.01).[i].[0].round(0.00001),
						~cart.lag(0.01).[i].[1].round(0.00001),
						~cart.lag(0.00001).[i].[2].round(0.00001));
						matter=Spherical(12,expansion.theta,expansion.phi).x;
				 TempoClock.default.tempo =  (~seq.next);
					(matter).wait;
};
	}))*/
		) ;
/*(
			~rand= Routine({
						   var i=0,expansion,matter;
				loop{
					i= ~cart.lag(0.01).size.rand;
						expansion=Cartesian(~cart.lag(0.01).[i].[0].round(0.00001),
						~cart.lag(0.01).[i].[1].round(0.00001),
						~cart.lag(0.00001).[i].[2].round(0.00001));
						matter=Spherical(20,expansion.theta,expansion.phi).y;
~val=1234.rand;
				(matter).wait;
};
});
	)*/
	});
	Tdef(\drone).play;
}
)
)

(
			~str.play;
		//	~temp.play;
	//	~rand.play;
)

TempoClock.default.tempo =  (1);



~str.stop;
~temp.stop;
~rand.stop;


~synth.free;
~synth.set(\fu,64);







s.record(numChannels:4)

//////////////////////////////



/////dac noise rremoval for generative instalation

Routine({
    loop {
        6*3600.wait;   // every 6 hours
        s.reboot;
    }
}).play;








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


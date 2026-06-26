
(
s.options.numOutputBusChannels=6;
s.waitForBoot;
Buffer.freeAll;
~controlBus = Bus.control(s, 1);
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
~controlBus3 = Bus.control(s, 1);
~controlBus4 = Bus.control(s, 1);
~controlBus5 = Bus.control(s, 1);


	~scale1= Buffer.alloc(s,2048);
	~scale2= Buffer.alloc(s,2048);
	~scale3= Buffer.alloc(s,2048);
	~w1= Buffer.alloc(s,2048);
	~w2= Buffer.alloc(s,2048);
	~w3= Buffer.alloc(s,2048);

{
var signal,wt;
	signal=Env([1,10000],[3],[8]);
	wt = signal.asSignal(1024).asWavetable;
~scale2.loadCollection(wt);
//signal.plot;
		}.value;
{
var signal,wt;
	signal=Env([1,10000],[3],[4]);
	wt = signal.asSignal(1024).asWavetable;
~scale3.loadCollection(wt);
//signal.plot;
		}.value;
		{
var signal,wt;
	signal=Env([1,10000],[3],[12]);
	wt = signal.asSignal(1024).asWavetable;
~scale1.loadCollection(wt);
//signal.plot;
		}.value;

	{
var signal,wt;
	signal=Env([0.001,1,0.01],[2,1],[4,2.neg]);
	wt = signal.asSignal(1024).asWavetable;
~w1.loadCollection(wt);
//signal.plot;
		}.value;

	{
var signal,wt;
	signal=Env([30000,0.01,100],[2,0.1],[16,2.neg]);
	wt = signal.asSignal(1024).asWavetable;
~w2.loadCollection(wt);
//signal.plot;
		}.value;

	{
var signal,wt;
	signal=Env([1,10],[3],[8]);
	wt = signal.asSignal(1024).asWavetable;
~w3.loadCollection(wt);
//signal.plot;
		}.value;



SynthDef.new(\player,{
	arg tempo;
	Out.kr(~controlBus.index, (Osc.kr(~scale1.bufnum,(1/50)).abs));
	Out.kr(~controlBus1.index, (Osc.kr(~w1.bufnum,(1/50)).abs));
		Out.kr(~controlBus2.index, (Osc.kr(~w2.bufnum,(1/50)).abs));
Out.kr(~controlBus3.index, (Osc.kr(~w3.bufnum,(1/50)).abs));

}).add;
)


Server.freeAll
//

//////////////////////////////////////////////////////////////////////animation

(
var ot=0,dota,pla=0;
var data;
var az=0,el=0;
var sph,pl=0,magg,r,run = true;
var sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=1,m_y=1,m_z=1,qx,qy,mq=0;
var angle1=0,angle2=0,angle3=0,angle4=0,angle5=0,angle6=0,angle7=0;
var sph11,sph22,sph33,sph44,sph55,sph66,sph77,sphx,sphy,sphz,sphqx,sphqy;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az11=0,el11=0,az22=0,el22=0,az33=0,el33=0,az44=0,el44=0,az55=0,el55=0,az66=0,el66=0,az77=0,el77=0;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez;
var angle=0,n=12,num=1.neg,ellipsis=[1,1,1],spread=1,harm;
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
var scale=8,scale_mag_total,perspective,g=((1+5.sqrt)/2),s=(1+2.sqrt);

	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];
//	spread = if(m_z < 1) { 1 / m_z } { m_z };
Synth.new(\player);
data = [];

w = Window.new("3D Scatterplot", Rect(40,40, 1500, 1000)).front;

~v = UserView.new(w,Rect(0,0,1500,1000)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 1500,1000), ~data, [-10000, 10000].asSpec,[-10000, 10000].asSpec,[-10000, 10000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 2;
a.symbolColor = Color.white;
a.background = Color.black;


  r= Routine({loop{

	data=[];
	scale=~controlBus.getSynchronous;
	scale_mag_total=~controlBus1.getSynchronous;
	perspective=~controlBus2.getSynchronous;
	harm=~controlBus3.getSynchronous;

	m_x=m_y=m_z=mq=harm;


	//scale=1;
	//scale.postln;

	(
{
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];


	3.do{

5.do{
			az1 = (az1+(2pi-(2pi/s))).wrap(pi.neg,pi);
			el1 = (el1+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
			sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2))));

			5.do{
				az11=az1;el11=el1;
	azimuth=5.collect{
				az11 = (az11+(2pi-(2pi/s))).wrap(pi.neg,pi);
				el11 = (el11+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));

				sph11=(Spherical(mag1/scale,(az11+angle+angle1).wrap(pi.neg,pi),(el11+angle+angle1).wrap((pi/2).neg,(pi/2))));
				(sph1.asCartesian.round(0.000000000001)+sph11.asCartesian.round(0.000000000001)).asSpherical.theta.round(0.000000000001);

			};~az=~az++azimuth;angle1=(angle1+(2pi-(2pi/s))).wrap(0,2pi);};
		};

5.do{
			az2 = (az2+(2pi-(2pi/s))).wrap(pi.neg,pi);
			el2 = (el2+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
			sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2))));

			5.do{
				az22=az2;el22=el2;
	elevation=5.collect{
				az22 = (az22+(2pi-(2pi/s))).wrap(pi.neg,pi);
				el22 = (el22+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));

				sph22=(Spherical(mag2/scale,(az22+angle+angle2).wrap(pi.neg,pi),(el22+angle+angle2).wrap((pi/2).neg,(pi/2))));
				(sph2.asCartesian.round(0.000000000001)+sph22.asCartesian.round(0.000000000001)).asSpherical.phi.round(0.000000000001);

			};~el=~el++elevation;angle2=(angle2+(2pi-(2pi/s))).wrap(0,2pi);};
		};

5.do{
			az3 = (az3+(2pi-(2pi/s))).wrap(pi.neg,pi);
			el3 = (el3+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
		    sph3=(Spherical(mag3,(az3+angle).wrap(pi.neg,pi),(el3+angle).wrap((pi/2).neg,(pi/2))));

			5.do{
				az33=az3;el33=el3;
	magnitudex=5.collect{
				az33 = (az33+(2pi-(2pi/s))).wrap(pi.neg,pi);
				el33 = (el33+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));

				sph33=(Spherical(mag3/scale,(az33+angle+angle3).wrap(pi.neg,pi),(el33+angle+angle3).wrap((pi/2).neg,(pi/2))));
	 mag_x=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
	sphx=(Spherical(mag_x,sph3.theta,sph3.phi).asCartesian.round(0.000000000001)+Spherical(mag_x/scale,sph33.theta,sph33.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magx=~magx++magnitudex;angle3=(angle3+(2pi-(2pi/s))).wrap(0,2pi);};
		};

5.do{
			az4 = (az4+(2pi-(2pi/s))).wrap(pi.neg,pi);
				el4 = (el4+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
	sph4=(Spherical(mag4,(az4+angle).wrap(pi.neg,pi),(el4+angle).wrap((pi/2).neg,(pi/2))));

			5.do{
				az44=az4;el44=el4;
	magnitudey=5.collect{
				az44 = (az44+(2pi-(2pi/s))).wrap(pi.neg,pi);
				el44 = (el44+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));

				sph44=(Spherical(mag4/scale,(az44+angle+angle4).wrap(pi.neg,pi),(el44+angle+angle4).wrap((pi/2).neg,(pi/2))));
	 mag_y=((Complex(sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
	sphy=(Spherical(mag_y,sph4.theta,sph4.phi).asCartesian.round(0.000000000001)+Spherical(mag_y/scale,sph44.theta,sph44.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magy=~magy++magnitudey;angle4=(angle4+(2pi-(2pi/s))).wrap(0,2pi);};
		};


5.do{
			az5 = (az5+(2pi-(2pi/s))).wrap(pi.neg,pi);
			el5 = (el5+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
	sph5=(Spherical(mag5,(az5+angle).wrap(pi.neg,pi),(el5+angle).wrap((pi/2).neg,(pi/2))));

			5.do{
				az55=az5;el55=el5;
	qx=5.collect{
				az55 = (az55+(2pi-(2pi/s))).wrap(pi.neg,pi);
				el55 = (el55+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));

				sph55=(Spherical(mag5/scale,(az55+angle+angle5).wrap(pi.neg,pi),(el55+angle+angle5).wrap((pi/2).neg,(pi/2))));
		mag_qx=((((Complex(cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
			(Complex(sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
			(Complex(cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
		sphqx=(Spherical(mag_qx,sph5.theta,sph5.phi).asCartesian.round(0.000000000001)+Spherical(mag_qx/scale,sph55.theta,sph55.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~qx=~qx++qx;angle5=(angle5+(2pi-(2pi/s))).wrap(0,2pi);};
		};



5.do{
			az6 = (az6+(2pi-(2pi/s))).wrap(pi.neg,pi);
			el6 = (el6+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
	sph6=(Spherical(mag6,(az6+angle).wrap(pi.neg,pi),(el6+angle).wrap((pi/2).neg,(pi/2))));

			5.do{
				az66=az6;el66=el6;
		qy=5.collect{
				az66 = (az66+(2pi-(2pi/s))).wrap(pi.neg,pi);
				el66 = (el66+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));

				sph66=(Spherical(mag6/scale,(az66+angle+angle6).wrap(pi.neg,pi),(el66+angle+angle6).wrap((pi/2).neg,(pi/2))));
		mag_qy=((((Complex(sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
				(Complex(sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
				(Complex(cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
		sphqy=(Spherical(mag_qy,sph6.theta,sph6.phi).asCartesian.round(0.000000000001)+Spherical(mag_qy/scale,sph66.theta,sph66.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~qy=~qy++qy;angle6=(angle6+(2pi-(2pi/s))).wrap(0,2pi);};
		};


5.do{
			az7 = (az7+(2pi-(2pi/s))).wrap(pi.neg,pi);
			el7 = (el7+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
sph7=(Spherical(mag7,(az7+angle).wrap(pi.neg,pi),(el7+angle).wrap((pi/2).neg,(pi/2))));

			5.do{
				az77=az7;el77=el7;
	magnitudez=	5.collect{
				az77 = (az77+(2pi-(2pi/s))).wrap(pi.neg,pi);
				el77 = (el77+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));

				sph77=(Spherical(mag7/scale,(az77+angle+angle7).wrap(pi.neg,pi),(el77+angle+angle7).wrap((pi/2).neg,(pi/2))));
		mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
		sphz=(Spherical(mag_z,sph7.theta,sph7.phi).asCartesian.round(0.000000000001)+Spherical(mag_z/scale,sph77.theta,sph77.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magz=~magz++magnitudez;angle7=(angle7+(2pi-(2pi/s))).wrap(0,2pi);};
		};

angle=(angle+(2pi-(2pi/s))).wrap(0,2pi);
		angle1=0;angle2=0;angle3=0;angle4=0;angle5=0;angle6=0;angle7=0;
		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
);
	dota=(3*5*5*3).collect{

	az=~az.[pla];
	el=~el.[pla];
	//mag=1000;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
				 mag=(Cartesian(0,0,~magz.[pla]).rho/(2.sqrt));
		// mag=~magz.[pl];
	pla=pla+1;
			//mk=(mk+(1-(1/1.6180339887499))).wrap(0,1);
			sph=Spherical(perspective*scale_mag_total*mag,az,el).asCartesian.asArray;
};
	//mk=(mk+(1200-(1200/1.6180339887499))).wrap(0,1200);
	pla=0;
	data =data++dota;
	//data.postln;
 	a.data = data;  // Update ScatterView3d
	(0.1).wait
}});
r.play;


~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.1.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/100).wait } }.fork(AppClock);
);




/////
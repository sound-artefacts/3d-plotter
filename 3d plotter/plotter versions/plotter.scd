
/* ///noMathlib       // Z-axis rotation

        x1 = x * rotZ.cos - y * rotZ.sin;
        y1 = x * rotZ.sin + y * rotZ.cos;
        z1 = z;

        // Y-axis rotation

        x2 = x1 * rotY.cos + z1 * rotY.sin;
        z2 = x1.neg * rotY.sin + z1 * rotY.cos;
        y2 = y1;

        // X-axis rotation

        x1 = x2;
        y1 = y2 * rotX.cos - z2 * rotX.sin;
        z1 = y2 * rotX.sin + z2 * rotX.cos;

//rotation of distributin
// X rotation
point = Cartesian(
    point.x,
    point.y * rx.cos - point.z * rx.sin,
    point.y * rx.sin + point.z * rx.cos
);

// Y rotation
point = Cartesian(
    point.x * ry.cos + point.z * ry.sin,
    point.y,
    point.x.neg * ry.sin + point.z * ry.cos
);
// Z rotation
point = Cartesian(
    point.x * rz.cos - point.y * rz.sin,
    point.x * rz.sin + point.y * rz.cos,
    point.z
);


*/


//////example
/*(
var w, u;

var rotAz = 0.0;
var rotEl = 0.0;

var points;

points = Array.fill(500, {

    Spherical(
        rrand(30.0,150.0),      // radius
        rrand(-pi,pi),          // azimuth
        rrand(-pi/2,pi/2)       // elevation
    )

});

w = Window("Spherical Plotter", Rect(100,100,600,600));

u = UserView(w, w.view.bounds)
.background_(Color.black);

u.drawFunc = {

    var d = 500;

    Pen.translate(
        u.bounds.width/2,
        u.bounds.height/2
    );

    points.do { |s|

        var p;
        var scale;

        p = Spherical(
            s.rho,
            s.theta + rotAz,
            (s.phi + rotEl).clip(
                -pi/2,
                pi/2
            )
        ).asCartesian;

        scale = d / (d + p.z + 250);

        Pen.fillColor =
        Color.white.alpha_(
            scale.clip(0.1,1.0)
        );

        Pen.fillOval(
            Rect.aboutPoint(
                Point(
                    p.x * scale,
                    p.y * scale
                ),
                3 * scale,
                3 * scale
            )
        );

    };

};

w.front;

Routine({

    inf.do {

        rotAz = rotAz + 0.01;
        rotEl = rotEl + 0.002;

        {
            u.refresh
        }.defer;

        0.02.wait;

    };

}).play;

)*/
/////////////////////////////////


(
var w, u,size=1000;
var r_az = 0.0,r_el = 0.0,az,el,px;
var n=0,point,per,dist=400,mag,diameter=500;
var rx = 0.0,ry = 0.0,rz = 0.0,d_o=2;

w = Window("3d Plotter", Rect(100,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);

v.drawFunc = {
Pen.translate(v.bounds.width/2,v.bounds.height/2);
n=0;

(32*16).do {
az=~az.[n];el=~el.[n];
mag=(Cartesian(~magx.[n],0,0).rho/(2.sqrt));
//mag=1;
point = Spherical(diameter*mag,
(az + r_az).wrap(pi.neg,pi),
(el + r_el).wrap(0.5pi.neg,0.5pi)).asCartesian;

// X rotation
point = Cartesian(point.x,point.y,point.z).rotateYZ(rx);
// Y rotation
point = Cartesian(point.x,point.y,point.z).rotateXZ(ry);
// Z rotation
point = Cartesian(point.x,point.y,point.z).rotateXY(rz);

n=n+1;
///perspective
per = dist / (dist + point.z + (dist/2));
px=Polar(point.z,Complex(point.x,point.y).theta);
px=point;
///color
Pen.fillColor = Color.white.alpha_(per.clip(0.1,1.0));
///object
Pen.fillOval(Rect.aboutPoint(Point(px.x*per,px.y*per),d_o*per,d_o*per));
};
};

w.front;

Routine({
inf.do {
///points rotation animation
r_az = r_az + 0;
r_el = r_el + 0;
///whole distribution rotation animation
rx = rx+0;
ry = ry + 0.1;
rz = rz + 0.1;
{v.refresh}.defer;
(1/8).wait;

};
}).play;
)
////generic distribution array
(
{
var  sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=2,m_y=1,m_z=1,qx,qy,mq=m_x-1;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,angle=0,n=12;
var sphx,sphy,sphz,azx,elx,azy,ely,azz,elz,plx=1,ply=1,plz=1;
var ellipsis=[1,1,1],spread=1,silver_r=(1+2.sqrt);
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];

//	spread = if(m_z < 1) { 1 / m_z } { m_z };

	16.do{
azimuth=32.collect{
			az1 = (az1+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
		   el1 = (el1+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

//	mag1=(mag1+(1-(1/1.6180339887499))).wrap(0,1);
sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=32.collect{
				az2 = (az2+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el2 = (el2+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag2=(mag2+(1-(1/1.6180339887499))).wrap(0,1);
		sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};

magnitudex=	32.collect{
			az3 = (az3+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el3 = (el3+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag3=(mag3+(1-(1/1.6180339887499))).wrap(0,1);
	sph3=(Spherical(mag3,(az3+angle).wrap(pi.neg,pi),(el3+angle).wrap((pi/2).neg,(pi/2))));

	 mag_x=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

				};

magnitudey=	32.collect{
			az4 = (az4+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
				el4 = (el4+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag4=(mag4+(1-(1/1.6180339887499))).wrap(0,1);
	sph4=(Spherical(mag4,(az4+angle).wrap(pi.neg,pi),(el4+angle).wrap((pi/2).neg,(pi/2))));

		 mag_y=((Complex(sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		 (Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
				};


qx=	32.collect{
			az5 = (az5+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el5 = (el5+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

		//mag5=(mag5+(1-(1/1.6180339887499))).wrap(0,1);
	sph5=(Spherical(mag5,(az5+angle).wrap(pi.neg,pi),(el5+angle).wrap((pi/2).neg,(pi/2))));


mag_qx=((((Complex(cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


qy=	32.collect{
			az6 = (az6+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el6 = (el6+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag6=(mag6+(1-(1/1.6180339887499))).wrap(0,1);
	sph6=(Spherical(mag6,(az6+angle).wrap(pi.neg,pi),(el6+angle).wrap((pi/2).neg,(pi/2))));

 mag_qy=((((Complex(sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


magnitudez=	32.collect{
			az7 = (az7+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el7 = (el7+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

//mag7=(mag7+(1-(1/1.6180339887499))).wrap(0,1);
sph7=(Spherical(mag7,(az7+angle).wrap(pi.neg,pi),(el7+angle).wrap((pi/2).neg,(pi/2))));

//if(
//m_z.even,
mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread)
			//,
//mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho(2.sqrt)).pow(spread);
			//);
////z axis   ambi..  sin for odd numbers, cos for even
				};

angle=(angle+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
~az=~az++azimuth;~el=~el++elevation;
~magx=~magx++magnitudex;~magy=~magy++magnitudey;~magz=~magz++magnitudez;
~qx=~qx++qx;~qy=~qy++qy;
		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;
		az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
)
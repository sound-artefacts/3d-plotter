
(
~points=8;
var w, u,size=1000;
var r_az = 0.0,r_el = 0.0,az,el,px;
var n=0,point,perspective,dist=600,mag,diameter=300;
var rx = 0.0,ry = 0.0,rz = 0.0,d_o=2,plane;

w = Window("3d Plotter", Rect(100,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);

v.drawFunc = {
Pen.translate(v.bounds.width/2,v.bounds.height/2);
n=0;

(~points).do {
az=~az.[n];el=~el.[n];
mag=(Cartesian(~magx.[n],0,0).rho/(2.sqrt));
mag=1;
point = Spherical(diameter*mag,
(az + r_az).wrap(pi.neg,pi),
(el + r_el).wrap(0.5pi.neg,0.5pi)).asCartesian;

///////use fixed rotations for vanishing points and animated for contnious frame rotation
// X rotation
point = Cartesian(point.x,point.y,point.z).rotateYZ(rx);
// Y rotation
point = Cartesian(point.x,point.y,point.z).rotateXZ(ry);
// Z rotation
point = Cartesian(point.x,point.y,point.z).rotateXY(rz);


plane=Complex(point.x,point.y);
n=n+1;
//////remaping
px=Polar(point.z,plane.theta);
px=point;

////////////////////perspective
perspective = dist / (dist + point.z + (dist/2));///remove (dist/2) for no depth
////weak perspective
//perspective = 1 - (point.z * 0.001);
////isometric
//perspective=1;
///axonometric/cabinet perspective shift
//Pen.fillOval(Rect.aboutPoint(Point(point.x + point.z*0.5,point.y + point.z*0.5),d_o*per,d_o*per));


///color
Pen.fillColor = Color.white.alpha_(perspective.clip(0.1,1.0));
///object
Pen.fillOval(Rect.aboutPoint(Point(px.x*perspective,px.y*perspective),d_o*perspective,d_o*perspective));
};
};

w.front;

Routine({
inf.do {
///points rotation animation
r_az = r_az + 0;
r_el = r_el + 0;
///whole distribution rotation animation
rx = 0.5pi;
ry = ry + 0.025;
rz = 0;
{v.refresh}.defer;
(1/8).wait;

};
}).play;
)



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


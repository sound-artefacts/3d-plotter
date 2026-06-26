(
var w, u,size=1000,diameter=300,n=0;
var r_az = 0.0,r_el = 0.0,az,el,cp,protaz,protel;
var point,perspective,dist=600,mag=1;
var rx = 0.0,ry = 0.0,rz = 0.0;
var plane,pointx,pointy;
var d_o=10,face;

w = Window("3d Plotter", Rect(100,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);

v.drawFunc = {

///scale drawing
Pen.translate(v.bounds.width/2,v.bounds.height/2);
///Pen.scale(0.5, 2);
///Pen.moveTo(0@0);

~points=8;
~point_cloud=[];
n=0;

(~points).do {
az=~az.[n];el=~el.[n];
///spherical harmonics
//mag=(Cartesian(~magx.[n],~magy.[n],~magz.[n]).rho/(2.sqrt));
///complex spherical harmonics
///mag=(Cartesian(~magx.[n],~magy.[n],~magz.[n]).rho/(2.sqrt))+(Cartesian(~qx.[n],~qy.[n],0).rho/(2.sqrt));

///cloud assignment and distortion
protaz=(az + r_az).wrap(pi.neg,pi);
protel=(el + r_el).wrap(0.5pi.neg,0.5pi);
point = Spherical(diameter*mag,protaz,protel).asCartesian;

///////use fixed rotations for vanishing points and animated for contnious frame rotation
// X rotation
point = Cartesian(point.x,point.y,point.z).rotateYZ(rx);
// Y rotation
point = Cartesian(point.x,point.y,point.z).rotateXZ(ry);
// Z rotation
point = Cartesian(point.x,point.y,point.z).rotateXY(rz);

plane=Complex(point.x,point.y);
//////remaping
cp=Polar(point.z,plane.theta);
cp=point;

////////////////////perspective
perspective = dist / (dist + point.z + (dist/2));///remove (dist/2) for no depth
////weak perspective
//perspective = 1 - (point.z * 0.001);
////isometric
//perspective=1;
///axonometric/cabinet perspective shift
//Pen.fillOval(Rect.aboutPoint(Point(cp.x + cp.z*0.5,cp.y + cp.z*0.5),d_o*per,d_o*per));

///color
Pen.fillColor = Color.white.alpha_(perspective.clip(0.1,1.0));
Pen.strokeColor = Color.white.alpha_(perspective.clip(0.1,1.0));

////////objects
//////points
pointx=cp.x*perspective;
pointy=cp.y*perspective;
~point_cloud=~point_cloud++Point(pointx,pointy);
///point_oval
Pen.addOval(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective,d_o*perspective));
///rectangles
//face=pointx-pointy;
//Pen.addRect(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective*,d_o*perspective*));

/////desics
///curves
///Pen.quadCurveTo(endPoint, cPoint)
///Pen.arcTo(point1, point2, radius)
///Pen.curveTo(endPoint, cPoint1, cPoint2)

//////lines
Pen.line(~point_cloud.[(n+8.rand).wrap(0,7)],~point_cloud.[(n+8.rand).wrap(0,7)]);
//Pen.lineTo(~point_cloud.[n]);

/////
Pen.stroke;
n=n+1;
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


(
var w, u,size=1000,diameter=300,n=0,m=0;
var r_az = 0.0,r_el = 0.0,az,el,cp,protaz,protel;
var point,perspective,dist=600,mag=1;
var rx = 0.0,ry = 0.0,rz = 0.0;
var plane,pointx,pointy;
var d_o=3,face;

w = Window("3d Plotter", Rect(100,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);

v.drawFunc = {

///scale drawing
Pen.translate(v.bounds.width/2,v.bounds.height/2);
///Pen.scale(0.5, 2);
///Pen.moveTo(0@0);

~vertice=8;
~mesh=12;
~point_cloud=[];
n=0;

(~vertice).do {
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

//////points
pointx=cp.x*perspective;
pointy=cp.y*perspective;
~point_cloud=~point_cloud++Point(pointx,pointy);
///point_oval
Pen.addOval(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective,d_o*perspective));
///rectangles
//face=pointx-pointy;
//Pen.addRect(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective*,d_o*perspective*));
Pen.fillStroke;
n=n+1;
};
n=0;
////////shapes
/*(~mesh).do {
///curves
///Pen.quadCurveTo(endPoint, cPoint)
///Pen.arcTo(point1, point2, radius)
///Pen.curveTo(endPoint, cPoint1, cPoint2)
//////lines
Pen.line(~point_cloud.[(n).wrap(0,7)],~point_cloud.[(n+1).wrap(0,7)]);
/////
Pen.stroke;
n=n+1;
};*/
n = 0;m=0;
(~point_cloud.size).do {
var m = n + 1;
(~point_cloud.size - n - 1).do {Pen.line(~point_cloud[n],~point_cloud[m]);
////mesh nearby points exclusion
///if(~point_cloud[n].dist(~point_cloud[m])<50) {Pen.line(~point_cloud[n],~point_cloud[m]);};
/////random exclusion
///if(0.3.coin){Pen.line(~point_cloud[n],~point_cloud[m]);};
/////skip adjuscent
///if((m - n) > 1){Pen.line(~point_cloud[n],~point_cloud[m]);};
Pen.stroke;
m = m + 1;
};
 n = n + 1;
};
};

w.front;

Routine({
inf.do {
///points rotation distortion
r_az = r_az + 0;
r_el = r_el + 0;
///whole animation object rotation
rx = 0.5pi;
ry = ry + 0.025;
rz = 0;
{v.refresh}.defer;
(1/8).wait;

};
}).play;
)


///thread tools

//////thread sequencer/routine
({
var n=1.neg;
~nseq=8.collect{2.rand};
}.defer);

//////l-system thread
({
var dict = IdentityDictionary[\A -> "AB", \B -> "A"];
//These are the production rules of the L-system
var word = "A";
var string_temp = "";
var iter = 20;
//These are diction for the mapping of the alphabet to "artistic" parameters: degrees in a scale, beat occurrence, etc.
var dictnotes = IdentityDictionary[\A ->0, \B -> 1];  ///amount of 0 in A (array), is the value of Rest(A) for silent events, eg. if A=[0,0,0] then Rest(3)
 ~lseq=[];
//This iteration generates the system recursively
iter.do({
word.asArray.do({|i|string_temp = string_temp ++ dict[i.asSymbol];});
word = string_temp;string_temp = "";});
word.postln;
//Here we map the final system to the parameters as above
word.do({|i| ~lseq = ~lseq ++ dictnotes[i.asSymbol];});
~lseq.postln;
~lseq.size////check for sequence size >= vertices count
}.value);

////plotter
(
var w, u,size=1000,diameter=300,n=0,m=0;
var r_az = 0.0,r_el = 0.0,az,el,cp,protaz,protel;
var point,perspective,dist=600,mag=1;
var rx = 0.0,ry = 0.0,rz = 0.0;
var plane,pointx,pointy;
var d_o=2,run=1;

w = Window("3d Plotter", Rect(100,100,size,size));
v = UserView(w, w.view.bounds).background_(Color.black);

v.drawFunc = {
///scale drawing
Pen.translate(v.bounds.width/2,v.bounds.height/2);
///Pen.scale(0.5, 2);
///Pen.moveTo(0@0);

//~vertice=8;  ////solide vertices cound
~vertice=~coo;   ///count from distributions points
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
///rectangle
//Pen.addRect(Rect.aboutPoint(Point(pointx,pointy),d_o*perspective*,d_o*perspective*));
Pen.fillStroke;
n=n+1;
};
n=0;
////////mesh
n = 0;m=0;
(~point_cloud.size).do {
var m = n + 1; m=0;
(~point_cloud.size - n - 1).do {
///all lines
///Pen.line(~point_cloud.[n],~point_cloud.[m]);
////selective exclusion
//if([[0,7],[1,6],[2,5]].includes([n,m]).not){Pen.line(~point_cloud.[n],~point_cloud.[m])};
////mesh nearby points exclusion
///if(~point_cloud.[n].dist(~point_cloud.[m])<50) {Pen.line(~point_cloud.[n],~point_cloud.[m])};
/////random exclusion
///if(0.3.coin){Pen.line(~point_cloud.[n],~point_cloud.[m])};
/////skip adjuscent
///if((m - n) > 1){Pen.line(~point_cloud.[n],~point_cloud.[m])};
///sequence exclusion
//based on algorithmic booelan distributions, number sequencies and sets, propabilty graphs to boolean sequence
if(~lseq.[m] == 1) {Pen.line( ~point_cloud.[n], ~point_cloud.[m])};
Pen.stroke;
m=m+1;
};
 n=n+1;
};
//~lseq=~lseq.size.collect{2.rand};
};
{ while { run } {v.background_(Color.black); v.refresh; (1/8).wait } }.fork(AppClock);
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


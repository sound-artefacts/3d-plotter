

/////////////single image

(
(~img_sound = Image.open("/Users/rohifes/sound artefacts/shots_image to sound/feed1/DSC_0011.JPG");
{
var img,c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;
img = ~img_sound;
~cx=[]; ~cy=[];  ~cz=[];
~height=img.height;
~width=img.width;
~vertices = ~height*~width;
	~height.do{
				~width.do {
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
		}.defer;
);

(
{
    ~az_im = [];
    ~el_im = [];

    ~vertices.do {
        var ix, iy, iz,n=1.neg;
        var az, el, r;

					n=n+1;
        ix = ~cx[n];
        iy = ~cy[n];
        iz = ~cz[n];

        az = atan2(iy, ix); // azimuth
        r = sqrt(ix.squared + iy.squared + iz.squared);
        el = acos(iz / r);  // same convention as Cartesian.phi

        ~az_im = ~az_im++az;
        ~el_im = ~el_im++el;
    };
}.defer;
);
)
///////video frames

(
{
var files, images, win, view, n=0;
var xx=0,yy=0,r=[],g=[],b=[],color;
~cx=[]; ~cy=[];  ~cz=[];
files = PathName.new("/Users/rohifes/sound artefacts/shots_image to sound/feed1/").files;
files.size.do { images=Image.open(files.[n].fullPath);
n=n+1;yy=0;
r=[];g=[];b=[];
~height=images.height;
~width=images.width;
~vertices = ~height*~width;
~height.do{
~width.do {
color = images.getColor(xx, yy);
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
}
		}.defer;
);


(
(~img_sound = Image.open("/Users/rohifes/sound artefacts/shots_image to sound/feed1/DSC_0011.JPG");
{
var img,c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;
img = ~img_sound;
~cx=[]; ~cy=[];  ~cz=[];
~height=img.height;
~width=img.width;
~vertices = ~height*~width;
	~height.do{
				~width.do {
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
		}.defer;
);

(
{
    ~az_im = [];
    ~el_im = [];

    ~vertices.do {
        var ix, iy, iz,n=1.neg;
        var az, el, r;

					n=n+1;
        ix = ~cx[n];
        iy = ~cy[n];
        iz = ~cz[n];

        az = atan2(iy, ix); // azimuth
        r = sqrt(ix.squared + iy.squared + iz.squared);
        el = acos(iz / r);  // same convention as Cartesian.phi

        ~az_im = ~az_im++az;
        ~el_im = ~el_im++el;
    };
}.defer;
);
)

////video playback

(
var files, images, win, view, i = 0;

// load file paths
files = PathName.new("/Users/rohifes/sound artefacts/shots_image to sound/sequence1/").files;

// preload images (important for smooth playback)
images = files.collect { |f| Image.open(f.fullPath) };

// create window
win = Window("Image Animation", Rect(100, 100, 400, 400)).front;

// create a view for drawing
view = UserView(win, win.view.bounds)
    .background_(Color.black);

// draw function
view.drawFunc = {
    if(images.notEmpty) {
        images[i].drawInRect(view.bounds);
    };
};

// animation routine
Routine({
    loop {
        {
            i = (i + 1) % images.size;  // loop through images
            view.refresh;              // trigger redraw
        }.defer; // GUI updates must be deferred

        (1/4).wait; // frame duration
    }
}).play;
)


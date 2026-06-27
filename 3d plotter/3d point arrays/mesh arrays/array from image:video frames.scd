(
var files, images, win, view, i = 0;

// load file paths
files = PathName.new("/Users/amimid/Documents/film/screenplay/").files;

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



////////

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

/////////////


({
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
5.wait;
(
{
    ~az = [];
    ~el = [];

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

        ~az = ~az++az;
        ~el = ~el++el;
    };
}.value;
);

///////
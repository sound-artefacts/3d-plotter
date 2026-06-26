(
var width = 800;
var height = 600;
var frames = 120;

("~/frames").standardizePath.mkdir;

frames.do { |i|

    var img = Image(width, height);
    var p = Pen(img);

    // draw animation
    p.fillColor = Color.black;
    p.fillRect(Rect(0,0,width,height));

    p.fillColor = Color.white;
    p.addOval(Rect(100 + (i*3), 200, 100, 100));
    p.fill;

    img.write("~/frames/frame_%05d.png".format(i).standardizePath);

};
)
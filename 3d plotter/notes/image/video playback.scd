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
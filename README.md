# mpv mount play

If target is a mountable device (like ISO image, dvd or something):
    Mount it.

If target is a directory (either initially or after the image has been mounted):
    Generate a playlist of the directories media-files.

Then play it with the playlist (or just regular if it was just a normal media-file).

## ABOUT

I really can't figure out how to get the filepath of the target.
I tried to use the at first obvious solution by:

```lua
local mp = require("mp")
local target = mp.get_property("path")
```

But it doesn't work because it can only do that after having loaded the file;
which is a major problem because you can't load directories/image-files.

So the solution I think is to read the `argv` or something,
but I don't know how...

So project was a massive FAIL.

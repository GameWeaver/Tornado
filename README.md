# Tornado

### OP-1 Controls an effect on the iPad

Overview
---------

01. [What is it?](https://github.com/Gameweaver/Tornado#what-is-it?)
02. [Video](https://github.com/Gameweaver/Tornado#video)
03. [How the Tornado effect was made](https://github.com/Gameweaver/Tornado#how-the-tornado-effect-was-made)
04. [Running the code](https://github.com/Gameweaver/Tornado#running-the-code)
05. [CoreMidi](https://github.com/Gameweaver/Tornado#coremidi)
06. [Communications](https://github.com/Gameweaver/Tornado#communications)
07. [Minimum Requirements](https://github.com/Gameweaver/Tornado#minimum-requirements)
08. [Optional Requirements](https://github.com/Gameweaver/Tornado#optional-requirements)
09. [Questions and Answers](https://github.com/Gameweaver/Tornado#questions-and-answers)
10. [Links](https://github.com/Gameweaver/Tornado#links)
11. [Things I'd like to know](https://github.com/Gameweaver/Tornado#things-id-like-to-know)

What is it?
-----------

The OP-1 is an amazing synthesizer from Teenage Engineering. One of the cool things
about it are the effects, like NITRO(My Favourite), DELAY, GRID, PHONE, PUCH and SPRING.
They all have a unique user interface, and I wanted to make my own for iOS, controlled
by the OP-1.

Video
-----

TODO: I will add a video when I get time.

How the Tornado effect was made
--------------------------------

The tornado swirls are created by calculating a bezier in 2d space, top-down.
This 2d space is then rotated approximately 70 degrees on the x-axis.
After rotation, I use CGPointApplyAffineTransform to work out the 2d CGPoint
from the 3D rotation, I then draw the bezier using these points.

Running the code
-----------------

Change the following line in the code:

```objective-c
[[MidiManager instance] createMidiSessionWithUniqueId:1322036174];
```

Turn on your OP-1 and go into MIDI mode Shift+Com->Option 2(CTRL)

Make sure the App is completely closed and not running, plug in the cable, then
open the app.

If you get: "Accessory Unavailable: The attached accessory uses too much power", you need
to restart your iPad, or charge your iPad to 100%. If anyone knows of a cable that
can charge and use the camera connection kit at the same time, can they let me know?

CoreMidi
--------

**OP-1 Settings - from CoreMidi**

Your settings will vary, but you need to take the uniqueID from the
sources section, and put that into your code, so that it will connect
correctly.

```json
{
	    SerialNumber = MY_SERIAL_NUMBER;
	    USBLocationID = 17825792;
	    USBVendorProduct = 593952772;
	    driver = "com.apple.AppleMIDIUSBDriver";
	    entities =     (
	                {
	            destinations =             (
	                                {
	                    uniqueID = 1154527813;
	                }
	            );
	            embedded = 0;
	            maxSysExSpeed = 3125; //If you add a 0 to this, it equals midi baud rate.
	            name = "OP-1 Midi Device";
	            sources =             (
	                                {
	                    uniqueID = 1322036174; //This is the ID you need to put into the code.
	                }
	            );
	            uniqueID = "-1837032176";
	        }
	    );
	    image = "/Library/Audio/MIDI Devices/Generic/Images/USBInterface.tiff";
	    manufacturer = "Teenage Engineering AB";
	    model = "OP-1 Midi Device";
	    name = "OP-1 Midi Device";
	    offline = 0;
	    uniqueID = "-1037462185";
	}
```

Communications
--------------

I tried to use the Redpark cables (DB9 and DB9V) to connect to an iPod Touch 4th Gen,
but I just couldn't get it to work. In the end I used a iPad Camera Connection Kit,
this ONLY works on an iPad.

**Camera Connection Kit**

* OP-1 ->
* OP-1 (Mini-USB to USB Cable) -> 
* iPad Camera Connection Kit -> 
* iPad 2

**Redpark Cable**

When using the Redpark cable, this was my setup, it didn't work for me. I think the problem
is that, there are too many adapaters.

* OP-1 -> 
* OP-1 (Mini-USB to USB Cable) -> 
* Female to Female USB Adapter ->
* USB to Serial Cable ->
* Female to Female serial adapter ->
* RedPark Serial to iPhone connector ->
* iPod Touch 4th Gen


Minimum Requirements
---------------------

* OP-1 - www.teenageengineering.com
* iPad - www.apple.com
* iPad Camera Connection Kit - www.apple.com
* Xcode - Mac App Store

Optional Requirements
----------------------

* Redpark cable - www.redpark.com (Again, I couldn't get this to work, if you can get it working, please show me how!)

Questions and Answers
----------------------

**Why didn't you use OpenGL ES?**

I don't know how to use it, and I wanted to play with CoreGraphics :-)

**Why not draw the bezier in 2d space, then rotate the layer and be done with it?**

Well, if you do that, the layer has no-depth and the bezier looks flat, 
doing it this way, the bezier appears to have depth. 

Links
-----------

* [Come Learn Cocoa with me](http://comelearncocoawithme.blogspot.co.uk/2011/08/reading-from-external-controllers-with.html)
* [xmidi](http://xmidi.com/blog/how-to-access-midi-devices-with-coremidi/)

Things I'd like to know
------------------------

* Can anyone get the Redpark cable working?
* Is there a cable that can supply power to the iPad/OP-1 with the camera kit connected?
# Tornado

### External effect for the OP-1

Overview
---------

1. [)What is it?](https://github.com/Gameweaver/Tornado#)What is it?)What is it?
2. [Video](https://github.com/Gameweaver/Tornado#Video)Video
3. [How the Tornado effect was made](https://github.com/Gameweaver/Tornado#How the Tornado effect was made)How the Tornado effect was made
5. [CoreMidi](https://github.com/Gameweaver/Tornado#CoreMidi)CoreMidi
4. [Communications](https://github.com/Gameweaver/Tornado#Communications)Communications between the OP-1 and iPad
5. [Minimum Requirements](https://github.com/Gameweaver/Tornado#Minimum Requirements)Minimum Requirements
6. [Questions and Answers](https://github.com/Gameweaver/Tornado#Questions and Answers)Questions and Answers


What is it?
-----------

The OP-1 is an amazing 

Video
-----

todo

How the Tornado effect was made
--------------------------------

The tornado swirls are created by calculating a bezier in 2d space, top-down.
This 2d space is then rotated approximately 70 degrees on the x-axis.
After rotation, I use CGPointApplyAffineTransform to work out the 2d CGPoint
from the 3D rotation, I then draw the bezier using these points.

```objective-c
test
```

CoreMidi
--------

**OP-1 Settings - from CoreMidi**

Your settings will vary:

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
	            maxSysExSpeed = 3125;
	            name = "OP-1 Midi Device";
	            sources =             (
	                                {
	                    uniqueID = 1322036174;
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
this ONLY works on an iPad

**Camera Connection Kit**

* OP-1 ->
* OP-1 (Mini-USB to USB Cable) -> 
* iPad Camera Connection Kit -> 
* iPad 2

**Redpark Cable**

When using the Redpark cable, this was my setup, it didn't work for me. I think the problem
is that there are too many adapaters.

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


Questions and Answers
----------------------

**Why didn't you use OpenGL ES?**
I don't know how to use it, and I wanted to play with CoreGraphics :-)

**Why not draw the bezier in 2d space, then rotate the layer and be done with it?**
Well, if you do that, the layer has no-depth and the bezier looks flat, 
doing it this way, the bezier appears to have depth. 



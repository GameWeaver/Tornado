# Tornado

External effect for the OP-1

The tornado swirls are created by calculating a bezier in 2d space, top-down.
This 2d space is then rotated approximately 70 degrees on the x-axis.
After rotation, I use CGPointApplyAffineTransform to work out the 2d CGPoint
from the 3D rotation, I then draw the bezier using these points.

You might be asking, why not: Draw the bezier in 2d space, then rotate the layer and
be done with it? - Well, if you do that, the layer has no-depth and the bezier looks
flat, doing it this way, the bezier appears to have depth. You also might be asking
why I didn't use OpenGL-ES, it's simple, I don't know how to use it, and I wanted to
play with CoreGraphics :-)


Connections:
OP-1 -> 
OP-1 (Mini-USB to USB Cable) -> 
Female to Female USB Adapter ->
USB to Serial Cable ->
Female to Female serial adapter ->
RedPark Serial to iPhone connector


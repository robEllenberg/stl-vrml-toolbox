stl-vrml-toolbox
================

A few useful matlab scripts to import and export STL and simple VRML files

You should  have the geom3d MATLAB toolbox installed to use the geometry reduction feature.

TODO:

"Shrinkwrapping" geometry reduction idea:

1) Take convex hull of overall geometry.
2) Fill large triangles with new points until mesh is even to some tolerance
3) Project inward at each of these vertices until the body is hit, or the other side of the hull.
4) Shift vertex along this line by some step (10%) if the 

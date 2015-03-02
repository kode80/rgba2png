# rgba2png
An OSX utility app for generating PNGs from specific color channels of separate images (e.g. image1.rgb + image2.a = image3.rgba).

# Use case: 
It is common in 3D shaders to use the various color channels of a texture to store separate information. Manually managing these channels can be a pain depending on the graphics application you use. With rgba2png you can choose multiple images, specify the color channels you want from the source images and their target channels in the output image. When rgba2png is running it will automatically detect changes to the source images and generate the output image.

# Status/Roadmap
rgba2png is functional but still in development. It is possible to create a project containing multiple image blueprints, edit all options of the blueprints and generate correct PNGs. Batch processing & automatic generation is not yet implemented (next on the list) and the UI is a little rough around the edges.  
  
~~Image manipulation/export implementation~~  
~~Project file format serialization~~  
~~Placeholder UI~~  
~~Processing~~  
Batch processing (in dev)  
File watching  
Polished UI  

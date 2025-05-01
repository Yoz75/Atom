
# Atom<br>
![image](https://github.com/user-attachments/assets/f55d699e-aeaa-4e30-be0b-f0930e3b74eb)
<br>

Simple atoms-like simulation written in D (ignore C files, it's just raylib)<br>
By the way, Atom uses raylib as renderer: https://www.raylib.com/ <br>

Currently, you can change settings only from code, this will be fixed soon (or not soon)<br>

All particles interact with some force. Force is inversely proportional to the square of the distance.
There is some particle types, every type interact each other with different force (you can change count of types from code, by default, there is 3 types. 
Particles bounce from borders, but there is also friction that slows them down.
Every launch all particle types get their own **random** color. 

Actually, particles have no radius, they are just points, so radius of circles on the screen can be any value (you can change it from settings.d)

# Building
On Windows:
* build.bat - build debug
* buildr.bat - build release
* buildravx.bat build release with avx2 support (potencially this could improve perfomance)

Other OSs:<br>
Use "dub run" with --build debug/release/release-avx2 or rename .bat files, there is no OS-related things inside, only dub call ¯\(0_0)/¯

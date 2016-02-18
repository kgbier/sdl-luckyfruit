# luckyfruit by Konrad Biernacki (kgbier@gmail.com)
This isn't really anything special, just some C++ thrown together.
It uses SDL2, check it out [here](https://www.libsdl.org) (www.libsdl.org).

# Features
* It does some type of text rendering using a bitmap image.
* It has some windows you can drag around.

## planned features?
* nothing really...

# Dev environment
* Written on Windows using mingw32 and its g++.
* The makefile statically links some mingw32 dlls for executable portability.

# Build instructions
* On Windows using mingw32 run make.bat. 
* OR invoke make, it'll compile into an 'obj' folder and link into the 'bin' folder.

# Run instructions
* Make sure you have the bitmap font in the 'bin/res' directory.
* As this uses SDL2, (on Windows) ensure you have an up-to-date SDL.dll file next to the executable.
* Run the executable from the 'bin' directory.
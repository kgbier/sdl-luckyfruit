# luckyfruit by Konrad Biernacki (kgbier@gmail.com)
This isn't really anything special, just some C++ thrown together.
It uses SDL2, check it out [here](https://www.libsdl.org) (www.libsdl.org).

# Features
* It does some type of text rendering using a bitmap image.
* It has some windows you can drag around.

## Planned features?
* Bundling assets into a blob to pull in at load time
* Better layout system (Constraints? Flow layouts?)
* More widgets
* ...?

# Dev environment
* Written and tested on MacOS Mojave

# Build instructions
* Invoke `make`, it'll build the application into the `bin` folder.

# Run instructions
* As this uses SDL2, (on Windows) ensure you have an up-to-date SDL.dll file next to the executable.
* Run the executable from the `bin` directory.
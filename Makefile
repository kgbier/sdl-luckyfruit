#CC specifies which compiler we're using
CC = g++

#SOURCES specifies which files to compile as part of the project
SOURCES := $(wildcard src/*.cpp)
HEADERS := $(wildcard src/*.h)
OBJECTS := $(addprefix obj/,$(notdir $(SOURCES:.cpp=.o)))
TARGET = luckyfruit.exe

#INCLUDE_PATHS specifies the additional include paths we'll need
INCLUDE_PATHS = -IC:\sdl\SDL2-devel-mingw-2.0.4\i686-w64-mingw32\include\SDL2

#LIBRARY_PATHS specifies the additional library paths we'll need
LIBRARY_PATHS = -LC:\sdl\SDL2-devel-mingw-2.0.4\i686-w64-mingw32\lib

#If we want to distribute these files without trailing .dll files we need to embed some MINGW32 libraries, 
# since we used the MINGW32 g++ compiler
STATIC_LINK_MINGW32 = -static-libgcc -static-libstdc++

#COMPILER_FLAGS specifies the additional compilation options we're using
# -Wl,-subsystem,windows gets rid of the console window
COMPILER_FLAGS = -std=c++11 -Wall -pedantic -Werror -Wl,-subsystem,windows $(STATIC_LINK_MINGW32)

#LINKER_FLAGS specifies the libraries we're linking against
LINKER_FLAGS = -lmingw32 -lSDL2main -lSDL2

#This is the target that compiles our executable
all: directory bin/$(TARGET)
	
#Ensure the directory structure is legit (HUGE THANKS TO SOH <3 FOR REQUESTING THIS)
directory:
	mkdir -p bin obj src
	
#This is the target that links our objects
bin/$(TARGET): $(OBJECTS) $(SOURCES) $(HEADERS)
	$(CC) $(OBJECTS) $(COMPILER_FLAGS) $(LIBRARY_PATHS) $(LINKER_FLAGS) -o $@

#This is the target that compiles our objects
obj/%.o : src/%.cpp
	$(CC) $< -c $(COMPILER_FLAGS) $(INCLUDE_PATHS) -o $@

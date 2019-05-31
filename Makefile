# The compiler to use
CC = g++

# Which files to compile as part of the project
SOURCES := $(wildcard src/*.cpp)
HEADERS := $(wildcard src/*.h)
OBJECTS := $(addprefix obj/,$(notdir $(SOURCES:.cpp=.o)))
TARGET = luckyfruit

# Additional include paths we'll need
INCLUDE_PATHS = -I/usr/local/Cellar/sdl2/2.0.9_1/include/SDL2

# Additional library paths we'll need
LIBRARY_PATHS = -L/usr/local/Cellar/sdl2/2.0.9_1/lib

# Additional compilation flags we're using
# -Wl,-subsystem,windows will omit the console window on Windows
COMPILER_FLAGS = -std=c++11 -Wall -pedantic -Werror

# The libraries we're linking against
LINKER_FLAGS = -lSDL2main -lSDL2

# Target which compiles our executable
all: directory bundle bin/$(TARGET)

# Ensure the directory structure is legit (Credit: SOH)
directory:
	@mkdir -p bin bin/res obj src
	
# Bundle our assets for execution
bundle: bin
	@cp -r assets/* bin/res

# Link our objects
bin/$(TARGET): $(OBJECTS) $(SOURCES) $(HEADERS)
	$(CC) $(OBJECTS) $(COMPILER_FLAGS) $(LIBRARY_PATHS) $(LINKER_FLAGS) -o $@

# Compile our objects
obj/%.o : src/%.cpp
	$(CC) $< -c $(COMPILER_FLAGS) $(INCLUDE_PATHS) -o $@

# Clean our build directories
.PHONY: clean
clean:
	@rm -fr bin obj
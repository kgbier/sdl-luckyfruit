# The compiler to use
CC = g++

# Directories
BINDIR = bin
OBJDIR = obj
SRCDIR = src
RESDIR = $(BINDIR)/res

# Which files to compile as part of the project
SOURCES := $(wildcard src/*.cpp)
HEADERS := $(wildcard src/*.h)
OBJECTS := $(addprefix obj/,$(notdir $(SOURCES:.cpp=.o)))
TARGET = $(BINDIR)/luckyfruit

# Additional include paths we'll need
INCLUDE_PATHS = -I/opt/homebrew/Cellar/sdl2/2.30.4/include/SDL2

# Additional library paths we'll need
LIBRARY_PATHS = -L/opt/homebrew/Cellar/sdl2/2.30.4/lib

# Additional compilation flags we're using
# -Wl,-subsystem,windows will omit the console window on Windows
COMPILER_FLAGS = -std=c++11 -Wall -pedantic -Werror
CXXFLAGS = -O3

# The libraries we're linking against
LINKER_FLAGS = -lSDL2main -lSDL2

# Target which compiles our executable
all: $(TARGET)

# Link our objects
$(TARGET): $(OBJECTS) $(SOURCES) $(HEADERS)
	$(CC) $(OBJECTS) $(COMPILER_FLAGS) $(CXXFLAGS) $(LIBRARY_PATHS) $(LINKER_FLAGS) -o $@

# Compile our objects
$(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	$(CC) $< -c $(COMPILER_FLAGS) $(CXXFLAGS) $(INCLUDE_PATHS) -o $@

# Bundle our assets for execution
bundle: build_folders
	@cp -r assets/* $(RESDIR)

# Build and run
run: bundle $(TARGET)
	@./$(TARGET)

# Ensure the build_folders structure is legit (Credit: SOH)
build_folders:
	@mkdir -p bin bin/res obj src

# Clean our build directories
clean:
	@rm -fr bin obj

.PHONY: all bundle run build_folders clean

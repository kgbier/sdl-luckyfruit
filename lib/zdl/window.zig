const sdl = @import("sdl2").c;
const model = @import("model.zig");
const log = @import("std").log.scoped(.SDL_WINDOW);

pub const Window = @This();

sdlWindow: *sdl.SDL_Window,
bounds: model.Rect,

pub const WindowOptions = struct {
    width: i32,
    height: i32,
};

pub fn init(options: WindowOptions) !Window {
    log.debug("INITIALISING SDL_WINDOW", .{});

    const sdlWindow = sdl.SDL_CreateWindow(
        "luckyfruit",
        sdl.SDL_WINDOWPOS_UNDEFINED,
        sdl.SDL_WINDOWPOS_UNDEFINED,
        options.width,
        options.height,
        sdl.SDL_WINDOW_SHOWN | sdl.SDL_WINDOW_ALLOW_HIGHDPI | sdl.SDL_WINDOW_RESIZABLE,
    ) orelse {
        log.err("Window could not be created! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLWindowCreationFailed;
    };

    var bounds = model.Rect{};

    readWindowBounds(sdlWindow, &bounds);

    log.debug("WINDOW ({d}x{d}) INITIALISED", .{ bounds.w, bounds.h });

    return Window{
        .sdlWindow = sdlWindow,
        .bounds = bounds,
    };
}

pub fn deinit(self: *const Window) void {
    sdl.SDL_DestroyWindow(self.sdlWindow);
}

fn readWindowBounds(sdlWindow: *sdl.SDL_Window, inRect: *model.Rect) void {
    sdl.SDL_GetWindowSize(sdlWindow, &inRect.w, &inRect.h);
}

pub fn update(self: *Window) void {
    readWindowBounds(self.sdlWindow, &self.bounds);
}

const std = @import("std");
const log = std.log;

pub const Window = @import("window.zig");
pub const Renderer = @import("renderer.zig");
pub const Timer = @import("timer.zig");
pub const events = @import("events.zig");
pub const sdl2 = @import("sdl2").c;
pub const model = @import("model.zig");
pub const controller = @import("controller.zig");

pub fn initEverything() !void {
    if (sdl2.SDL_Init(sdl2.SDL_INIT_EVERYTHING) != 0) {
        log.err("SDL could not initialize! SDL_Error: {s}", .{sdl2.SDL_GetError()});
        return error.ZDLInitializationFailed;
    }
}

pub fn deinit() void {
    sdl2.SDL_Quit();
}

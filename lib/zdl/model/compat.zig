const sdl = @import("sdl2").c;

const Rect = @import("../model.zig").Rect;

pub inline fn rectToSdlRect(rect: *const Rect) sdl.SDL_Rect {
    return sdl.SDL_Rect{ .x = rect.x, .y = rect.y, .w = rect.w, .h = rect.h };
}

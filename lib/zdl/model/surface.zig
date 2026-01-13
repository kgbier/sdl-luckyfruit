const log = @import("std").log;
const sdl = @import("sdl2").c;
const compat = @import("compat.zig");

const model = @import("../model.zig");

const Surface = @This();

sdlSurface: *sdl.SDL_Surface,

pub fn fromBitmap(path: [:0]const u8) !Surface {
    const sdlSurf: *sdl.SDL_Surface = sdl.SDL_LoadBMP(path.ptr) orelse {
        return error.SDLSurfaceLoadBMPFailed;
    };
    return Surface{ .sdlSurface = sdlSurf };
}

pub fn init(width: u32, height: u32) !Surface {
    const depth = 32;
    const format = sdl.SDL_PIXELFORMAT_RGBA32;

    const sdlSurf = sdl.SDL_CreateRGBSurfaceWithFormat(
        0,
        @intCast(width),
        @intCast(height),
        depth,
        format,
    ) orelse {
        return error.SDLSurfaceCreateRGBFailed;
    };

    return Surface{ .sdlSurface = sdlSurf };
}

pub fn enableColourKey(self: Surface) !void {
    if (sdl.SDL_SetColorKey(self.sdlSurface, sdl.SDL_TRUE, 0x00000000) != 0) {
        log.err("Failed to set colour key: {s}", .{sdl.SDL_GetError()});
        return error.SDLSetColorKeyFailed;
    }
}

pub fn fill(self: Surface, colour: model.Colour) !void {
    try fillRect(self, null, colour);
}

pub fn fillRect(self: Surface, rectOrNull: ?*const model.Rect, colour: model.Colour) !void {
    const colourFormat = self.sdlSurface.format;
    const sdlColour = sdl.SDL_MapRGBA(colourFormat, colour.r, colour.g, colour.b, colour.a);

    const sdlRectOrNull = if (rectOrNull) |rect| &compat.rectToSdlRect(rect) else null;

    if (sdl.SDL_FillRect(self.sdlSurface, sdlRectOrNull, sdlColour) != 0) {
        log.err("Failed to fill rect: {s}", .{sdl.SDL_GetError()});
        return error.SDLFillRectFailed;
    }
}

pub fn deinit(self: Surface) void {
    sdl.SDL_FreeSurface(self.sdlSurface);
}

const model = @import("model.zig");

const sdl = @import("sdl2").c;
const std = @import("std");
const log = std.log.scoped(.SDL_RENDER);
const Window = @import("window.zig");

const compat = @import("model/compat.zig");

pub const Renderer = @This();

sdlRenderer: *sdl.SDL_Renderer,
bounds: model.Rect,

pub const RendererOptions = struct {
    window: *const Window.Window,
};

pub fn init(options: RendererOptions) !Renderer {
    log.debug("INITIALISING SDL_RENDERER", .{});

    const sdlRenderer = sdl.SDL_CreateRenderer(options.window.sdlWindow, -1, sdl.SDL_RENDERER_ACCELERATED) orelse {
        log.err("Renderer could not be created! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLRendererCreationFailed;
    };

    var bounds = model.Rect{};

    try readRendererOutputBounds(sdlRenderer, &bounds);
    try setRenderScale(options.window, sdlRenderer, &bounds);

    log.debug("RENDERER ({d}x{d}) INITIALISED", .{ bounds.w, bounds.h });

    return .{
        .sdlRenderer = sdlRenderer,
        .bounds = bounds,
    };
}

pub fn deinit(self: *const Renderer) void {
    sdl.SDL_DestroyRenderer(self.sdlRenderer);
}

pub fn readRendererOutputBounds(sdlRenderer: *sdl.SDL_Renderer, inRect: *model.Rect) !void {
    if (sdl.SDL_GetRendererOutputSize(sdlRenderer, &inRect.w, &inRect.h) != 0) {
        log.err("Renderer output size could not be fetched! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLRendererOutputSizeFailed;
    }
}

pub fn setRenderScale(
    window: *const Window,
    sdlRenderer: *sdl.SDL_Renderer,
    renderBounds: *const model.Rect,
) !void {
    if (renderBounds.w != window.bounds.w or renderBounds.h != window.bounds.h) {
        const scale_w = @as(f32, @floatFromInt(renderBounds.w)) / @as(f32, @floatFromInt(window.bounds.w));
        const scale_h = @as(f32, @floatFromInt(renderBounds.h)) / @as(f32, @floatFromInt(window.bounds.h));

        log.debug("SCALING SET ({d:.2}x{d:.2})", .{ scale_w, scale_h });

        if (sdl.SDL_RenderSetScale(sdlRenderer, scale_w, scale_h) != 0) {
            log.err("Renderer scale could not be set! SDL_Error: {s}", .{sdl.SDL_GetError()});
            return error.ZDLRenderScaleFailed;
        }
    }
}

pub fn setDrawColour(self: *const Renderer, colour: *const model.Colour) !void {
    if (sdl.SDL_SetRenderDrawColor(self.sdlRenderer, colour.r, colour.g, colour.b, colour.a) != 0) {
        log.err("Renderer draw color could not be set! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLRenderDrawColorFailed;
    }
}

pub fn fillRect(self: *const Renderer, rect: *const model.Rect) !void {
    if (sdl.SDL_RenderFillRect(self.sdlRenderer, &compat.rectToSdlRect(rect)) != 0) {
        log.err("Renderer rectangle could not be filled! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLRenderFillRectFailed;
    }
}

pub fn clear(
    self: *const Renderer,
) !void {
    if (sdl.SDL_RenderClear(self.sdlRenderer) != 0) {
        log.err("Renderer could not be cleared! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLRenderClearFailed;
    }
}

pub fn createTextureFromSurface(self: *const Renderer, surface: *const model.Surface) !model.Texture {
    const tex = sdl.SDL_CreateTextureFromSurface(self.sdlRenderer, surface.sdlSurface) orelse {
        log.err("Texture could not be created from surface! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLTextureCreationFailed;
    };

    return .{ .sdlTexture = tex };
}

pub fn renderCopy(
    self: *const Renderer,
    texture: *const model.Texture,
    sourceRect: ?*const model.Rect,
    destRect: ?*const model.Rect,
) !void {
    const sdlSourceOrNull = if (sourceRect) |rect| &compat.rectToSdlRect(rect) else null;
    const sdlDestOrNull = if (destRect) |rect| &compat.rectToSdlRect(rect) else null;

    if (sdl.SDL_RenderCopy(self.sdlRenderer, texture.sdlTexture, sdlSourceOrNull, sdlDestOrNull) != 0) {
        log.err("Texture could not be copied to renderer! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLRenderCopyFailed;
    }
}

pub fn renderLine(
    self: *const Renderer,
    first_point: *const model.Point,
    second_point: *const model.Point,
) !void {
    if (sdl.SDL_RenderDrawLine(
        self.sdlRenderer,
        first_point.x,
        first_point.y,
        second_point.x,
        second_point.y,
    ) != 0) {
        log.err("Line could not be drawn! SDL_Error: {s}", .{sdl.SDL_GetError()});
        return error.ZDLRenderLineFailed;
    }
}

pub fn present(self: *const Renderer) void {
    sdl.SDL_RenderPresent(self.sdlRenderer);
}

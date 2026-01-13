const fmt = @import("std").fmt;
const zdl = @import("zdl");

const graphics = @import("../../../graphics/index.zig");
const engine = @import("../../../engine/index.zig");
const fps = engine.fps;

const Fps = @This();

const FPS_STR_BUFF_SIZE = 16;
var fps_str_buffer: [FPS_STR_BUFF_SIZE]u8 = undefined;
var fps_str: []u8 = fps_str_buffer[0..0];

pub fn update(_: *Fps) !void {
    // ...
}

pub fn draw(_: *Fps) !void {
    const padding = 10;
    const textSize = .subtitle;

    fps_str = try fmt.bufPrint(&fps_str_buffer, "{d:.2} FPS", .{fps.fps});

    const textWidth = graphics.text.measureWidth(fps_str, textSize);
    try graphics.text.printFast(fps_str, @as(i32, @intCast(engine.window.bounds.w)) - textWidth - padding, padding, textSize);
}

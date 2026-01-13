const fmt = @import("std").fmt;
const zdl = @import("zdl");

const engine = @import("../../../engine/index.zig");

const Checkboard = @This();

const staticscope = struct {
    const checkerboard_size: i32 = 20;
    const overdraw: i32 = 1;
    const checkerboard = zdl.model.Colour{ .r = 0x0F, .g = 0x0F, .b = 0x0F };
    var running_offset: i32 = 0;
};

pub fn update(_: *Checkboard) !void {
    if (staticscope.running_offset >= staticscope.checkerboard_size) {
        staticscope.running_offset = 0;
    } else {
        staticscope.running_offset = (staticscope.running_offset + 1);
    }
}

pub fn draw(_: *Checkboard) !void {
    // Overdraw applies equally to opposing sides
    const overdraw_count = staticscope.overdraw * 2;

    const h_board_count = @divTrunc(engine.window.bounds.w, staticscope.checkerboard_size) + overdraw_count;
    const v_board_count = @divTrunc(engine.window.bounds.h, staticscope.checkerboard_size) + overdraw_count;

    try engine.renderer.setDrawColour(&staticscope.checkerboard);

    for (0..@intCast(h_board_count)) |x_i| {
        inner: for (0..@intCast(v_board_count)) |y_i| {
            const skip_checkerboard_square = (x_i + y_i) % 2 == 0;

            if (skip_checkerboard_square) continue :inner;

            const x_square: i32 = @intCast(x_i);
            const y_square: i32 = @intCast(y_i);

            const x_pos: i32 = ((x_square - staticscope.overdraw) * staticscope.checkerboard_size) + staticscope.running_offset;
            const y_pos: i32 = ((y_square - staticscope.overdraw) * staticscope.checkerboard_size) + staticscope.running_offset;

            try engine.renderer.fillRect(&.{
                .x = x_pos,
                .y = y_pos,
                .w = staticscope.checkerboard_size,
                .h = staticscope.checkerboard_size,
            });
        }
    }
}

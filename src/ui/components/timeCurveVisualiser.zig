const zdl = @import("zdl");
const Point = zdl.model.Point;

const engine = @import("../../engine/index.zig");

const ui = @import("../ui.zig");

pub fn timeCurveVisualiser(_: ui.UIConfig, curve: *const fn (t: f32) f32) !void {
    const parent_layout = ui.uiState.layout.getLastOrNull().?;

    const scale = 0.5;

    const full_width = parent_layout.bounds.w - parent_layout.padding * 2;

    const full_height: i32 = parent_layout.bounds.h - parent_layout.padding * 2;
    const full_height_f: f32 = @floatFromInt(full_height);
    const height_f: f32 = full_height_f * scale;
    const height: i32 = @intFromFloat(height_f);
    const height_offset = @divTrunc(full_height - height, 2);

    const iterations = 32;
    const start_time: f32 = 0.0;
    const end_time: f32 = 1.0;
    const step: f32 = (end_time - start_time) / iterations;

    var time: f32 = 0.0 + step;

    // Start in the bottom left corner of the layout
    const origin_point_full = Point{
        .x = parent_layout.bounds.x + parent_layout.padding,
        .y = parent_layout.bounds.y + parent_layout.padding + full_height,
    };

    const limit_point_full = Point{
        .x = parent_layout.bounds.x + parent_layout.padding + full_width,
        .y = parent_layout.bounds.y + parent_layout.padding,
    };

    const origin_point = Point{
        .x = origin_point_full.x,
        .y = origin_point_full.y - height_offset,
    };

    const limit_point = Point{
        .x = limit_point_full.x,
        .y = limit_point_full.y + height_offset,
    };

    var last_point = origin_point;

    try engine.renderer.setDrawColour(&.{ .r = 0x80, .g = 0x80, .b = 0x80 });

    try engine.renderer.renderLine(&origin_point_full, &.{ .x = limit_point_full.x, .y = origin_point_full.y });
    try engine.renderer.renderLine(&.{ .x = origin_point_full.x, .y = limit_point_full.y }, &limit_point_full);

    try engine.renderer.setDrawColour(&.{ .r = 0x60, .g = 0x60, .b = 0x60 });

    try engine.renderer.renderLine(&origin_point, &.{ .x = limit_point.x, .y = origin_point.y });
    try engine.renderer.renderLine(&.{ .x = origin_point.x, .y = limit_point.y }, &limit_point);

    try engine.renderer.setDrawColour(&.{ .r = 0xFF, .g = 0xFF, .b = 0xFF });

    for (0..iterations) |_| {
        const value = curve(time);
        const next_point = Point{
            .x = origin_point.x + @as(i32, @intFromFloat(time * @as(f32, @floatFromInt(full_width)))),
            .y = origin_point.y - @as(i32, @intFromFloat(value * @as(f32, @floatFromInt(height)))),
        };

        try engine.renderer.renderLine(&last_point, &next_point);

        last_point = next_point;
        time += step;
    }
}

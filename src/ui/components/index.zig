pub const button = @import("button.zig").button;
pub const text = @import("text.zig").text;
pub const timeCurveVisualiser = @import("timeCurveVisualiser.zig").timeCurveVisualiser;
pub const window = @import("window.zig").window;

pub const ComponentState = union {
    window: @import("window.zig").WindowState,
};

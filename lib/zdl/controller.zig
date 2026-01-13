const events = @import("events.zig");

pub const MouseState = @import("controller/mousestate.zig");

pub const Controller = @This();

mouseState: MouseState = .{},

pub fn update(self: *Controller) void {
    events.latestMouseState(&self.mouseState);
}

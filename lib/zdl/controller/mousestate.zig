const Point = @import("../model.zig").Point;

pub const ButtonState = struct {
    down: bool = false,
    hold: bool = false,
    up: bool = false,

    pub fn update(self: *ButtonState, down: bool) void {
        const wasDownBefore = (self.down or self.hold);

        self.down = down and !wasDownBefore;
        self.hold = down and wasDownBefore;
        self.up = !down and wasDownBefore;
    }
};

position: Point = .{ .x = -1, .y = -1 },
leftButton: ButtonState = .{},
rightButton: ButtonState = .{},

const Point = @import("point.zig");
const Rect = @This();

x: i32 = 0,
y: i32 = 0,
w: i32 = 0,
h: i32 = 0,

pub fn intersectsRect(self: *const Rect, other: *const Rect) bool {
    return self.x < other.x + other.w and
        self.x + self.w > other.x and
        self.y < other.y + other.h and
        self.y + self.h > other.y;
}

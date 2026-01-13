const Rect = @import("rect.zig");

const Point = @This();

x: i32 = 0,
y: i32 = 0,

pub fn intersectsRect(self: *const Point, rect: *const Rect) bool {
    return self.x >= rect.x and
        self.x <= rect.x + rect.w and
        self.y >= rect.y and
        self.y <= rect.y + rect.h;
}

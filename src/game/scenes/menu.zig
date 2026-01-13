const zdl = @import("zdl");

const graphics = @import("../../graphics/index.zig");

const Menu = @This();

pub fn update(_: *Menu) !void {
    // ...
}

pub fn draw(_: *Menu) !void {
    // try Graphics.Text.printFast("Hello Sailor!", 10, 10, .heading);
    // try Graphics.Text.printFast("Hello Sailor!", 10, 50, .body);
}

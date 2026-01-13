const std = @import("std");
const zdl = @import("zdl");

const Rect = zdl.model.Rect;
const Point = zdl.model.Point;

const imid = @import("imid.zig");
const ui = @import("ui.zig");

pub const ComponentBoundsStack = std.array_list.Managed(Bounds);
pub const LayoutStack = std.array_list.Managed(Layout);

pub const Layout = struct {
    bounds: *const Rect,
    padding: i32,
    cursor: Point = .{},
};

pub const Bounds = struct {
    id: ?imid.IMID,
    rect: Rect,
};

pub fn getLayoutCursor() !Point {
    const layout = ui.uiState.layout.getLastOrNull() orelse return error.LayoutNotFound;
    return .{
        .x = layout.bounds.x + layout.cursor.x + layout.padding,
        .y = layout.bounds.y + layout.cursor.y + layout.padding,
    };
}

pub fn updateLayoutCursor(size: i32) !void {
    var layout = &ui.uiState.layout.items[ui.uiState.layout.items.len - 1];
    layout.cursor.y += size + layout.padding;
}

const zdl = @import("zdl");

const graphics = @import("../../graphics/index.zig");

const ui = @import("../ui.zig");

pub fn text(_: ui.UIConfig, label: []const u8) !void {
    const style = graphics.text.TextSize.subtitle;

    const layoutCursor = try ui.getLayoutCursor();
    const parent_layout = ui.uiState.layout.getLastOrNull().?;

    const width = parent_layout.bounds.w - parent_layout.padding * 2;

    try graphics.text.print(label, layoutCursor.x, layoutCursor.y, width, style);

    const height = graphics.text.measureHeight(label, width, style);
    try ui.updateLayoutCursor(height);
}

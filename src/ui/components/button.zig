const zdl = @import("zdl");
const Rect = zdl.model.Rect;

const engine = @import("../../engine/index.zig");
const graphics = @import("../../graphics/index.zig");
const assets = @import("../../game/index.zig").assets;

const ui = @import("../ui.zig");
const imid = @import("../imid.zig");
const layout = @import("../layout.zig");

pub fn button(config: ui.UIConfig, label: []const u8) !bool {
    const id = imid.getIMID(config.identifier);

    var clicked = false;

    const isHot = ui.uiState.hotComponent == id;
    const isActive = ui.uiState.activeComponent == id;

    const Decoration = struct {
        texture: zdl.model.Texture,
        offset: i32,
    };

    const decoration: Decoration = if (isActive) .{
        .texture = try assets.getTexture(.frame),
        .offset = 1,
    } else if (isHot) .{
        .texture = try assets.getTexture(.buttonHover),
        .offset = -1,
    } else .{
        .texture = try assets.getTexture(.button),
        .offset = 0,
    };

    if (isActive and ui.uiState.mouse.leftButton.up) {
        clicked = true;
    }

    const buttonTextStyle: graphics.text.TextSize = .subtitle;
    const padding = 8;
    const minWidth = 40;
    const minHeight = 6;

    const contentWidth = graphics.text.measureWidth(label, buttonTextStyle);

    const width = if (contentWidth > minWidth) contentWidth else minWidth;

    const layoutCursor = try layout.getLayoutCursor();

    const location = Rect{
        .x = layoutCursor.x + decoration.offset,
        .y = layoutCursor.y + decoration.offset,
        .w = width + padding * 2,
        .h = minHeight + padding * 2,
    };

    try engine.renderer.renderCopy(&decoration.texture, null, &location);
    try graphics.text.printFast(label, location.x + padding, location.y + padding, buttonTextStyle);

    try ui.uiState.bounds.append(.{ .id = id, .rect = location });

    try layout.updateLayoutCursor(location.h);

    return clicked;
}

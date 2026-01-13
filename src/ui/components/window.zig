const zdl = @import("zdl");
const Rect = zdl.model.Rect;
const Point = zdl.model.Point;

const engine = @import("../../engine/index.zig");
const graphics = @import("../../graphics/index.zig");
const assets = @import("../../game/index.zig").assets;

const ui = @import("../ui.zig");
const imid = @import("../imid.zig");
const layout = @import("../layout.zig");

pub const WindowState = struct {
    frame: Rect,
    handle: Rect,
    pane: Rect,
    grabPoint: ?Point = null,
};

pub fn window(config: ui.UIConfig, label: []const u8, initialFrame: Rect) !void {
    const id = imid.getIMID(config.identifier);

    const frameBorder = 2;
    const handleHeight = 20;
    const shadowTexture = try assets.getTexture(.shadow);
    const windowTexture = try assets.getTexture(.frame);
    const backgroundTexture = try assets.getTexture(.background);
    const shadowOffset = 5;

    const result = try ui.uiState.components.getOrPut(id);
    if (!result.found_existing) {
        result.value_ptr.* = .{ .window = WindowState{
            .frame = initialFrame,
            .handle = .{
                .x = initialFrame.x,
                .y = initialFrame.y,
                .w = initialFrame.w,
                .h = handleHeight + frameBorder,
            },
            .pane = .{
                .x = initialFrame.x + frameBorder,
                .y = initialFrame.y + handleHeight + frameBorder,
                .w = initialFrame.w - frameBorder * 2,
                .h = initialFrame.h - handleHeight - frameBorder * 2,
            },
        } };
    }
    var state = &result.value_ptr.window;

    try ui.uiState.layout.append(.{
        .bounds = &state.pane,
        .padding = ui.CONTENT_PADDING,
    });

    const isActive = ui.uiState.activeComponent == id;

    if (isActive) {
        if (state.grabPoint == null) {
            state.grabPoint = Point{
                .x = ui.uiState.mouse.position.x - state.frame.x,
                .y = ui.uiState.mouse.position.y - state.frame.y,
            };
        }

        const deltax = (ui.uiState.mouse.position.x - state.grabPoint.?.x) - state.frame.x;
        const deltay = (ui.uiState.mouse.position.y - state.grabPoint.?.y) - state.frame.y;

        state.frame.x = state.frame.x + deltax;
        state.frame.y = state.frame.y + deltay;
        state.pane.x = state.pane.x + deltax;
        state.pane.y = state.pane.y + deltay;
        state.handle.x = state.handle.x + deltax;
        state.handle.y = state.handle.y + deltay;
    } else {
        state.grabPoint = null;
    }

    var frame = state.frame;

    frame.x += shadowOffset;
    frame.y += shadowOffset;

    // Draw the window shadow behind
    try engine.renderer.renderCopy(&shadowTexture, null, &frame);

    frame.x -= shadowOffset;
    frame.y -= shadowOffset;

    // Draw the window background
    try engine.renderer.renderCopy(&windowTexture, null, &frame);

    try graphics.text.printFast(label, frame.x + 5, frame.y + 7, .subtitle);

    try engine.renderer.renderCopy(&backgroundTexture, null, &state.pane);

    // add pane to bounds stack
    try ui.uiState.bounds.append(layout.Bounds{ .id = id, .rect = state.handle });
}

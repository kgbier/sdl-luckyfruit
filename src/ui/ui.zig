const std = @import("std");
const zdl = @import("zdl");
const Rect = zdl.model.Rect;
const Controller = zdl.controller.Controller;

const components = @import("components/index.zig");
const imid = @import("imid.zig");
const layout = @import("layout.zig");

pub const CONTENT_PADDING = 4;

const UIState = struct {
    mouse: Controller.MouseState = .{},

    // A map of all stateful component data, accessible by instance GID
    components: ComponentStateHashMap,

    // A stack of all component bounding boxes, back-to-front
    bounds: layout.ComponentBoundsStack,

    // A stack of layout cursors, used to track the current layout position
    layout: layout.LayoutStack,

    // A "Hot" component is one that the mouse is currently hovering over
    hotComponent: ?imid.IMID = null,
    // An "Active" component is one that the mouse is currently clicking on
    activeComponent: ?imid.IMID = null,
};

pub const UIConfig = struct {
    identifier: imid.IMIDType = .auto,
};

pub var uiState: UIState = undefined;

const ComponentStateHashMap = std.AutoHashMap(imid.IMID, components.ComponentState);

pub fn init() void {
    uiState = UIState{
        .components = ComponentStateHashMap.init(std.heap.page_allocator),
        .bounds = layout.ComponentBoundsStack.init(std.heap.page_allocator),
        .layout = layout.LayoutStack.init(std.heap.page_allocator),
    };
}

pub fn deinit() void {
    uiState.components.deinit();
}

pub fn start(canvas: *const Rect, controller: *const Controller) !void {
    uiState.mouse = controller.mouseState;

    // Add an initial layout
    try uiState.layout.append(.{ .bounds = canvas, .padding = CONTENT_PADDING });
}

pub fn end() void {
    // clear hot/active components
    uiState.hotComponent = null;
    uiState.activeComponent = null;

    // walk the bounds stack and assign hot/active components
    while (uiState.bounds.pop()) |bounds| {
        if (uiState.mouse.position.intersectsRect(&bounds.rect)) {
            uiState.hotComponent = bounds.id;

            if (uiState.mouse.leftButton.down or uiState.mouse.leftButton.hold) {
                uiState.activeComponent = bounds.id;
            }

            // the remaining bounding boxes will be ignored
            break;
        }
    }

    // clear the bounds stack
    uiState.bounds.clearAndFree();
}

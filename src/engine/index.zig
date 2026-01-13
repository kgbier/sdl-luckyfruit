const zdl = @import("zdl");

pub const AnyAssetLibrary = @import("assetlibrary.zig").AnyAssetLibrary;

const scenemanager = @import("scenemanager.zig");
pub const SceneManager = scenemanager.SceneManager;
pub const CompositeScene = scenemanager.CompositeScene;

const DEFAULT_SIZE = .{ .width = 800, .height = 600 };

pub var window: zdl.Window = undefined;
pub var renderer: zdl.Renderer = undefined;

pub fn init() !void {
    try zdl.initEverything();

    window = try zdl.Window.init(.{ .width = DEFAULT_SIZE.width, .height = DEFAULT_SIZE.height });

    renderer = try zdl.Renderer.init(.{ .window = &window });
}

pub fn deinit() void {
    renderer.deinit();
    window.deinit();
    zdl.deinit();
}

pub fn updateWindow() void {
    window.update();
}

pub const fps = @import("framerate.zig");

const std = @import("std");
const engine = @import("../engine/index.zig");

const SceneManager = engine.SceneManager(Scenes);
const CompositeScene = engine.CompositeScene(Scenes);

const scenes = @import("scenes/index.zig");

pub const Scenes = union(enum) {
    composite: CompositeScene,

    menu: scenes.Menu,
    game: scenes.Game,

    fps: scenes.util.FPS,
    checkerboard: scenes.util.Checkerboard,

    pub fn update(self: *Scenes) !void {
        switch (self.*) {
            inline else => |*impl| return try impl.update(),
        }
    }

    pub fn draw(self: *Scenes) !void {
        switch (self.*) {
            inline else => |*impl| return impl.draw(),
        }
    }
};

pub fn init() !SceneManager {
    var overlayScenes = std.array_list.Managed(Scenes).init(std.heap.page_allocator);
    try overlayScenes.append(Scenes.checkerboard);
    try overlayScenes.append(Scenes.fps);

    return SceneManager{
        .foreground = Scenes{ .game = scenes.Game{} },
        .overlay = Scenes{
            .composite = CompositeScene{ .scenes = overlayScenes.items },
        },
    };
}

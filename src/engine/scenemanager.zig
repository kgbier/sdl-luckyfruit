pub fn SceneManager(comptime Scenes: type) type {
    return struct {
        overlay: ?Scenes = null,
        foreground: Scenes,

        const Self = @This();

        pub fn update(self: *Self) !void {
            try self.foreground.update();
            if (self.overlay) |*overlay| try overlay.update();
        }

        pub fn draw(self: *Self) !void {
            try self.foreground.draw();
            if (self.overlay) |*overlay| try overlay.draw();
        }
    };
}

pub fn CompositeScene(comptime Scenes: type) type {
    return struct {
        scenes: []Scenes,

        const Self = @This();

        pub fn update(self: *Self) anyerror!void {
            for (self.scenes) |*scene| {
                try scene.update();
            }
        }

        pub fn draw(self: *Self) anyerror!void {
            for (self.scenes) |*scene| {
                try scene.draw();
            }
        }
    };
}

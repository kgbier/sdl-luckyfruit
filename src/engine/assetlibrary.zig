const std = @import("std");
const zdl = @import("zdl");

const engine = @import("../engine/index.zig");

const Surface = zdl.model.Surface;
const Colour = zdl.model.Colour;

pub fn AnyAssetLibrary(comptime T: type) type {
    return struct {
        library: std.AutoHashMap(T, zdl.model.Texture),

        const Self = @This();

        pub fn init() !Self {
            return .{
                .library = std.AutoHashMap(T, zdl.model.Texture).init(std.heap.page_allocator),
            };
        }

        pub fn deinit(self: *Self) void {
            var textures = self.library.valueIterator();
            while (textures.next()) |texture| {
                texture.deinit();
            }
            self.library.deinit();
        }

        pub fn getTexture(self: *const Self, key: T) !zdl.model.Texture {
            return self.library.get(key) orelse error.TextureNotFound;
        }
    };
}

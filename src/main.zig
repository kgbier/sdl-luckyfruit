const std = @import("std");
const log = std.log;
const zdl = @import("zdl");
const c = zdl.sdl2;

const graphics = @import("graphics/index.zig");
const engine = @import("engine/index.zig");
const game = @import("game/index.zig");
const ui = @import("ui/index.zig");

const Colour = zdl.model.Colour;
const Controller = zdl.controller.Controller;

const WALLPAPER_RGB = Colour{ .r = 0x15, .g = 0x15, .b = 0x15 };

pub fn main() !void {
    log.debug("INITIALISING SDL", .{});

    try engine.init();
    defer engine.deinit();

    log.debug("STARTING MAIN LOOP", .{});
    var quit = false;

    try game.assets.init();
    defer game.assets.deinit();

    ui.init();
    defer ui.deinit();

    var controller = Controller{};

    var sceneManager = try game.scenes.init();

    // Main Loop
    while (!quit) {

        // Update
        controller.update();

        // -- Record Events
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            controller.update();
            switch (event.type) {
                c.SDL_WINDOWEVENT => {
                    if (event.window.event == c.SDL_WINDOWEVENT_RESIZED or
                        event.window.event == c.SDL_WINDOWEVENT_RESIZED)
                    {
                        engine.updateWindow();
                    }
                },
                c.SDL_QUIT => quit = true,
                else => {},
            }
        }

        // -- Update Scenes
        try sceneManager.update();

        // Draw

        const bg = struct {
            var on = false;
            var active: Colour = WALLPAPER_RGB;

            const wallpaper1: Colour = WALLPAPER_RGB;
            const wallpaper2: Colour = .{ .r = 0x25, .g = 0x25, .b = 0x35 };
        };

        // -- Render Clear
        try engine.renderer.setDrawColour(&bg.active);
        try engine.renderer.clear();

        // -- Draw Scenes
        try sceneManager.draw();

        try ui.start(&engine.window.bounds, &controller);

        try ui.components.window(.{}, "Main", zdl.model.Rect{ .x = 10, .y = 10, .w = 240, .h = 180 });
        if (try ui.components.button(.{}, "Hello, Sailor!")) {
            bg.on = !bg.on;
            bg.active = if (bg.on) bg.wallpaper2 else bg.wallpaper1;
        }

        const staticmem = struct {
            var buf: [64]u8 = undefined;
        };

        for (0..4) |i| {
            const string = try std.fmt.bufPrint(&staticmem.buf, "Repeat {}", .{i});
            _ = try ui.components.button(.{ .identifier = .{ .index = i } }, string);
        }

        try ui.components.window(.{}, "ease in", zdl.model.Rect{ .x = 10, .y = 200, .w = 240, .h = 180 });
        try ui.components.timeCurveVisualiser(.{}, &game.curves.easeIn);

        try ui.components.window(.{}, "ease out", zdl.model.Rect{ .x = 40, .y = 200, .w = 240, .h = 180 });
        try ui.components.timeCurveVisualiser(.{}, &game.curves.easeOut);

        try ui.components.window(.{}, "ease in out", zdl.model.Rect{ .x = 70, .y = 200, .w = 240, .h = 180 });
        try ui.components.timeCurveVisualiser(.{}, &game.curves.easeInOut);

        try ui.components.window(.{}, "ease out bounce", zdl.model.Rect{ .x = 100, .y = 200, .w = 240, .h = 180 });
        try ui.components.timeCurveVisualiser(.{}, &game.curves.easeOutBounce);

        try ui.components.window(.{}, "ease out elastic", zdl.model.Rect{ .x = 130, .y = 200, .w = 240, .h = 180 });
        try ui.components.timeCurveVisualiser(.{}, &game.curves.easeOutElastic);

        ui.end();

        // -- Present Backbuffer
        engine.renderer.present();

        engine.fps.tick();
    }
}

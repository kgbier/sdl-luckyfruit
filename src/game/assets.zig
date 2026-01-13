const std = @import("std");
const zdl = @import("zdl");

const engine = @import("../engine/index.zig");

const Surface = zdl.model.Surface;
const Colour = zdl.model.Colour;

const BG_RGB = Colour{ .r = 0x44, .g = 0x44, .b = 0x44 };
const SHADOW_RGBA = Colour{ .r = 0x00, .g = 0x00, .b = 0x00, .a = 0x55 };
const FRAME_RGB = Colour{ .r = 0x25, .g = 0x25, .b = 0x25 };
const BUTTON_RGB = Colour{ .r = 0x33, .g = 0x33, .b = 0x33 };
const BUTTON_HOVER_RGB = Colour{ .r = 0x80, .g = 0x80, .b = 0x80 };

const Assets = enum {
    background,
    shadow,
    frame,
    button,
    buttonHover,
    fontmap,
};

const AssetLibrary = engine.AnyAssetLibrary(Assets);

var assets: AssetLibrary = undefined;

pub fn init() !void {
    assets = try AssetLibrary.init();

    var surf = try Surface.fromBitmap("assets/font.bmp");
    // Mark black as our transparent colour
    try surf.enableColourKey();
    try assets.library.put(.fontmap, try engine.renderer.createTextureFromSurface(&surf));

    surf.deinit();

    surf = try Surface.init(1, 1); // make a blank surface
    defer surf.deinit();

    try surf.fill(BG_RGB);
    try assets.library.put(.background, try engine.renderer.createTextureFromSurface(&surf));

    try surf.fill(SHADOW_RGBA);
    try assets.library.put(.shadow, try engine.renderer.createTextureFromSurface(&surf));

    try surf.fill(FRAME_RGB);
    try assets.library.put(.frame, try engine.renderer.createTextureFromSurface(&surf));

    try surf.fill(BUTTON_RGB);
    try assets.library.put(.button, try engine.renderer.createTextureFromSurface(&surf));

    try surf.fill(BUTTON_HOVER_RGB);
    try assets.library.put(.buttonHover, try engine.renderer.createTextureFromSurface(&surf));
}

pub fn deinit() void {
    assets.deinit();
}

pub fn getTexture(asset: Assets) !zdl.model.Texture {
    return assets.library.get(asset) orelse error.TextureNotFound;
}

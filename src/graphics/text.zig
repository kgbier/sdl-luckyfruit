const zdl = @import("zdl");

const engine = @import("../engine/index.zig");

const Rect = zdl.model.Rect;

const ROWMASK = 0xF0;
const COLMASK = 0x0F;

const MINCHAR: u8 = 0x20;
const MAXCHAR: u8 = 0x7E;

const PLACEHOLDER_X = 106;
const PLACEHOLDER_Y = 49;

// Where our first sprite (0,0) appears in the ASCII character list
const SPRITE_SHEET_OFFSET = 0x20;

const CHAR_WIDTH = 6;
const CHAR_HEIGHT = 7;
const LINE_SPACING = 2;

// Px. Distance between characters in the spritesheet
const GUIDE_OFFSET = 1;
// Px. Distance to leave between characters when drawing
const KERN_OFFSET = 1;

var readcursor = Rect{
    .x = undefined,
    .y = undefined,
    .w = CHAR_WIDTH,
    .h = CHAR_HEIGHT,
};

var writecursor = Rect{
    .x = undefined,
    .y = undefined,
    .w = CHAR_WIDTH,
    .h = CHAR_HEIGHT,
};

fn alignReadCursor(c: u8) void {
    //If the character is out of range (READ: not supported) switch to our placeholder character
    if (c < MINCHAR or c > MAXCHAR) {
        readcursor.x = PLACEHOLDER_X;
        readcursor.y = PLACEHOLDER_Y;
        return;
    }

    const pos = c - SPRITE_SHEET_OFFSET; // 0x20 = 0x00 | 0x23 = 0x03
    const row = (pos & ROWMASK) >> 4; // shift half a byte to the right
    const col = pos & COLMASK;

    readcursor.x = GUIDE_OFFSET + (col * (CHAR_WIDTH + GUIDE_OFFSET));
    readcursor.y = GUIDE_OFFSET + (row * (CHAR_HEIGHT + GUIDE_OFFSET));
}

const assetLibrary = @import("../game/index.zig").assets;

pub const TextSize = enum {
    heading,
    body,
    subtitle,

    pub fn scale(self: TextSize) f32 {
        return switch (self) {
            .subtitle => 1.2,
            .body => 1.8,
            .heading => 2.4,
        };
    }
};

fn scaleSize(size: comptime_int, scale: f32) i32 {
    return @intFromFloat(@round(size * scale));
}

pub fn measureWidth(string: []const u8, size: TextSize) i32 {
    const scale = size.scale();
    const length: i32 = @intCast(string.len);

    const charWidth = scaleSize(CHAR_WIDTH, scale);
    const kerningWidth = scaleSize(KERN_OFFSET, scale);

    return (length * charWidth) + (length * kerningWidth); // TODO: should we omit the last kerning offset?
}

pub fn measureHeight(string: []const u8, maxWidth: i32, size: TextSize) i32 {
    const scale = size.scale();
    const length: i32 = @intCast(string.len);

    const charWidth = scaleSize(CHAR_WIDTH, scale);
    const kerningWidth = scaleSize(KERN_OFFSET, scale);

    const totalWidth = length * (charWidth + kerningWidth);

    // lineCount is guaranteed to be at least one
    const lineCount = @divFloor(totalWidth, maxWidth) + 1;
    const lineHeight = scaleSize(CHAR_HEIGHT, scale);

    return (lineCount * lineHeight) + ((lineCount - 1) * LINE_SPACING);
}

pub fn printFast(string: []const u8, x: i32, y: i32, size: TextSize) !void {
    const scale = size.scale();

    const charWidth = scaleSize(CHAR_WIDTH, scale);
    const charHeight = scaleSize(CHAR_HEIGHT, scale);

    writecursor.x = x;
    writecursor.y = y;
    writecursor.w = charWidth;
    writecursor.h = charHeight;

    const kerning = scaleSize(KERN_OFFSET, scale);

    for (string) |char| {
        alignReadCursor(char);
        try engine.renderer.renderCopy(&(try assetLibrary.getTexture(.fontmap)), &readcursor, &writecursor);
        writecursor.x += charWidth + kerning;
    }
}

pub fn print(string: []const u8, x: i32, y: i32, maxWidth: i32, size: TextSize) !void {
    const scale = size.scale();

    const charWidth = scaleSize(CHAR_WIDTH, scale);
    const charHeight = scaleSize(CHAR_HEIGHT, scale);

    writecursor.x = x;
    writecursor.y = y;
    writecursor.w = charWidth;
    writecursor.h = charHeight;

    const kerning = scaleSize(KERN_OFFSET, scale);

    const stride = charWidth + kerning;

    var writtenlength: i32 = 0;

    for (string) |char| {
        alignReadCursor(char);
        try engine.renderer.renderCopy(&(try assetLibrary.getTexture(.fontmap)), &readcursor, &writecursor);
        writtenlength += stride;
        if (writtenlength + charWidth < maxWidth) {
            writecursor.x += stride;
        } else {
            writtenlength = 0;
            writecursor.x = x;
            writecursor.y += charHeight + LINE_SPACING;
        }
    }
}

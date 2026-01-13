const sdl = @import("sdl2").c;

const Texture = @This();

sdlTexture: *sdl.SDL_Texture,

pub fn deinit(self: *const Texture) void {
    sdl.SDL_DestroyTexture(self.sdlTexture);
}

const sdl = @import("sdl2").c;

pub fn getTicks() u32 {
    return sdl.SDL_GetTicks();
}

pub fn delay(milliseconds: u32) void {
    sdl.SDL_Delay(milliseconds);
}

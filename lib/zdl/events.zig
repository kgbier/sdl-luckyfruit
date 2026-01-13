const sdl = @import("sdl2").c;
const Controller = @import("controller.zig").Controller;

pub fn latestMouseState(state: *Controller.MouseState) void {
    const buttonMask = sdl.SDL_GetMouseState(&state.position.x, &state.position.y);

    state.leftButton.update(buttonMask & sdl.SDL_BUTTON_LMASK != 0);
    state.rightButton.update(buttonMask & sdl.SDL_BUTTON_RMASK != 0);
}

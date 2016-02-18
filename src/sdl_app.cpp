#include "sdl_app.h"

void sdl_app::init() {
   renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
   SDL_SetRenderDrawColor(renderer, WALLPAPER_RGB, 0xFF);
   assets = new AssetManager();
   fps = new FrameRate();
   txt = new TextRenderer(); // depends on asset manager
}
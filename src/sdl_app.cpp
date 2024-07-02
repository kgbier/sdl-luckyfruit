#include "sdl_app.h"

bool sdl_app::init() {
   printf("DEBUG: INITIALISING SDL_WINDOW\n");
   window = SDL_CreateWindow(
      "LUCKYFRUIT", 
      SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 
      SCREEN_WIDTH, SCREEN_HEIGHT, 
      SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI);

   if(window == NULL) {
      printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );
      return false;
   }

   SDL_GetWindowSize(window, &window_w, &window_h);
   printf("DEBUG: WINDOW (%dx%d) INITIALISED\n", window_w, window_h);

   renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
   SDL_GetRendererOutputSize(app->renderer, &renderer_w, &renderer_h);
   printf("DEBUG: RENDERER (%dx%d) INITIALISED\n", renderer_w, renderer_h);

   if(renderer_w != SCREEN_WIDTH || renderer_h != SCREEN_HEIGHT) {
      float scale_w = (float)renderer_w / (float)SCREEN_WIDTH;
      float scale_h = (float)renderer_h / (float)SCREEN_HEIGHT;

      printf("DEBUG: SCALING SET (%.2fx%.2f)\n", scale_w, scale_h);

      SDL_RenderSetScale(renderer, scale_w, scale_h);
   }
   
   SDL_SetRenderDrawColor(renderer, WALLPAPER_RGB, 0xFF);
   assets = new AssetManager();
   fps = new FrameRate();
   txt = new TextRenderer(); // depends on asset manager
   return true;
}
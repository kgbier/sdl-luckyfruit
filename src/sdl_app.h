#pragma once
#include <SDL.h>

#include "luckyfruit.h"

#include "assetmanager.h"
#include "fps.h"
#include "textrenderer.h"
#include "luckycomponents.h"

#define WALLPAPER_RGB 0x15, 0x15, 0x15

class sdl_app {
public:
   SDL_Window* window = NULL; //The window we'll be rendering to
   int window_w, window_h;
   SDL_Renderer* renderer = NULL;
   int renderer_w, renderer_h;
   AssetManager* assets;
   FrameRate* fps;
   TextRenderer* txt;
   
   std::vector<LuckyWindow*> windows;
   
   bool init();
};

extern sdl_app* app;
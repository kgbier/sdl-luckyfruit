#pragma once
#include <SDL.h>

#include "assetmanager.h"
#include "fps.h"
#include "textrenderer.h"
#include "luckycomponents.h"

#define WALLPAPER_RGB 0x15, 0x15, 0x15

class sdl_app {
public:
   SDL_Window* window = NULL; //The window we'll be rendering to
   SDL_Renderer* renderer = NULL;
   AssetManager* assets;
   FrameRate* fps;
   TextRenderer* txt;
   
   std::vector<LuckyWindow*> windows;
   
   void init();
};

extern sdl_app* app;
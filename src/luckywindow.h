#pragma once
#include <SDL.h>

#include "luckycontent.h"

class LuckyContent;

class LuckyWindow {
public:
   const char* windowTitle;
   bool locked = false;
   int grabbedx, grabbedy;
   SDL_Rect window;
   SDL_Rect shadow;
   SDL_Rect frame;

   LuckyContent* content;
   
   SDL_Texture* shadow_tex;
   SDL_Texture* frame_tex;
   
   LuckyWindow(const char* name, int x, int y);
   void updateWindow();
   void update();
   void draw();
   bool trygrab();
};
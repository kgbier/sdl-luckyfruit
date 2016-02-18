#pragma once
#include <SDL.h>

#include "luckycontent.h"

class LuckyContent;

class LuckyButton {
public:
   bool hover, pressed; 
   int xpos, ypos;
   int padding;
   SDL_Rect button_rect;
   
   SDL_Texture* btex;
   SDL_Texture* btex_hover; 
   SDL_Texture* btex_press;
   
   LuckyContent* parent;
   const char* buttonText;
   
   LuckyButton(LuckyContent* p, const char* text, int x, int y);
   
   void update();
   void draw();
};
#pragma once
#include <SDL.h>

#include "luckywindow.h"
#include "luckybutton.h"

class LuckyWindow;
class LuckyButton;

class LuckyContent {
public:
   SDL_Rect content_rect;
   SDL_Texture* bg_tex;
   LuckyButton* button;
   LuckyWindow* parent;
   
   LuckyContent(LuckyWindow* p);
   
   void update();
   void draw();
   
   int getXPos();
   int getYPos();
   int getWidth();
   int getHeight();
   void setXPos(int x);
   void setYPos(int y);
   void setWidth(int w);
   void setHeight(int h);
};
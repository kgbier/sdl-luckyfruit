#include "luckywindow.h"
#include "sdl_app.h"

LuckyWindow::LuckyWindow(const char* name, int x = 40, int y = 40) {
   windowTitle = name;
   grabbedx = 0;
   grabbedy = 0;
   
   window.x = x;
   window.y = y;
   window.w = 240;
   window.h = 180; 
   
   content = new LuckyContent(this);   
   
   shadow_tex = app->assets->getTex("SHADOW_TEX");
   frame_tex = app->assets->getTex("FRAME_TEX");
   
   updateWindow();
}

void LuckyWindow::updateWindow() {
   window.x = window.x - grabbedx;
   window.y = window.y - grabbedy;
   
   int handleheight = 20;
   int framewidth = 2;
   frame.x = window.x - framewidth;
   frame.y = window.y - (handleheight);
   frame.w = window.w + framewidth*2;
   frame.h = window.h + handleheight + framewidth;
   
   int shadowwidth = 4;
   shadow.x = frame.x - shadowwidth;
   shadow.y = frame.y + shadowwidth;
   shadow.w = frame.w;
   shadow.h = frame.h;
}

void LuckyWindow::update() {
   if(locked) {
      if(!(SDL_GetMouseState(NULL, NULL) & SDL_BUTTON(SDL_BUTTON_LEFT))) { // if the LMB is released
         locked = false;
      } else {
         SDL_GetMouseState(&(window.x), &(window.y));
         updateWindow();
      }
   }
   content->update();
}
   
void LuckyWindow::draw() {
   SDL_RenderCopy(app->renderer, shadow_tex, NULL, &shadow);
   SDL_RenderCopy(app->renderer, frame_tex, NULL, &frame);
   app->txt->fastprint(windowTitle, frame.x + 5, frame.y + 7);
   content->draw();
}
	
bool LuckyWindow::trygrab() {
   SDL_Point mousepos;
   SDL_GetMouseState(&(mousepos.x), &(mousepos.y));
   
   if(SDL_PointInRect(&mousepos, &frame)) {
      locked = true;
      grabbedx = mousepos.x - content->getXPos();
      grabbedy = mousepos.y - content->getYPos();
      return true;
    }
    return false;
}
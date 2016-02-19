#include "luckycomponents.h"
#include "sdl_app.h"

LuckyWindow::LuckyWindow(const char* t, int x, int y, int w, int h)
   : title(t), window{x, y, w, h} {
         
   pane = new LuckyPane(this);
   
   grabbedx = 0;
   grabbedy = 0;
   
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
   
   handle.x = frame.x;
   handle.y = frame.y;
   handle.w = frame.w;
   handle.h = handleheight;
   
   int shadowwidth = 4;
   shadow.x = frame.x - shadowwidth;
   shadow.y = frame.y + shadowwidth;
   shadow.w = frame.w;
   shadow.h = frame.h;
}
	
bool LuckyWindow::trygrab() {
   SDL_Point mousepos;
   SDL_GetMouseState(&(mousepos.x), &(mousepos.y));
   
   if(SDL_PointInRect(&mousepos, &handle)) {
      locked = true;
      grabbedx = mousepos.x - window.x;
      grabbedy = mousepos.y - window.y;
      return true;
    }
    return false;
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
   pane->update();
}
   
void LuckyWindow::draw() {
   SDL_RenderCopy(app->renderer, shadow_tex, NULL, &shadow);
   SDL_RenderCopy(app->renderer, frame_tex, NULL, &frame);
   app->txt->fastprint(title, frame.x + 5, frame.y + 7);
   pane->draw();
}
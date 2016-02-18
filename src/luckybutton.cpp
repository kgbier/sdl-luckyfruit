#include "luckycomponents.h"
#include "sdl_app.h"

LuckyButton::LuckyButton(const char* t, int x, int y)
   : LuckyComponent(x, y), text(t) {

   btex = app->assets->getTex("BUTTON_TEX");
   btex_hover = app->assets->getTex("BUTTON_HOVER_TEX");
   btex_press = app->assets->getTex("FRAME_TEX");
   
   hover = false;
   pressed = false;
   
   padding = 8;
   
   bounds.w = 40 + padding * 2;
   bounds.h = 6 + padding * 2;
   
   actual.x = bounds.x;
   actual.y = bounds.y;
   actual.w = bounds.w;
   actual.h = bounds.h;
   
}

void LuckyButton::update() {
   actual.x = parent_bounds->x + bounds.x;
   actual.y = parent_bounds->y + bounds.y;
   
   SDL_Point mousepos;
   SDL_GetMouseState(&(mousepos.x), &(mousepos.y));
   
   if(SDL_PointInRect(&mousepos, &actual)) {
      hover = true;
      if((SDL_GetMouseState(NULL, NULL) & SDL_BUTTON(SDL_BUTTON_LEFT))) { // If LMB is down
         pressed = true;
      } else {
         pressed = false;
      }
   } else {
      hover = false;
   }
}

void LuckyButton::draw() {
   if(pressed) {
      SDL_RenderCopy(app->renderer, btex_press, NULL, &actual);
   } else if(hover) {
      SDL_RenderCopy(app->renderer, btex_hover, NULL, &actual);
   } else {
      SDL_RenderCopy(app->renderer, btex, NULL, &actual);
   }
   app->txt->fastprint(text, actual.x + padding, actual.y + padding);
}
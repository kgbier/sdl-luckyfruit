#include "luckybutton.h"
#include "sdl_app.h"

LuckyButton::LuckyButton(LuckyContent* p, const char* txt, int x, int y) {
   btex = app->assets->getTex("BUTTON_TEX");
   btex_hover = app->assets->getTex("BUTTON_HOVER_TEX");
   btex_press = app->assets->getTex("FRAME_TEX");
   
   hover = false;
   pressed = false;
   
   parent = p;
   buttonText = txt;
   padding = 8;
   
   xpos = x;
   ypos = y;
   
   button_rect.x = parent->content_rect.x + xpos;
   button_rect.y = parent->content_rect.y + ypos;
   button_rect.w = 40 + padding * 2;
   button_rect.h = 6 + padding * 2;
}

void LuckyButton::update() {
   button_rect.x = parent->content_rect.x + xpos;
   button_rect.y = parent->content_rect.y + ypos;
   
   SDL_Point mousepos;
   SDL_GetMouseState(&(mousepos.x), &(mousepos.y));
   
   if(SDL_PointInRect(&mousepos, &button_rect)) {
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
      SDL_RenderCopy(app->renderer, btex_press, NULL, &button_rect);
   } else if(hover) {
      SDL_RenderCopy(app->renderer, btex_hover, NULL, &button_rect);
   } else {
      SDL_RenderCopy(app->renderer, btex, NULL, &button_rect);
   }
   app->txt->fastprint(buttonText, button_rect.x + padding, button_rect.y + padding);
}
#include "luckycontent.h"   
#include "sdl_app.h"

LuckyContent::LuckyContent(LuckyWindow* p) {
   parent = p;
   bg_tex = app->assets->getTex("BG_TEX");
   
   button = new LuckyButton(this, "Press", 10, 140);
}

void LuckyContent::update() {
   content_rect.x = parent->window.x;
   content_rect.y = parent->window.y;
   content_rect.w = parent->window.w;
   content_rect.h = parent->window.h;
   
   button->update();
}

void LuckyContent::draw() {
      SDL_RenderCopy(app->renderer, bg_tex, NULL, &content_rect);
      app->txt->print("This is being drawn from an awesome content class!", content_rect.x, content_rect.y, content_rect.w);
      button->draw();
}

int LuckyContent::getXPos() {
   return content_rect.x;
}
int LuckyContent::getYPos() {
   return content_rect.y;
}
int LuckyContent::getWidth() {
   return content_rect.w;
}
int LuckyContent::getHeight() {
   return content_rect.h;
}

void LuckyContent::setXPos(int x) {
   content_rect.x = x;
}
void LuckyContent::setYPos(int y) {
   content_rect.y = y;
}
void LuckyContent::setWidth(int w) {
   content_rect.w = w;
}
void LuckyContent::setHeight(int h) {
   content_rect.h = h;
}


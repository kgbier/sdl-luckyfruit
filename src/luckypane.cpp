#include "luckycomponents.h"
#include "sdl_app.h"

LuckyPane::LuckyPane(LuckyWindow* p)
   : LuckyComponent(p->window.x, p->window.y, p->window.w, p->window.h), parent(p){
   pane_tex = app->assets->getTex("BG_TEX");
}

void LuckyPane::addComponent(LuckyComponent* component) {
   components.push_back(component);
}

void LuckyPane::update() {
   for(unsigned int i = 0; i < components.size(); i++) {
      components[i]->update();
   }
}

void LuckyPane::draw() {
   SDL_RenderCopy(app->renderer, pane_tex, NULL, &(parent->window));
   for(unsigned int i = 0; i < components.size(); i++) {
      components[i]->draw();
   }
}

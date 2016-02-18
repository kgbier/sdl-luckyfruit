#include "luckycomponents.h"
#include "sdl_app.h"

LuckyText::LuckyText(const char* t, int x, int y)
   : LuckyComponent(x, y), text(t) {
}

void LuckyText::update() {
   
}

void LuckyText::draw() {
   app->txt->fastprint(text, parent_bounds->x + bounds.x, parent_bounds->y + bounds.y);
}
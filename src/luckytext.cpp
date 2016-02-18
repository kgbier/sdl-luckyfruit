#include "luckycomponents.h"
#include "sdl_app.h"

LuckyText::LuckyText(const char* t, int x, int y)
   : LuckyComponent(x, y), text(t) {
}

void LuckyText::update() {
   
}

void LuckyText::draw() {
   app->txt->fastprint(text, bounds.x, bounds.y);
}
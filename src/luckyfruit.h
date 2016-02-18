#pragma once
#include <SDL.h>

#include "luckycomponents.h"

//Screen dimension constants
const int SCREEN_WIDTH = 800;
const int SCREEN_HEIGHT = 600;

void main_loop();
LuckyWindow* createWindowA();
LuckyWindow* createWindowB();
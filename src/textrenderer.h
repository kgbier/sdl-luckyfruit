#pragma once
#include <SDL.h>

#define ROWMASK 0xF0
#define COLMASK 0x0F

#define MINCHAR 0x20
#define MAXCHAR 0x7E

#define PLACEHOLDER_X 106
#define PLACEHOLDER_Y 49

class TextRenderer {
public:
   SDL_Texture* font_tex = NULL;
   int charWidth, charHeight;
   char spriteSheetOffset;
   int guideOffset, kernOffset;
   TextRenderer();
   void fastprint(const char* input, int x, int y);
   void print(const char* input, int x, int y, int width);
private:
   SDL_Rect readcursor;
   SDL_Rect writecursor;
   void alignReadCursor(char c);
};
#pragma once
#include <SDL.h>

#define ROWMASK 0xF0
#define COLMASK 0x0F

#define MINCHAR 0x20
#define MAXCHAR 0x7E

#define PLACEHOLDER_X 106
#define PLACEHOLDER_Y 49

#define SPRITE_SHEET_OFFSET 0x20

#define CHAR_WIDTH 6
#define CHAR_HEIGHT 7

#define GUIDE_OFFSET 1
#define KERN_OFFSET 1

class TextRenderer {
public:
   static const int spriteSheetOffset = SPRITE_SHEET_OFFSET; // Where our first sprite (0,0) appears in the ASCII character list
   static const int charWidth = CHAR_WIDTH, charHeight = CHAR_HEIGHT;
   static const int guideOffset = GUIDE_OFFSET; // Px. Distance between characters in the spritesheet
   static const int kernOffset = KERN_OFFSET; // Px. Distance to leave between characters when drawing

   SDL_Texture* font_tex = NULL;
   TextRenderer();
   static int measureWidth(const char* inut);
   void fastprint(const char* input, int x, int y);
   void print(const char* input, int x, int y, int width);
private:
   SDL_Rect readcursor;
   SDL_Rect writecursor;
   void alignReadCursor(char c);
};
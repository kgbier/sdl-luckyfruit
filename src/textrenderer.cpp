#include "textrenderer.h"
#include "sdl_app.h"

//CURRENTLY SUPPORTED - ASCII 32|0x20 (SPACE) to ASCII 126|0x7E (~)
TextRenderer::TextRenderer() {
   charWidth = 6;
   charHeight = 7;
   spriteSheetOffset = 0x20; // Where our first sprite (0,0) appears in the ASCII character list
   guideOffset = 1; // Px. Distance between characters in the spritesheet
   kernOffset = 1; // Px. Distance to leave between characters when drawing
   font_tex = app->assets->getTex("FONTMAP"); 
}

void TextRenderer::alignReadCursor(char c) {
   //If the character is out of range (READ: not supported) switch to our placeholder character
   if(c < MINCHAR || c > MAXCHAR) {
      readcursor.x = PLACEHOLDER_X;
      readcursor.y = PLACEHOLDER_Y;
      return;
   }
   char pos = c - spriteSheetOffset; // 0x20 = 0x00 | 0x23 = 0x03
   int row = (pos & ROWMASK) >> 4; // shift half a byte to the right
   int col = pos & COLMASK;
   
   readcursor.x = guideOffset + (col * (charWidth + guideOffset));
   readcursor.y = guideOffset + (row * (charHeight + guideOffset));
}


// fastprint just spits out characters in a line, doesn't care about colour or content area width.
void TextRenderer::fastprint(const char* input, int x, int y) {
   char* ptr = (char*)input;
   
   readcursor.w = charWidth;
   readcursor.h = charHeight;
   
   writecursor.x = x;
   writecursor.y = y;
   writecursor.w = charWidth;
   writecursor.h = charHeight;
   
   while(*ptr != '\0') {
      alignReadCursor(*ptr);
      SDL_RenderCopy(app->renderer, font_tex, &readcursor, &writecursor);
      writecursor.x += charWidth + kernOffset;
      ptr++;
   }
}

// print takes a width number, which is max pixel length to draw in before starting on a new line
void TextRenderer::print(const char* input, int x, int y, int width) {
   int writtenlength = 0;
   char* ptr = (char*)input;
   
   readcursor.w = charWidth;
   readcursor.h = charHeight;
   
   writecursor.x = x;
   writecursor.y = y;
   writecursor.w = charWidth;
   writecursor.h = charHeight;
   
   while(*ptr != '\0') {
      alignReadCursor(*ptr);
      
      SDL_RenderCopy(app->renderer, font_tex, &readcursor, &writecursor);
      writtenlength += charWidth + kernOffset;
      if(writtenlength < (width - charWidth)) {
         writecursor.x += charWidth + kernOffset;
      } else {
         writtenlength = 0;
         writecursor.x = x;
         writecursor.y += 10;
      }
      ptr++;
   }
}

#include "assetmanager.h"
#include "sdl_app.h"

AssetManager::AssetManager() {
   SDL_Surface* surf;
   Uint32 rmask, gmask, bmask, amask;
   /* SDL interprets each pixel as a 32-bit number, so our masks must depend
      on the endianness (byte order) of the machine.
      Now the mask indicates where from the uint32 we extract the colour data for that channel -
      (eg. rmask = 0xFF000000 means when we apply this mask to a pixel we extract the red channel from the first byte of the uint32)
   */
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
   rmask = 0xFF000000;
   gmask = 0x00FF0000;
   bmask = 0x0000FF00;
   amask = 0x000000FF;
#else
   rmask = 0x000000FF;
   gmask = 0x0000FF00;
   bmask = 0x00FF0000;
   amask = 0xFF000000;
#endif

   surf = SDL_LoadBMP("res/font.bmp");
   SDL_SetColorKey(surf, SDL_TRUE, 0x00000000); // Mark black as our transparent colour
   textureLibrary["FONTMAP"] = SDL_CreateTextureFromSurface(app->renderer, surf); // Font
   
   SDL_FreeSurface(surf);
   
   surf = SDL_CreateRGBSurface(0, 1, 1, 32, rmask, gmask, bmask, amask); // make a blank surface
   
   SDL_FillRect(surf, NULL, SDL_MapRGB(surf->format, BG_RGB)); // Content Background
   textureLibrary["BG_TEX"] = SDL_CreateTextureFromSurface(app->renderer, surf);
   
   SDL_FillRect(surf, NULL, SDL_MapRGBA(surf->format, SHADOW_RGBA)); // Shadow
   textureLibrary["SHADOW_TEX"] = SDL_CreateTextureFromSurface(app->renderer, surf);
   
   SDL_FillRect(surf, NULL, SDL_MapRGB(surf->format, FRAME_RGB)); // Frame
   textureLibrary["FRAME_TEX"] = SDL_CreateTextureFromSurface(app->renderer, surf);
   
   SDL_FillRect(surf, NULL, SDL_MapRGB(surf->format, BUTTON_RGB)); // Button
   textureLibrary["BUTTON_TEX"] = SDL_CreateTextureFromSurface(app->renderer, surf);
   
   SDL_FillRect(surf, NULL, SDL_MapRGB(surf->format, BUTTON_HOVER_RGB)); // Button Hover
   textureLibrary["BUTTON_HOVER_TEX"] = SDL_CreateTextureFromSurface(app->renderer, surf);
   
   
   SDL_FreeSurface(surf);
}

SDL_Texture* AssetManager::getTex(std::string texID) {
   return textureLibrary[texID];
}
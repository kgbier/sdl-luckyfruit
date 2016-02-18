#pragma once
#include <SDL.h>
#include <unordered_map>
#include <string>

#define BG_RGB 0x44, 0x44, 0x44
#define SHADOW_RGBA 0x00, 0x00, 0x00, 0x55
#define FRAME_RGB 0x25, 0x25, 0x25
#define BUTTON_RGB 0x33, 0x33, 0x33
#define BUTTON_HOVER_RGB 0x80, 0x80, 0x80

class AssetManager {
public:
   std::unordered_map<std::string, SDL_Texture*> textureLibrary;
   
   AssetManager();
   
   SDL_Texture* getTex(std::string texID);
};
#pragma once
#include <SDL.h>
#include <vector>

// class LuckyComponent;
// class LuckyWindow;
// class LuckyContent;
// class LuckyText;

//GENERIC COMPONENT CLASS
class LuckyComponent {
protected:
   SDL_Rect bounds;
public:
   SDL_Rect* parent_bounds;
   
   LuckyComponent(int x, int y, int w = 0, int h = 0) 
      : bounds{x, y, w, h} { }
   
   virtual void update() = 0;
   virtual void draw() = 0;
};

class LuckyWindow;

class LuckyPane : public LuckyComponent {
public:
   SDL_Texture* pane_tex;
   LuckyWindow* parent;
   std::vector<LuckyComponent*> components;
   
   LuckyPane(LuckyWindow* p);
   
   void addComponent(LuckyComponent* component);
   
   void update();
   void draw();
};

class LuckyWindow {
private:
   SDL_Rect shadow;
   SDL_Rect frame;
   SDL_Rect handle;
   
   bool locked = false;
   int grabbedx, grabbedy;
   
   SDL_Texture* shadow_tex;
   SDL_Texture* frame_tex;
   
public:
   const char* title;
   SDL_Rect window;
   
   LuckyPane* pane;

   LuckyWindow(const char* t, int x, int y, int w = 240, int h = 180);
   
   void updateWindow();
   bool trygrab();
   
   void update();
   void draw();
};

class LuckyText : public LuckyComponent {
public:
   const char* text;
  
   LuckyText(const char* t, int x, int y);

   void update();
   void draw();
};

class LuckyButton : public LuckyComponent {
private:
   bool hover, pressed; 
   int padding;
   
   
   SDL_Texture* btex;
   SDL_Texture* btex_hover; 
   SDL_Texture* btex_press;
   
public:
   const char* text;
   SDL_Rect actual;
   
   LuckyButton(const char* t, int x, int y);
   
   void (*onClick)(void*) = NULL;

   void update();
   void draw();
};
#include <stdlib.h>
#include <stdio.h>
#include <vector>

#include "luckyfruit.h"

#include "sdl_app.h"
#include "textrenderer.h"
#include "luckywindow.h"


sdl_app* app = NULL; //Global

int main(int argc, char* args[]) {
	//Initialize SDL
	
	printf("DEBUG: INITIALISING SDL\n");
	
	if(SDL_Init(SDL_INIT_EVERYTHING) < 0) {
		printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
	} else {
		printf("DEBUG: ALLOCATING APP\n");
		app = new sdl_app();
		//Create window
		printf("DEBUG: INITIALISING SDL_WINDOW\n");
		app->window = SDL_CreateWindow("LUCKYFRUIT", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
		if(app->window == NULL) {
			printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );
		} else {
			printf("DEBUG: WINDOW (%dx%d) INITIALISED\n", SCREEN_WIDTH, SCREEN_HEIGHT);
			printf("DEBUG: INITIALISING APP\n");
			app->init();
			printf("DEBUG: STARTING MAIN LOOP\n");
			main_loop(); // Where the magic happens
		}
	}
	
	SDL_DestroyWindow(app->window); //Destroy window
	SDL_Quit(); // Safely power down SDL
	
	return 0;
}

void main_loop() {
	
	std::vector<LuckyWindow*> windows;
	printf("CRASHTESTING: CREATE WINDOWS\n");
	windows.push_back(new LuckyWindow("WINDOW A", 20, 200));
	windows.push_back(new LuckyWindow("WINDOW B", 300, 200));
	printf("CRASHTESTING: WINDOWS CREATED\n");
	bool quit = false;
	SDL_Event e; // Event handler
	
	//While application is running
	while(!quit) {
		//Handle events on queue
		while(SDL_PollEvent(&e) != 0) {
			switch(e.type) {
				case SDL_QUIT: // Close button
					quit = true;
					break;
				case SDL_KEYDOWN: // Escape pressed
					if(e.key.keysym.sym == SDLK_ESCAPE) {
						quit = true;
					}
					break;
				case SDL_MOUSEBUTTONDOWN: // LMB Pressed
					if(e.button.button == SDL_BUTTON_LEFT) {
						for(int i = windows.size() - 1; i >= 0; i--) {
							if(windows[i]->trygrab()) {
								LuckyWindow *clicked = windows[i];
								windows.erase(windows.begin()+i);
								windows.push_back(clicked);
								break;
							}
						}
					}
					break;
				case SDL_MOUSEBUTTONUP:
					break;
				default: // Catchall
					break;
			}
		}
		
		//update entities
		for(unsigned int i = 0; i < windows.size(); i++) {
			windows[i]->update();
		}
		
		//wipe framebuffer
		SDL_RenderClear(app->renderer);
		
		//draw entities to framebuffer
		for(unsigned int i = 0; i < windows.size(); i++) {
			windows[i]->draw();
		}		
		
		app->txt->fastprint("HELLO WORLD", 10, 10);
		app->txt->fastprint("THIS IS A SPECIAL MESSAGE", 10, 20);
		app->txt->fastprint("! - EXCLAMATION MARK", 10, 30);
		app->txt->fastprint("WHAT IS THIS? @", 10, 40);
		app->txt->fastprint("WELL, CLEARLY. NO-ONE KNOWS.", 10, 50);
		app->txt->fastprint("*GASP*, HE SAID. 10 ^ 20.", 10, 60);
		app->txt->fastprint("10 + 2^2 = SOMETHING REALLY F#(&!<>/\'\" HUGE", 10, 70);
		app->txt->fastprint("I'M MR. SH\r\r\r\r\r LOOK AT MEE\r! <-(THIS TESTED INVALID CHARS)", 10, 80);
		app->txt->fastprint("! \"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`{}|~", 10, 90);
		app->fps->draw();
		
		//flip the framebuffer
		SDL_RenderPresent(app->renderer); // Update the surface
		
		app->fps->tick();
	}
}

/*********************************

		//Draw some custom pixel content to the framebuffer
		int pitch, texlen;
		void* pixels;
		
		SDL_Rect fontrect;
		fontrect.x = 40;
		fontrect.y = 40;
		fontrect.w = 20;
		fontrect.h = 10; 
		
		SDL_Texture* testtex = NULL;
		testtex = SDL_CreateTexture(app->renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STREAMING, 20, 10);
		SDL_LockTexture(testtex, NULL, &pixels, &pitch);
		texlen = (pitch/4) * fontrect.h;
		Uint32* pix = (Uint32*)pixels;	

		for(int i = 0; i < texlen; i++) {
			Uint32 colour = 0x000000FF;
			if(i % 2 == 0) {
				colour |= 0xFF000000;
			}
			if(i % 3 == 0) {
				colour |= 0x00FF0000;
			}
			if(i % 4 == 0) {
				colour |= 0x0000FF00;
			}
			
			if(i == 1) {
				colour = 0x00000066;
			} 
			
			pix[i] = colour;
		}
		
		SDL_UnlockTexture(testtex);
		
		SDL_RenderCopy(app->renderer, testtex, NULL, &fontrect);
		SDL_DestroyTexture(testtex);

*********************************/
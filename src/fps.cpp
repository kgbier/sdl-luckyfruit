#include "fps.h"
#include "sdl_app.h"
#include "luckyfruit.h"

#include <string>
#include <stdio.h>

FrameRate::FrameRate() {
	remainingframes = FRAMES_TO_COMPUTE;
	tick_lasttime = 0;
	tick_thistime = SDL_GetTicks();
	fps_draw_starttime = SDL_GetTicks();
	fps = 0.0f;
	fps_str_buffer = new char[FPS_STR_BUFF_SIZE];
}

void FrameRate::tick() {
	tick_lasttime = tick_thistime;
	tick_thistime = SDL_GetTicks();
	deltaTime = tick_thistime - tick_lasttime;
	
	if(remainingframes == 0) {
		fps_draw_endtime = SDL_GetTicks();
		fps_draw_delta = fps_draw_endtime - fps_draw_starttime;
		fps = 1000.0f * FRAMES_TO_COMPUTE / fps_draw_delta;
		fps_draw_starttime = SDL_GetTicks();
		remainingframes = FRAMES_TO_COMPUTE;
	} else {
		remainingframes--;
	}
	
	if(deltaTime < TARGET_FRAME_TIME) {
		SDL_Delay(TARGET_FRAME_TIME - deltaTime);
	}
	tick_thistime = SDL_GetTicks();
}

void FrameRate::draw() {
	sprintf(fps_str_buffer, "%.2f FPS", fps);
	app->txt->fastprint(fps_str_buffer, SCREEN_WIDTH - 100, 10);
}
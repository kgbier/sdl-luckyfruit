#pragma once
#include <SDL.h>

#define FPS_STR_BUFF_SIZE 10

#define FRAMES_TO_COMPUTE 30
#define FRAME_RATE_LOCK 144.0f
#define TARGET_FRAME_TIME 1000.0f / FRAME_RATE_LOCK

class FrameRate {
public:
	unsigned int deltaTime;
	float fps;
	
	FrameRate();
	
	void tick();	
	void draw();
		
private:
	int remainingframes;
	unsigned int tick_thistime, tick_lasttime;
	unsigned int fps_draw_starttime, fps_draw_endtime, fps_draw_delta;
	char* fps_str_buffer;
};
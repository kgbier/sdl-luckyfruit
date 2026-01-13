const zdl = @import("zdl");

const FRAME_RATE_LOCK = 120.0;
const TARGET_FRAME_TIME_MS_DECIMAL = 1000.0 / FRAME_RATE_LOCK;
const TARGET_FRAME_TIME_MS: u32 = @floor(TARGET_FRAME_TIME_MS_DECIMAL);

pub var deltaTime: f32 = 1;

var deltatime_ms: u32 = undefined;
pub var fps: f32 = undefined;

var remainingframes: i32 = FRAME_RATE_LOCK;
var tick_ms_thistime: u32 = 0;
var tick_ms_lasttime: u32 = 0;

var fps_ms_starttime: u32 = 0;
var fps_ms_delta: u32 = 0;

pub fn tick() void {
    tick_ms_thistime = zdl.Timer.getTicks();
    deltatime_ms = tick_ms_thistime - tick_ms_lasttime;

    deltaTime = @as(f32, @floatFromInt(deltatime_ms)) / TARGET_FRAME_TIME_MS_DECIMAL;

    if (remainingframes <= 1) {
        const fps_ms_endtime = tick_ms_thistime;

        fps_ms_delta = fps_ms_endtime - fps_ms_starttime;
        fps = 1000.0 / (@as(f32, @floatFromInt(fps_ms_delta)) / FRAME_RATE_LOCK);
        fps_ms_starttime = fps_ms_endtime;
        remainingframes = FRAME_RATE_LOCK;
    } else {
        remainingframes = remainingframes - 1;
    }

    if (deltatime_ms < TARGET_FRAME_TIME_MS) {
        zdl.Timer.delay(TARGET_FRAME_TIME_MS - deltatime_ms);
    }

    tick_ms_lasttime = zdl.Timer.getTicks();
}

const math = @import("std").math;

pub const curve = fn (t: f32) f32;

pub fn linear(t: f32) f32 {
    return t;
}

pub fn easeIn(t: f32) f32 {
    return t * t;
}

pub fn easeOut(t: f32) f32 {
    return t * (2.0 - t);
}

pub fn easeInOut(t: f32) f32 {
    if (t < 0.5) {
        return 2.0 * t * t;
    } else {
        return -1.0 + (4.0 - 2.0 * t) * t;
    }
}

pub fn easeOutBounce(t: f32) f32 {
    const n1: f32 = 7.5625;
    const d1: f32 = 2.75;

    if (t < 1.0 / d1) {
        return n1 * t * t;
    } else if (t < 2.0 / d1) {
        return n1 * (t - 1.5 / d1) * (t - 1.5 / d1) + 0.75;
    } else if (t < 2.5 / d1) {
        return n1 * (t - 2.25 / d1) * (t - 2.25 / d1) + 0.9375;
    } else {
        return n1 * (t - 2.625 / d1) * (t - 2.625 / d1) + 0.984375;
    }
}

pub fn easeOutBounceV2(t: f32) f32 {
    if (t < 1.0 / 2.75) {
        return 7.5625 * t * t;
    } else if (t < 2.0 / 2.75) {
        const t2 = t - 1.5 / 2.75;
        return 7.5625 * t * t2 + 0.75;
    } else if (t < 2.5 / 2.75) {
        const t2 = t - 2.25 / 2.75;
        return 7.5625 * t * t2 + 0.9375;
    } else {
        const t2 = t - 2.625 / 2.75;
        return 7.5625 * t * t2 + 0.984375;
    }
}

pub fn easeOutElastic(x: f32) f32 {
    const c4: f32 = (2.0 * math.pi) / 3.0;

    if (x == 0.0) {
        return 0.0;
    } else if (x == 1.0) {
        return 1.0;
    } else {
        return math.pow(f32, 2.0, -10.0 * x) * math.sin((x * 10.0 - 0.75) * c4) + 1.0;
    }
}

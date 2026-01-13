const engine = @import("../../engine/index.zig");
const logic = @import("../logic.zig");

const Game = @This();

initialised: bool = false,
state: logic.GameState = undefined,

fn init(self: *Game) !void {
    self.initialised = true;
    self.state = try logic.initialiseGameState();
}

pub fn update(self: *Game) !void {
    if (!self.initialised) {
        try self.init();
    }

    // ...
}

const card_width = @divFloor(250, 2);
const card_height = @divFloor(350, 2);

pub fn draw(self: *Game) !void {
    const hand = self.state.player_hand.cards;
    const window_bounds = engine.window.bounds;
    const padding = 10; // Padding between cards

    for (hand) |card| {
        _ = card;
        _ = window_bounds;
        _ = padding;
    }
}

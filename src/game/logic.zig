const std = @import("std");

const Suit = enum {
    Clubs,
    Diamonds,
    Hearts,
    Spades,
};

const Rank = enum {
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Jack,
    Queen,
    King,
    Ace,
};

const Card = struct {
    suit: Suit,
    rank: Rank,
};

const Cards = struct {
    buffer: [52]Card,
    cards: []Card,

    pub fn fillDeck(cards: *Cards) void {
        inline for (std.meta.fields(Suit), 0..) |suit_field, s_i| {
            inline for (std.meta.fields(Rank), 0..) |rank_field, r_i| {
                const suit: Suit = @enumFromInt(suit_field.value);
                const rank: Rank = @enumFromInt(rank_field.value);
                const index = (r_i) + (s_i * std.meta.fields(Rank).len);
                cards.buffer[index] = .{
                    .suit = suit,
                    .rank = rank,
                };
            }
        }
        cards.cards = &cards.buffer;
    }

    pub fn shuffle(cards: *Cards) !void {
        var prng = std.Random.DefaultPrng.init(blk: {
            var seed: u64 = undefined;
            try std.posix.getrandom(std.mem.asBytes(&seed));
            break :blk seed;
        });

        const len = cards.cards.len;
        for (0..len) |i| {
            const j = prng.random().intRangeLessThan(usize, 0, len);
            const temp = cards.cards[i];
            cards.cards[i] = cards.cards[j];
            cards.cards[j] = temp;
        }
    }
};

pub const GameState = struct {
    deck: Cards,
    player_hand: Cards,
};

pub fn initialiseGameState() !GameState {
    var deck = Cards{ .buffer = undefined, .cards = undefined };
    deck.fillDeck();
    try deck.shuffle();
    return .{
        .deck = deck,
        .player_hand = .{ .buffer = undefined, .cards = &[_]Card{} },
    };
}

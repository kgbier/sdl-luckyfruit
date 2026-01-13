const std = @import("std");

/// Uniquely identifies a component instance
pub const IMID = usize;

/// Two different methods of generating an IMID
pub const IMIDType = union(enum) {
    /// Automatically generate an IMID based on the call site
    auto: void,

    index: usize,
    key: []const u8,
};

/// Generate a unique identifier for a component instance.
pub inline fn getIMID(imid_type: IMIDType) IMID {
    const callerReturnAddress = @returnAddress();

    const imid = switch (imid_type) {
        .auto => callerReturnAddress,
        inline .index, .key => |data| blk: {
            var hasher = std.hash.Wyhash.init(0);
            std.hash.autoHashStrat(&hasher, callerReturnAddress, .Shallow);
            std.hash.autoHashStrat(&hasher, data, .Shallow);
            break :blk hasher.final();
        },
    };
    return imid;
}

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{ .name = "luckyfruit", .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    }) });

    const sdl2 = b.addModule("sdl2", .{
        .root_source_file = b.path("lib/sdl2.zig"),
    });

    const zdl = b.addModule("zdl", .{
        .root_source_file = b.path("lib/zdl/root.zig"),
    });

    if (target.query.isNativeOs() and target.query.os_tag == .linux) {
        // The SDL package doesn't work for Linux yet, so we rely on system
        // packages for now.
        sdl2.linkSystemLibrary("SDL2", .{});
        exe.linkLibC();
    } else {
        const sdl_dep = b.dependency("SDL", .{
            .optimize = optimize,
            .target = target,
        });
        sdl2.linkLibrary(sdl_dep.artifact("SDL2"));
    }

    zdl.addImport("sdl2", sdl2);
    exe.root_module.addImport("zdl", zdl);

    b.installArtifact(exe);

    const run = b.step("run", "Run the demo");
    const run_cmd = b.addRunArtifact(exe);
    run.dependOn(&run_cmd.step);
}

const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const days: [25]u8 = undefined;
    for (days) |_, day| {
        const day_name = b.fmt("day{:0>2}", .{day + 1});
        const day_path = b.fmt("src/{0s}/{0s}.zig", .{day_name});

        const build_step = b.addExecutable(day_name, day_path);
        build_step.setTarget(target);
        build_step.setBuildMode(mode);
        build_step.install();

        // Add the run steps
        const run_step = b.step(b.fmt("{s}-run", .{day_name}), b.fmt("Run the {s}", .{day_name}));
        const run_cmd = build_step.run();
        run_step.dependOn(&run_cmd.step);

        // Add the test steps
        const test_step = b.step(b.fmt("{s}-test", .{day_name}), b.fmt("Test the {s}", .{day_name}));
        const test_cmd = b.addTest(day_path);
        test_step.dependOn(&test_cmd.step);

        // Add the install steps
        const install_step = b.step(b.fmt("{s}-install", .{day_name}), b.fmt("Install the {s} to zig-out/bin", .{day_name}));
        const install_cmd = build_step.install_step.?;
        install_step.dependOn(&install_cmd.step);
    }
}

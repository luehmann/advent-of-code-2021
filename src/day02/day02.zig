const std = @import("std");

const example_input = @embedFile("./example_input.txt");
const puzzle_input = @embedFile("./puzzle_input.txt");

pub fn main() void {
    std.debug.print("Hello World\n", .{});
    std.debug.print("--- Part One ---\n", .{});
    std.debug.print("Result: {d}\n", .{part1(puzzle_input)});
    std.debug.print("--- Part Two ---\n", .{});
    std.debug.print("Result: {d}\n", .{part2(puzzle_input)});
}

fn part1(input: []const u8) usize {
    var lines = std.mem.tokenize(u8, input, "\n");
    var depth: usize = 0;
    var horizontal_position: usize = 0;
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " ");
        const op = parts.next().?;
        const arg = std.fmt.parseInt(usize, parts.next().?, 10) catch unreachable;
        if (std.mem.eql(u8, op, "forward")) {
            horizontal_position += arg;
        } else if (std.mem.eql(u8, op, "down")) {
            depth += arg;
        } else if (std.mem.eql(u8, op, "up")) {
            depth -= arg;
        }
    }
    return depth * horizontal_position;
}

test "day02 part1 - example input" {
    try std.testing.expectEqual(@as(usize, 150), part1(example_input));
}

test "day02 part1 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 2_187_380), part1(puzzle_input));
}

fn part2(input: []const u8) usize {
    var lines = std.mem.tokenize(u8, input, "\n");
    var depth: usize = 0;
    var horizontal_position: usize = 0;
    var aim: usize = 0;
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " ");
        const op = parts.next().?;
        const arg = std.fmt.parseInt(usize, parts.next().?, 10) catch unreachable;
        if (std.mem.eql(u8, op, "forward")) {
            horizontal_position += arg;
            depth += arg * aim;
        } else if (std.mem.eql(u8, op, "down")) {
            aim += arg;
        } else if (std.mem.eql(u8, op, "up")) {
            aim -= arg;
        }
    }
    return depth * horizontal_position;
}

test "day02 part2 - example input" {
    try std.testing.expectEqual(@as(usize, 900), part2(example_input));
}

test "day02 part2 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 2_086_357_770), part2(puzzle_input));
}

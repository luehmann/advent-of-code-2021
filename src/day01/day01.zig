const std = @import("std");

const example_input = @embedFile("./example_input.txt");
const puzzle_input = @embedFile("./puzzle_input.txt");

pub fn main() void {
    std.debug.print("--- Part One ---\n", .{});
    std.debug.print("Result: {d}\n", .{part1(puzzle_input)});
    std.debug.print("--- Part Two ---\n", .{});
    std.debug.print("Result: {d}\n", .{part2(puzzle_input)});
}

fn part1(input: []const u8) usize {
    var lines = std.mem.tokenize(u8, input, "\n");
    var increments: usize = 0;
    var prev = std.fmt.parseInt(usize, lines.next().?, 10) catch unreachable;
    while (lines.next()) |line| {
        const n = std.fmt.parseInt(usize, line, 10) catch unreachable;
        if (n > prev) {
            increments += 1;
        }
        prev = n;
    }
    return increments;
}

test "day01 part1 - example input" {
    try std.testing.expectEqual(@as(usize, 7), part1(example_input));
}

test "day01 part1 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 1_301), part1(puzzle_input));
}

fn part2(input: []const u8) usize {
    var lines = std.mem.tokenize(u8, input, "\n");
    var triple: [3]usize = undefined;
    for (triple) |*n| {
        n.* = std.fmt.parseInt(usize, lines.next().?, 10) catch unreachable;
    }
    var triple_index: usize = 0;
    var increments: usize = 0;
    var prev = triple[0] + triple[1] + triple[2];
    while (lines.next()) |line| {
        triple[triple_index] = std.fmt.parseInt(usize, line, 10) catch unreachable;
        triple_index += 1;
        triple_index %= triple.len;
        const sum = triple[0] + triple[1] + triple[2];
        if (sum > prev) {
            increments += 1;
        }
        prev = sum;
    }
    return increments;
}

test "day01 part2 - example input" {
    try std.testing.expectEqual(@as(usize, 5), part2(example_input));
}

test "day01 part2 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 1_346), part2(puzzle_input));
}

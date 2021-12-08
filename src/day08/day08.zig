const std = @import("std");

const example_input = @embedFile("./example_input.txt");
const puzzle_input = @embedFile("./puzzle_input.txt");

pub fn main() !void {
    std.debug.print("--- Part One ---\n", .{});
    std.debug.print("Result: {d}\n", .{part1(puzzle_input)});
    std.debug.print("--- Part Two ---\n", .{});
    std.debug.print("Result: {d}\n", .{part2(puzzle_input)});
}

fn part1(input: []const u8) usize {
    var lines = std.mem.tokenize(u8, input, "\n");
    var unique_digit_count: usize = 0;
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " | ");
        _ = parts.next();
        var output_signals = std.mem.split(u8, parts.next().?, " ");
        while (output_signals.next()) |output_signal| {
            if (output_signal.len == 2 or output_signal.len == 3 or output_signal.len == 4 or output_signal.len == 7) {
                unique_digit_count += 1;
            }
        }
    }
    return unique_digit_count;
}

test "day08 part1 - example input" {
    try std.testing.expectEqual(@as(usize, 26), part1(example_input));
}

test "day08 part1 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 284), part1(puzzle_input));
}

fn getSegments(input: []const u8) u7 {
    var segments: u7 = 0;
    for (input) |char| {
        segments |= @as(u7, 1) << @intCast(u3, char - 'a');
    }
    return segments;
}

fn part2(input: []const u8) usize {
    var lines = std.mem.tokenize(u8, input, "\n");
    var sum: usize = 0;
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " | ");
        var unique_signals = std.mem.split(u8, parts.next().?, " ");

        var one_pattern: u7 = undefined;
        var four_pattern: u7 = undefined;
        var seven_pattern: u7 = undefined;
        var eight_pattern: u7 = undefined;
        while (unique_signals.next()) |unique_signal| {
            const segments = getSegments(unique_signal);
            const bits_set = @popCount(u7, segments);
            if (bits_set == 2) one_pattern = segments;
            if (bits_set == 4) four_pattern = segments;
            if (bits_set == 3) seven_pattern = segments;
            if (bits_set == 7) eight_pattern = segments;
        }

        const cf_pattern: u7 = one_pattern;
        const eg_pattern: u7 = ~(seven_pattern | four_pattern);

        var digits: usize = 0;
        var base: usize = 1000;
        var output_signals = std.mem.split(u8, parts.next().?, " ");
        while (output_signals.next()) |output_signal| {
            const segments = getSegments(output_signal);
            const bits_set = @popCount(u7, segments);

            var digit: usize = blk: {
                if (segments == one_pattern) break :blk 1;
                if (segments == four_pattern) break :blk 4;
                if (segments == seven_pattern) break :blk 7;
                if (segments == eight_pattern) break :blk 8;

                if (bits_set == 5) {
                    if (segments & eg_pattern == eg_pattern) {
                        break :blk 2;
                    } else {
                        if (segments & cf_pattern == cf_pattern) {
                            break :blk 3;
                        } else {
                            break :blk 5;
                        }
                    }
                }
                if (bits_set == 6) {
                    if (segments & eg_pattern == eg_pattern) {
                        if (segments & cf_pattern == cf_pattern) {
                            break :blk 0;
                        } else {
                            break :blk 6;
                        }
                    } else {
                        break :blk 9;
                    }
                }
                unreachable;
            };

            digits += digit * base;
            base /= 10;
        }

        sum += digits;
    }
    return sum;
}

test "day08 part2 - example input" {
    try std.testing.expectEqual(@as(usize, 61229), part2(example_input));
}

test "day08 part2 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 973_499), part2(puzzle_input));
}

const std = @import("std");

const example_input = @embedFile("./example_input.txt");
const puzzle_input = @embedFile("./puzzle_input.txt");

pub fn main() !void {
    std.debug.print("--- Part One ---\n", .{});
    std.debug.print("Result: {d}\n", .{solve(puzzle_input, 80)});
    std.debug.print("--- Part Two ---\n", .{});
    std.debug.print("Result: {d}\n", .{solve(puzzle_input, 256)});
}

fn solve(input: []const u8, last_day: usize) usize {
    var numbers = std.mem.split(u8, input, ",");
    var replicates_in = [_]usize{0} ** 9;
    while (numbers.next()) |number| {
        const n = std.fmt.parseInt(usize, number, 10) catch unreachable;
        replicates_in[n] += 1;
    }
    var day: usize = 0;
    while (day < last_day) {
        day += 1;
        const day_0_count = replicates_in[0];
        var i: usize = 0;
        while (i < 8) : (i += 1) {
            replicates_in[i] = replicates_in[i + 1];
        }
        replicates_in[6] += day_0_count;
        replicates_in[8] = day_0_count;
    }

    var sum: usize = 0;
    for (replicates_in) |count| {
        sum += count;
    }
    return sum;
}

test "day06 part1 - example input" {
    try std.testing.expectEqual(@as(usize, 5_934), solve(example_input, 80));
}

test "day06 part1 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 352_872), solve(puzzle_input, 80));
}

test "day06 part2 - example input" {
    try std.testing.expectEqual(@as(usize, 26_984_457_539), solve(example_input, 256));
}

test "day06 part2 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 1_604_361_182_149), solve(puzzle_input, 256));
}

const std = @import("std");

const example_input = @embedFile("./example_input.txt");
const puzzle_input = @embedFile("./puzzle_input.txt");

pub fn main() !void {
    std.debug.print("--- Part One ---\n", .{});
    std.debug.print("Result: {d}\n", .{try part1(std.testing.allocator, puzzle_input)});
    std.debug.print("--- Part Two ---\n", .{});
    std.debug.print("Result: {d}\n", .{try part2(std.testing.allocator, puzzle_input)});
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !usize {
    var iter = std.mem.split(u8, input, ",");
    var list = std.ArrayList(usize).init(allocator);
    while (iter.next()) |item| {
        const n = std.fmt.parseInt(usize, item, 10) catch unreachable;
        try list.append(n);
    }
    const numbers = list.toOwnedSlice();
    defer allocator.free(numbers);

    const min = std.mem.min(usize, numbers);
    const max = std.mem.max(usize, numbers);

    var i: usize = min;
    var min_cost: usize = std.math.maxInt(usize);
    while (i < max) : (i += 1) {
        var cost: usize = 0;
        for (numbers) |n| {
            cost += if (i > n) i - n else n - i;
        }
        if (cost < min_cost) min_cost = cost;
    }
    return min_cost;
}

test "day07 part1 - example input" {
    try std.testing.expectEqual(@as(usize, 37), try part1(std.testing.allocator, example_input));
}

test "day07 part1 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 342_534), try part1(std.testing.allocator, puzzle_input));
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !usize {
    var iter = std.mem.split(u8, input, ",");
    var list = std.ArrayList(usize).init(allocator);
    while (iter.next()) |item| {
        const n = std.fmt.parseInt(usize, item, 10) catch unreachable;
        try list.append(n);
    }
    const numbers = list.toOwnedSlice();
    defer allocator.free(numbers);

    const min = std.mem.min(usize, numbers);
    const max = std.mem.max(usize, numbers);

    var i: usize = min;
    var min_cost: usize = std.math.maxInt(usize);
    while (i < max) : (i += 1) {
        var cost: usize = 0;
        for (numbers) |n| {
            cost += stepCost(if (i > n) i - n else n - i);
        }
        if (cost < min_cost) min_cost = cost;
    }
    return min_cost;
}

fn stepCost(d: usize) usize {
    return d * (d + 1) / 2;
}

test "day07 part2 - example input" {
    try std.testing.expectEqual(@as(usize, 168), try part2(std.testing.allocator, example_input));
}

test "day07 part2 - puzzle input" {
    try std.testing.expectEqual(@as(usize, 94_004_208), try part2(std.testing.allocator, puzzle_input));
}

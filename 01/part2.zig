const std = @import("std");
const input = @embedFile("input");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    const stdout = std.io.getStdOut().writer();

    var frequencies = std.AutoHashMap(u32, u32).init(allocator);
    defer frequencies.deinit();

    var as = std.ArrayList(u32).init(allocator);
    defer as.deinit();

    while (it.next()) |line| {
        var nums = std.mem.tokenizeScalar(u8, line, ' ');
        const a = try std.fmt.parseInt(u32, nums.next().?, 10);
        const b = try std.fmt.parseInt(u32, nums.next().?, 10);

        const freq = try frequencies.getOrPutValue(b, 0);
        try frequencies.put(b, freq.value_ptr.* + 1);

        try as.append(a);
    }

    var score: u32 = 0;
    for (as.items) |a| {
        const freq = frequencies.get(a) orelse 0;
        score += a * freq;
    }

    try stdout.print("{d}\n", .{score});
}

const std = @import("std");
const input = @embedFile("input");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var it = std.mem.tokenizeScalar(u8, input, '\n');
    const stdout = std.io.getStdOut().writer();

    var as = std.ArrayList(i32).init(allocator);
    defer as.deinit();
    var bs = std.ArrayList(i32).init(allocator);
    defer bs.deinit();

    while (it.next()) |line| {
        var nums = std.mem.tokenizeScalar(u8, line, ' ');
        const a = try std.fmt.parseInt(i32, nums.next().?, 10);
        const b = try std.fmt.parseInt(i32, nums.next().?, 10);

        try as.append(a);
        try bs.append(b);
    }

    std.mem.sort(i32, as.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, bs.items, {}, comptime std.sort.asc(i32));

    var sum: u32 = 0;
    for (as.items, bs.items) |a, b| {
        sum += @abs(a - b);
    }

    try stdout.print("{d}\n", .{sum});
}

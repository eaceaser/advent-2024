const std = @import("std");
const input = @embedFile("input");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var num_safe: u32 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var nums = std.mem.tokenizeScalar(u8, line, ' ');
        var report_arr: [99]i32 = undefined;
        var report_size: usize = 0;

        while (nums.next()) |numStr| {
            const num = try std.fmt.parseInt(i32, numStr, 10);
            report_arr[report_size] = num;
            report_size += 1;
        }

        if (report_size == 0) {
            break;
        }

        const report = report_arr[0..report_size];
        var last_d: i32 = 0;

        var safe = true;
        var it = std.mem.window(i32, report, 2, 1);
        while (it.next()) |pair| {
            const d = pair[1] - pair[0];
            defer last_d = d;

            if (d > 0 and last_d < 0) {
                safe = false;
                break;
            }

            if (d < 0 and last_d > 0) {
                safe = false;
                break;
            }

            const abs = @abs(d);
            if (abs < 1 or abs > 3) {
                safe = false;
                break;
            }
        }

        num_safe += if (safe) 1 else 0;
    }

    try stdout.print("{d}\n", .{num_safe});
}

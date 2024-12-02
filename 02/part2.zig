const std = @import("std");
const input = @embedFile("input");

const example = "71 68 71 73 74 75";

fn violates(last_d: i32, d: i32) bool {
    if (d > 0 and last_d < 0) {
        return true;
    }

    if (d < 0 and last_d > 0) {
        return true;
    }

    const abs = @abs(d);
    if (abs < 1 or abs > 3) {
        return true;
    }

    return false;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var num_safe: u32 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var nums = std.mem.tokenizeScalar(u8, line, ' ');
        var report_arr = [_]i32{0} ** 99;

        var report_size: usize = 1;
        while (nums.next()) |numStr| {
            const num = try std.fmt.parseInt(i32, numStr, 10);
            report_arr[report_size] = num;
            report_size += 1;
        }

        if (report_size == 1) {
            break;
        }

        // give ourselves a trailing zero
        report_size += 1;

        const report = report_arr[1 .. report_size - 1];
        var it = std.mem.window(i32, report, 2, 1);
        var last_d: i32 = 0;
        var unsafe: i32 = 0;
        while (it.next()) |pair| {
            const d = pair[1] - pair[0];
            if (violates(last_d, d)) {
                unsafe += 1;
                break;
            }
            last_d = d;
        }

        if (unsafe == 1) {
            for (1..report_size - 1) |skip| {
                var d_arr = [_]i32{0} ** 99;
                for (0.., report_arr[0..report_size]) |i, num| {
                    if (i == skip) {
                        continue;
                    }

                    d_arr[if (i > skip) i - 1 else i] = num;
                }

                const report_skipped = d_arr[1 .. report_size - 2];
                var it2 = std.mem.window(i32, report_skipped, 2, 1);
                var last_d2: i32 = 0;
                while (it2.next()) |pair| {
                    const d = pair[1] - pair[0];
                    if (violates(last_d2, d)) {
                        unsafe += 1;
                        break;
                    }
                    last_d2 = d;
                }
            }

            if (unsafe < report_size - 1) {
                num_safe += 1;
            }
        } else {
            num_safe += 1;
        }
    }

    try stdout.print("{d}\n", .{num_safe});
}

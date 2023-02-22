// TODO:
// Specify starting states
// Variable grid size
// Color!

// Interactive editor:
// pausable sim, cursor to edit the grid
// can save grid to disk when paused

const std = @import("std");
const print = std.debug.print;

const GRID_SIZE = 10;

var grid = [GRID_SIZE * GRID_SIZE]u1{
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 1, 1, 0, 0, 0, 0, 0, 0,
    0, 0, 1, 0, 1, 0, 0, 0, 0, 0,
    0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
};

var back_buffer = [1]u1{0} ** (GRID_SIZE * GRID_SIZE);

pub fn main() !void {
    var iter: usize = 0;

    while (iter < 100) : (iter += 1) {
        printGrid(&grid);

        var row: i8 = 0;
        while (row < GRID_SIZE) : (row += 1) {
            var col: i8 = 0;
            while (col < GRID_SIZE) : (col += 1) {
                var alive_count: u8 = 0;

                inline for (.{
                    .{ -1, -1 },
                    .{ -1, 0 },
                    .{ -1, 1 },
                    .{ 0, -1 },
                    .{ 0, 1 },
                    .{ 1, -1 },
                    .{ 1, 0 },
                    .{ 1, 1 },
                }) |offset| {
                    const check_col = @mod(col + offset[0], GRID_SIZE);
                    const check_row = @mod(row + offset[1], GRID_SIZE);
                    const index = @intCast(u8, check_row * GRID_SIZE + check_col);
                    alive_count += grid[index];
                }

                const index = @intCast(u8, row * GRID_SIZE + col);
                const is_alive = grid[index] == 1;

                if (is_alive) {
                    back_buffer[index] = if (alive_count < 2 or alive_count > 3) 0 else 1;
                } else if (alive_count == 3) {
                    back_buffer[index] = 1;
                } else {
                    back_buffer[index] = 0;
                }
            }
        }

        grid = back_buffer;
        std.time.sleep(100 * std.time.ns_per_ms);
    }
}

fn printGrid(g: []const u1) void {
    var stdout_hndl = std.io.getStdOut();
    stdout_hndl.writeAll(&.{ 0o33, '[', '2', 'J' }) catch unreachable;

    print("----------\n", .{});
    for (g, 0..) |value, i| {
        if (i > 0 and i % GRID_SIZE == 0) {
            print("\n", .{});
        }
        const char: u8 = switch (value) {
            0 => ' ',
            1 => '#',
        };
        print("{c}", .{char});
    }
    print("\n----------\n", .{});
}

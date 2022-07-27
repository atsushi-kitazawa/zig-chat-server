const std = @import("std");

const Chat = struct {
    channel:[]const u8,
    member:[][]const u8,

    pub fn init(channel:[]const u8, member:[][]const u8) Chat {
        return Chat{
            .channel = channel,
            .member = member,
        };
    }
};

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});

    testFn("foo bar");

    var members = [_][]const u8{"user1", "user2", "user3"};
    var c1 = Chat.init("chan1", &members);
    std.log.info("{}", .{c1});
}

pub fn testFn(data: []const u8) void {
    std.log.debug("{s}", .{data});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}

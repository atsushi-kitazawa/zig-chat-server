const std = @import("std");
const log = std.log;
const net = std.net;

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
    log.info("init server.", .{});

    try doMain();

    log.info("start server 127.0.0.1:8888...", .{});

    // testFn("foo bar");

    // var members = [_][]const u8{"user1", "user2", "user3"};
    // var c1 = Chat.init("chan1", &members);
    // std.log.info("{}", .{c1});
}

pub fn doMain() anyerror!void {
    const address = net.Address.initIp4([4]u8{127,0,0,1}, 8888);
    var server = net.StreamServer.init(.{});
    try server.listen(address);
    const connection = try server.accept();
    defer connection.stream.close();

    var buf: [1024]u8 = undefined;
    var msgSize = try connection.stream.read(buf[0..]);
    log.info("client message is {s}", .{buf[0..msgSize]});

    _ = try connection.stream.write("hello !!");
}

pub fn testFn(data: []const u8) void {
    std.log.debug("{s}", .{data});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}

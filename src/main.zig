const std = @import("std");
const log = std.log;
const net = std.net;
const expect = std.testing.expect;

const Chat = struct {
    channel: []const u8,
    member: [][]const u8,

    pub fn init(channel: []const u8, member: [][]const u8) Chat {
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
}

pub fn doMain() anyerror!void {
    const address = net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8888);
    var server = net.StreamServer.init(.{ .reuse_address = true });
    try server.listen(address);

    while (true) {
        const connection = try server.accept();
        try process(connection);
    }
}

pub fn process(conn: net.StreamServer.Connection) anyerror!void {
    while (true) {
        var buf: [1024]u8 = undefined;
        var msgSize = try conn.stream.read(buf[0..]);
        var msg = buf[0..msgSize];
        log.info("client message is {s}", .{msg});

        if (std.mem.eql(u8, msg, "quit")) {
            log.info("equal", .{});
            defer conn.stream.close();
            break;
        }

        _ = try conn.stream.write("hello !!");
    }
}

pub fn testFn(data: []const u8) void {
    std.log.debug("{s}", .{data});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}

test "difine function" {
    testFn("foo bar.");
}

test "test struct" {
    // var members = [_][]const u8{"user1", "user2", "user3"};
    // var c1 = Chat.init("chan1", &members);
    // std.log.info("{}", .{c1});
}

test "if u8 slice" {
    var data = "foo bar";
    if (std.mem.eql(u8, data, "foo bar")) {
        try expect(true);
    } else {
        try expect(false);
    }

    if (std.mem.eql(u8, data, "hoge ahe")) {
        try expect(false);
    } else {
        try expect(true);
    }
}

test "type check" {
    const T = @TypeOf("connection");
    log.info("{}", .{T});
}

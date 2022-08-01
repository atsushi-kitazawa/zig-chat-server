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
        log.info("accept client = {}", .{connection.address});
        try process(connection);
    }
}

pub fn process(conn: net.StreamServer.Connection) anyerror!void {
    var clientAddress_alloc = std.heap.page_allocator;
    const clientAddress = try std.fmt.allocPrint(clientAddress_alloc, "{}>", .{conn.address});
    defer clientAddress_alloc.free(clientAddress);

    while (true) {
        _ = try conn.stream.write(clientAddress);

        var buf: [1024]u8 = undefined;
        var msgSize = try conn.stream.read(buf[0..]);
        // remove \r\n
        var msg = buf[0 .. msgSize - 2];
        log.info("client message = {s}, size = {d}", .{ msg, msgSize });

        if (std.mem.eql(u8, msg, "/leave")) {
            log.info("leave client = {}", .{conn.address});
            defer conn.stream.close();
            break;
        }

        var allocator = std.heap.page_allocator;
        const respMsg = try std.fmt.allocPrint(allocator, "you sent msg = {s}\r\n", .{msg});
        defer allocator.free(respMsg);
        _ = try conn.stream.write(respMsg);
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

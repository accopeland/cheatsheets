---
syntax: bash
tags: [ dev ]
---
# ubuntu install
snap install zig --classic --beta

# macos install
asdf install zig
brew install zig

# debian install
 echo 'deb https://dl.bintray.com/dryzig/zig-ubuntu groovy main' | sudo tee -a /etc/apt/sources.list
 sudo apt update
 sudo apt install zig

#docs
https://ziglearn.org

# compile c/c++
CC="zig cc" CXX="zig c++" ./configure
make

# cross-compile
CC="zig cc -target aarch64-linux-gnu" CXX="zig c++ -target aarch64-linux-gnul" AR="zig ar" RANLIB="zig ranlib"  ./configure

# cross configure / compile
make CC="zig cc -target x86_64-linux-musl" CXX="zig c++ -target x86_64-linux-musl" AR="zig ar" RANLIB="zig ranlib"
export CC="zig cc -target aarch64-linux-gnu"
export HOST_CC="zig cc"
make CC="$CC" HOST_CC="$HOST_CC" TARGET_STRIP="echo"

# show
zig build-obj --show-builtin

# targets
zig targets | jq .libc

# c example
#include <stddef.h>
int main() {
   return 0;
}
zig cc -lc test.c
zig cc -lc test.c --target=aarch64-macos-gnu

#  autooconf
autoreconf -vi
 CC="zig cc -target native-native-musl"
 CXX="zig c++ -target native-native-musl"
 ##echo $HOST_CC
 CC="$CC" CXX="$CXX" HOST_CC="$HOST_CC" TARGET_STRIP="echo" ./configure
make check

# musl
CXX="zig c++ -target aarch64-linux-musl"
[ec2-user@ip-172-31-11-129 easel]$ CC="zig cc -target aarch64-linux-musl"
[ec2-user@ip-172-31-11-129 easel]$ CC="$CC" CXX="$CXX" HOST_CC="$HOST_CC" TARGET_STRIP="echo" ./configure

// Single-line comments start with "//", documentation comments start with "///"
const x: i32 = 42; // immutable int32 value that can not be changed
var y: u32 = 5;    // mutable unsigned int32 variable
var z = y; // type can be omitted if it can be inferred from the value
// There is no "int" type, all integers have fixed width.
// Same about floats, there are f16, f32, f64 and f128.
// For indices, "intptr_t" or "size_t" types use "isize" or "usize".
// All function parameters are immutable as if they are passed-by-value.
fn add_two_ints(a: i32, b: i32) i32 {
	if (a == 0) { // if statement looks like C
		return b;
	}
	return a+b;
}
// Arrays have fixed length, here numbers.len == 5
const numbers = [_]i32{ 0, 1, 3, 5, 7 };
// String literals are arrays of []u8
const hello = "hello";
// Arrays can be initialised with repeating values using ** operator
const ten_zero_bytes = [_]u8{0} ** 10;
// Arrays may contain a sentinel value at the end, here array.len == 4 and array[4] == 0.
const array = [_:0]u8 {1, 2, 3, 4};
// Slices are pointers to array data with associated length. The difference between
// arrays and slices is that array's length is known at compile time, while slice
// length is only known at runtime. Like arrays, slices also perform bounds checking.
const full_slice = numbers[0..]; // points at &numbers[0] and has length of 5
const short_slice = numbers[1..3]; // points at &numbers[1] and has length of 2
fn count_nonzero(a: []const i32) i32 {
	var count: i32 = 0;
	for (items) |value| { // "for" works only on arrays and slices, use "while" for generic loops.
		if (value == 0) {
			continue;
		}
		count += 1; // there is no increment operator, but there are shortcuts for +=, *=, >>= etc.
	}
}
pub fn main() void { // main() is a special entry point to your program
	var eight = add_two_ints(3, 5);
	var nonzeros = count_nonzero(full_slice);
}


# read a file
const std = @import("std");
const ProgramError = error{
    WrongAmountOfArguments,
};
pub fn main() !void {
    // Get an allocator.
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Get the file from the program's arguments, and assert there's a correct
    // amount of arguments.
    //
    // Note: you'd usually also want `std.process.argsFree` but since we're
    // using an arena allocator, the arena will free all memory at the end of
    // the program. Freeing at the end allows us to not worry about freeing
    // individual pieces of memory.
    // See also:
    //  "What's a Memory Allocator Anyway? - Benjamin Feng" on YouTube.
    const args = try std.process.argsAlloc(allocator);
    if (args.len != 2) {
        std.log.err(
            "Incorrect number of arguments: wanted 2, got {d}",
            .{args.len},
        );
        return ProgramError.WrongAmountOfArguments;
    }
    const filename = args[1];
    // Get the path to the file.
    //
    // We use `Z` version of `realpath` because Zig supports different types
    // of Pointer/Array notation. In this case, our arguments are 0-terminated
    // and that's the reason we use the `Z` variant.
    //
    // See also:
    //  "Solving Common Pointer Conundrums - Loris Cro" on YouTube.
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpathZ(filename, &path_buffer);
    // Open the file.
    //
    // The `.{}` means use the default version of `File.OpenFlags`.
    const file = try std.fs.openFileAbsolute(path, .{});
    defer file.close();
    // Get the contents - option 1
    // If the file is big prefer option 2.
    //
    // Read the entire file into memory by specifying a max length.
    // const mb = (1 << 10) << 10;
    // const file_contents = file.readToEndAlloc(allocator, 1 * mb);
    // Get the contents - option 2.
    //
    // Steam the file into memory using a buffered reader and get the contents
    // 1 byte at a time. You can change the number of bytes read at a time by
    // changing the buffer size.
    var buffered_file = std.io.bufferedReader(file.reader());
    var buffer: [1]u8 = undefined;
    while (true) {
        const number_of_read_bytes = try buffered_file.read(&buffer);
        if (number_of_read_bytes == 0) {
            break; // No more data
        }
        // Buffer now has some of the file bytes, do something with it here...
    }
}

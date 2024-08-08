# description
🤖 Just a command runner
Lightweight task runner in rust. Suitable replacement for Makefiles.
Any complex set of commands that you really should write down somewhere, if only to be able to remember them

# install
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to DEST
brew install just
cargo install just

# docs
https://github.com/casey/just?tab=readme-ov-file
https://cheatography.com/linux-china/cheat-sheets/justfile/

# alternatives
go-task:
mage:
make: The Unix build tool that inspired just. There are a few different modern day descendents of the original make, including FreeBSD Make and GNU Make.
task: A YAML-based command runner written in Go.
maid: A Markdown-based command runner written in JavaScript.
microsoft/just: A JavaScript-based command runner written in JavaScript.
cargo-make: A command runner for Rust projects.
mmake: A wrapper around make with a number of improvements, including remote includes.
robo: A YAML-based command runner written in Go.
mask: A Markdown-based command runner written in Rust.
makesure: A simple and portable command runner written in AWK and shell.
haku: A make-like command runner written in Rust.

# synopsis
Commands, called recipes, are stored in a file called justfile with syntax inspired by make:
You can then run them with just RECIPE:
$ just test-all
cc *.c -o main
./test --all
Yay, all your tests passed!


# justfication
- just is a command runner, not a build system, so it avoids much of make's complexity and idiosyncrasies. No need for .PHONY recipes!
- Linux, MacOS, and Windows are supported with no additional dependencies. (Although if your system doesn't have an sh, you'll need to choose a different shell.)
- Errors are specific and informative, and syntax errors are reported along with their source context.
- Recipes can accept command line arguments.
- Wherever possible, errors are resolved statically. Unknown recipes and circular dependencies are reported before anything runs.
- just loads .env files, making it easy to populate environment variables.
- Recipes can be listed from the command line.
- Command line completion scripts are available for most popular shells.
- Recipes can be written in arbitrary languages, like Python or NodeJS.
- just can be invoked from any subdirectory, not just the directory that contains the justfile.

# files
The search for a justfile is case insensitive, so any case, like Justfile, JUSTFILE, or JuStFiLe, will work. just will also look for files with the name .justfile, in case you'd like to hide a justfile.

# basic justfile
set shell := ["cmd.exe", "/c"]
hello:
  Write-Host "Hello, world!"
list:
  dir

#Quick Start
See the installation section for how to install just on your computer. Try running just --version to make sure that it's installed correctly.
Recipes stop running if a command fails.
Recipes can depend on other recipes. Here the test recipe depends on the build recipe, so build will run before test:
Recipes without dependencies will run in the order they're given on the command line:
Dependencies will always run first, even if they are passed after a recipe that depends on them:

# Examples
A variety of example justfiles can be found in the examples directory.

# Features
The Default Recipe
When just is invoked without a recipe, it runs the first recipe in the justfile. This recipe might be the most frequently run command in the project, like running the tests:

# use dependencies to run multiple recipes by default:

default: lint build test
build:
  echo Building…
test:
  echo Testing…
lint:
  echo Linting…

# Listing Available Recipes
Recipes can be listed in alphabetical order with just --list:

# Aliases allow recipes to be invoked on the command line with alternative names:
alias b := build
build:
  echo 'Building!'
$ just b
echo 'Building!'
Building!

# Settings
Settings control interpretation and execution. Each setting may be specified at most once, anywhere in the justfile.
ex:
set shell := ["zsh", "-cu"]
foo:
  # this line will be run as `zsh -cu 'ls **/*.txt'`
  ls **/*.txt

# set NAME
Which is equivalent to:
set NAME := true

# export -- export all just variables as environment variables. Defaults to false.
set export
a := "hello"
@foo b:
  echo $a
  echo $b
$ just foo goodbye
hello
goodbye

# positional-arguments (bool) -- If true, recipe arguments will be passed as positional arguments to commands.
# For linewise recipes, argument $0 will be the name of the recipe.
For example, running this recipe:
ex:
set positional-arguments
@foo bar:
  echo $0
  echo $1
Will produce the following output:
$ just foo hello
foo
hello

# shell
The shell setting controls the command used to invoke recipe lines and backticks. Shebang recipes are unaffected.

# use python3 to execute recipe lines and backticks
set shell := ["python3", "-c"]

# use print to capture result of evaluation
foos := `print("foo" * 4)`
foo:
  print("Snake snake snake snake.")
  print("{{foos}}")
just passes the command to be executed as an argument. Many shells will need an additional flag, often -c, to make them evaluate the first argument.

Windows PowerShell
#Documentation Comments
Comments immediately preceding a recipe will appear in just --list:

# Joining Paths
The / operator can be used to join two strings with a slash:
foo := "a" / "b"
$ just --evaluate foo
a/b
Note that a / is added even if one is already present:

# write a recipe containing {{ -- use {{{{:
ex:
braces:
  echo 'I {{{{LOVE}} curly braces!'
(An unmatched }} is ignored, so it doesn't need to be escaped.)

# Strings
Double-quoted strings support escape sequences:
ex:
string-with-tab             := "\t"
string-with-newline         := "\n"
string-with-carriage-return := "\r"
string-with-double-quote    := "\""
string-with-slash           := "\\"
string-with-no-newline      := "\
"
$ just --evaluate
"tring-with-carriage-return := "
string-with-double-quote    := """
string-with-newline         := "
"
string-with-no-newline      := ""
string-with-slash           := "\"
string-with-tab             := "     "

# Strings may contain line breaks:
single := '
hello
'

double := "
goodbye
"
Single-quoted strings do not recognize escape sequences:

# Escapes
escapes := '\t\n\r\"\\'
$ just --evaluate
escapes := "\t\n\r\"\\"

# Indented versions of both single- and double-quoted strings, delimited by triple single- or triple double-quotes, are supported
Indented string lines are stripped of a leading line break, and leading whitespace common to all non-blank lines:

# suppress Error message
just normally prints errormsg when a recipe line fails.
suppress errormsg using [no-exit-message]

# Stopping execution with error
Execution can be halted with the error function. For example:
foo := if "hello" == "goodbye" {
  "xyz"
} else if "a" == "b" {
  "abc"
} else {
  error("123")
}
git *args:
    @git {{args}}
$ just git status
fatal: not a git repository (or any of the parent directories): .git
error: Recipe `git` failed on line 2 with exit code 128

# Add the attribute to suppress the exit error message when the tool exits with a non-zero code:
[no-exit-message]
git *args:
    @git {{args}}
$ just git status
fatal: not a git repository (or any of the parent directories): .git

# Ignoring Errors
To continue after a failing command prefix the command with -:
foo:
  -cat foo
  echo 'Done!'
$ just foo
cat foo
cat: foo: No such file or directory
echo 'Done!'
Done!

# Functions
just provides a few built-in functions that might be useful when writing recipes.
System Information
arch() — Instruction set architecture. Possible
num_cpus()1.15.0 - Number of logical CPUs.
os() — Operating system.
os_family() — Operating system family; possible values are: "unix" and "windows".
ex:  @echo "This is an {{arch()}} machine".
env_var(key) — Retrieves the environment variable with name key, aborting if it is not present. ex: home_dir := env_var('HOME')
env(key)1.15.0 — Alias for env_var(key).
env(key, default)1.15.0 — Alias for env_var_or_default(key, default).
invocation_directory() - Retrieves the abspath to the cur dir, before just chdir'd prior to executing commands. ex:  cd {{invocation_directory()}}; ./script_to_run_from_here
invocation_directory_native() - Retrieves the absolute path to the current directory when just was invoked, before just changed it (chdir'd) prior to executing commands.
justfile() - Retrieves the path of the current justfile.
justfile_directory() - Retrieves the path of the parent directory of the current justfile.ex:  ./{{justfile_directory()}}/scripts/some_script
just_executable() - Absolute path to the just executable. ex:  @echo The executable is at: {{just_executable()}}
just_pid() - Process ID of the just executable.  @echo The process ID is: {{ just_pid() }}
quote(s) - Replace all single quotes with '\'' and prepend and append single quotes to s.
replace(s, from, to) - Replace all occurrences of from in s to to.
replace_regex(s, regex, replacement) - Replace all occurrences of regex in s to replacement.
trim(s) - Remove leading and trailing whitespace from s.
trim_end(s) - Remove trailing whitespace from s.
trim_end_match(s, pat) - Remove suffix of s matching pat.
trim_end_matches(s, pat) - Repeatedly remove suffixes of s matching pat.
trim_start(s) - Remove leading whitespace from s.
trim_start_match(s, pat) - Remove prefix of s matching pat.
trim_start_matches(s, pat) - Repeatedly remove prefixes of s matching pat.
capitalize(s)1.7.0 - Convert first character of s to uppercase and the rest to lowercase.
kebabcase(s)1.7.0 - Convert s to kebab-case.
lowercamelcase(s)1.7.0 - Convert s to lowerCamelCase.
lowercase(s) - Convert s to lowercase.
shoutykebabcase(s)1.7.0 - Convert s to SHOUTY-KEBAB-CASE.
shoutysnakecase(s)1.7.0 - Convert s to SHOUTY_SNAKE_CASE.
snakecase(s)1.7.0 - Convert s to snake_case.
titlecase(s)1.7.0 - Convert s to Title Case.
uppercamelcase(s)1.7.0 - Convert s to UpperCamelCase.
uppercase(s) - Convert s to uppercase.
absolute_path(path) - Absolute path to relative path in the working directory. absolute_path("./bar.txt") in directory /foo is /foo/bar.txt.
canonicalize(path)1.24.0 - Canonicalize path by resolving symlinks and removing ., .., and extra /s where possible.
extension(path) - Extension of path. extension("/foo/bar.txt") is txt.
file_name(path) - File name of path with any leading directory components removed. file_name("/foo/bar.txt") is bar.txt.
file_stem(path) - File name of path without extension. file_stem("/foo/bar.txt") is bar.
parent_directory(path) - Parent directory of path. parent_directory("/foo/bar.txt") is /foo.
without_extension(path) - path without extension. without_extension("/foo/bar.txt") is /foo/bar.
clean(path) - Simplify path by removing extra path separators, intermediate . components, and .. where possible.
join(a, b…) - This function uses / on Unix and \ on Windows, which can be lead to unwanted behavior.
path_exists(path) - Returns true if the path points at an existing entity and false otherwise. Traverses symbolic links
error(message) - Abort execution and report error message to user.
blake3(string)1.25.0 - Return BLAKE3 hash of string as hexadecimal string.
blake3_file(path)1.25.0 - Return BLAKE3 hash of file at path as hexadecimal string.
sha256(string) - Return the SHA-256 hash of string as hexadecimal string.
sha256_file(path) - Return SHA-256 hash of file at path as hexadecimal string.
uuid() - Generate a random version 4 UUID.
semver_matches(version, requirement) - Check whether a semver matches a requirement, e.g., ">=0.1.0", returning "true" if so and "false" otherwise.
cache_directory() - The user-specific cache directory.
config_directory() - The user-specific configuration directory.
config_local_directory() - The local user-specific configuration directory.
data_directory() - The user-specific data directory.
data_local_directory() - The local user-specific data directory.
executable_directory() - The user-specific executable directory.
home_directory() - The user's home directory.
[confirm]1.17.0	Require confirmation prior to executing recipe.
[confirm("prompt")]1.23.0	Require confirmation prior to executing recipe with a custom prompt.
[linux]1.8.0	Enable recipe on Linux.
[macos]1.8.0	Enable recipe on MacOS.
[no-cd]1.9.0	Don't change directory before executing recipe.
[no-exit-message]1.7.0	Don't print an error message if recipe fails.
[no-quiet]1.23.0	Override globally quiet recipes and always echo out the recipe.
[private]1.10.0	See Private Recipes.
[unix]1.8.0	Enable recipe on Unixes. (Includes MacOS).
[windows]1.8.0	Enable recipe on Windows.
A recipe can have multiple attributes, either on multiple lines:
[no-cd]
[private]
[no-cd, private]
Enabling and Disabling Recipes1.8.0
The [linux], [macos], [unix], and [windows] attributes are configuration attributes. By default, recipes are always enabled. A recipe with one or more configuration attributes will only be enabled when one or more of those configurations is active.
This can be used to write justfiles that behave differently depending on which operating system they run on. The run recipe in this justfile will compile and run main.c, using a different C compiler and using the correct output binary name for that compiler depending on the operating system:
[confirm]
[confirm("Are you sure you want to delete everything?")]

# Command execution
Backticks can be used to store the result of commands:
localhost := `dumpinterfaces | cut -d: -f2 | sed 's/\/.*//' | sed 's/ //g'`

# Conditional Expressions
if/else expressions evaluate different branches depending on if two expressions evaluate to the same value:
foo := if "2" == "2" { "Good!" } else { "1984" }
foo := if "hello" != "goodbye" { "xyz" } else { "abc" }
foo := if "hello" =~ 'hel+o' { "match" } else { "mismatch" }

# Regular expressions
provided by the regex crate
Conditional expressions short-circuit, only evaluate one of their branches.
foo := if env_var("RELEASE") == "true" { `get-something-from-release-database` } else { "dummy-value" }

# Conditionals
  echo {{ if foo == "bar" { "hello" } else { "goodbye" } }}
Note the space after the final }! Without the space, the interpolation will be prematurely closed.

# Multiple conditionals can be chained:
foo := if "hello" == "goodbye" {
  "xyz"
} else if "a" == "a" {
  "abc"
} else {
  "123"
}


# Setting Variables from the Command Line
os := "linux"
test: build
  ./test --test {{os}}
build:
  ./build {{os}}
$ just
./build linux
./test --test linux
Any number of arguments of the form NAME=VALUE can be passed before recipes:

# set variables
$ just --set os bsd
./build bsd
./test --test bsd

#Getting and Setting Environment Variables

#Exporting just Variables
Assignments prefixed with the export keyword will be exported to recipes as environment variables:

export RUST_BACKTRACE := "1"

test:
  # will print a stack trace if it crashes
  cargo test
Parameters prefixed with a $ will be exported as environment variables:

test $RUST_BACKTRACE="1":
  # will print a stack trace if it crashes
  cargo test
Exported variables and parameters are not exported to backticks in the same scope.

export WORLD := "world"
# This backtick will fail with "WORLD: unbound variable"
BAR := `echo hello $WORLD`
# Running `just a foo` will fail with "A: unbound variable"
a $A $B=`echo $A`:
  echo $A $B
When export is set, all just variables are exported as environment variables.

# Getting Environment Variables from the environment
Environment variables from the environment are passed automatically to the recipes.

print_home_folder:
  echo "HOME is: '${HOME}'"
$ just
HOME is '/home/myuser'
Setting just Variables from Environment Variables
Environment variables can be propagated to just variables using the functions env_var() and env_var_or_default(). See environment-variables.

#Recipe Parameters
Recipes may have parameters. Here recipe build has a parameter called target:

build target:
  @echo 'Building {{target}}…'
  cd {{target}} && make
To pass arguments on the command line, put them after the recipe name:

$ just build my-awesome-project
Building my-awesome-project…
cd my-awesome-project && make
To pass arguments to a dependency, put the dependency in parentheses along with the arguments:

default: (build "main")

build target:
  @echo 'Building {{target}}…'
  cd {{target}} && make
Variables can also be passed as arguments to dependencies:

target := "main"

_build version:
  @echo 'Building {{version}}…'
  cd {{version}} && make

build: (_build target)
A command's arguments can be passed to dependency by putting the dependency in parentheses along with the arguments:

build target:
  @echo "Building {{target}}…"

push target: (build target)
  @echo 'Pushing {{target}}…'
Parameters may have default values:

default := 'all'

test target tests=default:
  @echo 'Testing {{target}}:{{tests}}…'
  ./test --tests {{tests}} {{target}}


# Parameters with default values may be omitted:

$ just test server
Testing server:all…
./test --tests all server
Or supplied:

$ just test server unit
Testing server:unit…
./test --tests unit server
Default values may be arbitrary expressions, but concatenations or path joins must be parenthesized:

arch := "wasm"

test triple=(arch + "-unknown-unknown") input=(arch / "input.dat"):
  ./test {{triple}}

# The last parameter of a recipe may be variadic, indicated with either a + or a * before the argument name:

backup +FILES:
  scp {{FILES}} me@server.com:
Variadic parameters prefixed with + accept one or more arguments and expand to a string containing those arguments separated by spaces:

$ just backup FAQ.md GRAMMAR.md
scp FAQ.md GRAMMAR.md me@server.com:
FAQ.md                  100% 1831     1.8KB/s   00:00
GRAMMAR.md              100% 1666     1.6KB/s   00:00
Variadic parameters prefixed with * accept zero or more arguments and expand to a string containing those arguments separated by spaces, or an empty string if no arguments are present:

commit MESSAGE *FLAGS:
  git commit {{FLAGS}} -m "{{MESSAGE}}"
Variadic parameters can be assigned default values. These are overridden by arguments passed on the command line:

test +FLAGS='-q':
  cargo test {{FLAGS}}
{{…}} substitutions may need to be quoted if they contain spaces. For example, if you have the following recipe:

search QUERY:
  lynx https://www.google.com/?q={{QUERY}}
And you type:

$ just search "cat toupee"
just will run the command lynx https://www.google.com/?q=cat toupee, which will get parsed by sh as lynx, https://www.google.com/?q=cat, and toupee, and not the intended lynx and https://www.google.com/?q=cat toupee.

You can fix this by adding quotes:

search QUERY:
  lynx 'https://www.google.com/?q={{QUERY}}'
Parameters prefixed with a $ will be exported as environment variables:

foo $bar:
  echo $bar

# Running Recipes at the End of a Recipe
Normal dependencies of a recipes always run before a recipe starts. That is to say, the dependee always runs before the depender. These dependencies are called "prior dependencies".

A recipe can also have subsequent dependencies, which run after the recipe and are introduced with an &&:

a:
  echo 'A!'

b: a && c d
  echo 'B!'

c:
  echo 'C!'

d:
  echo 'D!'
…running b prints:

$ just b
echo 'A!'
A!
echo 'B!'
B!
echo 'C!'
C!
echo 'D!'
D!

# Running Recipes in the Middle of a Recipe
just doesn't support running recipes in the middle of another recipe, but you can call just recursively in the middle of a recipe. Given the following justfile:

a:
  echo 'A!'

b: a
  echo 'B start!'
  just c
  echo 'B end!'

c:
  echo 'C!'
…running b prints:

$ just b
echo 'A!'
A!
echo 'B start!'
B start!
echo 'C!'
C!
echo 'B end!'
B end!
This has limitations, since recipe c is run with an entirely new invocation of just: Assignments will be recalculated, dependencies might run twice, and command line arguments will not be propagated to the child just process.

# Writing Recipes in Other Languages
shebang recipes are executed by saving the recipe body to a file and running it. On Unix-like os, shebang recipes execute a tempfile.
ex:
polyglot: python js perl sh ruby nu
python:
  #!/usr/bin/env python3
  print('Hello from python!')
js:
  #!/usr/bin/env node
  console.log('Greetings from JavaScript!')
perl:
  #!/usr/bin/env perl
  print "Larry Wall says Hi!\n";
sh:
  #!/usr/bin/env sh
  hello='Yo'
  echo "$hello from a shell script!"
nu:
  #!/usr/bin/env nu
  let hello = 'Hola'
  echo $"($hello) from a nushell script!"
ruby:
  #!/usr/bin/env ruby
  puts "Hello from ruby!"

# Safer Bash Shebang Recipes
If you're writing a bash shebang recipe, consider adding set -euxo pipefail:
ex:
foo:
  #!/usr/bin/env bash
  set -euxo pipefail
  hello='Yo'
  echo "$hello from Bash!"

#Setting Variables in a Recipe
Recipe lines are interpreted by the shell, not just, so it's not possible to set just variables in the middle of a recipe:
foo:
  x := "hello" # This doesn't work!
  echo {{x}}
It is possible to use shell variables, but there's another problem. Every recipe line is run by a new shell instance, so variables set in one line won't be set in the next:
foo:
  x=hello && echo $x # This works!
  y=bye
  echo $y            # This doesn't, `y` is undefined here!
The best way to work around this is to use a shebang recipe. Shebang recipe bodies are extracted and run as scripts, so a single shell instance will run the whole thing:
foo:
  #!/usr/bin/env bash
  set -euxo pipefail
  x=hello
  echo $x
Sharing Environment Variables Between Recipes
Each line of each recipe is executed by a fresh shell, so it is not possible to share environment variables between recipes.

# Python Virtual Environments
Some tools, like Python's venv, require loading environment variables in order to work, making them challenging to use with just. As a workaround, you can execute the virtual environment binaries directly:

venv:
  [ -d foo ] || python3 -m venv foo

run: venv
  ./foo/bin/python3 main.py
Changing the Working Directory in a Recipe
Each recipe line is executed by a new shell, so if you change the working directory on one line, it won't have an effect on later lines:

foo:
  pwd    # This `pwd` will print the same directory…
  cd bar
  pwd    # …as this `pwd`!
There are a couple ways around this. One is to call cd on the same line as the command you want to run:

foo:
  cd bar && pwd
The other is to use a shebang recipe. Shebang recipe bodies are extracted and run as scripts, so a single shell instance will run the whole thing, and thus a pwd on one line will affect later lines, just like a shell script:

foo:
  #!/usr/bin/env bash
  set -euxo pipefail
  cd bar
  pwd

# Indentation
indent with spaces or tabs, but not a mix of both. All of a recipe's lines must
have the same type of indentation, but different recipes in the same justfile
may use different indentation.

Each recipe must be indented at least one level from the recipe-name but after that may be further indented.

Here's a justfile with a recipe indented with spaces, represented as ·, and tabs, represented as →.

set windows-shell := ["pwsh", "-NoLogo", "-NoProfileLoadTime", "-Command"]

set ignore-comments

list-space directory:
··#!pwsh
··foreach ($item in $(Get-ChildItem {{directory}} )) {
····echo $item.Name
··}
··echo ""

# indentation nesting works even when newlines are escaped
list-tab directory:
→ @foreach ($item in $(Get-ChildItem {{directory}} )) { \
→ → echo $item.Name \
→ }
→ @echo ""
PS > just list-space ~
Desktop
Documents
Downloads

PS > just list-tab ~
Desktop
Documents
Downloads

# Multi-Line Constructs
Recipes without an initial shebang are evaluated and run line-by-line, which means that multi-line constructs probably won't do what you want.
For example, with the following justfile:

conditional:
  if true; then
    echo 'True!'
  fi
The extra leading whitespace before the second line of the conditional recipe will produce a parse error:

$ just conditional
error: Recipe line has extra leading whitespace
  |
3 |         echo 'True!'
  |     ^^^^^^^^^^^^^^^^
To work around this, you can write conditionals on one line, escape newlines with slashes, or add a shebang to your recipe. Some examples of multi-line constructs are provided for reference.

# if statements
conditional:
  if true; then echo 'True!'; fi
conditional:
  if true; then \
    echo 'True!'; \
  fi
conditional:
  #!/usr/bin/env sh
  if true; then
    echo 'True!'
  fi

# for loops
for:
  for file in `ls .`; do echo $file; done
for:
  for file in `ls .`; do \
    echo $file; \
  done
for:
  #!/usr/bin/env sh
  for file in `ls .`; do
    echo $file
  done

# while loops
while:
  while `server-is-dead`; do ping -c 1 server; done
while:
  while `server-is-dead`; do \
    ping -c 1 server; \
  done
while:
  #!/usr/bin/env sh
  while `server-is-dead`; do
    ping -c 1 server
  done

# Outside Recipe Bodies
Parenthesized expressions can span multiple lines:

abc := ('a' +
        'b'
         + 'c')

abc2 := (
  'a' +
  'b' +
  'c'
)

foo param=('foo'
      + 'bar'
    ):
  echo {{param}}

bar: (foo
        'Foo'
     )
  echo 'Bar!'
Lines ending with a backslash continue on to the next line as if the lines were joined by whitespace1.15.0:

a := 'foo' + \
     'bar'

foo param1 \
  param2='foo' \
  *varparam='': dep1 \
                (dep2 'foo')
  echo {{param1}} {{param2}} {{varparam}}

dep1: \
    # this comment is not part of the recipe body
  echo 'dep1'

dep2 \
  param:
    echo 'Dependency with parameter {{param}}'

# Backslash line continuations can also be used in interpolations. The line following the backslash must start with the same indentation as the recipe body, although additional indentation is accepted.

recipe:
  echo '{{ \
  "This interpolation " + \
    "has a lot of text." \
  }}'
  echo 'back to recipe body'

# Command Line Options
just supports a number of useful command line options for listing, dumping, and debugging recipes and variables:

$ just --list
Available recipes:
  js
  perl
  polyglot
  python
  ruby
$ just --show perl
perl:
  #!/usr/bin/env perl
  print "Larry Wall says Hi!\n";
$ just --show polyglot
polyglot: python js perl sh ruby
Run just --help to see all the options.

# Private Recipes
Recipes and aliases whose name starts with a _ are omitted from just --list:

test: _test-helper
  ./bin/test

_test-helper:
  ./bin/super-secret-test-helper-stuff
$ just --list
Available recipes:
    test
And from just --summary:

$ just --summary
test
The [private] attribute1.10.0 may also be used to hide recipes or aliases without needing to change the name:

[private]
foo:

[private]
alias b := bar

bar:
$ just --list
Available recipes:
    bar
This is useful for helper recipes which are only meant to be used as dependencies of other recipes.

# Quiet Recipes
A recipe name may be prefixed with @ to invert the meaning of @ before each line:

@quiet:
  echo hello
  echo goodbye
  @# all done!
Now only the lines starting with @ will be echoed:

$ just quiet
hello
goodbye
# all done!
All recipes in a Justfile can be made quiet with set quiet:

set quiet

foo:
  echo "This is quiet"

@foo2:
  echo "This is also quiet"
The [no-quiet] attribute overrides this setting:

set quiet

foo:
  echo "This is quiet"

[no-quiet]
foo2:
  echo "This is not quiet"
Shebang recipes are quiet by default:

foo:
  #!/usr/bin/env bash
  echo 'Foo!'
$ just foo
Foo!

# Adding @ to a shebang recipe name makes just print the recipe before executing it:
@bar:
  #!/usr/bin/env bash
  echo 'Bar!'
$ just bar
#!/usr/bin/env bash
echo 'Bar!'
Bar!

#Selecting Recipes to Run With an Interactive Chooser
The --choose subcommand makes just invoke a chooser to select which recipes to run. Choosers should read lines containing recipe names from standard input and print one or more of those names separated by spaces to standard output.

Because there is currently no way to run a recipe that requires arguments with --choose, such recipes will not be given to the chooser. Private recipes and aliases are also skipped.

The chooser can be overridden with the --chooser flag. If --chooser is not given, then just first checks if $JUST_CHOOSER is set. If it isn't, then the chooser defaults to fzf, a popular fuzzy finder.

Arguments can be included in the chooser, i.e. fzf --exact.

The chooser is invoked in the same way as recipe lines. For example, if the chooser is fzf, it will be invoked with sh -cu 'fzf', and if the shell, or the shell arguments are overridden, the chooser invocation will respect those overrides.

If you'd like just to default to selecting recipes with a chooser, you can use this as your default recipe:

default:
  @just --choose
Invoking justfiles in Other Directories
If the first argument passed to just contains a /, then the following occurs:

The argument is split at the last /.

The part before the last / is treated as a directory. just will start its search for the justfile there, instead of in the current directory.

The part after the last slash is treated as a normal argument, or ignored if it is empty.

This may seem a little strange, but it's useful if you wish to run a command in a justfile that is in a subdirectory.

For example, if you are in a directory which contains a subdirectory named foo, which contains a justfile with the recipe build, which is also the default recipe, the following are all equivalent:

$ (cd foo && just build)
$ just foo/build
$ just foo/
Additional recipes after the first are sought in the same justfile. For example, the following are both equivalent:

$ just foo/a b
$ (cd foo && just a b)
And will both invoke recipes a and b in foo/justfile.

Imports
One justfile can include the contents of another using import statements.

If you have the following justfile:

import 'foo/bar.just'

a: b
  @echo A
And the following text in foo/bar.just:

b:
  @echo B
foo/bar.just will be included in justfile and recipe b will be defined:

$ just b
B
$ just a
B
A
The import path can be absolute or relative to the location of the justfile containing it. A leading ~/ in the import path is replaced with the current users home directory.

Justfiles are insensitive to order, so included files can reference variables and recipes defined after the import statement.

Imported files can themselves contain imports, which are processed recursively.

When allow-duplicate-recipes is set, recipes in parent modules override recipes in imports.

Imports may be made optional by putting a ? after the import keyword:

import? 'foo/bar.just'
Missing source files for optional imports do not produce an error.

Modules1.19.0
A justfile can declare modules using mod statements. mod statements are currently unstable, so you'll need to use the --unstable flag, or set the JUST_UNSTABLE environment variable to use them.

If you have the following justfile:

mod bar

a:
  @echo A
And the following text in bar.just:

b:
  @echo B
bar.just will be included in justfile as a submodule. Recipes, aliases, and variables defined in one submodule cannot be used in another, and each module uses its own settings.

Recipes in submodules can be invoked as subcommands:

$ just --unstable bar b
B
Or with path syntax:

$ just --unstable bar::b
B
If a module is named foo, just will search for the module file in foo.just, foo/mod.just, foo/justfile, and foo/.justfile. In the latter two cases, the module file may have any capitalization.

Module statements may be of the form:

mod foo 'PATH'
Which loads the module's source file from PATH, instead of from the usual locations. A leading ~/ in PATH is replaced with the current user's home directory.

Environment files are only loaded for the root justfile, and loaded environment variables are available in submodules. Settings in submodules that affect environment file loading are ignored.

Recipes in submodules without the [no-cd] attribute run with the working directory set to the directory containing the submodule source file.

justfile() and justfile_directory() always return the path to the root justfile and the directory that contains it, even when called from submodule recipes.

Modules may be made optional by putting a ? after the mod keyword:

mod? foo
Missing source files for optional modules do not produce an error.

Optional modules with no source file do not conflict, so you can have multiple mod statements with the same name, but with different source file paths, as long as at most one source file exists:

mod? foo 'bar.just'
mod? foo 'baz.just'
See the module stabilization tracking issue for more information.

# Hiding justfiles
just looks for justfiles named justfile and .justfile, which can be used to keep a justfile hidden.

# Just Scripts
By adding a shebang line to the top of a justfile and making it executable, just can be used as an interpreter for scripts:

$ cat > script <<EOF
#!/usr/bin/env just --justfile

foo:
  echo foo
EOF
$ chmod +x script
$ ./script foo
echo foo
foo
When a script with a shebang is executed, the system supplies the path to the script as an argument to the command in the shebang. So, with a shebang of #!/usr/bin/env just --justfile, the command will be /usr/bin/env just --justfile PATH_TO_SCRIPT.

With the above shebang, just will change its working directory to the location of the script. If you'd rather leave the working directory unchanged, use #!/usr/bin/env just --working-directory . --justfile.

Note: Shebang line splitting is not consistent across operating systems. The previous examples have only been tested on macOS. On Linux, you may need to pass the -S flag to env:

#!/usr/bin/env -S just --justfile

default:
  echo foo

#Formatting and dumping justfiles
Each justfile has a canonical formatting with respect to whitespace and newlines.

# format
You can overwrite the current justfile with a canonically-formatted version using the currently-unstable --fmt flag:

$ cat justfile
# A lot of blank lines

some-recipe:
  echo "foo"
$ just --fmt --unstable
$ cat justfile
# A lot of blank lines

some-recipe:
    echo "foo"
Invoking just --fmt --check --unstable runs --fmt in check mode. Instead of overwriting the justfile, just will exit with an exit code of 0 if it is formatted correctly, and will exit with 1 and print a diff if it is not.

# dump
# You can use the --dump command to output a formatted version of the justfile to stdout:

$ just --dump > formatted-justfile
The --dump command can be used with --dump-format json to print a JSON representation of a justfile.

# Fallback to parent justfiles
If a recipe is not found in a justfile and the fallback setting is set, just will look for justfiles in the parent directory and up, until it reaches the root directory. just will stop after it reaches a justfile in which the fallback setting is false or unset.

As an example, suppose the current directory contains this justfile:

set fallback
foo:
  echo foo
And the parent directory contains this justfile:

bar:
  echo bar
$ just bar
Trying ../justfile
echo bar
bar

# Avoiding Argument Splitting
Given this justfile:

foo argument:
  touch {{argument}}
The following command will create two files, some and argument.txt:

$ just foo "some argument.txt"
The users shell will parse "some argument.txt" as a single argument, but when just replaces touch {{argument}} with touch some argument.txt, the quotes are not preserved, and touch will receive two arguments.

There are a few ways to avoid this: quoting, positional arguments, and exported arguments.

# Quoting
Quotes can be added around the {{argument}} interpolation:

foo argument:
  touch '{{argument}}'
This preserves just's ability to catch variable name typos before running, for example if you were to write {{argument}}, but will not do what you want if the value of argument contains single quotes.

Positional Arguments
The positional-arguments setting causes all arguments to be passed as positional arguments, allowing them to be accessed with $1, $2, …, and $@, which can be then double-quoted to avoid further splitting by the shell:

set positional-arguments

foo argument:
  touch "$1"
This defeats just's ability to catch typos, for example if you type $2, but works for all possible values of argument, including those with double quotes.

# Exported Arguments
All arguments are exported when the export setting is set:

set export

foo argument:
  touch "$argument"
Or individual arguments may be exported by prefixing them with $:

foo $argument:
  touch "$argument"
This defeats just's ability to catch typos, for example if you type $argumant, but works for all possible values of argument, including those with double quotes.

# Configuring the Shell
There are a number of ways to configure the shell for linewise recipes, which are the default when a recipe does not start with a #! shebang. Their precedence, from highest to lowest, is:

The --shell and --shell-arg command line options. Passing either of these will cause just to ignore any settings in the current justfile.
set windows-shell := [...]
set windows-powershell (deprecated)
set shell := [...]
Since set windows-shell has higher precedence than set shell, you can use set windows-shell to pick a shell on Windows, and set shell to pick a shell for all other platforms.

# Shell Alias
For lightning-fast command running, put alias j=just in your shell's configuration file.

In bash, the aliased command may not keep the shell completion functionality described in the next section. Add the following line to your .bashrc to use the same completion function as just for your aliased command:

complete -F _just -o bashdefault -o default j

# Shell Completion Scripts
Shell completion scripts for Bash, Zsh, Fish, PowerShell, and Elvish are available in the completions directory. Please refer to your shell's documentation for how to install them.

The just binary can also generate the same completion scripts at runtime, using the --completions command:

$ just --completions zsh > just.zsh
macOS Note: Recent versions of macOS use zsh as the default shell. If you use Homebrew to install just, it will automatically install the most recent copy of the zsh completion script in the Homebrew zsh directory, which the built-in version of zsh doesn't know about by default. It's best to use this copy of the script if possible, since it will be updated whenever you update just via Homebrew. Also, many other Homebrew packages use the same location for completion scripts, and the built-in zsh doesn't know about those either. To take advantage of just completion in zsh in this scenario, you can set fpath to the Homebrew location before calling compinit. Note also that Oh My Zsh runs compinit by default. So your .zshrc file could look like this:

# Init Homebrew, which adds environment variables
eval "$(brew shellenv)"

fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

# Then choose one of these options:
# 1. If you're using Oh My Zsh, you can initialize it here
# source $ZSH/oh-my-zsh.sh

# 2. Otherwise, run compinit yourself
# autoload -U compinit
# compinit

# Grammar
A non-normative grammar of justfiles can be found in GRAMMAR.md.

just.sh
Before just was a fancy Rust program it was a tiny shell script that called make. You can find the old version in contrib/just.sh.

# User justfiles
If you want some recipes to be available everywhere, you have a few options.

First, create a justfile in ~/.user.justfile with some recipes.

# Recipe Aliases
If you want to call the recipes in ~/.user.justfile by name, and don't mind creating an alias for every recipe, add the following to your shell's initialization script:

for recipe in `just --justfile ~/.user.justfile --summary`; do
  alias $recipe="just --justfile ~/.user.justfile --working-directory . $recipe"
done
Now, if you have a recipe called foo in ~/.user.justfile, you can just type foo at the command line to run it.

It took me way too long to realize that you could create recipe aliases like this. Notwithstanding my tardiness, I am very pleased to bring you this major advance in justfile technology.

# Forwarding Alias
If you'd rather not create aliases for every recipe, you can create a single alias:

alias .j='just --justfile ~/.user.justfile --working-directory .'
Now, if you have a recipe called foo in ~/.user.justfile, you can just type .j foo at the command line to run it.

I'm pretty sure that nobody actually uses this feature, but it's there.

¯\_(ツ)_/¯

# Customization
You can customize the above aliases with additional options. For example, if
you'd prefer to have the recipes in your justfile run in your home directory,
instead of the current directory:

alias .j='just --justfile ~/.user.justfile --working-directory ~'
Node.js package.json Script Compatibility
The following export statement gives just recipes access to local Node module binaries, and makes just recipe commands behave more like script entries in Node.js package.json files:

export PATH := "./node_modules/.bin:" + env_var('PATH')
Alternatives and Prior Art
There is no shortage of command runners! Some more or less similar alternatives to just include:

# heredoc
# see https://github.com/casey/just/issues/881
A. But I think just would mangle the indentation in that case, and the string wouldn't be correct..
generate_justfile:
    cat <<EOF > generated/Justfile \
    default: \
      @just --list \
    EOF
B. Using a shebang recipe isn't perfect, but wouldn't be too bad:
generate_justfile:
    #!/usr/bin/env bash
    set -euxo pipefail
    cat <<"EOF" > generated/Justfile
    default:
      @just --list
    EOF
C. Or Another option would be to use a variable:
export DEFAULT_JUSTFILE := '''
    default:
      @just --list
'''
generate_justfile:
	printf '%s' "$DEFAULT_JUSTFILE" > generated/Justfile

# recipe local variables -- bummer
# Recipe lines are interpreted by the shell, so it’s NOT possible to set variables in the middle of a recipe:
foo:
  x := "hello" # This doesn't work!
  echo {{x}}
# It is possible to use shell variables, BUT every recipe line is run by a new shell, so vars set in one line won’t be set in the next:
foo:
  x=hello && echo $x # This works!
  y=bye
  echo $y            # This doesn't, `y` is undefined here!
#The best way to work around this is to use a shebang recipe. Shebang recipe bodies are extracted and run as scripts, so a single shell instance will run the whole thing:
foo:
  #!/usr/bin/env bash
  set -euxo pipefail
  x=hello
  echo $x


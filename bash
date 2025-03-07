# description
notes on bash

# install
brew install bash

# config
.bashrc
.profile
.bash_profile

# docs
https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02

# Vi Mode Shortcuts:
k Fetch the previous command from the history list.
j Fetch the next command from the history list.
/string or CTRL-r Search history backward for a command matching string.
?string or CTRL-s Search history forward for a command matching string.
n Repeat search in the same direction as previous.
N Repeat search in the opposite direction as previous.
G Move to Nth history line e.g. 15Go

# History expansion
!  Starts a history substitution.
!!  Refers to the last command.
!n Refers to the n-th command line.
!-n Refers to the current command line minus n.
!string Refers to the most recent command starting with string.
!?string?  Refers to the most recent command containing string (the ending ? is optional).
ˆstring1ˆstring2ˆ Quick substitution. Repeats the last command, replacing string1 with string2.
!# Refers to the entire command line typed so far.

# Word Designators (word designators follow the event designators, separated by a colon): 0
0 The zeroth (first) word in a line (usually command name).
n The n-th word in a line.
ˆ The first argument (the second word) in a line.
$ The last argument in a line.
% The word matched by the most recent ?string? search.
x-y A range of words from x to y (-y is synonymous with 0-y).
* All word but the zeroth.
x* Synonymous with x-$.
x- The words from x to the second to last word.

# variables : see https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
${var+x} is a parameter expansion which evaluates to nothing if var is unset, and substitutes the string x otherwise.
RIGHT: if [ -z ${var+x} ]; then echo "var is unset"; else echo "var is set to '$var'"; fi
WRONG: if [ -z "$var" ]; then echo "var is blank"; else echo "var is set to '$var'"; fi
RIGHT: [ -v var ] bash>=4.2 -v to check if variable is set
WRONG: [ -v $var ]
[[ $var ]] && echo "var is set"
[[ $var ]] || echo "var is not set or it holds an empty string"

# parameter
${parameter:-[word]}  #Use Default Values. If parameter is unset or null, expansion of word (or "" if word omitted) shall be substituted; otherwise, the value of parameter shall be substituted.
${parameter:=[word]} # Assign Default Values. If parameter is unset or null, the expansion of word (or "" if word omitted) shall be assigned to parameter. In all cases, the final value of parameter shall be substituted. Only variables, not positional parameters or special parameters, can be assigned in this way.
${parameter:?[word]} # Indicate Error if Null or Unset. If parameter is unset or null, the expansion of word (or a message indicating it is unset if word is omitted) shall be written to standard error and the shell exits with a non-zero exit status. Otherwise, the value of parameter shall be substituted. An interactive shell need not exit.
${parameter:+[word]} # Use Alternative Value. If parameter is unset or null, null shall be substituted; otherwise, the expansion of word (or an empty string if word is omitted) shall be substituted.
${#parameter} # String Length. The length in characters of the value of parameter shall be substituted. If parameter is '*' or '@', the result of the expansion is unspecified. If parameter is unset and set -u is in effect, the expansion shall fail.

# parameter expansion
# The following four varieties of parameter expansion provide for substring processing. In each case, pattern matching notation, rather than regex notation, used to evaluate the patterns. If parameter is '#', '*', or '@', the result of the expansion is unspecified. If parameter is unset and set -u is in effect, the expansion shall fail. Enclosing the full parameter expansion string in double-quotes shall not cause the following four varieties of pattern characters to be quoted, whereas quoting characters within the braces shall have this effect. In each variety, if word is omitted, the empty pattern shall be used.
${parameter%[word]} # Remove Smallest Suffix Pattern. The word shall be expanded to produce a pattern. The parameter expansion shall then result in parameter, with the smallest portion of the suffix matched by the pattern deleted. If present, word shall not begin with an unquoted '%'.
${parameter%%[word]} # Remove Largest Suffix Pattern. The word shall be expanded to produce a pattern. The parameter expansion shall then result in parameter, with the largest portion of the suffix matched by the pattern deleted.
${parameter#[word]} # Remove Smallest Prefix Pattern. The word shall be expanded to produce a pattern. The parameter expansion shall then result in parameter, with the smallest portion of the prefix matched by the pattern deleted. If present, word shall not begin with an unquoted '#'.
${parameter##[word]} # Remove Largest Prefix Pattern. The word shall be expanded to produce a pattern. The parameter expansion shall then result in parameter, with the largest portion of the prefix matched by the pattern deleted.

# brace expansion -- generate arbitrary strings
echo a{d,c,b}e
ade ace abe

# filename expansion -- globbing

# shell expansion

# tilde expansion

# variable expansion

# for loop
for file in *;
do
    echo $file found;
done

# case
case "$1"
in
    0) echo "zero found";;
    1) echo "one found";;
    2) echo "two found";;
    3*) echo "something beginning with 3 found";;
esac

# debugging
set -x # enable  debugging:
set +x # disable debugging:

# Retrieve N-th piped command exit status
printf 'foo' | fgrep 'foo' | sed 's/foo/bar/'
echo ${PIPESTATUS[0]}  # replace 0 with N

# global replace in command
!!:gs^string1^string2

# To create a lockfile:
( set -o noclobber; echo > my.lock ) || echo 'Failed to create lock file'

# positional parameters
# See:
# - http://tldp.org/LDP/abs/html/string-manipulation.html#AEN5117
# - http://tldp.org/LDP/abs/html/internalvariables.html#POSPARAMREF
# - http://tldp.org/LDP/abs/html/internalvariables.html#IFSREF
# - http://tldp.org/LDP/abs/html/parameter-substitution.html#PARAMSUBREF
# - cmdparser, http://codesnippets.joyent.com/posts/show/1697
echo $#                             # number of arguments
printf "%s\n" "${@}"                # all arguments
printf "%s\n" "${1}"                # first argument
printf "%s\n" "${3}"                # third argument
printf "%s\n" "${5}"                # last argument
#
printf "%s\n" "${@:1}"              # all arguments starting with the first
printf "%s\n" "${@:2}"              # all arguments starting with the second
printf "%s\n" "${@:3}"              # all arguments starting with the third
#
printf "%s\n" "${@:(-$#):1}"        # first argument
printf "%s\n" "${@:$#:1}"           # last argument
printf "%s\n" "${!#}"               # last argument
#
printf "%s\n" "${@:1:1}"            # first argument
printf "%s\n" "${@:3:1}"            # third argument
printf "%s\n" "${@:5:1}"            # fifth argument
printf "%s\n" "${@:(-1):1}"         # last argument
printf "%s\n" "${@:(-2):1}"         # second-to-last argument

# string matching
expr match "$string" '$substring'   Length of matching $substring* at beginning of $string
expr "$string" : '$substring'   Length of matching $substring* at beginning of $string
expr index "$string" $substring Numerical position in $string of first character in $substring that matches
expr substr $string $position $length   Extract $length characters from $string starting at $position
expr match "$string" '\($substring\)'   Extract $substring* at beginning of $string
expr "$string" : '\($substring\)'   Extract $substring* at beginning of $string
expr match "$string" '.*\($substring\)' Extract $substring* at end of $string
expr "$string" : '.*\($substring\)' Extract $substring* at end of $string

# read multiple vars from file
awk '{print $1,$5}' file | while read x y ; ... ; done

# while read
while read x y ; ... ; done < F
while read -a ary ; ... ; done < F

# here-doc (here document; heredoc) and here strings
COMMAND <<< $VAR
COMMAND <<-W ; doc; W
var=$(cat <<-EOF
this is a line
so is this
EOF

# heredoc - avoid quoting hell
perl -lna - ng.input <<'EOF'
if (@F==2) {print $F[0] . "\t". $F[1] . "\n"} else { print "\t" . $F[0] . "\n" }
EOF
# bash -c example...
# regex substitutions - see http://tldp.org/LDP/LG/issue57/eyler.html  http://tldp.org/LDP/abs/html/refcards.html#AEN22004
$foo="this is a test"
'#'  delete shortest possible match from left:  >echo ${foo#t*is}  --> is a test
'##' delete longest possible match from left:   >echo ${foo##t*is} --> a test
'%'  delete shortest possible match from right: >echo ${foo%t*st}  --> this is a
'%%' delete longest possible match from right:  >echo ${foo%%t*is} -->  ""
${string:position}  Extract substring from $string  at $position
${string:position:length}   Extract $length characters substring from $string at $position
${string#substring} Strip shortest match of $substring from front of $string
${string##substring}    Strip longest match of $substring from front of $string
${string%substring} Strip shortest match of $substring from back of $string
${string%%substring}    Strip longest match of $substring from back of $string
${string/substring/replacement} Replace first match of $substring with $replacement
${string//substring/replacement}    Replace all matches of $substring with $replacement
${string/#substring/replacement}    If $substring matches front end of $string, substitute $replacement for $substring
${string/%substring/replacement}    If $substring matches back end of $string, substitute $replacement for $substring

# negation globbing
#see http://stackoverflow.com/questions/216995/how-can-i-use-negative-wildcards-in-a-unix-linux-shell
shopt -s extglob # but see readonly
cp !(*Music*) /tmp
ls -d !(*@(.c|.h))

# string matching
expr match "$string" '$substring'   Length of matching $substring* at beginning of $string
expr "$string" : '$substring'   Length of matching $substring* at beginning of $string
expr index "$string" $substring Numerical position in $string of first character in $substring that matches
expr substr $string $position $length   Extract $length characters from $string starting at $position
expr match "$string" '\($substring\)'   Extract $substring* at beginning of $string
expr "$string" : '\($substring\)'   Extract $substring* at beginning of $string
expr match "$string" '.*\($substring\)' Extract $substring* at end of $string
expr "$string" : '.*\($substring\)' Extract $substring* at end of $string

# optional appending string
local_classpath="$local_classpath${local_classpath:+:}$1"

# coprocess (tag so I can locate it) ; group command

# Compound Commands
(list)  -  commands execute as one process so gruop has one PID and entire group can run in bg.
list is executed in a subshell environment. Variable assignments and builtin commands that affect the
shell's environment do not remain in effect after the command completes.  The return status is the exit status of list.
#
{ list; }  - run commands in gf of current shell. list  is  executed in the current shell environment.  list must
be terminated with a newline or semicolon.  The return status is the exit status of list.  Note that unlike the
metacharacters ( and ), { and } are reserved words and must occur where a
reserved word is permitted  to be recognized.  Since they do not cause a word
break, they must be separated from list by whitespace.

# string matching -
version_output=`"$bin_dir/java" -version 2>&1`
is_gcj=`expr "$version_output" : '.*gcj'`
if [ "$is_gcj" = "0" ]; then
  java_version=`expr "$version_output" : '.*"\(.*\)".*'`
  ver_major=`expr "$java_version" : '\([0-9][0-9]*\)\..*'`
  ver_minor=`expr "$java_version" : '[0-9][0-9]*\.\([0-9][0-9]*\)\..*'`
  ver_micro=`expr "$java_version" : '[0-9][0-9]*\.[0-9][0-9]*\.\([0-9][0-9]*\).*'`
  ver_patch=`expr "$java_version" : '.*_\(.*\)'`
fi

# printf padded numbers
printf "%02d " $(seq 10)

# array assignment in read -
#  read -a assigns resulting values to successive members of an array.
String="This is a string of words."
read -r -a Words <<< "$String"

# %g string formatting:
for a in `seq -f "//MB%02g/d$/" 84`;
do
ls $a 2>/dev/null ; #&& rm $a;
done

# sources .profile on login not .bashrc
# order of ops for reading files on bash startup:
if(interactive_login_shell)
/etc/profile
~/.bash_profile
~/.bash_login
~/.profile
# and ~/.bash_logout on exit
if(interactive_non_login_shell)
~/.bashrc

# arrays
A=(`cmd`)
${A[1]}
BUT can't declare 'A' local
length of array : ${#A[@]}

# redirect stderr and stdout to logfile
brew info --installed --json > /tmp/b.json 2>&1
brew info --installed --json 2>&1 > /tmp/b.json
cmd 2>&1 logfile
cmd &>> logfile

# global search replace in command line
!!:gs/foo/bar/

# name of current function
${FUNCNAME[0]} #  This array contains the current call stack. To quote the man page:

# timeout
To disable auto-logout, just set the TMOUT to zero or unset it

# silent background : run bkd process , save stderr but disable jobs output
set +m
{ { sleep 2; echo stdout; echo stderr >&2; } 2>&3- & } 3>&2 2>/dev/null
see pbclear2

# silent background
silent_background() {
    { 2>&3 "$@"& } 3>&2 2>/dev/null
    disown &>/dev/null  # Prevent whine if job has already completed
}

# snippets

# what is the difference between $*, $@, "$*", and "$@"?:
https://stackoverflow.com/questions/3348443/a-confusion-about-array-versus-array-in-the-context-of-a-bash-comple/3355375#3355375
https://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-a-bash-script/256225#256225
 -  $* and $@ (unquoted) do the same thing. They treat each 'word' (sequence of non-whitespace) as a separate argument.
 - "$*" treats the argument list as a single space-separated string,
 - "$@" treats the arguments almost exactly as they were when specified on the command line.
 - "$@" expands to nothing at all when there are no positional arguments; see IFS
 - "$*" expands to an empty string — and yes, there's a difference, though it can be hard to perceive it.

# more "$@ $*"
$* and $@ are like $1 $2 $3 …
resulting values subject to word splitting and filename expansion (globbing); usually do not want to use these without double quotes.
"$*" is like "$1 $2 $3…"
All positional parameter values joined into a single “word” (string) that is protected from further word splitting and globbing.
The character that is put between each positional parameter value is actually the first character from IFS; this is usually a plain space.
"$@" is like "$1" "$2" "$3" …

# quote
$ printf "'%s'," $(< /tmp/y)

# array assignment in read -
# read -a assigns resulting values to successive members of an array.
String="This is a string of words."
read -r -a Words <<< "$String"

# array tsv input
# >howdoi read tsv into array
while IFS=$'\t' read -r -a myArray
do
 echo "${myArray[0]}"
 echo "${myArray[1]}"
 echo "${myArray[2]}"
done < myfile

# array tsv input parallel
parallel --colsep ' ' 'ln -sf {2} {1}.{2/}' ::::  <(jamo info raw_normal library $LIB)
parallel -j1 --colsep ' ' 'bbmap.sh reads=100000 ref=$REF ihist={1}.hist in={2}' ::::  <(jamo info filtered library $LIB)"
parallel --eta --progress --joblog parallel.log -j66% '[ -d {} ] && tar --ignore-failed-read -hcf {/}.tar {} -X $EXC -vp 1>{/}.idx 2>{/}.stderr' :::  $D "
parallel --colsep='\t' "datediff -f %H {1} {2}" :::: outages.tsv  | histogram2.pl - 1 1 ; }
parallel --dry-run --xapply --header --results est_insert_size_bbmap {ref} {lib} ::: ref $REF ::: lib $LIB"
parallel \"jamo show {}\" :::: <(jfind $S | grep -v '#' | cut -d ' ' -f1 |sort -u )
parallel "jamo show {} " :::: <(jfind $ID | awk '!/#/&&NR>2 {print $NF}' )
parallel curl -G --data-urlencode query={} --data search_by=proposal_id -s $RQC_API/search/homesearch ::: "${@:?ids}" \

# vanilla env
env -i bash --noprofile --norc

# config files
.bash_profile for login shells,
.bashrc for interactive shells.

# readonly
$ readonly -p  # some shopt not modifiable

# modify readonly shopt
?

# spaces before / after auto complete
# after  https://askubuntu.com/questions/41707/bash-auto-completion-with-added-spaces-why-and-how-to-fix
# before: shopt

# startup sequence -- command to investigate
strings `type -p bash` | grep bashrc # if result is  ~/.bashrc you know your bash doesn't source a system bashrc file

# To figure out which init file is read
$ strings `type -p bash` | grep bashrc

# dotfiles
On login shells the ~/.profile file is read which can cause ~/.bashrc to be read.
On interactive non-login shells, the ~/.bashrc file is read instead.
Bash shell scripts don't source any files before starting, but if env var BASH_ENV is set bash treats
the contents as a filename and sources it before starting a bash script.

# sources .profile on login not .bashrc
# order of ops for reading files on bash startup:
if(interactive_login_shell)
/etc/profile
~/.bash_profile
~/.bash_login
~/.profile
# and ~/.bash_logout on exit
if(interactive_non_login_shell)
~/.bashrc

# indirect refs
# pointer vars
eval \$$var
${!var}

# getopt / getopts (builtin)
Colon in front of option allows you handle the errors in your code:
- var will contain '?' if unsupported option,
- ':' if missing value.
OPTARG - is set to current argument value,
OPTERR - indicates if Bash should display error messages.
OPTSTRING is string with list of expected arguments,
h    - check for '-h' w/out parameters; error on unsupported options;
h:   - check for '-h' w parameter; errors on unsupported options;
abc  - check for '-a', '-b', '-c'; errors on unsupported options;
:abc - check for '-a', '-b', '-c'; silences errors on unsupported options;

# getopts example
function usage() { echo "$0 usage:" && grep " .)\ #" $0; exit 0; }
[ $# -eq 0 ] && usage
while getopts ":hs:p:" arg; do
    case $arg in
        p) # Specify p value.
            echo "p is ${OPTARG}"
        ;;
        s) # Specify strength, either 45 or 90.
            S=${OPTARG}
            [ $S -eq 45 -o $S -eq 90 ]  && echo "S is $S." || echo "S needs to be either 45 or 90, $S found instead."
        ;;
        h | *) # Display help.
            usage
            exit 0
        ;;
    esac
done

# filter
while   IFS= read -r line        &&
case    $line in (@@*start) :;;  (*)
        printf %s\\n "$line"
        sed -un "/^@@.*start$/q;p";;
esac;do sed -un "/^@@.*end$/q;=;p" |
        paste -d: - -
done    <infile

# filter -- using sed
sed '/^@@.*start$/!b
     s//nl <<\\@@/;:l;N
     s/\(\n@@\)[^\n]*end$/\1/
Tl;e'  <infile
Above sed collects input in pattern space until it has enough to successfully pass the substitution Test and stop branching back to the the :label. When it does, it executes nl with input represented as a <<here-document for all of the rest of its pattern-space.

The workflow is like this:
/^@@.*start$/!b
if an ^entire line$ does !not /match/ the above pattern, then it is branched out of the script and autoprinted - so from this point on we are only working with a series of lines which began with the pattern.
s//nl <<\\@@/
the empty s//field/ stands in for the last address sed attempted to match - so this command substitutes the entire @@.*start line for nl <<\\@@ instead.
:l;N
The : command defines a branch label - here I set one named :label. The Next command appends the next line of input to pattern space followed by a \newline character. This is one of only a few ways to get a \newline in a sed pattern space - the \newline character is a sure delimiter to a sedder who has been doing it awhile.
s/\(\n@@\)[^\n]*end$/\1/
this s///ubstitution can only be successful after a start is encountered and only on the first following occurrence of an end line. It will only act on a pattern space in which the final \newline is immediately followed by @@.*end marking the very end$ of pattern space. When it does act, it replaces the whole matched string with the \1first \(group\), or \n@@.
Tl
the Test command branches to a label (if provided) if a successful substitution has not occurred since the last time an input line was pulled into pattern space (as I do w/ N). This means that each time a \newline is appended to pattern space which does not match your end delimiter, the Test command fails and branches back to the :label, which results in sed pulling in the Next line and looping until successful.
e
When the substitution for the end match is successful and the script does not branch back for a failed Test, sed will execute a command that looks like this:
nl <<\\@@\nline X\nline Y\nline Z\n@@$

# printf v echo -- https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo/65819#65819
if the first argument matches the ^-([eEn]*|-|-help|-version)$ extended regexp or any argument contains backslashes (or characters whose encoding contains the encoding of the backslash character like α in locales using the BIG5 charset), then the behaviour is unspecified.
printf, on the other hand, is more reliable, at least when it's limited to the basic usage of echo.
$ printf '%s\n' "$var" # Will output the content of $var followed by a newline character regardless of what character it may contain.
$ printf '%s' "$var" # Will output it without the trailing newline character.

# seek fd
There are many commands out there that can only deal with seekable files, but when that's the case, that's generally not for the files open on their stdin.
$ unzip -l file.zip
Archive:  file.zip ...
$ unzip -l <(cat file.zip)  # more or less the same as cat file.zip | unzip -l /dev/stdin
  error
unzip needs to read the index stored at the end of the file, and then seek within the file to read the archive members. But here, the file (regular in the first case, pipe in the second) is given as a path argument to unzip, and unzip opens it itself (typically on fd other than 0) instead of inheriting a fd already opened by the caller. It doesn't read zip files from its stdin. stdin is mostly used for user interaction.

# set args from stdin
#!/bin/bash
declare -a A=("$@")
[[ -p /dev/stdin ]] && { \
    mapfile -t -O ${#A[@]} A; set -- "${A[@]}"; \
}
echo "$@"
#Example use :
$ ./script.sh arg1 arg2 arg3
> arg1 arg2 arg3
$ echo "piped1 piped2 piped3" | ./script.sh
> piped1 piped2 piped3
$ echo "piped1 piped2 piped3" | ./script.sh arg1 arg2 arg3
> arg1 arg2 arg3 piped1 piped2 piped3

# read -t 0     #<timeout>
# -t timeout time out and return failure if a complete line of input is not read withint TIMEOUT seconds. The value of the TMOUT variable is the default timeout. TIMEOUT may be a fractional number. The exit status is greater than 128 if the timeout is exceeded
# If TIMEOUT is 0, read returns immediately, without trying to read any data, returning success only if input is available on the specified file descriptor.
$ read -t 0 && read -d '' myData;  # see if there's anything to read; if yes, read it.

# redirect fd
exec 4>&1 # duplicate file descriptor 1 (stdout) as descriptor 4.
key=$(password_program 3>&1 >&4-) #because of the $() exec password_program in subshell whose stdout will go into the variable key. But we let that subshell do some descriptor mangling, before actually executing password_program: Descriptor 3 is opened as a copy of descriptor 1, so that password_program can write its results to descriptor 3.
exec 4>&- # descriptor 4 (saved "copy" of original stdout) moved to descriptor 1. So the result is: password_program will run with its stdout as the same file (or tty etc.), that the shell was started with. The final command then gets rid again of the descriptor 4 in the main shell.

# Brace Expansion
mechanism to generate arbitrary strings; similar to pathname expansion, but the filenames generated need not exist.  Patterns are optional preamble, followed by either a series of comma-separated strings or a sequence expression between a pair of braces, followed by an optional postscript.
The preamble is prefixed to each string contained within the braces, and the postscript is then appended to each resulting string, expanding left to right.
Brace expansions may be nested.  The results of each expanded string are not sorted; left to right order is preserved.  For example, a{d,c,b}e expands into `ade ace abe'.

# Sequence expression
# takes the form {x..y[..incr]}, where x and y are either integers or single letters, and incr, an optional increment, is an integer.
When integers are supplied, the expression expands to each number between x and y, inclusive.  Supplied integers may be prefixed with 0 to force each term to have the same width.
When either x or y begins with a zero, the shell attempts to force all generated terms to contain the same number of digits, zero-padding where necessary.
When letters are supplied, the expression expands to each character lexicographically between x and y, inclusive, using the default C locale.
Note that both x and y must be of the same type (integer or letter).
When the increment is supplied, it is used as the difference between each term.  The default increment is 1 or -1 as appropriate.

$ {a..z}

# optarg / getopt (not getopts)
getopt -n test  -o '' -a -l xmx:,xms:,Xmx:,Xms:, -- --Xmx 2g && echo "OPTERR=$OPTERR OPTIND=$OPTIND OPTARG=$OPTARG"

# getopts -- short opt only
builtin

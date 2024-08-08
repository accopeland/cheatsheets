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

>>>>>>> 5ebb389 (vim: fixed whitespace)
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
shopt -s extglob
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

# "$@ $*"
$* and $@ are like $1 $2 $3 …
resulting values subject to word splitting and filename expansion (globbing); usually do not want to use these without double quotes.
"$*" is like "$1 $2 $3…"
All positional parameter values joined into a single “word” (string) that is protected from further word splitting and globbing.
The character that is put between each positional parameter value is actually the first character from IFS; this is usually a plain space.
"$@" is like "$1" "$2" "$3" …

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

# description

# install

# doc
# https://www.pement.org/sed/sed1line.txt

#
$ sed -i -E 's/;size=[0-9]+;//g' tabfile.tsv

# do something every nth line
$ sed 'N~Ns/.../'

# To replace all occurrences of "day" with "night" and write to stdout:
$ sed 's/day/night/g' <file>

# To replace all occurrences of "day" with "night" within <file>:
$ sed -i 's/day/night/g' <file>

# do something every nth line
$ sed 'N~Ns/.../'

# To replace all occurrences of "day" with "night" on stdin:
echo 'It is daytime' | sed 's/day/night/g'

# To remove leading spaces:
$ sed -i -r 's/^\s+//g' <file>

# To insert a line before a matching pattern:
$ sed '/Once upon a time/i\Chapter 1'

# To add a line after a matching pattern:
$ sed '/happily ever after/a\The end.'

# To remove empty lines and print results to stdout:
$ sed '/^$/d' file.txt

# To replace newlines in multiple lines
$ sed ':a;N;$!ba;s/\n//g'  file.txt

# fastq
$ sed -n -e '/^@.*\/1/{$!N;$!N;$!N;p;}'

# fix fastq headers
$ sed -n "2~4 s/^\(.\{$N\}\).*$/\1/p"

# fastq to fasta
$ sed -n 's/^@/>/p;2~4p'

# fastq to fasta
$ sed -n '1~4p;2~4p' | sed 's/^@/>/'

# fastq
$ sed -n '/@/d;2~4p'

# first N chars
$

# last N chars
$

# skip str then cut 4
$  gsed -r  '/^>/b; s/^(.{4}).*/\1/'  /Users/copeland/BaseSpace/DATA/40k.fasta | head
>pi1-04:47:222Y2JLT3:1:1101:30181:1000 1:N:0:CNGCTTCC+GATCTATC
ANTA
TGTG
GTGG

# branch
$


# markdown table
$ sed '2d;s/|/,/g'

# change one line
$ sed '3s/MEGABLAST/BLASTN/'

# hmm
$ sed '/>/{N;s/>//;s/\n/ /}'

# delete one line
$ sed 1d

# edit single line
gsed '1s/1101/tile/;2q'

# get ip
$ sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'

# doc
$ sed -i -E 's/;size=[0-9]+;//g' tabfile.tsv

# inplace
gsed -i 's/foo/bar/' infile
$ sed -r -i 's/foo/bar' infile
ex +%s/foo/bar/g -scwq file.txt

# filter -- see https://unix.stackexchange.com/questions/195292/filter-or-pipe-certain-sections-of-a-file
# collect input in pattern space until it has enough to successfully pass the substitution Test and stop branching back to the :label. When it does, it executes nl with input represented as a <<here-document for all of the rest of its pattern-space.
$ sed '/^@@.*start$/!b
     s//nl <<\\@@/;:l;N
     s/\(\n@@\)[^\n]*end$/\1/
Tl;e'  <infile

Details:
/^@@pat$/!b # if ^entire line$ does !not /match/ pattern, then branch out of the script and autoprint - so from this point on we are only working with a series of lines which began with the pattern.
s//nl <<\\@@/  # empty s//field/ stands in for the last address sed attempted to match - so this command substitutes the entire @@pat line for nl <<\\@@ instead.
:l;N  # : command defines a branch label - here set to :label. Next command appends next line of input to pattern space followed by a \n (one of only a few ways to get a newline in a sed pattern space)
s/\(\n@@\)[^\n]*end$/\1/  #  s///ubstitution only successful after a start is found and only on the first following occurrence of an end line. It will only act on a pattern space in which the final \n
				                  # is immediately followed by @@.*end marking the very end$ of pattern space. When it does act, it replaces the whole matched string with the \1first \(group\), or \n@@.
Tl # the Test command branches to a label (if provided) if a successful substitution has not occurred since the last time an input line was pulled into pattern space (as I do w/ N).
   # so each time a \n is appended to pattern space which does not match the end delimiter, 'Test' command fails and branches back to :label, resulting in sed pulling in the Next line and looping until successful.
e  #When the substitution for the end match is successful and the script does not branch back for a failed Test, sed will execute a command that looks like this:
nl <<\\@@\nline X\nline Y\nline Z\n@@$

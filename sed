# description

# install

# doc
sed -i -E 's/;size=[0-9]+;//g' tabfile.tsv

# do something every nth line
sed 'N~Ns/.../'

# To replace all occurrences of "day" with "night" and write to stdout:
sed 's/day/night/g' <file>

# To replace all occurrences of "day" with "night" within <file>:
sed -i 's/day/night/g' <file>

# do something every nth line
sed 'N~Ns/.../'

# To replace all occurrences of "day" with "night" on stdin:
echo 'It is daytime' | sed 's/day/night/g'

# To remove leading spaces:
sed -i -r 's/^\s+//g' <file>

# To insert a line before a matching pattern:
sed '/Once upon a time/i\Chapter 1'

# To add a line after a matching pattern:
sed '/happily ever after/a\The end.'

# To remove empty lines and print results to stdout:
sed '/^$/d' file.txt

# To replace newlines in multiple lines
sed ':a;N;$!ba;s/\n//g'  file.txt

# fastq
sed -n -e '/^@.*\/1/{$!N;$!N;$!N;p;}'

# fix fastq headers
sed -n "2~4 s/^\(.\{$N\}\).*$/\1/p"

# fastq to fasta
sed -n 's/^@/>/p;2~4p'

# fastq to fasta
sed -n '1~4p;2~4p' | sed 's/^@/>/'

# fastq
sed -n '/@/d;2~4p'

# markdown table
sed '2d;s/|/,/g'

# change one line
sed '3s/MEGABLAST/BLASTN/'

# hmm
sed '/>/{N;s/>//;s/\n/ /}'

# delete one line
sed 1d

# edit single line
gsed '1s/1101/tile/;2q'

# get ip
sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'

# doc
sed -i -E 's/;size=[0-9]+;//g' tabfile.tsv

# inplace
gsed -i 's/foo/bar/' infile
sed -r -i 's/foo/bar' infile
ex +%s/foo/bar/g -scwq file.txt

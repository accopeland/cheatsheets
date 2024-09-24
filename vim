#  description
notes on modal text editor vim

#  line numbers enable/disable
:set number
:set nonumber

#  fix ^M line ending in vim
:set ff=unix


# File management

:e              reload file
:q              quit
:q!             quit without saving changes
:w              write file
:w {file}       write new file
:x              write file and exit

# Movement

    k
  h   l         basic motion
    j

w               next start of word
W               next start of whitespace-delimited word
e               next end of word
E               next end of whitespace-delimited word
b               previous start of word
B               previous start of whitespace-delimited word
0               start of line
$               end of line
gg              go to first line in file
G               go to end of file
gk		move down one displayed line
gj		move up one displayed line

# Insertion
#   To exit from insert mode use Esc or Ctrl-C
#   Enter insertion mode and:

a               append after the cursor
A               append at the end of the line
i               insert before the cursor
I               insert at the beginning of the line
o               create a new line under the cursor
O               create a new line above the cursor
R               enter insert mode but replace instead of inserting chars
:r {file}       insert from file

# Editing

u               undo
yy              yank (copy) a line
y{motion}       yank text that {motion} moves over
p               paste after cursor
P               paste before cursor
<Del> or x      delete a character
dd              delete a line
d{motion}       delete text that {motion} moves over

# Search and replace with the `:substitute` (aka `:s`) command

:s/foo/bar/	replace the first match of 'foo' with 'bar' on the current line only
:s/foo/bar/g	replace all matches (`g` flag) of 'foo' with 'bar' on the current line only
:%s/foo/bar/g	replace all matches of 'foo' with 'bar' in the entire file (`:%s`)
:%s/foo/bar/gc	ask to manually confirm (`c` flag) each replacement

# Preceding a motion or edition with a number repeats it 'n' times
# Examples:
50k         moves 50 lines up
2dw         deletes 2 words
5yy         copies 5 lines
42G         go to line 42

# change block
c-v : select block
cmd
esc esc

# block comment
c-v  # select lines
c #   or I #
esc esc


# vim remap
:nmap - Display normal mode maps
:imap - Display insert mode maps
:vmap - Display visual and select mode maps
:smap - Display select mode maps
:xmap - Display visual mode maps
:cmap - Display command-line mode maps
:omap - Display operator pending mode maps

# vim fix ^M line ending in vim
:set ff=unix

# vim macro
https://www.redhat.com/sysadmin/use-vim-macros

# macro create
let @c=':r c.c^M'
OR
q<letter><commands>q

# macro use --use macro 'a'
:5,10norm! @a

# vim quote word -- with a macro
"qq" B i " <esc> e a " <esc> q

# vim keys
cs'"		: change surrounding ' for "
% 		: find matching symbol/brace
df' | dt'
=   		: format
gUw 		: capitalize word
b or ( or )  	: block surrounded by ()
B or { or }  	: block surrouned  by {}
ci"  		: change INside ""
ca'  		: change Around ''
cit  		: change inside html tag
cib  		: change Inside block
C-r 		: redo
A  		: append at eol
gi		: goto insert mode at last place you inserted
ESC=C-c=C-]	: exit insert mode
v		: vis mode by char
V		: vis mode by line
C-V		: vis mode by block
dgn		: del next search pat
yi(		: yank inside block

# Multiple windows
:e filename      - edit another file
:split filename  - split window and load another file
ctrl-w up arrow  - move cursor up a window
ctrl-w ctrl-w    - move cursor to another window (cycle)
ctrl-w_          - maximize current window
ctrl-w=          - all equal size
10 ctrl-w+       - increase window size by 10 lines
:vsplit file     - vertical split
:sview file      - same as split, but readonly
:hide            - close current window
:only            - keep only this window open
:ls              - show current buffers
:.! <command>    - shell out

# Buffers
# move to N, next, previous, first last buffers
:bn              - goes to next buffer
:bp              - goes to prev buffer
:bf              - goes to first buffer
:bl              - goes to last buffer
:b 2             - open buffer #2 in this window
:new             - open a new buffer
:vnew            - open a new vertical buffer
:bd 2            - deletes buffer 2
:wall            - writes all buffers
:ball            - open a window for all buffers
:bunload         - removes buffer from window
:taball          - open a tab for all buffers

# Pointers back
ctrl-o

# Pointers forward
ctrl-o

# Super search
ctrl-p

# To sort  a visual range on column 1 as a number:
:'<,'>!sort -gk 1 -t ,


# Map (in normal mode) the F2 key to a bash call `uuidgen`, then trim the `\n`
# from the result, and put that in the expression register `"=`, then put that
# before the cursor:
nmap <F2> "= system("uuidgen")[:-2]<C-M>P

# plugin vim-plug
# run in vim with :PlugInstall
# default install location for plugins:  '~/.vim/plugged'
#curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
##
call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'fatih/vim-go', { 'tag': '*' }  " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug '~/my-prototype-plugin'
Plug 'flazz/vim-colorschemes' # add  to .vimrc
call plug#end()    " Initialize plugin system

# vim plugins
pathogen
ctags / gtags
unimpaired
cucumber
go / vim-go
julia-vim
neocompletion
nim.vim
sql.vim
syntastic
vim-wdl

# Delete every line that has a FOO in it. See `:help global`.
# The _ in the d _ command ensures registers and clipboards are not changed.
:g/FOO/d _

# indent
set tabstop=2
set shiftwidth=2
set expandtab
gg=G

# indent
:set cindent
:set autoindent - closely mimics vi autoindent, but differs subtly as to where the cursor is placed after indentation is deleted.
:set smartindent - Slightly more powerful than autoindent; recognizes some basic C syntax primitives for defining indentation levels.
:set cindent - much richer awareness of C and sophisticated customization beyond simple indentation levels;can be configured to control how and where braces indent, etc.
:set indentexpr - define your own expression, which Vim evaluates in the context of each new line. you write your own rules. Most flexible.

# indent -- See also http://vim.wikia.com/wiki/Indent_a_code_block
>>   Indent line by shiftwidth spaces
<<   De-indent line by shiftwidth spaces
5>>  Indent 5 lines
5==  Re-indent 5 lines
>%   Increase indent of a braced or bracketed block (place cursor on brace first)
=%   Reindent a braced or bracketed block (cursor on brace)
<%   Decrease indent of a braced or bracketed block (cursor on brace)
]p   Paste text, aligning indentation with surroundings
=i{  Re-indent the 'inner block', i.e. the contents of the block
=a{  Re-indent 'a block', i.e. block and containing braces
=2a{ Re-indent '2 blocks', i.e. this block and containing block
>i{  Increase inner block indent
<i{  Decrease inner block indent
-- replace { with } or B, e.g. =iB is a valid block indent command.

# delete to beg of line
dv0

# arithmetic on column
select range with c-v , extend, enter, then...
:'<,'>s/\%V\d\+/\=submatch(0)+5

# use fzf in vim  -- add to .vimrc
set rtp+=/usr/local/opt/fzf

# whitespace
set showbreak=↪\
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

# remove trailing whitespace
:s/\(^--\)\@<!\s*$// # except for email sig
:%s/\s\+$//e

# nfpeters/vim-better-whitespace config
By default operates on entire file. To restrict to portion of file, either give a range or select a group of lines
:StripWhitespace
or
<leader>s) to clean whitespace.
<leader>sip  # in normal mode:  remove trailing whitespace from the current paragraph.
##change the operator , for example to set it to _s, using:
let g:better_whitespace_operator='_s'
##Now <number>_s<space> strips whitespace on <number> lines, and _s<motion> on the lines affected by the motion given. Set to the empty string to deactivate the operator.
##Note: This operator will not be mapped if an existing, user-defined mapping is detected for the provided operator value.
##To enable/disable stripping of extra whitespace on file save for a buffer, call one of:
:EnableStripWhitespaceOnSave
:DisableStripWhitespaceOnSave
:ToggleStripWhitespaceOnSave
##This will strip all trailing whitespace everytime you save the file for all file types.
##If you want this behaviour by default for all filetypes, add the following to your ~/.vimrc:
let g:strip_whitespace_on_save = 1
##For exceptions of all see g:better_whitespace_filetypes_blacklist.

" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

# make
:make
set makeprg=g++\ -o\ %<\ %
nnoremap <F5> :make<cr>
nnoremap <F6> :!./%<<cr>
nnoremap <leader>n :cnext<cr>
nnoremap <leader>p :cprevious<cr>

# goto definition
ctags
c-]

# goto declaration
see ctags docs?

# yank bash func
ya{
or
/function yn

# delete bash func
da{
/function dn

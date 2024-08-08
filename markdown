# description - markdown and associated tools

# doc
TODO

# markdown to pdf
md2pdf ./**/*.md   # then pdfunite ./**/*.pdf

# convert to html, pdf, etc.
mkdocs
mdbook
readthedocs
- pandoc	# depends on ghc
	markdown,textile,html,docbook,latex,mediawiki,docx,odt,epub,pdf(latex),beamer,man,texinfo,rst
	convert files from one markup format into another, pandoc is your swiss-army knife. Pandoc can convert documents in markdown, reStructuredText, textile, HTML, DocBook, LaTeX, MediaWiki markup, OPML, Emacs Org-Mode, Txt2Tags, Microsoft Word docx, EPUB, or Haddock markup t

# viewers
mmark
mdless
R -e "markdown::markdownToHTML('markdown_example.md', 'markdown_example.html')"
bat
mdless
glow

# to pdf :  npm install -g markdown-pdf
markdown-pdf README.md -o README.pdf
#
pandoc README.md -o README.pdf

# headers
# (without double qutation marks("))
"# h1 header"
"###### h6 header"

# blockquotes
> first level and paragraph
>> second level and first paragraph
>
> first level and second paragraph

# collapsed text
To create a collapsible section (collapsed by default) showing the text "Collapsed Item Title", use this:
<details>
    <summary>Collapsed Item Title</summary>
    <p>Collapsed content</p>
    <p>Other collapsed content.</p>
</details>

# lists
Sub-bullets can be done with 2+ spaces or 1 tab
## unordered - use *, +, or -
* Red
  * sub-bullet
    * sub-sub-bullet
* Green
  - sub with dash
  + sub with plus
* Blue

## ordered
1. First
  1. First sub-item <-- this is the best supported format
2. Second
  * Unordered  <-- this also appears to be a widely supported format
3. Third
  a. Lettered  <-- there is mixed support for this format
4. Fourth
  i. using roman numerals  <-- there is mixed support for this format
  ii. more stuff

## check list
There is limited support for rendering check lists:
- [ ] incomplete task
    - [ ] incomplete sub-task
    - [x] complete sub-task
- [x] complete task

# code
## code block with 4 spaces/1 tab
regular text
        code code code

## in-line code
or:
Use the `printf()` function

## code block with syntax support
or a code block (optionally specifying the language, more details here: https://rdmd.readme.io/docs/code-blocks):
```shell
alias ltr='ls -ltr'
alias latr='ls -latr'
```
# code - use 4 spaces/1 tab
regular text
        code code code
or:
Use the `printf()` function

## key bindings
<kbd>⌘F</kbd>
# hr's (horizontal rules) - three or more of the following
***
---
___

# links
The "Title" is optional
This is [an example](http://example.com "Title") inline link.

## Links to Headings
Assuming you have a heading called `# My First Heading` then link is the case-insensitive string with spaces replaced by dashes:
[Visible Link Text](#my-first-heading "Hover-text link title")

This is [an example](http://example.com "Title") inline link.

# image
![Alt Text](/path/to/file.png)

# italic
Italic:
*em* _em_

# bold
Bold:
**strong** __strong__

# strikethrough
~~strikethrough~~

# Tables

## Table Alignment
The alignment applies to the table data, not the header.

Left-aligned Stuff | Right-aligned Stuff | Center-aligned Stuff
| :--- | ---: | :---:
Some left stuff   | Some right stuff  | Some center stuff
Some left stuff   | Some right stuff  | Some center stuff

## Special Characters in Tables
First Header  | Second Header
------------- | -------------
Some stuff   | things about stuff
Other Stuff  |  A \| B

# description
R notes. rlang.

# install
brew install r # brew pin r
spack install r

# troubleshoot
> pkgbuild::has_compiler(debug = TRUE)

# upgrade -- see https://www.r-bloggers.com/2020/04/updating-to-4-0-0-on-macos/
expect problems with rlang, vctrs - reinstall to fix

# config
~/.Rprofile
options(width=75)		# output width
options(pillar.print_max=40) 	# output lines
etc.

# capabilities
capabilities()
sessionInfo()

# display issues
ideal? : spack install r +X
alt? ... wayland ???
 echo $DISPLAY
login07:23.0
[copeland@login07:~/tmp] DISPLAY=:0.0 # no
[copeland@login07:~/tmp] DISPLAY=:23.0 # no
[copeland@login07:~/tmp] DISPLAY=login07:23.0 # yes
[copeland@login07:~/tmp] nslookup login07
Server:         10.92.100.225
Address:        10.92.100.225#53
Name:   login07.chn
Address: 128.55.64.16
[copeland@login07:~/tmp] DISPLAY=128.55.64.16:23.0  # yes
strace xterm | grep sin # see x11

# history
savehistory()
.Last <- function()
   if(interactive()) try(savehistory("~/.Rhistory"))

# build  command 20221022 --
/usr/local/opt/llvm@13/bin/clang++ -I"/usr/local/Cellar/r/4.2.1_2/lib/R/include" -DNDEBUG -I./libuv-1.38.1/include -I. -pthread  -I/usr/local/opt/gettext/include -I/usr/local/opt/readline/include -I/usr/local/opt/xz/include -I/usr/local/include   -fPIC  -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -O2 -Wall -pedantic -Wconversion -Wno-sign-conversion -I/usr/local/opt/llvm/include -c unix/getmode.cc -o unix/getmode.o
--
clang-13: warning: /usr/local/opt/llvm@13/bin/clang++: 'linker' input unused [-Wunused-command-line-argument]
-I'/usr/local/lib/R/4.2/site-library/progress/include' -I'/usr/local/lib/R/4.2/site-library/cpp11/include' -I'/usr/local/lib/R/4.2/site-library/tzdb/include' -I/usr/local/opt/g

# build 20230117 4.2.2
CFLAGS="$CFLAGS -I/usr/local/Cellar/xz/5.4.1/include/lzma -I/usr/local/include -I/opt/X11/include" LDFLAGS="-L/opt/X11/lib" ./configure
  C compiler:                  /usr/local/opt/llvm@15/bin/clang  -I/usr/local/lib -I/usr/local/Cellar/xz/5.4.1/include/lzma -I/usr/local/include -I/opt/X11/include
  Fortran fixed-form compiler: gfortran -fno-optimize-sibling-calls -g -O2
  Default C++ compiler:        /usr/local/opt/llvm@15/bin/clang++ -std=gnu++14   -I/usr/local/opt/llvm@15/include -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -O2 -Wall -pedantic -Wconversion -Wno-sign-conversion -Wno-deprecated
  C++11 compiler:              /usr/local/opt/llvm@15/bin/clang++ -std=gnu++11   -I/usr/local/opt/llvm@15/include -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -O2 -Wall -pedantic -Wconversion -Wno-sign-conversion -Wno-deprecated
  C++14 compiler:              /usr/local/opt/llvm@15/bin/clang++ -std=gnu++14   -I/usr/local/opt/llvm@15/include -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -O2 -Wall -pedantic -Wconversion -Wno-sign-conversion -Wno-deprecated
  C++17 compiler:              /usr/local/opt/llvm@15/bin/clang++ -std=gnu++17   -I/usr/local/opt/llvm@15/include -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -O2 -Wall -pedantic -Wconversion -Wno-sign-conversion -Wno-deprecated
  C++20 compiler:              /usr/local/opt/llvm@15/bin/clang++ -std=gnu++20   -I/usr/local/opt/llvm@15/include -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -O2 -Wall -pedantic -Wconversion -Wno-sign-conversion -Wno-deprecated
  Fortran free-form compiler:  gfortran -fno-optimize-sibling-calls -g -O2
  Obj-C compiler:              gcc -g -O2 -fobjc-exceptions
  Interfaces supported:        X11, aqua
  External libraries:          pcre2, readline, curl
  Additional capabilities:     PNG, JPEG, TIFF, NLS, ICU
  Options enabled:             shared BLAS, R profiling
  Capabilities skipped:        cairo
  Options not enabled:         memory profiling
  Recommended packages:        yes
configure: WARNING: you cannot build info or HTML versions of the R manuals
configure: WARNING: you cannot build PDF versions of the R manuals
configure: WARNING: you cannot build PDF versions of vignettes and help pages

# build -- using /usr/bin/gcc is llvm@14
# Error: missing X11 headers (Intrinsic.h)
# Fix: add -I/usr/local/include to CFLAGS ?

# build -- using llvm@15 is homebrew
# Error: missing X11 headers
# Fix: add -I/usr/local/include to CFLAGS ?

# Error: missing lzma.h (configure)
# Fix: CFLAGS=$CFLAGS -I /usr/local/Cellar/xz/5.4.1/include/lzma

# Error: missing lXt (X11)
# Fix: -L"/opt/X11/lib"

# Error: missing Intrinsic.h (X11)
# Fix: -I/opt/X11/include  (from xquartz ???)

# Error: general X11 errors (X11)
# Fix:  brew install xquartz ?
# Notes: Installing R from the master branch using the --with-tcl-tk-x11 option should install an X11 based version of tcl-tk. While I'm not completely sure, it may still be necessary to have xquartz installed. Sometimes xquartz gets messed up with OS updates and needs to be reinstalled. Try reinstalling xquartz, cairo-x11, and tcl-tk-x11 and then recompile R.

# Error: missing SDK headers (build)
# Fix:
xcrun --show-sdk-path
export C_INCLUDE_PATH=$XCBASE/usr/include
export CPLUS_INCLUDE_PATH=$XCBASE/usr/include
export LIBRARY_PATH=$XCBASE/usr/lib

# Error: compiler cannot build executables
# Fix: make sure not CPPFLAGS (these are for -I )

# Error: cpp error (configure)
# Fix: make sure $CPP is set to something sane e.g. $CC -E (and matched to compiler)

# Error: cpp  error (configure)
# Fix:  ...
extract confdefs.h from config.log
export CPP="/usr/local/opt/llvm@15/bin/clang -E -Wno-deprecated"
$CPP confdefs.h # examine error

# docs

# package building
see ~/.Rmakevars

# tidyverse
# fix xml2 for xcode 8:
sudo /usr/bin/sed -E -i.backup 's@/usr/lib/system/libsystem_symptoms.dylib(, )?@@' \
$(grep -ril /usr/lib/system/libsystem_symptoms.dylib \
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/lib)
install.packages("tidyverse") # Install from CRAN
devtools::install_github("hadley/tidyverse") # Or the development version from GitHub # install.packages("devtools")

# taxonomy
R::library(taxize)
R::library(myTAI)
# install.packages("ritis") # uncomment if not already installed
# install_github('taxize_', 'ropensci') # uncomment if not already installed
# install.packages("taxize", type="source") # uncomment if not already installed
library(ritis)
library(taxize)

# Get sequences: What's nice about this is that it gets the longest sequence avaialable for the gene you searched for,
# and if there isn't anything available, it lets you get a sequence from a congener if you set
# getrelated=TRUE. The last column in the output data.frame also tells you what species the sequence is from.
out <- get_seqs(taxon_name = "Acipenser brevirostrum", gene = c("5S rRNA"), seqrange = "1:3000", getrelated = T, writetodf = F)
out[, !names(out) %in% "sequence"]
		   taxon                                         gene_desc
1 Acipenser brevirostrum Acipenser brevirostrum 5S rRNA gene, clone BRE92A
     gi_no     acc_no length                 spused
1 60417159 AJ745069.1    121 Acipenser brevirostrum
# Search for available sequences
out <- get_genes_avail(taxon_name = "Umbra limi", seqrange = "1:2000", getrelated = F)

# unnest, map
# https://www.brodrigues.co/blog/2021-03-19-no_loops_tidyeval/
mtcars_plot <- mtcars %>%
  group_nest(am) %>% #shortcut for group_by(am) %>% nest()
  mutate(plots = map2(.y = am, .x = data, ~{ggplot(data = .x) +
                              geom_smooth(aes(y = mpg, x = hp), colour = "#82518c") +
                                ggtitle(paste0("Miles per gallon as a function of horse power for am = ", .y)) +
                                theme_blog()}))

# book
#https://bookdown.org/ndphillips/YaRrr/saving-plots-to-a-file-with-pdf-jpeg-and-png.html

# plate analysis
https://bookdown.org/ansellbr/WEHI_tidyR_course_book/week-4-part-2.html#analyse-plate-1

# ggplate
> plate_plot(p, position=alq_plate_location, value=my_z, label=my_z, plate_type="round")
p %>% group_by(sample_plate_name) %>% mutate(mr=mean(rqc_raw_reads_count)) %>% plate_plot(position=alq_plate_location, value=mr, plate_type="round")

# forecasting
https://otexts.com/fpp2/simple-methods.html

# mtpview1 -- https://github.com/npjc/mtpview1
> devtools::install_github("https://github.com/npjc/mtpview1")
mtp_example2 %>% mutate(plate = 1) %>% unnest() %>% mtp_ggplot(aes(plate = plate, well = well)) + mtp_spec_96well() + geom_footprint() +
    geom_notched_border() +geom_col_label() + geom_row_label() + geom_well_rect(aes(fill = cond)) + geom_well_line(aes(x = runtime, y = measure))

# mtpview1 -- multiple plates
plot <- data %>%
    mtp_ggplot(aes(plate = plate, well = well)) +
    mtp_spec_96well() +
    geom_footprint(aes(fill = strain), alpha = 0.25) +
    geom_notched_border() +
    geom_col_label(size = 2) +
    geom_row_label(size = 2) +
    geom_well_rect(fill = "grey96", size = 0.1) +
    geom_well_line(aes(x = runtime, y = measure), size = 0.2) +
    facet_wrap(~plate)

# dplyr
https://dplyr.tidyverse.org/articles/programming.html#setting-variable-names

# plate data plotting
library(platetools)
library(dplyr)
library(ggplot2)
x=summarise(group_by(d,plate,iTAG.Primer.Set,Well),mmc=mean(Pairs.Count))
> raw_map(x$mmc,well=x$Well) + theme_dark() + scale_fill_viridis()
# internally the above does this
plt96(plate_map(well=x$Well,x$mmc)) + theme_dark()

# plate data - library(platetools)
library(readxl)
d=read_excel("sheet.xlsx",sheet=1)
d0=subset(d,select=c("Values","Wells"))
raw_map(d$Values,d$Wells,plate=96)

# plate
# https://rstudio-pubs-static.s3.amazonaws.com/427185_abcc25a951c9436680dc6a8fcc471ca9.html
# https://www.r-bloggers.com/2014/05/plotting-microtiter-plate-maps/
geom_point(data=expand.grid(seq(1, 12), seq(1, 8)), aes(x=Var1, y=Var2), color="grey90", shape=21)

# PCA
ape::pcoa

# compare phylogeny -  ape::all.equal.phylo

# sequence distance - ape::dist.dna

# distance plots
bio3d::plot.dmat(ide.mat, color.palette=mono.colors, main="Sequence Identity", xlab="Structure No.", ylab="Structure No.")

# spider::sppDistMatrix  - ditnace matrix

# compare trees
spider::tree.comp

# tidy / tidyr   - http://garrettgman.github.io/tidying/
x=read.csv("mess")
library(tidyr)
glimpse(x)
xx=spread(x,metric_name,metric_value)

# convert df to table
dplyr::tbl_df(df)

# summary of tbl data
dplyr::glimpse(df)

# pipe
dplyr::%>%

# gather cols into rows
gather(df, ...)

# split 1 col into several
separate(df,date,c("y","m","d"))
separate_wider_regex(data=bgc,col=c("StorageLocation"),patterns = c(plate="\\d{3}|X\\d","_",row="[A-HX]",col="\\d{2}"))

# spread rows into cols
spread(df,size,amt)

# merge cols
unite(df,col,...,sep)

# subset
filter(df,condition)

# filter
df %>% filter(grepl('Guard', player))
df |> filter(str_detect(prod,"Plant"))
df %>% filter(grepl('P|Center', player))
mpg_df %>% filter(year == 1999)
mpg_df %>% filter(year==1999 & cty > 18) %>% View()
mpg_df %>% filter(manufacturer=='chevrolet' | class=='suv')
mpg_df %>% filter(cyl %in% c(4,5,6))

# remove dupes
distinct(df)

# random sample
sample_frac(df,rate,replace=TRUE)

# random numbers
runif()
rnorm()
rbinom()
rexp()

# sample n rows
sample_n

# find top N
top_n

# distinct
n_distinct()

# select cols -- valid only in select()
starts_with(),
ends_with()
contains()
matches(regex,...)
select_if(condition)

rownames_to_column() # https://suzanbaert.netlify.app/2018/01/dplyr-tutorial-1/

# tidyverse other
dots()
pull()
enframe()
eval_tidy()
tribble()
quos() # quosure
quo_...()
map_dfr()
map_...()
across()

# select values
ifelse()
stringr::...
case_when()
recode()

# window functions
lead
lag
dense_rank
min_rank
percent_rank
row_number
ntile
between
cume_dist
cumall
cumany
cummean
cumsun
cummax
cumprod
pmax
pmin

# purrr
safely()
quietly()
possibly()

# anonymous functions
(\(x)(x+1))(10)

# data.table v. dplyr: http://stackoverflow.com/questions/21435339/data-table-vs-dplyr-can-one-do-something-well-the-other-cant-or-does-poorly

# phyloseq  /  itags workflow
library(devtools)
source('http://bioconductor.org/biocLite.R')
biocLite('phyloseq')
library(phyloseq)
c=import_biom("BPTPW.biom","BPTPW.tre","BPTPW.fasta")
t=import_biom("BSGBG.biom","BSGBG.tre","BSGBG.fasta")
m=import_biom("BSGPN.biom","BSGPN.tre","BSGPN.fasta")
cs=import_qiime_sample_data("BPTPW.mapping.tsv")
ts=import_qiime_sample_data("BSGBG.mapping.tsv")
ms=import_qiime_sample_data("BSGPN.mapping.tsv")
merge_phyloseq(c,cs)
control=merge_phyloseq(c,cs)
treat=merge_phyloseq(t,ts)
moon=merge_phyloseq(m,ms)
print(control[,"SampleType"])
m=merge_phyloseq(control,treat)
plot_heatmap(control,taxa.label="Phylum")
c2=import_biom("BPTPW.biom","BPTPW.tre","BPTPW.fasta",parseFunction=parse_taxonomy_greengenes)
m=import_biom("BSGPN.biom","BSGPN.tre","BSGPN.fasta")
m=import_biom("BSGPN.biom","BSGPN.tre","BSGPN.fasta")
all=import_biom("all.biom")
cs=sample_data("BSGBG/BSGBG.mapping.tsv")
ts2=import_qiime_sample_data("BSGBG/BSGBG.mapping.tsv")
control=merge_phyloseq(c2,cs)
plot_richness(control)
sample_variables(control)
library(ggplot2)
plot_richness(control,x="Type") + geom_boxplot()
sample_variables(treat)
names(ts)
ts=import_qiime_sample_data("BSGBG/BSGBG.mapping.tsv")
names(ts)

# tics / ticks
labs() or lims()
scale_y_discrete()
scale_x_discrete()
> ggplot(data=d, aes(x=gb_ccs))+ geom_histogram() + scale_y_continuous(breaks=seq(0,10,1))

# ecdf y as percentage
g = ggplot(data=d, aes(x=gb_ccs)) + stat_ecdf() + scale_x_log10() +  scale_y_continuous(breaks=seq(0,1,0.1),labels=scales::percent)
g + xlab("Gbp") + ylab("") + geom_line(y=.10,color="red") + ggtitle("Fungal CCS Yield")

# log scale axis
scale_y_continuous(trans="log10")
scale_log10_x()
scale_log2_y()
coord_trans()

# skim - useful df summaries
skim(df)

# collapse
#  https://sebkrantz.github.io/collapse/articles/collapse_intro.html#why-collapse

# timetk (time series)
# https://business-science.github.io/timetk/reference/plot_time_series.html
# https://business-science.github.io/timetk/articles/TK04_Plotting_Time_Series.html/
# https://robjhyndman.com/hyndsight/feasts/
FANG %>% mutate(year = year(date)) %>%
  plot_time_series(date, adjusted,
    .facet_vars     = c(symbol, year), # add groups/facets
    .color_var      = year,            # color by year
    .facet_ncol     = 4,
    .facet_scales   = "free",
    .facet_collapse = TRUE,  # combine group strip text into 1 line
    .interactive    = FALSE)

# tidyr
# http://garrettgman.github.io/tidying/
# https://bookdown.org/ansellbr/WEHI_tidyR_course_book/automating-your-work.html

# processmining
https://www.dataminingapps.com/2017/11/a-process-mining-tour-in-r/

# eventlog preprocessing
gather === pivot_longer
mutate(activity_instance_id=dplyr::row_number())  # for enumerating groups

# tidyr pivot_longer
d |> group_by(prod) |>pivot_longer(cols=c("reqsec","wallsec"),names_to="t",values_to="sec") |> glimpse()
prod wall req        prod   t  sec
a     1    2   ---->  a    wall 1
b     3    4          a    req  2
--
> glimpse(d)
Rows: 160,561
Columns: 15
$ dt      <dttm> 2021-09-30 07:13:42, 2021-09-30 08:35:21, 2021-10-01 08:15:40…
$ ttot    <dbl> 71060893, 71098302, 2093060, 2105164, 71074688, 58230, 790, 73…
$ reqsec  <dbl> 129600, 129600, 259200, 259200, 129600, 115200, 1800, 1800, 18…
$ wallsec <dbl> 108533, 121382, 207020, 211884, 112008, 20550, 470, 450, 495, …
$ reqmem  <dbl> 118, 118, 118, 118, 118, 72, 115, 115, 115, 115, 115, 115, 115…
$ rss     <chr> "100.45G", "100.48G", "100.53G", "100.58G", "100.49G", "48.44G…
$ maxmem  <chr> "135.21G", "132.81G", "138.63G", "138.69G", "132.81G", "63.29G…
$ lib     <chr> "HSYTT", "HSYSW", "HSYTB", "HSYTO", "HSYTS", "HTCHZ", "HTXCP",…
$ pipe_id <dbl> 5, 5, 5, 5, 5, 50, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3…
$ su      <chr> "52589.1.390473.TACTGCGT-TACTGCGT.fastq.gz", "52589.2.390513.A…
$ pipe    <chr> "Filter", "Filter", "Filter", "Filter", "Filter", "Pacbio Filt…
$ prod    <chr> "Plant Resequencing, Isolate", "Plant Resequencing, Isolate", …
$ status  <chr> "Run Folder Purged", "Run Folder Purged", "Run Folder Purged",…
$ cmd     <chr> "dirs/PI/rqc/prod/pipel", "dirs/PI/rqc/prod/pipel", "dirs/PI/r…
$ mem     <dbl> 135.21, 132.81, 138.63, 138.69, 132.81, 63.29, 123.85, 123.85,…
> d |> group_by(prod) |>pivot_longer(cols=c("reqmem","mem"),names_to="ram",values_to="G") |> arrange(sec) |> ggplot(aes(prod,G,color=ram)) + them
e(axis.text.x=element_text(angle=90)) + geom_jitter(size=0.1,alpha=0.5)
Error in `arrange()`:
ℹ In argument: `..1 = sec`.
Caused by error:
! object 'sec' not found
Run `rlang::last_trace()` to see where the error occurred.
> d |> group_by(prod) |>pivot_longer(cols=c("reqmem","mem"),names_to="ram",values_to="G") |> arrange(G) |> ggplot(aes(prod,G,color=ram)) + theme(
axis.text.x=element_text(angle=90)) + geom_jitter(size=0.1,alpha=0.5)
Warning message:
Removed 6014 rows containing missing values (`geom_point()`).


# dplyr table summary
d %>% group_by(protocol,input) %>% summarise(n=n(),m=mean(raw0,na.rm=T),v=var(raw0,na.rm=T))

# countr
n()
count()
tally()
add_count() # don't drop cols
add_tally()  # don't drop cols

# grouping
group_by()

# select based on value
> library(dplyr)
> xs=filter(x,grepl('ubstan|no data',failure_mode_what),!grepl('iTag',actual_library_queue))

# ggplot cumulative plot
ggplot(data=pb,aes(x=n_contigs)) + stat_ecdf(geom="smooth") + labs(x="Contigs",y="Fraction")
# or
dplyr::cume_dist()

# dplyr / tidy read csv :
library("readr")
read_csv("f.csv", col_tyes=...)
col_types
c = character
i = integer
n = number
d = double
l = logical
f = factor
D = date
T = date time
t = time
? = guess
_ or - = skip
see also spec()


# tidy / tidyr	 - http://garrettgman.github.io/tidying/
x=read.csv("mess")
library(tidyr)
glimpse(x)
xx=spread(x,metric_name,metric_value)

# cran install github
devtools::install_github("garrettgman/DSR")

# cran install using devtools install github
biocLite("devtools")
library("devtools")
devtools::install_github("benjjneb/dada2")

# ggplot rotate text
> ggplot(x,aes(Name,BasesPct)) + geom_boxplot() +  theme(axis.text.x= element_text(angle=90))

# ggplot fungal summary
> ggplot(data=subset(f,assembler %in% c("Falcon","AllPathsLG")),aes(x=cut(dt,breaks="month"),y=n_scaffolds,color=assembler,size=scaf_bp)) + geom_point()  + coord_flip()

# install R library from tarball
> install.packages("https://cran.r-project.org/src/contrib/spider_1.3-0.tar.gz",repos=NULL)

# xlsx
cran xlsx - huge java pain in the ass
cran readxl - wickham
readr - hadleyverse  # library(readr) (read_csv, read_tsv)
install.packages("readxl")
# only the binary install worked; grab tarball then unpack into /Users/copeland/Library/R/3.2
library(readxl)
d=read_excel("/Users/copeland/Work/klail//RQC_metrics.xlsx",sheet="Sheet1")

# excel sheets
list_paths <- list.files(path = "~/six_to/spreadsheets",pattern = ".xlsx",full.names = TRUE)
example_xlsx %>%  summarise(n_sheets = n_distinct(sheet)) # how many sheets
example_xlsx %>%  mutate(is_formula=!is.na(formula)) %>% group_by(sheet) %>% summarise(n_formula=sum(is_formula)) %>% arrange(desc(n_formula)) # formulas?
## # A tibble: 11 x 2
##    sheet                  n_formula
##    <chr>                      <int>
##  1 Preschedule                 2651
##  2 Deals                        324
##  3 Economics                    192
##  4 Balancing                     97
##  5 Fuel                          70
##  6 Comp                           0
##  7 EPEData                        0
##  8 HeatRate                       0
##  9 spin reserve log sheet         0
## 10 Top                            0
## 11 Unit Summary                   0

# many plots
https://data-se.netlify.app/2018/12/05/plot-many-ggplot-diagrams-using-nest-and-map/

# many plots
mtcars_plot <- mtcars %>% group_nest(am) %>% #shortcut for group_by(am) %>% nest()
  mutate(plots = map2(.y = am, .x = data, ~{
    ggplot(data=.x) + geom_smooth(aes(y=mpg, x=hp), colour="#82518c") + ggtitle(paste0("mpg v. HP for am = ", .y)) + theme_minimal()
  }
  ) # map
  ) # mutate

# many files - quo / lazy tibble
# https://www.r-bloggers.com/2021/03/how-to-treat-as-many-files-as-fit-on-your-hard-disk-without-loops-sorta-nor-running-out-of-memory-all-the-while-being-as-lazy-as-possible/
# example using >15000 xl files
(enron <- enframe(list_paths, name = NULL, value = "paths")) ## # A tibble: 15,871 x 1
enron %>%  mutate(datasets = map(paths, xlsx_cells)) # read data when needed one at a time: build a lazy tibble using quo().
(enron <- enron %>%   mutate(datasets = map(paths, ~quo(xlsx_cells(.)))))  ## # A tibble: 30 x 2
get_stats <- function(x){
  x <- eval_tidy(x); # eval quosure
  tribble(~has_formula, ~n_sheets, ~n_formulas, at_least_one_formula(x), n_sheets(x), n_formulas(x)) }
(enron <- enron %>%   mutate(stats = map(datasets, get_stats)))  ## # A tibble: 30 x 3
enron %>%  summarise(average_n_formulas = mean(n_formulas),max_sheets = max(n_sheets))  ## # A tibble: 1 x 2

# quo - create quosure
quosures are quoted expressions that keep track of an environment

# phyloseq: http://joey711.github.io/phyloseq/preprocess (cran package)

# r qplot / ggplot2 - rotated xlabel
> qplot(y=d$ReadBaseCount,x=d$SeqProjName) + theme(axis.text.x=element_text(angle=-90))

# data.table
https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-intro-vignette.html
.N := number of samples
.SD := subset of data (also a data.table)
.() := list()
#
DT[i, j, by]
##   R:      i                 j        by
## SQL:  where   select | update  group by
#
– Calculate the average arrival and departure delay for all flights with “JFK” as the origin airport in the month of June.
flights[origin == "JFK" & month == 6L, .(m_arr=mean(arr_delay), m_dep=mean(dep_delay))]
– How many trips have been made in 2014 from “JFK” airport in the month of June?
flights[origin == "JFK" & month == 6L, length(dest)]
flights[origin == "JFK" & month == 6L, .N]
# chaining
flights[carrier == "AA", .N, by=.(origin, dest)][order(origin, -dest)]
# by expressions
flights[, .N, .(dep_delay>0, arr_delay>0)]

#  dashboard
https://gist.github.com/jtleek/3e1baac9a74ea81556c9e6d55743d7ea

#  eventlog preprocessing
gather === pivot_longer
mutate(activity_instance_id=dplyr::row_number())  # for enumerating groups

# tibble ggplot
ggplot(tibble(x = c(-8, 8)), aes(x)) + stat_function(fun=dnorm) + stat_function( fun=dcauchy, geom="point", n=75 )

#  tibble
tibble::glimpse(chic)

#  tibble print cols
print(myt,n=10,width=100)

#   ggblanket
gg_histogram(...)
etc.

#  geom_rug()

#  geom_text_repel()

#  stat_summary(..)

#   tibble ggplot
ggplot(tibble(x = c(-8, 8)), aes(x)) + stat_function(fun=dnorm) + stat_function( fun=dcauchy, geom="point", n=75 )

#  tibble
tibble::glimpse(chic)

#  pivot table
pivot(subset(d16,Machine %in% c("cori","cori2","cori knl","cori haswell")), sum, Util, c(Machine,Day)) %>% head()

# dplyr:: group_by %>% summarize
> filter(d16,grepl("Genom",ScienceCat)) %>% group_by(Program) %>% summarize(n=n())

#  window function
Ranking and ordering functions (dplyr::...)
row_number(), min_rank(), dense_rank(), cume_dist(), percent_rank(), ntile()
Offsets allow you to access the previous and next values in a vector, making it easy to compute differences and trends.
lead() and lag()
Cumulative aggregates:
cumsum(), cummin(), cummax() (from base R), and cumall(), cumany(), and cummean() (from dplyr).
dplyr::lag
RcppRoll::roll_sum(v))
	data.frame(v, c2=RcppRoll::roll_sum(v,2, fill=NA), c3=RcppRoll::roll_sum(v,3, fill=NA))
dplyr::mutate(...,min_rank() )
# For each player, find every year that was better than the previous year
filter(players, G > lag(G))
mutate(players, G_change = (G - lag(G)) / (yearID - lag(yearID)))
filter(players, cume_dist(desc(G)) < 0.1)

#  rolling aggregates / moving  average: many implementations in other packages, such as RcppRoll.

#  moving average : qcc:ewma
dplyr::rollmean()
tibbletime::rollify()
airquality <- airquality %>%  group_by(Month) %>%  mutate(rec = 1) %>%  mutate(rollavg = cumsum(Wind)/cumsum(rec)) %>%  select(-rec)
RcppRoll::roll_mean


#  tables
briatte/ggtable
gridExtra::grid.table
gtable
tlamadon/ggtable - install.packages('devtools');require(devtools);install_github('ggtable',user='tlamadon')
xtable

# ggtable
tlamadon/ggtable - install.packages('devtools');require(devtools);install_github('ggtable',user='tlamadon')

#  tables
install.packages("knitr")
install.packages("kableExtra")
library("kableExtra")

# table to browser !! kable
> all %>% pull(type) %>% fct_count(prop=TRUE) %>% kbl()
all %>% filter(date>'2018-09-30') %>% group_by(type,yy=year(date)) %>% mutate(yy,sb=sum(bytes)) %>% summarize(yy,type,sb) %>% unique() %>% arrange(yy,desc(sb)) %>% kbl(booktabs=T) %>% kable_styling(full_width = T) %>% column_spec(1, width = "8cm")

#  kable
library(kableExtra)
library(knitr)
# kable example
all %>% pull(type) %>% fct_count(prop=TRUE) %>% kbl()
all %>% ...  %>% summarize(yy,type,sb) %>%  kbl(booktabs=T) %>% kable_styling(full_width = T) %>% column_spec(1, width = "8cm")
dt %>%  kbl() %>%  kable_material(c("striped", "hover"))
kbl(dt) %>%  kable_paper("striped", full_width = F) %>%  add_indent(c(1, 3, 5))
# save
save_kable(file = "table1.html", self_contained = T)

# month names
lubridate::month(day,label=T))

#  geom_bar() -- counts values at each x (by default)
p |> mutate(m=month(day,label=T)) |>  ggplot(aes(pipeline,fill=m)) + geom_bar() + theme(axis.text.x=element_text(angle=-90, hjust=0))

#  time bar chart w floating labels
fy18td %>% ggplot(aes(x=Month,y=mon_bytes,fill=type,label=type)) + geom_bar(position="fill",stat="identity",fun=mean) + theme(legend.position="none") + geom_text_repel(force_pull=0,angle=315,segment.size=0.1,direction="x",nudge_x=0.2,nudge_y=2.7e14-subset(fy18td,mon_bytes>30e12)$mon_bytes,data=subset(fy18td,mon_bytes>30e12),aes(label=type,color=type)) + labs(y="Bytes/mon",title="JAMO bytes / mon [highlight files > 30TB]")

#  ggplot : https://www.cedricscherer.com/slides/2019-08-28-intro-ggplot-statsizw#117

#  theme
ggplot(chic, aes(date, temp)) +  geom_point(color = "black")
+  ggthemes::theme_tufte()
#
ggthemes::theme_gdocs()
ggthemes::scale_color_gdocs()

#  log2
# coord_trans does not clip data, scale_y_continous can
ggplot(chic, aes(o3, temp)) +  geom_point() +  coord_trans(x = "log2")
#
all %>%  ggplot(aes(fct_infreq(fct_lump_min(type,min=100)))) + geom_bar() + scale_y_continuous(trans="log2")

#  time series : https://otexts.com/fpp2/simple-methods.html

#  tsibble - time series
https://otexts.com/fpp3/tsibbles.html

#  time series support
gg_subseries()
library(feasts)
library(fpp2)
library(forecast)
forecast::tsoutliers()
tsclean()
library(fable) ## fabletools
stretch_tsibble()

#  forcats
fct_lump / fct_lump_n - fact_lump(prop=0.1), fct_lump(n = -3) # bottom 3
fct_reorder / fct_relevel
fct_count / fct_unique
fct_infreq

#  factor recoding
se %>% mutate(platform=case_when(str_detect(run_mode, "Pac") ~ "P", str_detect(run_mode,"Ill") ~ "I") ) %>% tally(platform)

#  forcats  factor math and label justification various
all %>%  ggplot(aes(fct_infreq(fct_lump_min(type,min=100)))) + geom_bar()
  + theme(axis.text.x=element_text(angle=-90,hjust=0)) + scale_y_continuous(trans="log2")

# reorder histogram
lt %>% group_by(yr,acct_scientific_program,lib_queue,sp_actual_product) %>% tally() %>% ggplot(aes(fct_infreq(lib_queue))) + geom_histogram(stat="count")

# manually reorder x in ggplot -- forcats::fct_relevel
ordered_grades <- c("Very Low", "Low", "Medium","High","Very High")
df %>%   count(grade) %>%
  mutate(grade=forcats::fct_relevel(grade, ordered_grades)) %>%
  ggplot(aes(x=grade, y=n))+
  geom_col()

#  time aggregates
sb = most %>% mutate(Month=as.Date(tsibble::yearmonth(date))) %>% filter(date>'2019-01-01') %>% group_by(Month,type) %>% summarize(sum_b=sum(bytes))
# 1
sb %>% ggplot(aes(x=Month,y=sum_b,color=type)) + geom_jitter(alpha=0.2) + theme(legend.position="none") + geom_text_repel(data=dplyr::filter(sb,sum_b>3.5e13),aes(label=type,color=type))  + coord_trans(y ="log2")
# 2
sb %>% ggplot(aes(x=Month,y=sum_b,color=type)) + geom_jitter(alpha=0.2) + theme(legend.position="none") + geom_text_repel(data=dplyr::filter(sb,sum_b>3.5e13),aes(label=type,color=type))  + scale_x_continuous(trans="log2")
Error in Math.Date(x, base) : log not defined for "Date" objects
# 3
sb  %>% ggplot(aes(x=Month,y=sum_b,color=type)) + geom_jitter(alpha=0.2) + theme(legend.position="none") + geom_text_repel(data=dplyr::filter(sb,sum_b>3.5e13),aes(label=type,color=type))  + scale_y_continuous(trans="log2")

#  timeseries summary
 f |> mutate(date=date(file_date)) |> group_by(date) |> summarize(tot_bytes=sum(file_size), tot_files=n())

#  timeseries -> tsibble
tt = tt %>% filter(grepl("procmon",type))
tt %>% mutate(Month = tsibble::yearmonth(date))

#  interruption plot
ggplot(aes(hour, bytes, fill=percent)) + geom_tile(size=.5, color="white") + theme_classic() +labs(x="24hour Clock", y="", title= "Peak and Lull JAMO", fill="%")  + scale_y_discrete(limits = rev(levels(x$bytes)))+scale_x_datetime(date_breaks = ("1 hour"), date_labels = "%H")

#  counts by hour
patients_df %>% mutate( time=format(time, format="%H:%M:%S") %>% as.POSIXct(format="%H:%M:%S"),  hour=lubridate::floor_date(time, "hour")) %>% count(handling, hour) %>% add_count(handling, wt=n) %>% mutate(percent= ((n/nn)*100)) %>% ggplot(aes(hour, handling, fill=percent)) + geom_tile(size=.5, color="white") + theme_classic() +labs(x="24hour Clock", y="", title= "Peak and Lull Period of Patient Activities", subtitle= "percentage calculated is the relative frequency for a specific activity", fill="%")  + scale_y_discrete(limits = rev(levels(patients_df$handling)))+scale_x_datetime(date_breaks = ("1 hour"), date_labels = "%H")

#  sum by month
https://gist.github.com/mollietaylor/5846843

#  memory size
> pryr::object_size(all) #180,529,648 B

#  dates and times: https://r4ds.had.co.nz/dates-and-times.html

#  convert date <-> datetime:
as_datetime(today())#> [1] "2020-10-09 UTC"
as_date(now())#> [1] "2020-10-09"

#  filter date:  filter(dep_time < ymd(20130102)) %>%

#  datetime histograms
flights_dt %>% filter(dep_time < ymd(20130102)) %>% ggplot(aes(dep_time)) + geom_freqpoly(binwidth = 600) # 600 s = 10 minutes

#  extract day:
as_date(ymd_hms(data$time)) where time is Y-M-D H:M:S
all$d = as_date(all$date) # where 'date' is a tibble::dttm

#  eventlog preprocessing
 prod=read_csv("prod.csv",col_types="fffTTTTTTTTTT")
> prod  %>% pivot_longer(!c(lib:prod), names_to ="step", values_to="datetime")

# process mininmg
minit
disco
pm4py pip
proM  processming.org prom.org
celonis www.celonis.de
bupaR cran
rapidProM https://arxiv.org/abs/1703.03740 www.rapidprom.org

# sketching / drawing
draw.io
inkscape
https://excalidraw.com

# clang problems: maybe try
sudo ARCHFLAGS="-arch x86_64"

# macos compiler stuff: https://developer.apple.com/download/more/

#  package not available errors
remotes::install_github("bupaverse/pm4py@dev")
see also devtools

#  config
R CMD config --all

#  availabel packages
 available.packages(filters = "OS_type")[pkgname, ]
#  xtick
df1 %>% na.omit %>% filter(now()-start<51) %>% ggplot(aes(x=dt,y=wclk)) + scale_y_log10() + scale_x_date(date_breaks="2 day")
scale_x_date(limits = c(ymd("2008-01-01"), ymd("2009-12-31")), date_breaks = "1 year", date_labels = "%Y") + ...

#  grep dplyr: grepl
> filter(d16,grepl('Bio',Program))

#  queueing theory (https://journal.r-project.org/archive/2017/RJ-2017-051/RJ-2017-051.pdf)
library(queueing)
i_mm1 <- NewInput.MM1(lambda=2, mu=3)	# Create the inputs for the model.
CheckInput(i_mm1)			# Optionally check the inputs of the model
o_mm1 <- QueueingModel(i_mm1)		# Create the model
print(summary(o_mm1), digits=2)		# Print on the screen a summary of the model

#  binary infix operators  (https://stackoverflow.com/questions/12730629/what-do-the-op-operators-in-mean-for-example-in)
ggplot2::`%+%`

# javascript
typescript (30k)
coffeescript (2k)
elm (515)
crystal -> js (220)
nim -> js (46)
purescript (37)

#  remove outlier data points
ggplot(chic, aes(year, temp)) +  geom_boxplot()
+  scale_y_continuous(    limits = c(50, 70)  )

#  remove legend
ggplot(chic, aes(date, temp)) + geom_point(aes(color = season))
+ scale_color_manual( values = c("red","blue","green","goldenrod"), guide = FALSE)
# or
theme(legend. position = "none")

#  color palette
ggplot(chic, aes(date, temp)) + geom_point(aes(color = season))
+  scale_color_brewer( palette = "Set2", guide = FALSE  )

#  ggplot rotate xlabel
theme(x.axis.text= element_text(angle=-90))

#  ggplot point size small
geom_jitter(alpha=0.2, size=0.2,...)

#  calendar heatmap - outages
# https://www.nersc.gov/events/nersc-scheduled-system-outages
https://exts.ggplot2.tidyverse.org/ggTimeSeries.html
https://vietle.info/post/calendarheatmap/
http://www.columbia.edu/~sg3637/blog/Time_Series_Heatmaps.html
source("https://raw.githubusercontent.com/iascchen/VisHealth/master/R/calendarHeat.R")
#

# calendar heatmap
ggTimeSeries::stat_calendar_heatmap
ggTimeSeries::ggplot_calendar_heatmap

ggplot(dft, aes(monthweek, x=weekday, color=typef)) + geom_tile(color="white") + facet_wrap(year~month,ncol=4) + scale_color_hue() + theme(axis.text.x = element_text(angle=-90), panel.grid.minor=element_blank(), panel.grid.major = element_line(colour = "white",size=0.35)) + scale_y_reverse() + scale_x_discrete()
#
ggplot(aes(weekday,-week, fill = ValueCol)) + geom_tile(colour = "white")  + theme(aspect.ratio = 1/5,
axis.title.x = element_blank(),
axis.title.y = element_blank(),
axis.text.y = element_blank(),
panel.grid = element_blank(),
axis.ticks = element_blank(),
panel.background = element_blank(),
strip.background = element_blank(),
strip.text = element_text(face = "bold", size = 15),
panel.border = element_rect(colour = "black", fill=NA, size=1)) +
facet_wrap(~month, nrow = 4, ncol = 3, scales = "free")

# reverse x factor
 f |> filter(template!="None") |> group_by(template) |> summarize(n=n()) |> mutate(fr=fct_reorder(template,-n),pct_rank=percent_rank(n)*100) |> ggplot(aes(x=fct
_infreq(fct_lump(fr)),y=n)) + geom_point() + rotateTextX() + scale_y_log10()
# or
scale_x_discrete(limits = rev(levels(the_factor)))
# or
aes(x = reorder(the_factor, desc(the_factor)), ...)
# or
scale_x_discrete(limits = rev)

#  axis datetime
scale_x_date(date_breaks="2 day")
scale_x_date(limits = c(ymd("2008-01-01"), ymd("2009-12-31")), date_breaks = "1 year", date_labels = "%Y")

#  filter datetime
df1 %>% na.omit %>% filter(now()-start<51)

#  timeseries / ggplot2 : https://www.granvillematheson.com/post/self-portrait/

#  timeseries remove duplicates: > most %>% filter(!tsibble::are_duplicated(most,index=date,key=bytes))

#  datetime annotation (https://edav.info/dates.html)
 ... + geom_line() +  geom_vline(xintercept = ymd("2008-09-29"), color = "blue") +
  annotate("text", x = ymd("2008-09-29"), y = 3.75, label = " Market crash\n 9/29/08", color = "blue", hjust = 0) +  scale_x_date(limits = c(ymd("2008-01-01"), ymd("2009-12-31")), date_breaks = "1 year", date_labels = "%Y") + ...

#  time series : missing dates
> DateRange <- seq(min(d16$Day), max(d16$Day), by = 1)
> DateRange[! DateRange %in% d16$Day ]

#  time series
tsibble - fill_gaps(), as_tsibble()
feasts - gg_subseries(), gg_lag(), ACF(), autoplot(), features() , [https://github.com/tidyverts/feasts]
install.packages("TSstudio") - ts_plot, ts_info() , ts_to_prophet(),
chron
dplyr::lag, etc.
runner
zoo
timetk (https://business-science.github.io/timetk/articles/TK00_Time_Series_Coercion.html)
# add useful ts calc fields
R>  FB_vol_date_signature <- FB_tbl %>% tk_augment_timeseries_signature(.date_var = date)
tk_get_timeseries_summary(idx_date)[,7:12]

#  time series padding (missing values)
library(padr)
pad(df,...)
tidyr::fill is handy for filling missing values after padding.
Also
- padr::fill_by_value: fill w single value
- padr::fill_by_function: fill w function of non-missing values
- padr::fill_by_prevalent: fill w the most prevalent value among the nonmissing values.

#  time series : timetk
https://business-science.github.io/timetk/articles/TK04_Plotting_Time_Series.html
m4_hourly %>% group_by(id) %>%  plot_time_series(date, log(value),             # Apply a Log Transformation
   .color_var = week(date),      # Color applied to Week transformation
   .facet_ncol = 2, .facet_scales = "free", .interactive = interactive)  # Facet formatting
# anomaly
walmart_sales_weekly %>%  group_by(Store, Dept) %>%  plot_anomaly_diagnostics(Date, Weekly_Sales, .facet_ncol = 2)
d16wd %>% filter(Machine %in% c("cori2","cori knl")) %>% filter(ScienceCat %in% c("Cosmology","Materials Science", "Genomics")) %>% group_by(Machine) %>% plot_anomaly_diagnostics(Day, DailyJobs, .facet_ncol = 2)

#  compile / rmakevar / rcompile
 see cran.r-project.org/doc/manuals/r-release/R-admin.html
/Library/Frameworks/R.framework/Resources/etc/Makeconf
R_SHARE_DIR <- Sys.getenv()
~/.R/Makevars # or ~/.R/Rmakevars ??
/path/R/install/[lib64/R/]etc/Makeconf
~/.julia/conda/3/lib/R/etc/Makeconf
# or
julia> Conda.add("r-zoo")

#  bioconductor install (new)
> install.packages("BiocManager",repos="https://cloud.r-project.org")
#┌ Warning: RCall.jl: Bioconductor version 3.10 (BiocManager 1.30.10), ?BiocManager::install for help
R> BiocManager::install("qvalue")

#  package is not available: https://stackoverflow.com/questions/25721884/how-should-i-deal-with-package-xxx-is-not-available-for-r-version-x-y-z-wa
R> install.packages("BiocManager",repos="https://cloud.r-project.org")

#  compile clang fails (see https://github.com/ContinuumIO/anaconda-issues/issues/11184)
what about flang?

#  configure vars
install.packages compile options: install.packages("Rmpfr" , configure.vars = "--with-mpfr-include=/path/to/mpfr/include")

#  configure (conda r-base)
x86_64-apple-darwin13.4.0-clang" CFLAGS="-march=core2 -mtune=haswell -mssse3 -ftree-vectorize -fPIC -fPIE -fstack-protector-strong -O2 -pipe -I/Users/copeland/.julia/conda/3/include -fdebug-prefix-map=/opt/concourse/worker/volumes/live/35542676-6889-43cb-7dee-5296bec04994/volume/r-base_1583246889808/work=/usr/local/src/conda/r-base-3.5.3 -fdebug-prefix-map=/Users/copeland/.julia/conda/3=/usr/local/src/conda-prefix  -D_FORTIFY_SOURCE=2 -mmacosx-version-min=10.9  -I/Users/copeland/.julia/conda/3/include -fPIC " AR="x86_64-apple-darwin13.4.0-ar" RANLIB="x86_64-apple-darwin13.4.0-ranlib" LDFLAGS="-Wl,-dead_strip_dylibs  -Wl,-pie -Wl,-headerpad_max_install_names -Wl,-dead_strip_dylibs -Wl,-rpath,/Users/copeland/.julia/conda/3/lib -L/Users/copeland/.julia/conda/3/lib" ./configure --quiet)

#  center/standardize/winsorize
DescTools::RobScale  - Robust Scaling With Median and Mad
‘RobScale’ is a wrapper function for robust standardization, using ‘median’ and ‘mad’ instead of ‘mean’ and ‘sd’.
Usage:
RobScale(x, center = TRUE, scale = TRUE)
# see also scale()

#  summary (skim)
a63 %>% filter(!grepl("Custom|Nega",type),n()>30,raw_reads_count>1000,sec_perM<500) %>% mutate(n=n(),s=sum()) %>% group_by(type) %>% skimr::skim()
glimpse()


# skim print() options
print(skim(df), n=..., width=...)
# permanant set options via pillar::pillar_options
pillar.print_max
pillar.width

#  boxplot by date (violin or boxplot same)
all %>% filter(date>'2018-09-30') %>% group_by(type,yy=year(date)) %>% mutate(yy,sb=sum(bytes)) %>% ggplot() + geom_violin(aes(y=sb,x=yy,group=yy)) + labs(x="Bytes(sum by month)",y="Date",title="JAMO bytes(sum) by month+type")

#  outliers
boxplot.stats(a63$sec_perM)$out
car::outlierTest(mod)
as.numeric(names(cooksd)[(cooksd > 4*mean(cooksd, na.rm=T))])
https://cran.r-project.org/web/packages/outliers/index.html

#  heatmap tidyr ts
cori_sh %>% mutate(y=year(datetime_start),d=day(datetime_start),h=hour(datetime_start)) %>%  acast(darshan_app~d) %>% heatmap(Colv=NA)

#  ggplot extensions, see
cowplot	 https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
- plot_grid, ggdraw,
ggridges 	- geom_density_ridges
ggTimeSeries - calendar_heatmap https://exts.ggplot2.tidyverse.org/ggTimeSeries.html
ggrepel
ggsankey
https://davidhodge931.github.io/ggblanket/

#  ggplot extensions, see
cowplot	 https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
- plot_grid, ggdraw,
ggridges 	- geom_density_ridges
ggTimeSeries - calendar_heatmap

# nersc outages
curl 'https://api.nersc.gov/api/v1.2/status/outages'   > NERSC-outages-all.json
cat NERSC-outages-all.json  |  \
jq -r '.[]|.[]| [.name,.start_at,.end_at,.status]|@csv' > NERSC-outages-all.csv
R
> library(ggplot2)
> library(ggTimeSeries)
> library(readr)
> n = read_csv("2022-perlmutter.csv",col_types="fTTf")
> names(n)=c("system","start","end","desc")
> n %>% mutate(hrs=as.numeric(end-start)/3600.0) %>% ggplot_calendar_heatmap('start','hrs') +  xlab(NULL) + ylab(NULL) + scale_fill_continuous(low = 'yellow', high = 'red') + facet_wrap(~Year, ncol = 1) + ggtitle("NERSC outages")
ggsave("NERSC-outages.pdf")


#  for SPC
ggQC
xmrr - xmrr control charts

#  boxplot data : p <- ggplot(mtcars, aes(x=factor(gear), y=mpg)) + geom_boxplot()
ggplot_build(p)$data
p <- ggplot(mtcars, aes(x=factor(gear), y=mpg)) + geom_boxplot()

#  ggplot labels that don't overlap: library(ggrepel)

#  ggrepel label some points
ggplot(dt, aes(x = one, y = two, color = diff_cat)) +  geom_point() +
  geom_text_repel(data = . %>%
	mutate(label = ifelse(diff_cat %in% c("type_1", "type_2") & abs(diff) > 2, name, "")),
	 aes(label = label), box.padding = 1, show.legend = FALSE) + #this removes the 'a' from the legend
  coord_cartesian(xlim = c(-5, 5), ylim = c(-5, 5)) + theme_bw()

#  inset table in ggplot : library(ggpmisc)
# https://cran.r-project.org/web/packages/ggpmisc/vignettes/user-guide.html
geom_table()

# sort dataframe
dplyr::arrange(df, -desc(date))

#  plots hline and color
p2 = asm %>% arrange(d) %>% group_by(d) %>% filter(sec_perM<1000) %>% gplot(aes(x=d,y=sec_perM,group=d)) + geom_boxplot(outlier.shape=NA,aes(middle=mean(sec_perM))) + geom_jitter(color="red",size=0.3,alpha=0.1) + geom_hline(aes(yintercept=0),color="blue") + geom_hline(aes(yintercept=80),color="red")

#  multiple figures : library(gridExtra)
p1 = ggplot()...
p2 = ggplot() ...
grid.arrange(p1,p2)
# save to pdf
ggsave("foo.pdf", arrangeGrob(plot1, plot2))

# multiplot
library(cowplot)
plot_grid(p1, p2, labels=c("A","B"), align="v")

# ggplot annotations :
library(cowplot)

# dplyr / ggplot2 examples : https://owi.usgs.gov/blog/data-munging/

#  magrittr tidyverse ggplot2:
https://www.r-bloggers.com/2021/03/how-to-treat-as-many-files-as-fit-on-your-hard-disk-without-loops-sorta-nor-running-out-of-memory-all-the-while-being-as-lazy-as-possible/
# who knew ?
library(tidyverse)
library(rlang)
library(tidyxl)
library(brotools)
mtcars_plot <- mtcars %>% group_by(am) %>% nest()
%>%  mutate(plots = map2(.y = am, .x = data, ~{ggplot(data = .x) + geom_smooth(aes(y = mpg, x = hp), colour = "#82518c") +
	ggtitle(paste0("Miles per gallon as a function of horse power for am = ", .y)) + theme_blog()}))

# _HOME: Rscript -e "cat(Sys.getenv('R_HOME'))

#  markdown to html  (knitr, pandonc, rmarkdown)
R -e "markdown::markdownToHTML('markdown_example.md', 'markdown_example.html')"

#  library github	 (https://github.com/MangoTheCat/remotes)
source("https://raw.githubusercontent.com/MangoTheCat/remotes/master/install-github.R")$value("mangothecat/remotes")
remotes::install_github("mangothecat/remotes")

# dplyr / tidy read csv :
library("readr")
read_csv

# tidy / tidyr	 - http://garrettgman.github.io/tidying/
x=read.csv("mess")
library(tidyr)
glimpse(x)
xx=spread(x,metric_name,metric_value)

# jupyter R
IRkernel / R
# which R is determined by IRkernel::InstallSpec()
jupyter-notebook
p Library/Jupyter/kernels/ir/kernel.json
R --version
brew cask versions R
jupyter-notebook --kernel=ir
%config InlineBackend.figure_formats = {'png', 'retina'}

# -java
R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
If you've installed a version of Java other than the default, you might need to instead use:
  R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I/Library/Java/JavaVirtualMachines/jdk<version>.jdk/"
(where <version> can be found by running `java -version`, `/usr/libexec/java_home`, or `locate jni.h`), or:
  R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I$(/usr/libexec/java_home | grep -o '.*jdk')"

#  CMD INSTALL pkg.tar.gz

# library(genomes)
genomes::updateproks
genomes::updatevirus()
genomes::updateeuks()

# bioconductor
source("https://bioconductor.org/biocLite.R")
biocLite("genomes")

# tidyr	http://garrettgman.github.io/tidying/

# cran install github
devtools::install_github("garrettgman/DSR")

# cran install using devtools install github
biocLite("devtools")
library("devtools")
devtools::install_github("benjjneb/dada2")

# ggplot rotate text
> ggplot(x,aes(Name,BasesPct)) + geom_boxplot() +  theme(axis.text.x= element_text(angle=90))

# ggplot fungal summary
> ggplot(data=subset(f,assembler %in% c("Falcon","AllPathsLG")),aes(x=cut(dt,breaks="month"),y=n_scaffolds,color=assembler,size=scaf_bp)) + geom_point()  + coord_flip()

# xlsx
cran xlsx - huge java pain in the ass
cran readxl - wickham
readr - hadleyverse  # library(readr) (read_csv, read_tsv)
##
install.packages("readxl")
# only the binary install worked; grab tarball then unpack into /Users/copeland/Library/R/3.2
library(readxl)
d=read_excel("/Users/copeland/Work/klail//RQC_metrics.xlsx",sheet="Sheet1")

# SPC / control charts
spc, qcc, ggQC, xmrr,
surveillance

# ggQC
https://r-bar.net/xmr-limits-moving-range
filter(d16wd,grepl("Genom",ScienceCat)) %>% ggplot() + aes(Day,DailyJobs) + geom_point() + geom_line() + stat_QC(method="XmR",auto.label=T,label.digits=2,show.ln2.sigma=T)

# data.table
https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-intro-vignette.html
.N := number of samples
.SD := subset of data (also a data.table)
.() := list()
#
DT[i, j, by]
##   R:      i                 j        by
## SQL:  where   select | update  group by
#
– Calculate the average arrival and departure delay for all flights with “JFK” as the origin airport in the month of June.
flights[origin == "JFK" & month == 6L, .(m_arr=mean(arr_delay), m_dep=mean(dep_delay))]
– How many trips have been made in 2014 from “JFK” airport in the month of June?
flights[origin == "JFK" & month == 6L, length(dest)]
flights[origin == "JFK" & month == 6L, .N]
# chaining
flights[carrier == "AA", .N, by=.(origin, dest)][order(origin, -dest)]
# by expressions
flights[, .N, .(dep_delay>0, arr_delay>0)]

# ggplot cumulative plot
ggplot(data=pb,aes(x=n_contigs)) + stat_ecdf(geom="smooth") + labs(x="Contigs",y="Fraction")
# or
dplyr::cume_dist()

#  cumulative plot by factor
set.seed(123)
x <- data.frame(A=replicate(200,sample(c("a","b","c"),1)),X=rnorm(200))
iilibrary(plyr)
df <- ddply(x,.(A),transform,len=length(X))
ggplot(df,aes(x=X,color=A)) + geom_step(aes(len=len,y=..y.. * len),stat="ecdf")
#	df <- data.frame(x = c(rnorm(100, 0, 3), rnorm(100, 0, 10)),
g = gl(2, 100))
ggplot(df, aes(x, colour = g)) + stat_ecdf()
#
qplot(unique(mydata), ecdf(mydata)(unique(mydata))*length(mydata), geom='step')
qplot(data=ac417.dt[, .SD[length>100][,sum(length)/asm_len],by=lib],x=lib,y=V1)

#   summarizing data frames
plyr - ok but quirky and slow
dd <- ddply(df, .(date), summarise, val = sum(val))
data.table - much faster
dd <- dt[, cumsum(.SD), by=c('date') ] # where .SD is the subset_data defined with the 'by' operator

#  factor to date
> ai$Library.Creation.Date = ymd_hms(levels(ai$Library.Creation.Date))[ai$Library.Creation.Date]
# 6051] "2014-06-05" "2014-06-05"
> lcmt$lib_date=as.Date(levels(lcmt$library_status_date),format="%d-%b-%y")[lcmt$library_status_date]

#  qplot/ data.table
> lcm=read.csv("file.csv")
> lcmt=data.table(lcm)
# fix dates etc.
> setkey(lcmt,stats_name)
> lcmt[ ]
> lcmt[,mode:=length(ins_size_mode),by=stats_name]
> qplot(data=lcmt["ins_size_mode",],lib_date,mode,color=account_jgi_sci_prog) + scale_y_continuous(breaks=seq(100,300,by=10))
> qplot(data=lcmt["ins_size_avg", ],lib_date,avg ,color=account_jgi_sci_prog) + scale_y_continuous(breaks=seq(0,200,by=10)) + geom_text(data=lcmt["ins_size_av
qplot(data=lcmt["ins_size_avg",],lib_date,avg,color=account_jgi_sci_prog)
> p=qplot(data=lcmt["ins_size_avg",],lib_date,avg,color=account_jgi_sci_prog)
> pp=p + scale_y_continuous(breaks=seq(0,300,by=10))
> ppp= pp + geom_text(data=lcmt["ins_size_avg",],aes(label=library_name),hjust=0,vjust=0,size=2)

#  factor to numeric
as.numeric(levels(f)) [f]
data <- read.csv("datafile.csv", stringsAsFactors=FALSE)

#  summaries / summary / summarize
http://www.cookbook-r.com/Manipulating_data/Summarizing_data/

# studio - won't start
need gfortran but possible conflict with julia builds?

#  - convert FACTOR to numeric
as.numeric(levels(f)) [f]

# Error: ld: library not found for -lintl:
Fix: Make sure LDFLAGS in ~/.R/Makevars is correct

# Error: clang-13: error: linker command failed with exit code 1
Fix: (use -v to see invocation)

# Error: unable to load rlang.so
# Fix: install.packages("rlang")

# Error: compile errors -stdlib=c++ e.g. roxygen2, httpuv,...
# this is a clang arg that comes from god knows where
# cut/paste the sane part of the failed compile command from stdout then run it via:
withr::with_makevars(c(PKG_CPPFLAGS="-std=gnu++11 -I/usr/local/Cellar/r/4.1.1_1/lib/R/include -DNDEBUG  -I/usr/local/lib/R/4.1/site-library/cpp11/include -I/usr/local/opt/gettext/include -I/usr/local/opt/readline/include -I/usr/local/opt/xz/include -I/usr/local/include -fPIC", {install.packages("roxygen2")}, assignment = "+="))
withr::with_makevars(c(PKG_LDFLAGS=" -dynamiclib -Wl,-headerpad_max_install_names -undefined dynamic_lookup -single_module -multiply_defined suppress -L/usr/local/Cellar/r/4.1.1_1/lib/R/lib -L/usr/local/opt/llvm@13/lib -o readxl.so RcppExports.o XlsWorkBook.o XlsWorkSheet.o XlsxWorkBook.o XlsxWorkSheet.o cran.o endian.o ole.o xls.o xlstool.o zip.o -L/usr/local/Cellar/r/4.1.1_1/lib/R/lib -lR -Wl,-framework -Wl,CoreFoundation",{install.packages("tidyverse")}, assignment= "+="))

# Error: library compile fail due to incorrect compiler :
Fix: create ~/.R/Makevars; set CC and CXX

# Error: linker fail
Fix: vim ~/.R/Makevars  # explicitly set gcc-<VER> to avoid using old clang-> gcc link

# Error:  compile fail - openmp not available
Fix: vim ~/.R/Makevars  # explicitly set gcc-<VER> to avoid using old clang-> gcc link

#  compile flang (https://releases.llvm.org/11.0.0/tools/flang/docs/ReleaseNotes.html)

#  recompile all packages
pkgs = lib...
pkgs = as.data.frame(installed.packages(),stringsAsFactors=FALSE)[,"Package"]
install.packages( lib=lib, pkgs=as.data.frame(pkgs, stringsAsFactors=FALSE)$Package, type = 'source')

# compile package with zig
# .fortran int / loog int issues.....

# dylib / macos
LD_LIBRARY_PATH ==> DYLD_LIBRARY_PATH and DYLD_FALLBACK_LIBRARY_PATH.
R CMD otool -L <pkg.so> will show where dependencies are resolved.

# rebuild package and all deps
renv::rebuild("dplyr", recursive = TRUE)  # rebuild 'dplyr' + all of its dependencies

#  ggplot extensions, see
cowplot  https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
- plot_grid, ggdraw,
ggridges        - geom_density_ridges
ggTimeSeries - calendar_heatmap https://exts.ggplot2.tidyverse.org/ggTimeSeries.html
ggrepel
ggsankey - https://github.com/davidsjoberg/ggsankey
https://davidhodge931.github.io/ggblanket/

# sankey plots
https://rpubs.com/techanswers88/sankey-with-own-data-in-ggplot
#install.packages("remotes")
remotes::install_github("davidsjoberg/ggsankey")
devtools::install_github("davidsjoberg/ggsankey")

# sankey
tl = plant16 %>% make_long(sam_dna_isolation_method, sow_fm,sp_actual_product)
t = plant16 %>% make_long(sam_dna_isolation_method, sow_fm,sp_actual_product) %>% group_by(node) %>% tally()
merge(tl, t, by.x = 'node', by.y = 'node', all.x = TRUE)
pl <- ggplot(x, aes(x = x, next_x = next_x , node = node, next_node= next_node, fill = factor(node), label = paste0(node," n=", n)))
 + geom_sankey(flow.alpha = 0.5,  color = "gray40",show.legend = TRUE)
 + geom_sankey_label(size = 3, color = "white", fill="gray40", hjust = -0.2)
ggsave("plant_method_sowfm_sankey.pdf", height=8000,width=12000,units="px")

# ecdf y as percentage
g = ggplot(data=d, aes(x=gb_ccs)) + stat_ecdf() + scale_x_log10() +  scale_y_continuous(breaks=seq(0,1,0.1),labels=scales::percent)
g + xlab("Gbp") + ylab("") + geom_line(y=.10,color="red") + ggtitle("Fungal CCS Yield")

* cumulative plot
ggplot(data=pb,aes(x=n_contigs)) + stat_ecdf(geom="smooth") + labs(x="Contigs",y="Fraction")
# or
dplyr::cume_dist()

# selection matchers
https://tidyselect.r-lib.org/reference/starts_with.html

starts_with()

# stringr
str_detect(str, pat)
str_...
str_view_all(str, pat, match) # render html
str_extract(x, pat) or str_match(x, (a).*(b))

# introspection
str()
class()
glimpse() #  a better str() ?

#  cumulative plot by factor
set.seed(123)
x <- data.frame(A=replicate(200,sample(c("a","b","c"),1)),X=rnorm(200))
iilibrary(plyr)
df <- ddply(x,.(A),transform,len=length(X))
ggplot(df,aes(x=X,color=A)) + geom_step(aes(len=len,y=..y.. * len),stat="ecdf")
#	df <- data.frame(x = c(rnorm(100, 0, 3), rnorm(100, 0, 10)),
g = gl(2, 100))
ggplot(df, aes(x, colour = g)) + stat_ecdf()
#
qplot(unique(mydata), ecdf(mydata)(unique(mydata))*length(mydata), geom='step')
#
qplot(data=ac417.dt[, .SD[length>100][,sum(length)/asm_len],by=lib],x=lib,y=V1)

# Error: <libintl.h> not found
# Fix: brew install gettext

# plate data plotting
library(platetools)
library(dplyr)
library(ggplot2)
x=summarise(group_by(d,plate,iTAG.Primer.Set,Well),mmc=mean(Pairs.Count))
> raw_map(x$mmc,well=x$Well) + theme_dark() + scale_fill_viridis()
# internally the above does this
plt96(plate_map(well=x$Well,x$mmc)) + theme_dark()

# convert df to table
dplyr::tbl_df(df)

# summary of tbl data
dplyr::glimpse(df)

# pipe
dplyr::%>%

# data.table v. dplyr: http://stackoverflow.com/questions/21435339/data-table-vs-dplyr-can-one-do-something-well-the-other-cant-or-does-poorly

# r eventlog preprocessing
gather === pivot_longer
mutate(activity_instance_id=dplyr::row_number())  # for enumerating groups

# dplyr table summary
d %>% group_by(protocol,input) %>% summarise(n=n(),m=mean(raw0,na.rm=T),v=var(raw0,na.rm=T))

# option parsing -- see ~/scripts/NERSC-outages.r
library(optparse)
option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL,
              help="dataset file name", metavar="character"),
    make_option(c("-o", "--out"), type="character", default="NERSC-outages.pdf",
              help="pdf output file [default= %default]", metavar="character")
);
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
if (is.null(opt$file)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}
n = read_csv(opt$file, col_types="fTTf")

# dplyr
tally
group_by

# package install
Rscript -e "install.packages('<url>', type = 'source', Ncpus = 4)"

# r grep
> library(dplyr)
> xs=filter(x,grepl('ubstan|no data',failure_mode_what),!grepl('iTag',actual_library_queue))

# pareto
f |> filter(template=="None") |> group_by(file_group) |> summarize(tot_bytes=sum(file_size), tot_files=n(),avg_size=mean(file_size)) |> ggplot(
aes(y=tot_files,x=file_group)) +  stat_pareto() + rotateTextX()

#  eventlog preprocessing
gather === pivot_longer
mutate(activity_instance_id=dplyr::row_number())  # for enumerating groups

#  additions ggplot: geom_rug() , geom_text_repel() stat_summary(..)
#  pivot table
pivot(subset(d16,Machine %in% c("cori","cori2","cori knl","cori haswell")), sum, Util, c(Machine,Day)) %>% head()
# dplyr:: group_by %>% summarize
> filter(d16,grepl("Genom",ScienceCat)) %>% group_by(Program) %>% summarize(n=n())

#  window function
Ranking and ordering functions (dplyr::...)
	row_number(), min_rank(), dense_rank(), cume_dist(), percent_rank(), ntile()
	Offsets allow you to access the previous and next values in a vector, making it easy to compute differences and trends.
	lead() and lag()
Cumulative aggregates:
	cumsum(), cummin(), cummax() (from base R), and cumall(), cumany(), and cummean() (from dplyr).
	dplyr::lag
	RcppRoll::roll_sum(v))
		data.frame(v, c2=RcppRoll::roll_sum(v,2, fill=NA), c3=RcppRoll::roll_sum(v,3, fill=NA))
	dplyr::mutate(...,min_rank() )
	# For each player, find every year that was better than the previous year
	filter(players, G > lag(G))
	mutate(players, G_change = (G - lag(G)) / (yearID - lag(yearID)))
	filter(players, cume_dist(desc(G)) < 0.1)

# pareto
f <- max(df$counts) # or df$counts[1], as it is sorted descendingly
ggplot(df, aes(x=value)) +  theme_bw(base_size = 12)+
  geom_bar(aes(y=counts, fill=value), stat="identity",show.legend = FALSE) +
  geom_path(aes(y=cumulative*f, group=1),colour="red", size=0.9) +
  geom_point(aes(y=cumulative*f, group=1),colour="red") +
  scale_y_continuous("Counts", sec.axis = sec_axis(~./f, labels = scales::percent), n.breaks = 9) +
  scale_fill_grey() +
  theme(
    axis.text = element_text(size=12),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title.x=element_blank()
  )

#  time aggregates
sb = most %>% mutate(Month=as.Date(tsibble::yearmonth(date))) %>% filter(date>'2019-01-01') %>% group_by(Month,type) %>% summarize(sum_b=sum(bytes))
# 1
sb %>% ggplot(aes(x=Month,y=sum_b,color=type)) + geom_jitter(alpha=0.2) + theme(legend.position="none") + geom_text_repel(data=dplyr::filter(sb,sum_b>3.5e13),aes(label=type,color=type))  + coord_trans(y ="log2")
# 2
sb %>% ggplot(aes(x=Month,y=sum_b,color=type)) + geom_jitter(alpha=0.2) + theme(legend.position="none") + geom_text_repel(data=dplyr::filter(sb,sum_b>3.5e13),aes(label=type,color=type))  + scale_x_continuous(trans="log2")
Error in Math.Date(x, base) : log not defined for "Date" objects
# 3
sb  %>% ggplot(aes(x=Month,y=sum_b,color=type)) + geom_jitter(alpha=0.2) + theme(legend.position="none") + geom_text_repel(data=dplyr::filter(sb,sum_b>3.5e13),aes(label=type,color=type))  + scale_y_continuous(trans="log2")


# simulation: rework rate mix
hist(c(rgamma(700,70),rgamma(300,150)) # 70% @70d; 30%@150d
fivenum(c(rgamma(700,70),rgamma(300,150)) # 70% @70d; 30%@150d
fivenum(c(rep(70,700),rep(150,300)))

# abbrev
abbreviate()

# JAMO file_type
 f |> group_by(file_type,yr=year(file_date),template) |> filter(yr==2023,template=="None")  |> summarize(tot_bytes=sum(file_size), tot_files=n()
)|> filter(tot_bytes>1e8)  |> arrange(desc(tot_bytes)) |> ggplot(aes(y=reorder(file_type,tot_files),x=tot_files)) + geom_point(size=3) + ggExtra:
:rotateTextX() + theme( panel.grid.major.x = element_blank(),panel.grid.minor.x=element_blank(),panel.grid.major.y=element_line(colour="grey60",
linetype="dashed",size=0.4)) + scale_x_log10() + ggtitle("JAMO file_types:2023,template=None,>100MB") + ylab(NULL)
`summarise()` has grouped output by 'file_type', 'yr'. You can override using the `.groups` argument.
> ggsave("JAMO-tot_files.by.type.None.gt100MB.2023.pdf")

#  grep dplyr: grepl
> filter(d16,grepl('Bio',Program))

#  grep dplyr: grepl
> filter(d16,grepl('Bio',Program))
#  time series
tsibble - fill_gaps(), as_tsibble()
feasts - gg_subseries(), gg_lag(), ACF(), autoplot(), features() , [https://github.com/tidyverts/feasts]
install.packages("TSstudio") - ts_plot, ts_info() , ts_to_prophet(),
chron
dplyr::lag, etc.
runner
zoo
timetk (https://business-science.github.io/timetk/articles/TK00_Time_Series_Coercion.html)
# add useful ts calc fields
R>  FB_vol_date_signature <- FB_tbl %>% tk_augment_timeseries_signature(.date_var = date)
tk_get_timeseries_summary(idx_date)[,7:12]

# ecdf
Fn = ecdf(x);  xr = knots(Fn);  xr

# distance plots
bio3d::plot.dmat(ide.mat, color.palette=mono.colors, main="Sequence Identity", xlab="Structure No.", ylab="Structure No.")

# spider::sppDistMatrix  - ditnace matrix

# compare trees
        spider::tree.comp

# bar chart of pure categorical data without counts
bgc = rio::import("20230417_JGIContaminationAnalysis.xlsx")
bgc |> group_by(gDNAMethod) |> add_count(JGIStatus) |> mutate(prop=n/sum(n),tot=sum(n))
  |> ggplot(aes(x=gDNAMethod,y=prop,fill=JGIStatus)) + geom_col() + scale_y_continuous(labels=scales::percent_format())

# split col into cols
> bgcx = separate_wider_regex(data=bgc,col=c("StorageLocation"),patterns = c(plate="\\d{3}|X\\d","_",row="[A-HX]",col="\\d{2}"))

#  sort dataframe
dplyr::arrange(df, -desc(date))

# reorder factor on another column ; see also add_count, add_tally
bgcx |> group_by(plate) |> count(JGIStatus) |> mutate(prop=n/sum(n),tot=sum(n)) |> mutate(plate=fct_reorder(plate, n, .desc=TRUE)) |> ggplot
(aes(x=reorder(plate,plate,function(x) length(x)),y=prop,fill=JGIStatus)) + geom_col() + scale_y_continuous(labels=scales::percent_format()) +
 rotateTextX()



# reorder factor
reorder(name, avg), which takes the name column, turns it into a factor, and sorts the factor levels by avg.

# dplyr / ggplot2 examples :
https://owi.usgs.gov/blog/data-munging/

# dplyr / tidy read csv :
library("readr")
read_csv

# cumulative plot
ggplot(data=pb,aes(x=n_contigs)) + stat_ecdf(geom="smooth") + labs(x="Contigs",y="Fraction")
# or
dplyr::cume_dist()

# hoist
https://tidyr.tidyverse.org/articles/rectangle.html

# group by date
 bgcx |> mutate(ym=as.Date(tsibble::yearmonth(bgcx$gDNADate))) |> group_by(ym) |> add_count(JGIStatus,gDNAMethod) |> mutate(prop=n/sum(n),tot
=sum(n)) |> select(NumberOnly,JGIStatus,gDNADate,Collection,ym,n,prop,tot,gDNAPerson,gDNAMethod,GrowthPerson1,GrowthPerson2) |> ggplot(aes(x=y
m,y=n,group=JGIStatus,fill=JGIStatus)) + geom_col(width=30,na.rm=T)

# benchmark
set.seed(42)
df <- tidyr::expand_grid(
  date = seq_len(10^6) |> lubridate::as_date(),
  item = 1:4,
  shop = LETTERS[1:4]
) |>
  dplyr::mutate(
    sale = (stats::rnorm(n = dplyr::n()) * 100) |>
      abs() |>
      round(0) |>
      as.integer()
  )
res <- bench::mark(
  check = FALSE, # Only duckdb returns dbl, others return int.
  min_iterations = 5,
  dplyr = df |>
    dplyr::group_by(date, item) |>
    dplyr::summarise(sale = sum(sale, na.rm = TRUE), .groups = "drop_last") |>
    dplyr::mutate(total = sum(sale, na.rm = TRUE)) |>
    dplyr::ungroup(),
  dtplyr = df |>
    dtplyr::lazy_dt() |>
    dplyr::group_by(date, item) |>
    dplyr::summarise(sale = sum(sale, na.rm = TRUE), .groups = "drop_last") |>
    dplyr::mutate(total = sum(sale, na.rm = TRUE)) |>
    dplyr::ungroup() |>
    dplyr::collect(),
  duckdb = df |>
    arrow::to_duckdb() |>
    dplyr::group_by(date, item) |>
    dplyr::summarise(sale = sum(sale, na.rm = TRUE), .groups = "drop_last") |>
    dplyr::mutate(total = sum(sale, na.rm = TRUE)) |>
    dplyr::ungroup() |>
    dplyr::collect(),
  `duckdb -> dplyr` = df |>
    arrow::to_duckdb() |>
    dplyr::group_by(date, item) |>
    dplyr::summarise(sale = sum(sale, na.rm = TRUE), .groups = "drop_last") |>
    dplyr::collect() |>
    dplyr::mutate(total = sum(sale, na.rm = TRUE)) |>
    dplyr::ungroup()
)
res |> ggplot2::autoplot("violin")

# json
# see also https://tidyr.tidyverse.org/articles/rectangle.html
library(tidyverse)
library(jsonlite)
# link to the API output as a JSON file
url_json <- "https://site.web.api.espn.com/apis/fitt/v3/sports/football/nfl/qbr?region=us&lang=en&qbrType=seasons&seasontype=2&isqualified=true&sort=schedAdjQBR%3Adesc&season=2019"
raw_json_list <- jsonlite::read_json(url_json)  		# get the raw json into R
category_names <- pluck(raw_json_list, "categories", 1, "labels")  # get names of the QBR categories
athletes <- tibble(athlete = pluck(raw_json_list, "athletes"))  # create tibble out of athlete objects
qbr_hadley <- athletes %>%   unnest_wider(athlete) %>%
  hoist(athlete, "displayName", "teamName", "teamShortName") %>%   unnest_longer(categories) %>%
  hoist(categories, "totals") %>%   mutate(totals = map(totals, as.double),
         totals = map(totals, set_names, category_names)) %>%   unnest_wider(totals) %>%
  hoist(athlete, headshot = list("headshot", "href")) %>%   select(-athlete, -categories)

# outages
> n = read_csv("2022-perlmutter.csv",col_types="fTTf")
> names(n)=c("system","start","end","desc")
> n %>% mutate(hrs=as.numeric(end-start)/3600.0) %>% ggplot_calendar_heatmap('start','hrs') +  xlab(NULL) + ylab(NULL) + scale_fill_continuous(low = 'yellow', high = 'red') + facet_wrap(~Year, ncol = 1) + ggtitle("Perlmutter outages")

# cleveland dotplot dot-line-dot
ggplot(city_gender_rev, aes(Revenue, City)) +geom_line(aes(group = City)) +geom_point(aes(color = Gender))

# correlationfunnel -- https://cran.r-project.org/web/packages/correlationfunnel/vignettes/introducing_correlation_funnel.html
install.packages("correlationfunnel")
library("correlationfunnel)
customer_churn_tbl %>% select(-customerID) %>% mutate(TotalCharges = ifelse(is.na(TotalCharges), MonthlyCharges, TotalCharges)) %>% binarize(n_bins = 5, thresh_infreq = 0.01, name_infreq = "OTHER", one_hot = TRUE) %>% correlate(Churn__Yes) %>% plot_correlation_funnel()

# time deltas
# data from DW query (see qctools::dw_ct())
df = readr::read_csv("_data/Days-delta.csv")
# remove col 'jamo2jat' empty
# remove dat_jt
# remove rows for 'Ribosomal', 'Algal', RnD
# remove rows with days==0
xx = df %>% select(-dt_jat,-jamo2jat)  %>% filter(!grepl('Algal|RnD|Ribo',product))
#x %>% pivot_longer(contains("2"), names_to="delta", values_to="days") %>% filter(days>0)
x = xx %>% pivot_longer(contains("2"), names_to="delta", values_to="days") %>% filter(days>0)
ggplot(x,aes(x=dt_rcv,y=days,color=program)) + theme(axis.text.x=element_text(angle=-90)) + facet_grid(~delta) + geom_violin() + coord_trans(y="log2")
ggsave("")
ggplot(subset(x,days>0),aes(x=dt_rcv,y=days,color=product)) + theme(axis.text.x=element_text(angle=-90)) + facet_grid(~delta) + geom_point(size=0.1, alpha=0.1) +
 coord_trans(y="log2")
ggsave("")
ggplot(subset(x,dt_rcv>2017 & program=="Microbial"),aes(x=dt_rcv,y=days)) + theme(axis.text.x=element_text(angle=-90)) + facet_wrap(vars(delta,program),ncol=5) +
 geom_violin(aes(linecolor=0,fill=product,alpha=0.1),scale="area",show.legend=FALSE,) + coord_trans(y="log2")
ggsave("")
# others
# R> ggplot(subset(x,program=="Microbial" & days>0),aes(x=dt_rcv,y=days,color=product)) + theme(axis.text.x=element_text(angle=-90)) + facet_grid(~delta)  + coor
d_trans(y="log2") + geom_count(alpha=0.2)
# ggplot(subset(x,program=="Microbial" & days>0 & days < 750),aes(x=dt_rcv,y=days,color=product)) + theme(axis.text.x=element_text(angle=-90)) + facet_grid(~delt
a)  + coord_trans(y="log2") + geom_count(alpha=0.4) + scale_fill_viridis_c()

# dealing with 'na'
tidyr::drop_na:  df |> tidyr::drop_na()
na.omit(df)
df[complete.cases(df), ]
df[matrixStats::rowSums2(is.na(df)) < dim(df)[2]*1e-2, ]  ## allow 1% missings per row

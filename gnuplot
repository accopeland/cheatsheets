# description

# install
brew install gnuplot
spack instal gnuplot (82 deps)

# usage
plot "file" using 1:3 w p title "foo"

# transparency
  ColorNames = "white black dark-grey red web-green web-blue dark-magenta dark-cyan dark-orange dark-yellow royalblue goldenrod dark-spring-green purple steelblue dark-red dark-chartreuse orchid aquamarine brown yellow turquoise grey0 grey10 grey20 grey30 grey40 grey50 grey60 grey70 grey grey80 grey90 grey100 light-red light-green light-blue light-magenta light-cyan light-goldenrod light-pink light-turquoise gold green dark-green spring-green forest-green sea-green blue dark-blue midnight-blue navy medium-blue skyblue cyan magenta dark-turquoise dark-pink coral light-coral orange-red salmon dark-salmon khaki dark-khaki dark-goldenrod beige olive orange violet dark-violet plum dark-plum dark-olivegreen orangered4 brown4 sienna4 orchid4 mediumpurple3 slateblue1 yellow4 sienna1 tan1 sandybrown light-salmon pink khaki1 lemonchiffon bisque honeydew slategrey seagreen antiquewhite chartreuse greenyellow gray light-gray light-grey dark-gray slategray gray0 gray10 gray20 gray30 gray40 gray50 gray60 gray70 gray80 gray90 gray100"
  ColorValues = "0xffffff 0x000000 0xa0a0a0 0xff0000 0x00c000 0x0080ff 0xc000ff 0x00eeee 0xc04000 0xc8c800 0x4169e1 0xffc020 0x008040 0xc080ff 0x306080 0x8b0000 0x408000 0xff80ff 0x7fffd4 0xa52a2a 0xffff00 0x40e0d0 0x000000 0x1a1a1a 0x333333 0x4d4d4d 0x666666 0x7f7f7f 0x999999 0xb3b3b3 0xc0c0c0 0xcccccc 0xe5e5e5 0xffffff 0xf03232 0x90ee90 0xadd8e6 0xf055f0 0xe0ffff 0xeedd82 0xffb6c1 0xafeeee 0xffd700 0x00ff00 0x006400 0x00ff7f 0x228b22 0x2e8b57 0x0000ff 0x00008b 0x191970 0x000080 0x0000cd 0x87ceeb 0x00ffff 0xff00ff 0x00ced1 0xff1493 0xff7f50 0xf08080 0xff4500 0xfa8072 0xe9967a 0xf0e68c 0xbdb76b 0xb8860b 0xf5f5dc 0xa08020 0xffa500 0xee82ee 0x9400d3 0xdda0dd 0x905040 0x556b2f 0x801400 0x801414 0x804014 0x804080 0x8060c0 0x8060ff 0x808000 0xff8040 0xffa040 0xffa060 0xffa070 0xffc0c0 0xffff80 0xffffc0 0xcdb79e 0xf0fff0 0xa0b6cd 0xc1ffc1 0xcdc0b0 0x7cff40 0xa0ff20 0xbebebe 0xd3d3d3 0xd3d3d3 0xa0a0a0 0xa0b6cd 0x000000 0x1a1a1a 0x333333 0x4d4d4d 0x666666 0x7f7f7f 0x999999 0xb3b3b3 0xcccccc 0xe5e5e5 0xffffff"
  myColor(c) = (idx=NaN, sum [i=1:words(ColorNames)] \
    (c eq word(ColorNames,i) ? idx=i : idx), word(ColorValues,idx))
  # add transparency (alpha) a=0 to 255 or 0x00 to 0xff
  myTColor(c,a) = sprintf("0x%x%s",a, myColor(c)[3:])

# time
set timefmt "%Y-%m-%d"
set xdata time
plot "$TMPF" u 1:($2!=$3?$2:1/0) t "scaffolds", "" u 1:3 t "contigs", "" u 1:2:($2) smooth csplines t "fit"

# csv
gnuplot> set datafile separator ","
gnuplot> plot 'mgsd.csv' u 0:5 w p

# cumulative distribution
gnuplot> bin(x, s) = s*int(x/s)
gnuplot> set boxwidth 0.1
gnuplot> set xrange [0 : *] noextend
gnuplot> plot 'mgsc.csv' u 5:(1.)  smooth cumulative


# columnheader
set datafile columnheader

# smooth cum norm
gnuplot> set datafile columnheader
gnuplot> plot i=5'' u i:i title columnhead(i) smooth cnorm

# other empirical distribution functions
$ head mgsd.csv
rqc_pipeline_queue_id,rqc_pipeline_type_id,actual_seq_prod_name,scaf_gt50k,scaf_pct_gt50k,scaf_max,contam_filt,singletons,pct_asm,pct_asm_gt10k
1398326,13,Metagenome Standard Draft,386,2.838,485472,23555586,20947801,90.6,34.2
1489812,13,Metagenome Standard Draft,4,0.034,94074,15917804,14800009,84.1,5.5
1398189,13,Metagenome Standard Draft,133,0.689,275875,90873476,81105861,57.9,3.9
1398211,13,Metagenome Standard Draft,135,0.724,336800,90508510,80667313,58.7,3.9
$ gnuplot
gnuplot> set datafile separator ","
gnuplot> plot for [i=4:6] '' u 1:i title columnhead(i) smooth cnorm

# terminals
gunplot> set terminal
gunplot> set terminal sixel
gunplot> set terminal qt # mac

# histograms
gunplot> set style histogram columnstacked
gunplot> plot for [i=3:8] "datafile" using i title columnhead

# parallelaxes
gnuplot> set datafile columnheader
gnuplot> set style data parallelaxes
gnuplot> set datafile columnheader
gnuplot> set datafile separator ","
gnuplot> set border 0
gnuplot> key
gnuplot> xrange [] noextend
gnuplot> ytics
gnuplot> plot "mgsd.csv" u 9 w parallelaxes at 9 t "%asm" , '' u 10 w parallelaxes at 10 t "%asm>10k" , '' u 5 w parallelaxes at 11 t "%gt50k"

# loops
gnuplot> array xpos[7] = [4,5,6,7,8,9,10]
gnuplot> plot for [col=1:7] '' u col w parallelaxes at xpos[col] title columnhead(i)

# alpha linecolor -- add colors by name with transparency (without hex-color code list)
gnuplot> reset session
gnuplot> ColorNames = 'red green blue magenta yellow cyan'   # must be existing gnuplot color names
gnuplot> ColorValues = ''  # get the color values from dummy palettes
gnuplot> RGBComp(c) = int(word($PALETTE[256],c+1)*0xff)
gnuplot> do for [i=1:words(ColorNames)] {
    set palette defined (0 word(ColorNames,i))
    test palette
    RGB = sprintf("0x%02x%02x%02x",RGBComp(1),RGBComp(2),RGBComp(3))
    ColorValues = ColorValues." ".RGB
}
gnuplot> myColor(c) = (idx=NaN, sum [i=1:words(ColorNames)] (c eq word(ColorNames,i) ? idx=i : idx), word(ColorValues,idx))
# add transparency (alpha) a=0 to 255 or 0x00 to 0xff
gnuplot> myTColor(c,a) = sprintf("0x%02x%s",a, myColor(c)[3:])
gnuplot> set xrange[0:2*pi]
gnuplot> set samples 200
gnuplot> plot sin(x)   w l lw 12 lc rgb myTColor("red",0xcc),  sin(2*x) w l lw 12 lc rgb myTColor("green",0xcc), sin(3*x) w l lw 12 lc rgb myTColor("blue",0xcc)

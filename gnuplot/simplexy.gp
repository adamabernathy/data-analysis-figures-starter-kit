#-----------------------------------------------------------------------
# Very, very basic CSV GNUPLOT example.
#
# Some good places to see better examples are at:
# 	GNUPLOT Homepage:
#		http://gnuplot.sourceforge.net/demo/
#
#	And this guy:
#	http://alvinalexander.com/technology/gnuplot-charts-graphs-examples
#-----------------------------------------------------------------------

# Since we are using a CSV file ...
set datafile separator ','
set term x11                            # So we can see it on the screen

set title  'Temperature vs. Height'     # Set the title of the figure
set xlabel 'Temperature [K]'            # Label of the horizontal axis
set ylabel 'Height [m]'                 # Label of the vertical axis

set xrange [10:30]                      # Set x, y range
set yrange [1500:2000]


# For a single x,y plot the following works. Notice the 'using' option
# for getting the columns you want from the text file. GNUPLOT will
# ignore the header lines.
plot '../data/1430258910-example.csv' \
		using 10:7 with lines title 'Temperature'


#
# For printing, we want to also save the image as a PNG file. To do
# this just uncomment the following lines.
#

set terminal png transparent nocrop enhanced size 450,320 font "arial,8"
set output 'simplexy.png'
replot
unset term

# All done!

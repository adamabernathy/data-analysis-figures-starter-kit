#
# Very simple CSV plotting example for Python.
#

# Import the modules
import array
import numpy as np
import matplotlib.pyplot as plt

F      = '../data/1430258910-example.csv'
result = np.genfromtxt(F, delimiter=',')

# Isolate variables you want to use
unixtime  = result[:,1] # Unix time stamp
dat_tempc = result[:,9] # Temperature (C)

# Create time offsets
nprofiles = int(max(unixtime) - min(unixtime))
time_offset = np.arange(nprofiles)
time_scaled = np.arange(len(dat_tempc))


# Draw plot
plt.figure()
plt.plot(time_scaled, dat_tempc,'r-')

x1,x2,y1,y2 = plt.axis()
plt.axis((x1,x2,10,35))
plt.show()

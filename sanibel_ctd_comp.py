## Python code written by Christian Caredio
## The purpose of this code is to import, visualize, and compare temperature and salinity data
## collected in the Sanibel, Florida region using two Seabird 16plus CTDs. The data is collected
## and used by Mote Marine Laboratory's Ocean Technology program.
## Last Updated: 1/3/2022


import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

# We will first increase the amount of columns and rows viewable to make it easier to see the
# data.

pd.options.display.max_rows = 100
pd.options.display.max_columns = 10

# Print the prompt for the user to know what to input for easier understanding. It then 
# reads the inputed file. The sep argument tells pandas the data is separated by spaces that are
# not uniform. We do this because the Seabird CTDs create an ascii file instead of a csv. 
print('Input upstream CTD file') 
upstream = pd.read_csv(input(), sep='\s+')

print('Input downstream CTD file')
downstream = pd.read_csv(input(), sep='\s+')

# The ascii file does not have labels for the columns. The following commands labels the columns.

upstream.columns=['Temperature', 'Conductivity', 'Fluorescence', 'Voltage 1',
	    'Turbidity', 'Salinity', 'Minutes', 'Date', 'Time', 'Span'] 
downstream.columns=['Temperature', 'Conductivity', 'Fluorescence', 'Voltage 1',
	    'Turbidity', 'Salinity', 'Minutes', 'Date', 'Time', 'Span']

# Instead of having the rows being labeled with numbers, we can set the columns to be indexed by
# the date. This allows easy reading of the data and the date the measurement was taken.

upstream = upstream.set_index('Date')
downstream = downstream.set_index('Date')

# This set of commands prints the dataset to be viewed, followed by printing the information
# (index dtype, columns, memory usage, and non-null values) of the data, and then the descriptive
# statistics. This allows for better understanding of the data being analyzed.
print(upstream)
print(upstream.info())
print(upstream.describe())
print(downstream)
print(downstream.info())
print(downstream.describe())

# Create a subplot for the comparison plots

fig, ax = plt.subplots(ncols=2, nrows=1, figsize=(12,8))

# We are using the index set above for the x values in the plots. We are also rotating the x
# labels for easier reading.
upstream.plot.line(use_index=True, y='Temperature', rot=45, ax=ax[0], grid=True,
                   title='Temperature Comparison', ylabel='Temperature (C)')

# This will be plotted on the same plot to create the overlap.
downstream.plot.line(use_index=True, y='Temperature', rot=45, ax=ax[0], grid=True)  

# Since both dataframes have the same labels for the columns, this allows us to set the legend to
# properly distinguish the lines.
ax[0].legend(["Upstream Temp", "Downstream Temp"]) 

upstream.plot.line(use_index=True, y='Salinity', rot=45, ax=ax[1], grid=True,
                   title='Salinity Comparison', ylabel='Salinity (PSU)')

downstream.plot.line(use_index=True, y='Salinity', rot=45, ax=ax[1], grid=True)

ax[1].legend(["Upstream Salinity", "Downstream Salinity"])

# This will make the plot spaced properly and look pretty before showing the plots.
plt.tight_layout()  
plt.show()

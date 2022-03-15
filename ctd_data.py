## Python code written by Christian Caredio
## The purpose of this code was to automate the data analysis and visualization
## process of Mote Ocean Technology's Seabird 16plus CTDs. The data is collected
## and used by Mote Marine Laboratory's Ocean Technology program.
## Last Updated: 11/16/2021

## Import the packages we need.

from seabird.cnv import fCNV
import numpy as np
from matplotlib import pyplot as plt

## Print the prompt for the user to know what to input.
## The fCNV command will convert the cnv file into a NetCDF file.

print('Input file')
data = fCNV(input()) 

## Next, we will print the attributes of the CTD.

print(data.attrs)

## Now we will check the keys of the file.

print(data.keys())

## This prints the raw data; uncomment if you want to see it.

# print(data['tv290C']) 
# print(data['CNDC'])
# print(data['flECO-AFL'])
# print(data['turbWETntu0'])
# print(data['PSAL'])
# print(data['flag'])
# print(data['v1'])

## Time to rename the columns for easier manipulation and understanding.

temp = data['tv290C']
fluoro = data['flECO-AFL']
turbidity = data['turbWETntu0']
salinity = data['PSAL']
time = data['timeM']
days = data['timeJ']

## Create the subplot that will be used to easily compare the data.

fig, axes = plt.subplots(figsize=(12,8), nrows=4)
ax0, ax1, ax2, ax3 = axes

## First plot will be temperature.

ax0.plot(time,temp, color='r') #, marker='.', markerfacecolor='k',
         #markeredgecolor='k')
ax0.set_xlabel('Minutes')
ax0.set_ylabel('Temp (C)')
ax0.grid()
ax0.set_title('Temperature')

## Second plot will be the fluorometer (chlorophyll).

ax1.plot(time, fluoro, color='b') #, marker='.', markerfacecolor='k',
         #markeredgecolor='k')
ax1.set_xlabel('Minutes')
ax1.set_ylabel('Fluorescence (mg/m^3)')
ax1.set_title('Fluorescence')
ax1.grid()

## Third plot will be turbidity.

ax2.plot(time, turbidity, color='g') #, marker='.', markerfacecolor='k',
         #markeredgecolor='k')
ax2.set_xlabel('Minutes')
ax2.set_ylabel('Turbidity (NTU)')
ax2.set_title('Turbidity')
ax2.grid()

## Fourth plot will be salinity.

ax3.plot(time, salinity, color='m') #, marker='.', markerfacecolor='k',
         #markeredgecolor='k')
ax3.set_xlabel('Minutes')
ax3.set_ylabel('Salinity (PSU)')
ax3.set_title('Salinity')
ax3.grid()

## Let's make it a nice and neat layout.

plt.tight_layout()

## Make a separate plot to take a better look at temperature

plot2 = plt.figure(2)
plt.plot(time, temp)
plt.xlabel('Minutes')
plt.ylabel('Temp (C)')
plt.title('Temperature')

## Make a separate plot to take a better look at salinity.

plot3 = plt.figure(3)
plt.plot(time, salinity)
plt.xlabel('Minutes')
plt.ylabel('Salinity (PSU)')
plt.title('Salinity')


plt.show()

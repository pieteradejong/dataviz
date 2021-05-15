from matplotlib import pyplot as plt
import numpy as np
from random import randint

fig, ax = plt.subplots(1,1)
a = np.array([randint(1,100) for _ in range(40)])
ax.hist(a, bins=[0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100], rwidth=0.8)
ax.set_title("Histogram")
ax.set_xticks([0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100])
ax.set_xlabel("numbers")
ax.set_ylabel("frequencies")
plt.show()


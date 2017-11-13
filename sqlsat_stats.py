# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 19:58:19 2017

@author: si01017988
"""

import pandas as pd

sqlsat = pd.read_csv('C:\\DataTK\\pandas\\sqlsat_stats.csv', encoding='latin1', sep=";",index_col='title')

sqlsat

sqlsat.plot(kind="bar")
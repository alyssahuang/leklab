import plotly.plotly as py
import plotly.graph_objs as go
import plotly.figure_factory as FF
import numpy as np
import pandas as pd
#df = pd.read_csv('Exome Metrics.csv', index_col=[0,1], usecols=[0,1,3,4])
#df = pd.read_csv('trial.csv', index_col=[0,1], usecols=[0,1,3,4])
df = pd.read_csv('trial.csv')
sample_data_table = FF.create_table(df.head())
#py.plot(sample_data_table, filename='sample-data-table')
trace1 = go.Bar(
	x=df['Sample'], y=df['NUM_SINGLETONS'],
	name='Singletons',
	hoverinfo='all')
trace2 = go.Scatter(
	x=df['Sample'], y=df['DBSNP_INS_DEL_RATIO'],
	name='Ins/Del Ratio',
	hoverinfo='all',
	yaxis='y2')
layout = go.Layout(title= 'Number of Singletons and Ins/Del Ratio per Individual',
	#plot_bgcolor='rgb(230,230,230)',
	#showlegend=True,
	yaxis=dict(title='Number of Singletons'),
	yaxis2=dict(title='DBSNP Insertion & Deletion Ratio',
		titlefont=dict(color='rgb(148,103,189)'),
			tickfont=dict(color='rgb(148,103,189'),
			overlaying='y',
			side='right')
	
)
fig = go.Figure(data=[trace1, trace2], layout=layout)
py.plot(fig, filename='sample-graph-from-exome-metrics')

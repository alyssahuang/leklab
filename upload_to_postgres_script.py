#!/usr/bin/env python

#Testing Instructions
#in '/seqr/code/seqr/' 
#run 'python manage.py shell' 
#run 'subprocess.call(["/home/ml2529/seqr/code/seqr/xbrowse_server/upload_to_postgres_script.py", "gc_3", "/home/ml2529/seqr/code/seqr/xbrowse_server/temp2.csv"])'

from django.conf import settings
from django.db import connection
from argparse import ArgumentParser

import pandas
import psycopg2
from psycopg2.extensions import AsIs

#Grab datatable name and csv/tsv from command line
parser = ArgumentParser()
parser.add_argument('dt', help='the datatable in postgres to update')
parser.add_argument('fname', help='the csv to upload')
#parser.add_argument('inOrder', default=False, help='if the columns are in the correct order (default False)')
args = parser.parse_args()

#can use to check if all columns there and in order
df = pandas.read_csv(args.fname, header=0)
cHeaders = list(df.columns.values)

#copying csv values into table
cursor = connection.cursor()
cursor.execute("copy %s from %s with (format csv, header)", (AsIs(args.dt), args.fname))
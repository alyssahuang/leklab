#!/usr/bin/env python
#from sqlalchemy import create_engine
import psycopg2
from psycopg2.extensions import AsIs
from django.conf import settings

from django.db import connection
#import csv
from argparse import ArgumentParser
import pandas

#test_connection = psycopg2.connect(dbname="seqrdb", user="postgres")
#test_connection = postgresql+psycopg2://postgres: 
cursor = connection.cursor()

#Grab datatable name and csv/tsv from command line
parser = ArgumentParser()
parser.add_argument('dt', help='the datatable in postgres to update')
parser.add_argument('fname', help='the csv/tsv to upload')
#parser.add_argument('inOrder', default=False, help='if the columns are in the correct order (default False)')
args = parser.parse_args()

#attempt with pandas
###
#look into header
#df = pandas.read_csv(args.fname, header=0)
#cHeaders = list(df.columns.values)
#print(cHeaders)
####
#attempt3
#test_engine = create_engine("postgresql://postgres@localhost/seqrdb")
#with test_engine.connect() as conn, conn.begin():
#        df.to_sql(name=args.dt, con=conn, if_exists='append')

#attempt2
#df.to_sql(name=args.dt, con=test_connection, if_exists='append')

#attempt1
#df.to_sql(name=args.dt, con=connection, if_exists='append')

#cursor method
df = pandas.read_csv(args.fname, header=0)
cHeaders = list(df.columns.values)

cursor.execute("copy %s from %s with (format csv, header)", (AsIs(args.dt), args.fname))

#with open(args.fname) as f:

#       f = csv.reader(f, delimiter='\t')
#       next(f) # skipping the header
#       for line in r:


        #tsv pre-processing (assumes columns in order of postgres datatable rn) (assumes no missing or additional columns yet) 

#       cursor.execute("COPY (%s) ((%s))", (dt,))


from xbrowse_server.api import utils as api_utils
from xbrowse_server.api import forms as api_forms
from xbrowse_server.mall import get_reference, get_datastore, get_mall
from xbrowse_server.search_cache import utils as cache_utils
#from xbrowse_server.decorators import log_request
#from xbrowse_server.server_utils import JSONResponse
import utils
#from xbrowse.variant_search import cohort as cohort_search
#from xbrowse import Variant
#from xbrowse.analysis_modules.mendelian_variant_search import MendelianVariantSearchSpec
#from xbrowse.core import displays as xbrowse_displays
from xbrowse_server import server_utils
from . import basicauth
from xbrowse_server import user_controls
from django.utils import timezone

#from xbrowse_server.phenotips.reporting_utilities import phenotype_entry_metric_for_individual
#from xbrowse_server.base.models import ANALYSIS_STATUS_CHOICES
#import requests
#from django.contrib.admin.views.decorators import staff_member_required
import pymongo

from django.db import connection
import csv
from argparse import ArgumentParser

#Grab datatable name and csv/tsv from command line
parser = ArgumentParser()
parser.add_argument('dt', type=string, help='the datatable in postgres to update')
parser.add_argument('fname', metavar='FILE', help='the csv/tsv to upload')
args = parser.parse_args('inOrder', type=boolean, default=false, help='if the columns are in the correct order? (default false)')

#look into header
df = DataFrame.read_csv(args.fname, header=0)
cHeaders = list(df.columns.values)
df.to_sql(args.dt, connection, if_exists='append')


#Connect to Postgres
#cursor = connection.cursor()

#with open(args.fname) as f:
	
#	f = csv.reader(f, delimiter='\t')
#	next(f) # skipping the header
#	for line in r:


	#tsv pre-processing (assumes columns in order of postgres datatable rn) (assumes no missing or additional columns yet) 

#	cursor.execute("COPY (%s) ((%s))", (dt,))



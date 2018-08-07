# README #

## Google Charts on *seqr* ##
This repo tracks changes to 
* /xbrowse_server/templates/individual_hom.html -> testing purposes
* /xbrowse_server/templates/project/metrics.html -> final(?) location of charts
* /xbrowse_server/api/views.py -> only changes to the function 'alyssa' are tracked
  * each commit pairs versions of (individual_hom.html & views.py) and (metrics.html & views.py) which work together
  * as '.../views.py' only actually contains function 'alyssa' and its wrappers, testing different versions on the local instance of *seqr* only requires copypasta-ing the one function
* python script for adding project metric data to existing postgres datables

Untracked changes were made to 
* /xbrowse_server/staticfiles/css/additional.css -> new css file created for formatting metrics.html
* /xbrowse_server/urls.py
* /xbrowse_server/templates/project.html -> addition of link to metrics.html
Changes within large files can be found by searching 'alyssa' or ah2264.

 


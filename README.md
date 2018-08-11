# README #
View on [Github](https://github.com/alyssahuang/leklab) for readability
## Google Charts on *seqr* ##
This repo tracks changes to 
* [/xbrowse_server/templates/individual_hom.html](https://github.com/alyssahuang/leklab/blob/master/:seqr:code:seqr:xbrowse_server:templates:individual:individual_hom.html)       -> testing purposes
* [/xbrowse_server/templates/project/metrics.html](https://github.com/alyssahuang/leklab/blob/master/metrics.html)      -> final(?) location of charts
* [/xbrowse_server/api/views.py](https://github.com/alyssahuang/leklab/blob/master/:seqr:code:seqr:xbrowse_server:api:views.py)                        -> only changes to the function 'alyssa' are tracked
  * each commit pairs versions of (individual_hom.html & views.py) and (metrics.html & views.py) which work together
  * as '.../views.py' only actually contains function 'alyssa' and its wrappers, testing different versions on the local instance of *seqr* only requires copypasta-ing the one function
* [/xbrowse_server/templates/project.html](https://github.com/alyssahuang/leklab/blob/master/project.html)              -> addition of link to metrics.html (previous versions contain plots on this page)
* [python script](https://github.com/alyssahuang/leklab/blob/master/upload_to_postgres_script.py) for adding project metric data to existing postgres datables


Untracked changes were made to 
* /xbrowse_server/staticfiles/css/additional.css        -> new css file created for formatting metrics.html
* /xbrowse_server/urls.py

In general changes within large files can be found by searching 'alyssa' or ah2264.

## VAMP-seq data visualizations on RStudio ##
Better documentation in progress!
* [pten_in_rstudio.Rmd](https://github.com/alyssahuang/leklab/blob/master/pten_in_rstudio.Rmd)                                   -> File name is misnomer, graphs both PTEN and TPMT data. Created in RStudio. Requires data from [https://www.nature.com/articles/s41588-018-0122-z](https://www.nature.com/articles/s41588-018-0122-z) (Supplementary Datasets 1, 2) and [https://github.com/FowlerLab/VAMPseq](https://github.com/FowlerLab/VAMPseq) (PTEN/TPMT_positional_data.tsv).
* [pten_in_rstudio.nb.html](https://github.com/alyssahuang/leklab/raw/master/pten_in_rstudio.nb.html)
* [pten_tpmt_mean_heat.pdf](https://github.com/alyssahuang/leklab/blob/master/pten_tpmt_mean_heat.pdf)                               -> output pdf generated from Rmd file
* [pten_tpmt_mean_heat_variance.pdf](https://github.com/alyssahuang/leklab/blob/master/pten_tpmt_mean_heat_variance.pdf)                      -> same as above, additional track

## Deployment of Multitracks (Shiny app) ##
[https://huangtya.shinyapps.io/track_attempt2/](https://huangtya.shinyapps.io/track_attempt2/)
To zoom, click and drag over any region.
To get back to default zoom, double click.
To set up new deployment, follow these [notes]


## PyMOL 3D Visualizations ##
PyMOL version 2.2.0, macOS, free student account
[PyMOL download and setup](https://pymol.org/2/) 
[tpmt_colored.pse](https://github.com/alyssahuang/leklab/blob/master/tpmt_colored.pse)                                        -> TPMT colored according to VAMP-seq abundance scores (mean)
[notes](https://github.com/alyssahuang/leklab/blob/master/pymol_notes.txt) on creating custom coloring format

## Questions? ##
alyssahuang@berkeley.edu



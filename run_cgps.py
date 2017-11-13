'''
CGPS pipeline
Copyright (c) 2017, Chen Ai
This code is free software; you can redistribute it and/or modify it
under the terms of the BSD License (see the file COPYING included with
the distribution).
@ version: experimental
@ author: Chen Ai
'''
import sys, os
import subprocess
from optparse import OptionParser
import numpy as np
import pandas as pd

def get_dir():
    srcf = os.environ['HOME']+'/.cgpsrc'
    if not os.path.isfile(srcf):
        sys.exit('please add .cgpsrc under HOME folder\n')
    with open(srcf,'r') as f:
        tmp = f.readline()
    cgps_home = tmp.split('=')[1].strip()
    return cgps_home

cgps_home = get_dir()
scriptdir = cgps_home + '/src/'
sys.path.append(scriptdir)
from CGPSpredict import *

def config_option():
    usage = 'Usage: run_cgps.py -e expfile -p phefile -d datatype -s species -o outdir'
    p = OptionParser(usage)
    p.add_option(
        '-e','--expfile',dest='expfile',action='store',
        help='')
    p.add_option(
        '-p','--phefile',dest='phefile',action='store',
        help='')
    p.add_option(
        '-d','--datatype',dest='datatype',action='store',
        help='')
    p.add_option(
        '-s','--species',dest='spe',action='store',
        help='')
    p.add_option(
        '-o','--outdir',dest='outdir',action='store',
        help='')
    opt, args = p.parse_args()
    return p,opt,args

#################################
##### run individual methods ####
#################################
cgps_home = get_dir()
opt_parser, opt, args = config_option()
if len(sys.argv) == 1:
    opt_parser.print_help()
    sys.exit(1)
cmdline = 'Rscript '+cgps_home+'/src/combined_methods.R '+ ' '.join([cgps_home,opt.expfile, opt.phefile, opt.datatype, opt.spe, opt.outdir])
print "### Running " + cmdline
subprocess.call(cmdline,shell=True)
################################
###### Predict by CGPS #########
################################
print '### R program OK'

gmtf = cgps_home + '/data/kegg.'+opt.spe+'.gmt'
svmfile = cgps_home + '/data/cgps_model.pkl'
outdir = opt.outdir + '/'
run_svm_18dims(outdir,gmtf,outdir,svmfile)


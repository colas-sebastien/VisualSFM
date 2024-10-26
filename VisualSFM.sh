#!/bin/bash

cwd=`pwd`

export LD_LIBRARY_PATH=$cwd/lib64:$LD_LIBRARY_PATH
export PATH=$cwd/bin:$PATH

VisualSFM

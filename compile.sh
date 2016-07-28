#!/bin/bash

# mcc options:
#  -R '-singleCompThread,-nosplash,-nodisplay' : To compile in command-line (non graphical mode).
#  -v        : Verbose
#  -w enable : Enable compilation warnings
#  -m        : Generate a standalone application
#  -N        : Clear the compilation search path of all directories
#               except the following core directories: <matlabroot>/toolbox/matlab, 
#               <matlabroot>/toolbox/local, <matlabroot>/toolbox/compiler 
#  -p        : <directory>  Add <directory> to the compilation search path. This
#               option can only be used in conjunction with the -N option.
#  -I        : Add<path> to the list of paths to search for files.
#  -a        : <filename> Add <filename> to the deployable archive. If the specified
#                file is an m, mex or p file, this function will not be exported in
#                the resulting target. 

FUNCTION_NAME="petseg_main"
\rm ${FUNCTION_NAME} run_${FUNCTION_NAME}.sh
time mcc   -R '-singleCompThread,-nosplash,-nodisplay'\
      -v \
      -w enable \
      -m \
      -N \
      -a . \
      -a /usr/local/MATLAB/R2016a/toolbox/images/images \
      ${FUNCTION_NAME}.m
      

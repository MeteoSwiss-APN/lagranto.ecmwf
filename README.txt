LAGRANTO
========

Lagranto - calculate trajectories for ECMWF analyses and forecasts.

Version for use with ECMWF models.  Sub-version (branch) adapted for operational
use at MeteoSwiss.  Hints for the installation on the MeteoSwiss server at CSCS
see further below.

See LICENCE.pdf for the full text of the licence.

***********************************************************************
* Copyright 2015                                                      *
* Heini Wernli and Michael Sprenger                                   *
*                                                                     *
* This file is part of LAGRANTO.                                      *
*                                                                     *
* LAGRANTO is free software: you can redistribute it and/or modify    *
* it under the terms of the GNU General Public License as published by*
* the Free Software Foundation, either version 3 of the License, or   *
* (at your option) any later version.                                 *
*                                                                     *
* LAGRANTO is distributed in the hope that it will be useful,         *
* but WITHOUT ANY WARRANTY; without even the implied warranty of      *
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the        *
* GNU General Public License for more details.                        *
*                                                                     *
* You should have received a copy of the GNU General Public License   *
* along with LAGRANTO. If not, see http://www.gnu.org/licenses.       *
***********************************************************************


Installation
============

Clone this repository to your account (these instructions are made for the
MeteoSwiss server at CSCS).

Change to the cloned repository:

  cd lagranto.ecmwf

Let the environment variable DYN_TOOLS point to the location, where the cloned
repository is be placed. The script install.csh needs the environment variable
DYN_TOOLS, and additionally LAGRANTO

  export DYN_TOOLS=$(dirname $PWD)
  export LAGRANTO=$PWD

Note: While the location of DYN_TOOLS can be chosen freely, the
      directory name "lagranto.ecmwf" in the environment variable
      LAGRANTO is hardcoded in the script install.csh (see definition
      of path_devel and path_sync in install.csh)

The script "install.csh" has been adapted to the MeteoSwiss needs on the CSCS
servers. Use the follwing install commands to generate the needed executables.
Essential for caltra are only the steps 'lib' and 'caltra'.

  ./install.csh lib
  ./install.csh caltra

This installation is sufficient for operational use.

All other tools are not needed. If you nevertheless want to install them,
the full installation sequence for all tools would be:

  ./install.csh clean    # Some No match/No such file messages might appear
  ./install.csh lib      # Copies relevant ioinp_*.f to ioinp.f prior to compilation
  ./install.csh caltra
  ./install.csh create_startf
  ./install.csh trace
  ./install.csh select   # produces 2 compiler warnings
  ./install.csh density
  ./install.csh lidar    # produces 1 compiler warning
  ./install.csh goodies  # uses adapted tracal.install
  ./install.csh docu
  ./install.csh links

Caution: The "install.csh links" step creates a number of soft links into the
         bin directory. Even though they don't have the .sh ending, they in fact
         point to the wrapper scripts rather than the executables directly!


Documentation
-------------

Lagranto comes with a detailed documentation; you can start it with one of the
following calls:

  bin/lagrantohelp
  bin/lagrantohelp tutorial
  bin/lagrantohelp reference
  bin/lagrantohelp caltra

Note: The documentation refers to the wrapper scripts, not to the executables
      themselves!  In the case of caltra, all option values are stored in the file
      caltra.param by the wrapper script that is then read by the caltra
      executable. At MeteoSwiss, the program latrac is used to produces the
      file caltra.param.

In case you need to see the documentation for caltra without the help
of lagrantohelp, may use the command:

  man caltra $LAGRANTO/docu/man/caltra.0



Test run
--------

Define the environment variable LAGRANTO (as explained above). 

Assuming you have placed the lagranto.ecmwf directory on $SCRATCH):

  export LAGRANTO=$SCRATCH/lagranto.ecmwf

or using the current directory, if this is lagranto.ecmwf:

  export LAGRANTO=$PWD

Create a test directory and change to it.

  mkdir $SCRATCH/lagranto.ecmwf-test
  cd $SCRATCH/lagranto.ecmwf-test

Note: The installation step "install.csh sync" creates a link with the name
      'starf' in the directory lagranto.ecmwf, pointing to the directory
      create_startf. The name of this softlink is unfortunately the same as the
      default name of the file defining the starting positions. Therefore it is
      better to avoid running caltra in the directory lagranto.ecmwf.

a) Use the data from a COSMO-Package run (MeteoSwiss sprecific)

See what runs are available in the temporary directory defined in the LM_TDIR
environment variable.

  grep LM_FISY ~/.lm_env_dispers

In the follwing commands, ... stands for the COSMO-Package temporary directory.

  ls .../lm_lagranto_c_wd_*/caltra_*/caltra.param

  cp .../caltra.param .
  cp .../startf_* .
  cp -d .../P* .

Load necessary modules before running the test (these commands are system-specific):

  module load PrgEnv-gnu
  module load netCDF-Fortran
  ${LAGRANTO}/caltra/caltra

For visualisation, use trajplot (not part of this software). Assuming that the
caltra output file is named tra_geom:

  trajplot --model=ifs --pressure --domain=10,10 tra_geom


For trans-dataline dispersion, you may use Segula as starting point

cat > startf  <<EOF
178.140 52.015 900
178.140 52.015 850
178.140 52.015 700
178.140 52.015 500
EOF

and replace startf_... with startf in the caltra.param file.

Use evince to visualize the PostScript file (<ctrl>-ArrowLeft rotates the display).


b) Use another data source

Create an appropriate startf file. Example (several levels above station BaselBinnigen):

cat > startf  <<EOF
7.58 47.54 900
7.58 47.54 850
7.58 47.54 700
7.58 47.54 500
EOF

Load necessary modules before running the test (these commands are system-specific):

  module load PrgEnv-gnu
  module load netCDF-Fortran

Run caltra using the script. In order for this to work, you need to install the
steps 'goodies' and 'links'. The latter provides the link bin/caltra to
caltra/caltra.sh.  The dates used in the command below are those for the test
data described in the next section.

Usage: caltra(.sh) START-DATE_TIME END-DATE_TIME INPUT-FILE OUTPUT-FILE [ OPTIONS ]

  $LAGRANTO/bin/caltra 20160201_00 20160201_18 startf trajectory.tst -j

or for debugging:

  csh -vx $LAGRANTO/bin/caltra 20160201_00 20160201_18 startf trajectory.tst -j -noclean


Test data provided by the developer of the original software
------------------------------------------------------------

On the FTP server of the IAC at ETH, you find a sample data set which allows you
to run Lagranto without bothering about the Grib-NetCDF conversion.

ftp://iacftp.ethz.ch/pub_read/sprenger/lagranto.ecmwf.test/

Use data in subdirectory cdo of the above source. For the following step, the
local copy of the test data is placed in $SCRATCH/lagranto.ecmwf-test

The reference file in the ftp repository may have many trailing spaces
in the file name 'trajectory    ', rename the file to a more convenient
name, e.g.

  mv trajectory* trajectory.ref


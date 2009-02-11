#!/bin/bash

# Source the 
cd $HOME
source .bash_profile

CTEST_EXE=/usr/local/bin/ctest

echo
echo "Starting nightly Trilinos testing on godel: `date`"
echo

echo
echo "Checking out just the drivers: `date`"
echo

BASEDIR=/home/rabartl/PROJECTS/dashboards/Trilinos

cd $BASEDIR
cvs -q -d :ext:@software.sandia.gov:/space/CVS co -d scripts Trilinos/cmake/ctest

echo
echo "Doing dependency checking-only build: `date`"
echo

time ${CTEST_EXE} -S $BASEDIR/scripts/ctest_linux_nightly_package_deps_godel.cmake -VV

echo
echo "Doing serial performance build: `date`"
echo

time ${CTEST_EXE} -S $BASEDIR/scripts/ctest_linux_nightly_serial_performance_godel.cmake -VV

echo
echo "Doing mpi optimized build: `date`"
echo

time ${CTEST_EXE} -S $BASEDIR/scripts/ctest_linux_nightly_mpi_optimized_godel.cmake -VV

echo
echo "Doing serial debug build: `date`"
echo

time ${CTEST_EXE} -S $BASEDIR/scripts/ctest_linux_nightly_serial_debug_godel.cmake -VV

echo
echo "Doing mpi optimized shared library build: `date`"
echo

time ${CTEST_EXE} -S $BASEDIR/scripts/ctest_linux_nightly_mpi_optimized_shared_godel.cmake -VV

echo
echo "Ending nightly Trilinos testing on godel: `date`"
echo

/home/rabartl/mailmsg.py "Finished nightly Trilinos tests godel: http://trilinos.sandia.gov/cdash/index.php?project=Trilinos"

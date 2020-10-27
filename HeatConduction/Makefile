#^CMP COPYRIGHT UM
#^CMP FILE TESTING

### HEAT CONDUCTION TESTS ###

test: 
	@rm -f output/*.diff
	-@(make test_parcondsemi)
	@ls -l output/*.diff

# Path to this test directory from the main directory
TESTDIR = CCHMTEST/HeatConduction

# Main SWMF directory
SWMFDIR = ../..

# Main GM/BATSRUS directory
DIR = ${SWMFDIR}/GM/BATSRUS

SCRIPTDIR = ${SWMFDIR}/share/Scripts

# All tests are done in this directory:
RUNDIR = run_test

# Tests are done either parallel or serial. Default:
MPIRUN = mpirun -np 16

help:
	@echo "    test                       (run all tests with ${MPIRUN})"
	@echo "    test MPIRUN=               (run all tests serially)"
	@echo "    test MPIRUN='mpirun -np 3' (run test with mpirun -np 3)"
	@echo "    test MPIRUN='mprun -np 2'  (run test with mprun -np 2)"
	@echo "    test_parcondsemi           (run heat conduction test with semi-implicit scheme)"


test_rundir:
	cd ${DIR}; \
		rm -rf ${RUNDIR}; \
		make rundir RUNDIR=${RUNDIR} STANDALONE=YES GMDIR=`pwd`; \
                        DEFAULT_EXE=BATSRUS.exe


### Heat conduction test in 2D with semi-implicit scheme ###

test_parcondsemi:
	@echo "test_parcondsemi_compile..." > output/test_parcondsemi.diff
	make test_parcondsemi_compile
	@echo "test_parcondsemi_rundir..." >> output/test_parcondsemi.diff
	make test_parcondsemi_rundir
	@echo "test_parcondsemi_run..." >> output/test_parcondsemi.diff
	make test_parcondsemi_run
	@echo "test_parcondsemi_check..." >> output/test_parcondsemi.diff
	make test_parcondsemi_check

test_parcondsemi_compile:
	cd ${DIR}; ./Config.pl -u=HeatConduction -e=MhdEosRad -g=10,10,1
	cd ${DIR}; make BATSRUS PIDL

test_parcondsemi_rundir: test_rundir
	cp input/PARAM.in.parcondsemi ${DIR}/${RUNDIR}/PARAM.in

test_parcondsemi_run:
	make test_parcondsemi_run_res RES=40
	make test_parcondsemi_run_res RES=80
	make test_parcondsemi_run_res RES=160
	rm -rf output/test_parcondsemi_results
	mv ${DIR}/${RUNDIR}/RESULTS output/test_parcondsemi_results

test_parcondsemi_run_res:
	cd ${DIR}/${RUNDIR}; \
		perl -pi -e '$$a=${RES}/10; s/\S+(\s*nRootBlockX)/$$a$$1/' PARAM.in;\
		perl -pi -e '$$a=${RES}/10; s/\S+(\s*nRootBlockY)/$$a$$1/' PARAM.in;\
		perl -pi -e '$$a=1.0E-2*(40/${RES})**2; s/\S+(\s*DtFixedDim)/$$a$$1/' PARAM.in
	cd ${DIR}/${RUNDIR}; \
		${MPIRUN} ./BATSRUS.exe > runlog; \
		PostProc.pl -M RESULTS/${RES}

test_parcondsemi_check:
	cd output; idl test_parcondsemi.pro; \
		rm -f test_parcondsemi_results/*.eps
	-(${SCRIPTDIR}/DiffNum.pl \
		output/test_parcondsemi_results/error.dat \
		output/test_parcondsemi.ref \
		> output/test_parcondsemi.diff)
	ls -l output/test_parcondsemi.diff


clean:
	rm -f *~ input/*~ output/*~
	cd output; rm -rf *.diff *_results

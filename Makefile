MPIRUN = mpirun -np 16

help:
	@echo "Examples:"
	@echo "make test                       (run all tests with ${MPIRUN})"
	@echo "make test MPIRUN=               (run all tests serially)"
	@echo "make test MPIRUN='mpirun -np 3' (run test with mpirun -np 3)"
	@echo "make test MPIRUN='mprun -np 2'  (run test with mprun -np 2)"

FILEDIFF = */output/*.diff */*/output/*.diff

test:
	@rm -f test.results ${FILEDIFF}
	-@(cd HeatConduction;                  make test)
	make check

check:
	ls -ltr ${FILEDIFF} >> test_results.txt
	@echo "<PRE>"      >  test_results.html
	ls -l ${FILEDIFF} >> test_results.html
	@echo "</PRE>"     >> test_results.html
	@perl -pi -e 's/(\S+diff)$$/<A HREF=$$1\>$$1<\/A>/' test_results.html

clean:
	-@(cd HeatConduction;                  make clean)

all: install hatch

install: python_install R_install cmd_install

python_install: ./python/sparrow/
	cd ./python; python setup.py install; cd ..

R_install: ./R/
	R CMD INSTALL ./R --no-multiarch --with-keep.source

cmd_install: sparrow
	cp sparrow /usr/local/bin

hatch: nest install
	sparrow hatch --dir ~/Projects/mydir --rport 6311

nest: install
	rm -rf ~/Projects/mydir; sparrow nest --dir ~/Projects/mydir --nest ~/Projects/deployr/data/iris.Rdata

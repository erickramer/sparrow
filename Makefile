all: install hatch

install: .install_py .install_r .install_exe .install_npm .install_pip .install_rserve

.install_py: python/sparrow/*
	cd ./python; python setup.py install; cd ..
	touch $@

.install_r: R/R/* .install_rserve
	R CMD INSTALL ./R --no-multiarch --with-keep.source
	touch $@

.install_exe: sparrow
	printf '#!' >/usr/local/bin/sparrow
	which python >>/usr/local/bin/sparrow
	cat sparrow >>/usr/local/bin/sparrow
	touch $@

.install_npm:
	npm install bower
	touch $@

.install_pip:
	pip install flask
	pip install pyRserve
	touch $@

.install_rserve:
	wget --no-check-certificate https://rforge.net/Rserve/snapshot/Rserve_1.8-5.tar.gz
	R CMD INSTALL Rserve_1.8-5.tar.gz;
	rm Rserve_1.8-5.tar.gz;
	touch $@

hatch: .nest
	sparrow hatch --dir ~/Projects/mydir --rport 6311

.nest: install 
	rm -rf ~/Projects/mydir; sparrow nest --dir ~/Projects/mydir --nest ~/Projects/sparrow/data/iris.Rdata
	touch $@
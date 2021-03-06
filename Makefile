# pysttrafik
# Copyright (C) 2012-2018 Salvo "LtWorf" Tomaselli
#
# pysttrafik is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>

all:
	@echo Nothing to do

.PHONY: install
install:
	#Install py files
	install -d $${DESTDIR:-/}/usr/share/pysttrafik
	install stops.py $${DESTDIR:-/}/usr/share/pysttrafik
	install trip.py $${DESTDIR:-/}/usr/share/pysttrafik
	install -m644 pysttrafik.py $${DESTDIR:-/}/usr/share/pysttrafik
	#Install links
	install -d $${DESTDIR:-/}/usr/bin/
	ln -fs "../share/pysttrafik/stops.py" $${DESTDIR:-/}/usr/bin/stops
	ln -fs "../share/pysttrafik/trip.py" $${DESTDIR:-/}/usr/bin/trip
	#Install conf
	install -m644 -D conf/pysttrafik.conf $${DESTDIR:-/}/etc/pysttrafik.conf
	#Install other files
	install -m644 -D README.md $${DESTDIR:-/}/usr/share/doc/pysttrafik/README.md
	install -m644 -D man/stops.1 $${DESTDIR:-/}/usr/share/man/man1/stops.1
	install -m644 -D man/trip.1 $${DESTDIR:-/}/usr/share/man/man1/trip.1
	install -m644 -D completion/trip $${DESTDIR:-/}/usr/share/bash-completion/completions/trip
	install -m644 -D completion/stops $${DESTDIR:-/}/usr/share/bash-completion/completions/stops

.PHONY: clean
clean:
	$(RM) -r deb-pkg
	$(RM) -r __pycache__
	$(RM) -r *~

.PHONY: dist
dist: clean
	cd ..; tar -czvvf pysttrafik.tar.gz \
		pysttrafik/conf/ \
		pysttrafik/CHANGELOG \
		pysttrafik/COPYING \
		pysttrafik/completion \
		pysttrafik/Makefile \
		pysttrafik/man \
		pysttrafik/pysttrafik.py \
		pysttrafik/README.md \
		pysttrafik/screenshot.png \
		pysttrafik/stops.py \
		pysttrafik/trip.py
	mv ../pysttrafik.tar.gz pysttrafik_`head -1 CHANGELOG`.orig.tar.gz
	gpg --detach-sign -a *.orig.tar.gz

deb-pkg: dist
	mv pysttrafik_`head -1 CHANGELOG`.orig.tar.gz* /tmp
	cd /tmp; tar -xf pysttrafik_*.orig.tar.gz
	cp -r debian /tmp/pysttrafik/
	cd /tmp/pysttrafik/; dpkg-buildpackage
	mkdir deb-pkg
	mv /tmp/pysttrafik_* deb-pkg
	$(RM) -r /tmp/pysttrafik

#!/usr/bin/env python3
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

import sys

from pysttrafik import Vasttrafik, get_key
import trip

key = get_key()
if key == None:
    print("No configuration")
    sys.exit(1)

vast = Vasttrafik(key)

def main():
    preset = sys.argv[1] if len(sys.argv) == 2 else ''
    stop = trip.get_stop('> ', preset)
    try:
        trams = vast.board(stop.id, time_span=120, departures=4)
    except:
        print("Error")
        sys.exit(1)

    print("\n\n\n\n\n\n\n\n\n")
    print("\t\t%s, Time: %s\n" % (stop.name, vast.datetime_obj))
    prev_track = None
    for i in trams:
        if prev_track != i.track:
            print("   == Track %s ==" % i.track)
        prev_track = i.track
        print(i.toTerm(vast.datetime_obj))

if __name__ == '__main__':
    main()

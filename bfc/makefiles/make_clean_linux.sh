#!/bin/bash

cd ../src
rm -f *.ppu *.o
cd ../tests
rm *.s *.o t1 t2 t3 dump.*
cd ../samples
rm *.s *.o hello hello2 quinebf quine1 simplerot13 div10 dump.*
cd ../makefiles

#!/bin/bash

a=10

while [ $a < 10 ]
do
    echo $a
    a=`expr $a + 1`
done

while IPS read -r line
do
    echo $line
done < 17-set.sh
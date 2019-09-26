#!/bin/bash
# calculate the mean average of wall clock time from multiple /usr/bin/time results.
# credits to https://stackoverflow.com/a/8216082/2795592
cat /dev/null > time.log
for i in `seq 1 10`; do
echo "Iteration $i: $@"
/usr/bin/time -p -a -o time.log $@
rm -rf /home/ubuntu/.ansible/cp/*
done
file=time.log
cnt=0
if [ ${#file} -lt 1 ]; then
echo "you must specify a file containing output of /usr/bin/time results"
exit 1
elif [ ${#file} -gt 1 ]; then
samples=(`grep --color=never real ${file} | awk '{print $2}' | cut -dm -f2 | cut -ds -f1`)
for sample in `grep --color=never real ${file} | awk '{print $2}' | cut -dm -f2 | cut -ds -f1`; do
cnt=$(echo ${cnt}+${sample} | bc -l)
done
# Calculate the 'Mean' average (sum / samples).
mean_avg=$(echo ${cnt}/${#samples[@]} | bc -l)
mean_avg=$(echo ${mean_avg} | cut -b1-6)
printf "\tSamples:\t%s \n\tMean Avg:\t%s\n\n" ${#samples[@]} ${mean_avg}
grep --color=never real ${file}
fi


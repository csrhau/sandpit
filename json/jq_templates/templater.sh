#!/bin/sh

FILENAME="rodinia-euler-streamsub.sh"
REPEATS=`jq -r '.repeats' bins.json`
RUNDIR=`jq -r '.directory' bins.json`
SLEEPLEN=1 

cat << PBSHEADER > $FILENAME
#!/bin/bash
#SBATCH -J ${SUITE}-${BIN##*/}-${INPUT##*/}
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --time=00:15:00
#SBATCH --array=1-${REPEATS}
#SBATCH --partition=haswell

module load scorep/sync-2015-07-24-intel-xmpi-cuda6.5
module load hdeem
cd $RUNDIR
export OMP_NUM_THREADS=1


echo Hostname is \$HOSTNAME
cat /proc/meminfo
cat /proc/cpuinfo
PBSHEADER


jq -r '.experiments[] | {binary, input} | join (" ")' bins.json | while read BINARY INPUT; do
cat << RUNTEXT >> $FILENAME
# $BINARY $INPUT
sleep $SLEEPLEN
CSVNAME="Rodinia-Euler-Binary-${BINARY##*/}-Input-${INPUT##*/}-Array-\${SLURM_ARRAY_TASK_ID}-Of-${REPEATS}.csv" 
clearHdeem
startHdeem
./${BINARY} ${INPUT}
stopHdeem
printHdeem -o \$CSVNAME
RUNTEXT
done



echo done

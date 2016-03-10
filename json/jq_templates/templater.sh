#!/bin/sh

FILENAME="rodinia-euler-streamsub.sh"
REPEATS=`jq -r '.repeats' bins.json`
RUNDIR=`jq -r '.directory' bins.json`
SLEEPLEN=1 

cat << PBSHEADER > $FILENAME
#!/bin/bash
#SBATCH -J ${SUITE}-${BIN##*/}-${INPUT##*/}
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --exclusive
#SBATCH --time=00:15:00
#SBATCH --array=1-${REPEATS}
#SBATCH --partition=haswell

module load scorep/sync-2015-07-24-intel-xmpi-cuda6.5
module load hdeem
cd $RUNDIR


echo Hostname is \$HOSTNAME
cat /proc/meminfo
cat /proc/cpuinfo
PBSHEADER

jq -r '.experiments[] | {binary, input} | join (" ")' bins.json | while read BINARY INPUT; do
cat << RUNTEXT >> $FILENAME
# $BINARY $INPUT
sleep $SLEEPLEN
CSVNAME="Bound-Rodinia-Euler-Binary-${BINARY##*/}-Input-${INPUT##*/}-Array-\${SLURM_ARRAY_TASK_ID}-Of-${REPEATS}.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./${BINARY} ${INPUT}
stopHdeem
printHdeem -o \$CSVNAME
RUNTEXT
done

echo done

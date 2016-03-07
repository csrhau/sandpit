#!/bin/sh

jq -r '(.repeats | tostring) as $repeats | .suite as $suite | .directory as $dir | .experiments[] | {$dir, binary, input, $repeats, $suite} | join (" ")' bins.json\
| while read DIR BIN INPUT REPEATS SUITE
do
  FILENAME="${SUITE}-Binary-${BIN##*/}-Input-${INPUT##*/}-Array-${REPEATS}-Submit.sh"
  cat << PBSHERE > $FILENAME
#!/bin/bash
#SBATCH -J ${SUITE}-${BIN##*/}-${INPUT##*/}
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --time=00:15:00
#SBATCH --array=1-${REPEATS}
#SBATCH --partition=haswell

module load scorep/sync-2015-07-24-intel-xmpi-cuda6.5
module load hdeem

cd $DIR
export OMP_NUM_THREADS=1
clearHdeem
startHdeem
./${BIN##*/} ${INPUT}
stopHdeem
printHdeem -o $FILENAME.csv
clearHdeem

PBSHERE
done

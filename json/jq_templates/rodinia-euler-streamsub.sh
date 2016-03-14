#!/bin/bash
#SBATCH -J --
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --exclusive
#SBATCH --time=00:15:00
#SBATCH --array=1-5
#SBATCH --partition=haswell

module load scorep/sync-2015-07-24-intel-xmpi-cuda6.5
module load hdeem
cd ~/Projects/proxy-power/benchmarks/rodinia/src


echo Hostname is $HOSTNAME
cat /proc/meminfo
cat /proc/cpuinfo
# euler3d_cpu_double.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_novectorflux.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_novectorflux.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_novectorflux.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_novectorflux.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_novectorflux.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_novectorflux.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_novectorflux.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_novectorflux.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_novectorflux.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted.b ../input/fvcorr.domn.097K.sorted
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted.b-Input-fvcorr.domn.097K.sorted-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted.b ../input/fvcorr.domn.097K.sorted
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_novectorflux.b ../input/fvcorr.domn.097K.sorted
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_novectorflux.b-Input-fvcorr.domn.097K.sorted-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_novectorflux.b ../input/fvcorr.domn.097K.sorted
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_soa.b ../input/fvcorr.domn.097K.sorted
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_soa.b-Input-fvcorr.domn.097K.sorted-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_soa.b ../input/fvcorr.domn.097K.sorted
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_novectorflux.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_novectorflux.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_novectorflux.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_scratch.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_scratch.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_scratch.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_tiling.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_tiling.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_tiling.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_scratch_novectorflux.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_scratch_novectorflux.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_scratch_novectorflux.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_float_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding.b ../input/fvcorr.domn.097K.sorted
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_float_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding.b-Input-fvcorr.domn.097K.sorted-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_float_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding.b ../input/fvcorr.domn.097K.sorted
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_float_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding_novectorflux.b ../input/fvcorr.domn.097K.sorted
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_float_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding_novectorflux.b-Input-fvcorr.domn.097K.sorted-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_float_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding_novectorflux.b ../input/fvcorr.domn.097K.sorted
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding.b ../input/fvcorr.domn.097K.sorted
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding.b-Input-fvcorr.domn.097K.sorted-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding.b ../input/fvcorr.domn.097K.sorted
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding_flip.b ../input/fvcorr.domn.097K.sorted
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding_flip.b-Input-fvcorr.domn.097K.sorted-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_fusion_neighbourfission_align_sorted_padding_flip.b ../input/fvcorr.domn.097K.sorted
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_prefetch.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_prefetch.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_prefetch.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_float.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_float.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_float.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_float_sqrt.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_float_sqrt.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_float_sqrt.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_float_sse.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_float_sse.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_float_sse.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_float_flip.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_float_flip.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_float_flip.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# pre_euler3d_cpu_float.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-pre_euler3d_cpu_float.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./pre_euler3d_cpu_float.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME
# euler3d_cpu_double_div_swap_reducedcompute_restrict_neighbourfission.b ../input/fvcorr.domn.097K
sleep 1
CSVNAME="Bound-Rodinia-Euler-Binary-euler3d_cpu_double_div_swap_reducedcompute_restrict_neighbourfission.b-Input-fvcorr.domn.097K-Array-${SLURM_ARRAY_TASK_ID}-Of-5.csv" 
clearHdeem
startHdeem
OMP_NUM_THREADS=1 KMP_AFFINITY=compact KMP_PLACE_THREADS=1c,1t,0O srun ./euler3d_cpu_double_div_swap_reducedcompute_restrict_neighbourfission.b ../input/fvcorr.domn.097K
stopHdeem
printHdeem -o $CSVNAME

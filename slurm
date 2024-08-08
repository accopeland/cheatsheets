# description
SLURM

# usage

# config

# To submit a new job:
sbatch job.sh

# To list all jobs for a user:
squeue -u <user>

# julia with one script readable by bash(slurm) and julia; N.B. #=
#!/usr/bin/env sh
#SBATCH -N 10
#SBATCH -n 8
#SBATCH -o %x-%j.out
#=
srun julia $(scontrol show job $SLURM_JOBID | awk -F= '/Command=/{print $2}')
exit
# =#
using SomePackge
do_julia_stuff()

# report env vars
srun -n 1 env | grep SLURM

# debug -- why is my job not running
squeue -j <jobid>
AssocGrpCPUMinutesLimit # This job is waiting for a dependent job to complete.
Cleaning    #The job is being requeued and still cleaning up from its previous execution.
Dependency  #This job is waiting for a dependent job to complete.
JobHeldAdmin # The job is held by a system administrator
JobHeldUser #The job is held by the user
NodeDown    # A node required by the job is down.
Priority    #. Other jobs in the queue have higher priority than yours.
QOSGrpNodeLimit # maximum number of nodes available to the partition are in use.
QOSUsageThreshold #Required QOS threshold has been breached
ReqNodeNotAvail #No nodes can be found satisfying your limits, e.g. because scheduled maintenance and the job can not finish before it
Reservation #job is waiting for its advanced reservation to become available.
Resources #job is waiting for resources (nodes) to become available and will run when Slurm finds enough free nodes.
SystemFailure #Failure of the SLURM system, a file system, the network, etc.

# salloc --no-shell + srun --jobid=<JOBID>
immediately exit after allocating resources, without running a command. However, the Slurm job will still be created and will remain
active and will own the allocated resources as long as it is active. Creates Slurmjob_id with no processes or tasks.
submit srun commands against this resource allocation by specifying --jobid=<JOBID>
Or, this can be used to temporarily reserve a set of resources so that other jobs cannot use them for some period of time.
(Note that the Slurm job is subject to the normal constraints on jobs, including time limits, so that eventually the job will
terminate and the resources will be freed, or you can terminate the job manually using the scancel command.)

#sbatch ~ qsub

#sbatch without script:
sbatch --wrap="echo hello"

# est start time
squeue --sort=S | egrep -i -v 'n/a|null'

# approx place in line
sprio --noheader -o "%.15i %9u %9Y %9y" -S -y,i | awk '{print NR $s}' | grep "<username>"

#options
--accel-bind=n
--begin=now
--exclusive
--export=ALL|NONE
--immediate=10 (sec)
--priority=TOP
--pty
--test-only
--slurm_debug [fatal|error|info|verbose]
--unbuffered
--prefer [ldoms,ib_qdr,sse42,cpu_amd,...]
--cpu-bind=[quiet|verbose|...  cores,threads,ldoms]
--container
--label
-J <name>
-p dori
-A $JGI_ACCTG_GRP
-N <nodes>
--verbose

# salloc
Obtain a Slurm job allocation (a set of nodes), execute a command, and then release the allocation when the command is finished.

# srun
Run a parallel job on cluster managed by Slurm. If necessary, srun will first create a resource allocation in which to run the parallel job.

# srun + opemmpi
> srun —mpi=pmix

# Error: The application appears to have been direct launched using "srun",but OMPI was not built with SLURM support.
# Fix: ???

# pmi
> srun --mpi=list
MPI plugin types are...
        pmix
        pmi2
        none
        cray_shasta
specific pmix plugin versions available: pmix_v4

# pmi1 -- deprecated and not avail on dori
> srun -n 1 --mpi=pmi1 ./test_mpi_main
srun: error: Couldn't find the specified plugin name for mpi/pmi1 looking at all files
srun: error: cannot find mpi plugin for mpi/pmi1
srun: error: MPI: Cannot create context for mpi/pmi1
srun: error: MPI: Unable to load any plugin
srun: error: Invalid MPI type 'pmi1', --mpi=list for acceptable types

# pmi2 -- not on dori
> srun -n 1 --mpi=pmi2 ./test_mpi_main
srun: job 6403277 queued and waiting for resources
srun: job 6403277 has been allocated resources
--------------------------------------------------------------------------
The application appears to have been direct launched using "srun",
but OMPI was not built with SLURM support. This usually happens
when OMPI was not configured --with-slurm and we weren't able
to discover a SLURM installation in the usual places.
Please configure as appropriate and try again.
--------------------------------------------------------------------------
*** An error occurred in MPI_Init
*** on a NULL communicator
*** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
***    and potentially your MPI job)
[n0002.dori0:83675] Local abort before MPI_INIT completed completed successfully, but am not able to aggregate error messages, and not able to guarantee that all other processes were killed!
srun: error: n0002.dori0: task 0: Exited with exit code 1
srun: launch/slurm: _step_signal: Terminating StepId=6403277.0

# srun mpi -- execute simple MPI job.
use srun to build a list of machines (nodes) to be used by mpirun in its required format. A sample command line and the script to be executed follow.
$ cat test.sh
#!/bin/sh
MACHINEFILE="nodes.$SLURM_JOB_ID"
# Generate Machinefile for mpi such that hosts are in the same
#  order as if run via srun
srun -l /bin/hostname | sort -n | awk '{print $2}' > $MACHINEFILE
# Run using generated Machine file:
mpirun -np $SLURM_NTASKS -machinefile $MACHINEFILE mpi-app
rm $MACHINEFILE
$ salloc -N2 -n4 test.sh # -N/--nodes -n/--ntasks
# srun ex
#!/bin/bash
#SBATCH --job-name=mpi_job_test      # Job name
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=email@ufl.edu    # Where to send mail.  Set this to your email address
#SBATCH --ntasks=24                  # Number of MPI tasks (i.e. processes)
#SBATCH --cpus-per-task=1            # Number of cores per MPI task
#SBATCH --nodes=2                    # Maximum number of nodes to be allocated
#SBATCH --ntasks-per-node=12         # Maximum number of tasks on each node
#SBATCH --ntasks-per-socket=6        # Maximum number of tasks on each socket
#SBATCH --distribution=cyclic:cyclic # Distribute tasks cyclically first among nodes and then among sockets within a node
#SBATCH --mem-per-cpu=600mb          # Memory (i.e. RAM) per processor
#SBATCH --time=00:05:00              # Wall time limit (days-hrs:min:sec)
#SBATCH --output=mpi_test_%j.log     # Path to the standard output and error files relative to the working directory
echo "Date              = $(date)"
echo "Hostname          = $(hostname -s)"
echo "Working Directory = $(pwd)"
echo ""
echo "Number of Nodes Allocated      = $SLURM_JOB_NUM_NODES"
echo "Number of Tasks Allocated      = $SLURM_NTASKS"
echo "Number of Cores/Task Allocated = $SLURM_CPUS_PER_TASK"
module load intel/2018.1.163 openmpi/3.0.0
srun --mpi=pmix_v1 /data/training/SLURM/prime/prime_mpi

# srun
https://help.rc.ufl.edu/doc/Sample_SLURM_Scripts#MPI_job
-c, --cpus-per-task=<ncpus>  ## Request ncpus cores per task.
-m, --distribution=arbitrary|<block|cyclic|plane=<options>[:block|cyclic|fcyclic]>  # alternate distrib for remote processes.
  # recommend -m cyclic:cyclic, which tells SLURM to distribute tasks cyclically over nodes and sockets.
-N, --nodes=<minnodes[-maxnodes]>  # Request that a minimum of minnodes nodes be allocated to this job.
-n, --ntasks=<number>  # Number of tasks (MPI ranks)
--ntasks-per-node=<ntasks>  # Request that ntasks be invoked on each node
--ntasks-per-socket=<ntasks>  # Request the maximum ntasks be invoked on each socket
  Notes on socket layout:
  hpg3-compute nodes have 2 sockets, each with 64 cores.
  hpg2-compute nodes have 2 sockets, each with 16 cores.
  hpg1-compute nodes have 4 sockets, each with 16 cores.

# To cancel a job by id or name:
scancel <job-id>
scancel --name <job-name>

# To list all information for a job:
scontrol show jobid -dd <job-id>

# To status info for currently running job:
sstat --format=AveCPU,AvePages,AveRSS,AveVMSize,JobID -j <job-id> --allsteps

# sbatch ~ qsub

# sbatch without script:
sbatch --wrap="echo hello"

# dori socket layout
hwloc::lstopo
Machine (504GB total)
  Package L#0
    NUMANode L#0 (P#0 504GB)
    L3 L#0 (16MB)
      L2 L#0 (512KB) + L1d L#0 (32KB) + L1i L#0 (32KB) + Core L#0 + PU L#0 (P#0)
      L2 L#1 (512KB) + L1d L#1 (32KB) + L1i L#1 (32KB) + Core L#1 + PU L#1 (P#1)
      L2 L#2 (512KB) + L1d L#2 (32KB) + L1i L#2 (32KB) + Core L#2 + PU L#2 (P#2)
      L2 L#3 (512KB) + L1d L#3 (32KB) + L1i L#3 (32KB) + Core L#3 + PU L#3 (P#3)
    L3 L#1 (16MB)
      L2 L#4 (512KB) + L1d L#4 (32KB) + L1i L#4 (32KB) + Core L#4 + PU L#4 (P#4)
      L2 L#5 (512KB) + L1d L#5 (32KB) + L1i L#5 (32KB) + Core L#5 + PU L#5 (P#5)
      L2 L#6 (512KB) + L1d L#6 (32KB) + L1i L#6 (32KB) + Core L#6 + PU L#6 (P#6)
      L2 L#7 (512KB) + L1d L#7 (32KB) + L1i L#7 (32KB) + Core L#7 + PU L#7 (P#7)
    L3 L#2 (16MB)
      L2 L#8 (512KB) + L1d L#8 (32KB) + L1i L#8 (32KB) + Core L#8 + PU L#8 (P#8)
      L2 L#9 (512KB) + L1d L#9 (32KB) + L1i L#9 (32KB) + Core L#9 + PU L#9 (P#9)
      L2 L#10 (512KB) + L1d L#10 (32KB) + L1i L#10 (32KB) + Core L#10 + PU L#10 (P#10)
      L2 L#11 (512KB) + L1d L#11 (32KB) + L1i L#11 (32KB) + Core L#11 + PU L#11 (P#11)
    L3 L#3 (16MB)
      L2 L#12 (512KB) + L1d L#12 (32KB) + L1i L#12 (32KB) + Core L#12 + PU L#12 (P#12)
      L2 L#13 (512KB) + L1d L#13 (32KB) + L1i L#13 (32KB) + Core L#13 + PU L#13 (P#13)
      L2 L#14 (512KB) + L1d L#14 (32KB) + L1i L#14 (32KB) + Core L#14 + PU L#14 (P#14)
      L2 L#15 (512KB) + L1d L#15 (32KB) + L1i L#15 (32KB) + Core L#15 + PU L#15 (P#15)
    L3 L#4 (16MB)
      L2 L#16 (512KB) + L1d L#16 (32KB) + L1i L#16 (32KB) + Core L#16 + PU L#16 (P#16)
      L2 L#17 (512KB) + L1d L#17 (32KB) + L1i L#17 (32KB) + Core L#17 + PU L#17 (P#17)
      L2 L#18 (512KB) + L1d L#18 (32KB) + L1i L#18 (32KB) + Core L#18 + PU L#18 (P#18)
      L2 L#19 (512KB) + L1d L#19 (32KB) + L1i L#19 (32KB) + Core L#19 + PU L#19 (P#19)
    L3 L#5 (16MB)
      L2 L#20 (512KB) + L1d L#20 (32KB) + L1i L#20 (32KB) + Core L#20 + PU L#20 (P#20)
      L2 L#21 (512KB) + L1d L#21 (32KB) + L1i L#21 (32KB) + Core L#21 + PU L#21 (P#21)
      L2 L#22 (512KB) + L1d L#22 (32KB) + L1i L#22 (32KB) + Core L#22 + PU L#22 (P#22)
      L2 L#23 (512KB) + L1d L#23 (32KB) + L1i L#23 (32KB) + Core L#23 + PU L#23 (P#23)
    L3 L#6 (16MB)
      L2 L#24 (512KB) + L1d L#24 (32KB) + L1i L#24 (32KB) + Core L#24 + PU L#24 (P#24)
      L2 L#25 (512KB) + L1d L#25 (32KB) + L1i L#25 (32KB) + Core L#25 + PU L#25 (P#25)
      L2 L#26 (512KB) + L1d L#26 (32KB) + L1i L#26 (32KB) + Core L#26 + PU L#26 (P#26)
      L2 L#27 (512KB) + L1d L#27 (32KB) + L1i L#27 (32KB) + Core L#27 + PU L#27 (P#27)
    L3 L#7 (16MB)
      L2 L#28 (512KB) + L1d L#28 (32KB) + L1i L#28 (32KB) + Core L#28 + PU L#28 (P#28)
      L2 L#29 (512KB) + L1d L#29 (32KB) + L1i L#29 (32KB) + Core L#29 + PU L#29 (P#29)
      L2 L#30 (512KB) + L1d L#30 (32KB) + L1i L#30 (32KB) + Core L#30 + PU L#30 (P#30)
      L2 L#31 (512KB) + L1d L#31 (32KB) + L1i L#31 (32KB) + Core L#31 + PU L#31 (P#31)
   HostBridge
    PCIBridge
      PCI 01:00.0 (InfiniBand)
        Net "ib0"
        OpenFabrics "mlx5_0"
  HostBridge
    PCIBridge
      PCI 41:00.0 (NVMExp)
        Block(Disk) "nvme0n1"
    PCIBridge
      PCI 44:00.0 (SATA)
    PCIBridge
      PCI 45:00.0 (SATA)
  HostBridge
    PCIBridge
      PCI 81:00.0 (Ethernet)
        Net "eth0"
      PCI 81:00.1 (Ethernet)
        Net "eth1"
    PCIBridge
      PCI 85:00.0 (SATA)
    PCIBridge
      PCI 86:00.0 (SATA)
  HostBridge
    PCIBridge
      PCIBridge
        PCI c6:00.0 (VGA)

# spack external slurm
$ cat .spack/packages.yaml
packages:
  slurm:
    externals:
    - spec: slurm@19.05.5
      prefix: /usr
    buildable: false
  pmix:
    externals:
    - spec: pmix@3.1.5
      prefix: /usr/lib/x86_64-linux-gnu/pmix
    buildable: false

# Error: A requested component was not found, or was unable to be opened.
# Fix: missing or can't find 'munge'.
# PMIX_MCA_psec=^munge

# mvapich2 --  build MVAPICH2 to use PMIx and integrated with Slurm
# see mvapich
./configure --prefix=/home/user/bin/mvapich2 \
> --with-slurm=/home/user/slurm/master/inst/ \
> --with-pm=slurm \
> --with-pmix=/home/user/bin/pmix_4.1.2/ \
> --with-pmi=pmix

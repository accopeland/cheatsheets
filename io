# description
Notes and tools for IO testing, benchmarking, and tuning

# disk stress test
stress-ng --fallocate 4 --fallocate-bytes 4g --timeout 1m --metrics --verify --times

# benchmark collection www.vi4io.org
ffsb
patternio
macsio
benchio
bonnie64
iozone
dd
fio
Parabench
postmark
S3aSim
tiobench
https://www.vi4io.org/tools/benchmarks/bonnie

# docker IO slow (2016) https://github.com/moby/moby/issues/21485
	# docker (SLOW)
	root@ubuntu:~# mount /dev/sdb /workspace
	root@ubuntu:~# docker run --rm --net=host --read-only -v "/workspace:/workspace" opensuse bash -c "time dd if=/dev/zero of=/workspace/image.img bs=512 count=1000 oflag=dsync"
	1000+0 records in
	1000+0 records out
	512000 bytes (512 kB) copied, 8.27865 s, 61.8 kB/s
	real    0m8.281s
	user    0m0.008s
	sys     0m0.192s
	# vs
	root@ubuntu:~# time dd if=/dev/zero of=/workspace/image.img bs=512 count=1000 oflag=dsync
	1000+0 records in
	1000+0 records out
	512000 bytes (512 kB) copied, 8.70208 s, 58.8 kB/s
	real    0m8.704s
	user    0m0.008s
	sys     0m0.196s
	root@ubuntu:~# umount /workspace

# docker IO testing - good info here  https://github.com/moby/moby/issues/21485
	https://github.com/opencontainers/runc/issues/861
	https://github.com/moby/moby/pull/24307
	# problem w slow docker IO due to blkio + cgroup
	>echo y | mkfs.ext3 /dev/sdb
	>mount /dev/sdb /workspace
	>dbench -D /workspace -s -S -t 10 5
	#
	docker run --rm --net=none --log-driver=none --read-only -v "/workspace:/workspace" -v "/usr/share/dbench:/usr/share/dbench" -v "/usr/bin/dbench:/usr/bin/dbench" opensuse bash -c "dbench -D /workspace -s -S -t 10 5"
	#
	> echo y | mkfs.ext3 /dev/sdb
	> mount /dev/sdb /workspace
	> dbench -D /workspace -s -S -t 10 5
	Can you run blktrace -d <the device> while the dd is running?

# docker IO issues https://github.com/opencontainers/runc/issues/861
	#https://github.com/moby/moby/pull/24307
	#Switch IO scheduler on the underlying disk to 'deadline'   -  completely lose propotional IO weighting between blkio cgroups and
	#     also some other features of CFQ IO scheduler. But it may work fine.
	echo deadline >/sys/block/<device>/queue/scheduler
	# A less drastic option - turn off CFQ scheduler idling by:
	echo 0 >/sys/block/<device>/queue/iosched/slice_idle
	echo 0 >/sys/block/<device>/queue/iosched/group_idle
	# CFQ IO scheduler will not wait before switching to serving
	# another process / blkio cgroup. So performance will not suffer when using
	# blkio cgroups but "IO hungry" cgroup / process can get disproportionate
	# amount of IO time compared to cgroup that does not have IO always ready.

# macsio
	https://www.vi4io.org/tools/benchmarks/macsio

# IOR cscratch IO testing
	Lustre: /usr/sbin/lctl get_param llite/snx*/stats
	https://sites.google.com/a/lbl.gov/glennklockwood/holistic-i-o-characterization/lustre-counters?authuser=0
	https://www.nersc.gov/users/software/performance-and-debugging-tools/darshan/
/global/cscratch1/sd/darshanlogs/2016/month/day/
	/project/projectdirs/bigdata/nersc_data

# BPF: https://github.com/iovisor/bcc

# pytokio
	https://sites.google.com/a/lbl.gov/glennklockwood/benchmarks-tools/tokio-client-counters?authuser=0
	 curl -L -H "Accept: application/json" 'http://app.pytokio.dev-cattle.stable.spin.nersc.org:8081/hdf5/cscratch/writerates?start=1509793200&end=1509793215'
	# API
	$ curl -L -H "Accept: application/json" 'http://app.pytokio.dev-cattle.stable.spin.nersc.org:8081/hdf5'

# kibana / collectd
	https://kb.nersc.gov/s/syslog/app/kibana#/home?_g=()
	# tunnel from cori login
	 ssh -L 9200:es5-client-pool.service.consul:9200 hatter.nersc.gov -Nf
	 curl -X POST 'http://localhost:9200/cori-collectd-*/_search?pretty=true'
	# or direct: $ curl -X POST 'http://es5-client-pool.service.consul:9200/cori-collectd-*/_search?pretty=true'

# perf for IO monitoring / tracing
	# Trace all block device (disk I/O) requests with stack traces, until Ctrl-C:
	perf record -e block:block_rq_insert -ag!
	# Trace all block device issues and completions (has timestamps), until Ctrl-C:!
	perf record -e block:block_rq_issue -e block:block_rq_complete -a!
	# Trace all block completions, of size at least 100 Kbytes, until Ctrl-C:!
	perf record -e block:block_rq_complete --filter 'nr_sector > 200'!
	# Trace all block completions, synchronous writes only, until Ctrl-C:!
	perf record -e block:block_rq_complete --filter 'rwbs == "WS"'!
	# Trace all block completions, all types of writes, until Ctrl-C:!
	perf record -e block:block_rq_complete --filter 'rwbs ~ "*W*"'!
	# Trace all ext4 calls, and write to a non-ext4 location, until Ctrl-C:!
	perf record -e 'ext4:*' -o /tmp/perf.data -a!

# disk
	bwm-ng
	iostat
	iostat -xmdz 1

# list targets
make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' |sort -u

# list targets if makefile created by cmake
make help

# sync (make > 4.3)
make -j<N> SPACK_COLOR=always --output-sync=recurse

# .PHONY
special targets not associated with files. A phony target is always out-of-date, so make <phony> will always run.
Some common .PHONY are: all, install, clean, distclean, TAGS, info, check.
example:
.PHONY: clean
clean:
  rm -rf *.o

# Define a pattern rule that compiles every .c file into a .o file
# ----
%.o : %.c
		$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

# static pattern rules and filter
  obj_files = foo.result bar.o lose.o
  src_files = foo.raw bar.c lose.c

  all: $(obj_files)
  # Note: PHONY is important here. Without it, implicit rules will try to build the executable "all", since the prereqs are ".o" files.
  .PHONY: all

  # Ex 1: .o files depend on .c files. Though we don't actually make the .o file.
  $(filter %.o,$(obj_files)): %.o: %.c
    echo "target: $@ prereq: $<"

  # Ex 2: .result files depend on .raw files. Though we don't actually make the .result file.
  $(filter %.result,$(obj_files)): %.result: %.raw
    echo "target: $@ prereq: $<"

  %.c %.raw:
    touch $@

  clean:
    rm -f $(src_files)
# ----

# silencing
all:
	@echo "This make line will not be printed"
	echo "But this will"

# Error: missing separator -- https://pastorini.net/blog/make-missing-separator-problem/
# Fix: look for spaces or vars which eval to empty

#  Error:
#

#Your HDF5 install path
HDF5_DIR=/Users/koziol/HDF5/github/hdfgroup/develop/build_parallel_debug/hdf5

CC=mpicc
#CC=gcc-10
AR=ar

DEBUG=-DENABLE_PROVNC_LOGGING -g -O0
INCLUDES=-I$(HDF5_DIR)/include
CFLAGS = $(DEBUG) -fPIC $(INCLUDES) -Wall
#LIBS=-L$(HDF5_DIR)/lib -L$(MPI_DIR)/lib -lhdf5 -lz
LIBS=-L$(HDF5_DIR)/lib -lhdf5 -lz
DYNLDFLAGS = -dynamiclib -current_version 1.0 
LDFLAGS = $(DEBUG) $(LIBS)
ARFLAGS = rs

# Shared library VOL connector
DYNEXT = dylib
DYNSRC = H5VLprovnc.c
DYNOBJ = $(DYNSRC:.c=.o)
DYNLIB = libh5prov.$(DYNEXT)
DYNDBG = libh5prov.$(DYNEXT).dSYM

# Testcase section
EXSRC = vpicio_uni_h5.c
EXOBJ = $(EXSRC:.c=.o)
EXEXE = $(EXSRC:.c=.exe)
EXDBG = $(EXSRC:.c=.exe.dSYM)

all: $(EXEXE) $(DYNLIB)

$(EXEXE): $(EXSRC) $(STATLIB) $(DYNLIB)
	$(CC) $(CFLAGS) $^ -o $(EXEXE) $(LDFLAGS)

$(DYNLIB): $(DYNSRC)
	$(CC) $(CFLAGS) $(DYNLDFLAGS) $(LIBS) $^ -o $@

.PHONY: clean all
clean:
	rm -rf $(DYNOBJ) $(DYNLIB) $(DYNDBG) \
            $(EXOBJ) $(EXEXE) $(EXDBG)

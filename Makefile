#Your HDF5 install path
HDF5_DIR=/home/runzhou/Downloads/myhdfstuff/hdf5-develop/build/hdf5
SERD_DIR=/home/runzhou/Downloads/myhdfstuff/serd

CC=mpicc
# CC=gcc
AR=ar

DEBUG=-DENABLE_PROVNC_LOGGING -g -O0
INCLUDES=-I$(HDF5_DIR)/include -I$(SERD_DIR)/include/serd
CFLAGS = $(DEBUG) -fPIC $(INCLUDES) -Wall
DYNCFLAGS = $(DEBUG) $(INCLUDES) -Wall -fPIC
# DYNCFLAGS2 = $(DEBUG) $(INCLUDES) -Wall

#LIBS=-L$(HDF5_DIR)/lib -L$(MPI_DIR)/lib -lhdf5 -lz
LIBS=-L$(HDF5_DIR)/lib -L$(SERD_DIR)/build -lhdf5 -lz -lserd-0
# DYNLIBS=-L$(HDF5_DIR)/lib -L$(SERD_DIR)/build -lhdf5 -lz -lserd-0
DYNLDFLAGS = $(DEBUG) -shared -fPIC 
# DYNLDFLAGS = $(DEBUG) -dynamiclib -current_version 1.0 -fPIC $(LIBS)
LDFLAGS = $(DEBUG) $(LIBS)
ARFLAGS = rs

# Shared library VOL connector
DYNSRC = H5VLprovnc.c
DYNOBJ = $(DYNSRC:.c=.o)
DYNLIB = libh5prov.so
#DYNLIB = libh5prov.dylib
#DYNDBG = libh5prov.dylib.dSYM

# Testcase section
EXSRC = vpicio_uni_h5.c
EXOBJ = $(EXSRC:.c=.o)
EXEXE = $(EXSRC:.c=.exe)
EXDBG = $(EXSRC:.c=.exe.dSYM)

all: $(EXEXE) $(DYNLIB)
# all: $(DYNLIB)


$(EXEXE): $(EXSRC) $(STATLIB) $(DYNLIB)
		$(CC) $(CFLAGS) $^ -o $(EXEXE) $(LDFLAGS)

$(DYNLIB): $(DYNSRC)
		$(CC) $(DYNCFLAGS) $(DYNSRC) -c -o $(DYNOBJ)
		$(CC) $(DYNOBJ) $(DYNLDFLAGS) $(LIBS) -o $(DYNLIB)

.PHONY: clean all
clean:
		rm -rf $(DYNOBJ) $(DYNLIB) $(DYNDBG) \
			$(EXOBJ) $(EXEXE) $(EXDBG)

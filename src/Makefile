# Makefile
#
ROOTDIR = ../
include $(ROOTDIR)/Rules.make 


SRC  = $(wildcard *.c)
OBJS = $(patsubst %.c,%.o,$(SRC))

CPPSRC  = $(wildcard *.cpp)
OBJS += $(patsubst %.cpp,%.o,$(CPPSRC))

OBJS_OUT_DIR = ../linux_lib/pc/
LINK_OBJS += $(patsubst %.o,$(OBJS_OUT_DIR)%.o,$(OBJS))

TARGET = $(OBJS_OUT_DIR)libua.so 
INCLUDE_DIR = -I../include -I../include/eXosip2  -I../include/liblame  \
-I../include/libmad  -I../include/libresample  -I../include/ortp  \
-I../include/osip2  -I../include/osipparser2 -I../include/portaudio \
-I../include/osipparser2/headers  -I./
LIB_DIR = -L../linux_lib/pc

all:$(TARGET)

%.o:%.c
	$(CPP) $(INCLUDE_DIR)  -shared -fPIC -c $< -o $(OBJS_OUT_DIR)$@ 

%.o:%.cpp
	$(CPP) $(INCLUDE_DIR)   -shared -fPIC -c $< -o $(OBJS_OUT_DIR)$@ 

$(TARGET):$(OBJS)  
	$(LD)  $@ $(LINK_OBJS) #-lpthread  -lrt -leXosip2 -losip2 -losipparser2 -lortp -lportaudio
clean:  
	rm -f $(LINK_OBJS) 



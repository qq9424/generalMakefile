# Makefile
#
#CFLAGS          = -Wall  -O2
ROOTDIR = ../
include $(ROOTDIR)/Rules.make 


SRC  = $(wildcard *.cpp)
OBJS = $(patsubst %.cpp,%.o,$(SRC))
LDFLAGS = -L../../linux_lib/pc  -lpthread  -lrt -leXosip2 -losip2 -losipparser2 -lortp -lportaudio -lua 
#LDFLAGS = ../Release/libresample.a 
INCLUDE_PATH = -I../../include -I../../include/eXosip2  -I../../include/liblame  \
-I../../include/libmad  -I../../include/libresample  -I../../include/ortp  \
-I../../include/osip2  -I../../include/osipparser2 -I../../include/portaudio \
-I../../include/osipparser2/headers  -I../

.PHONY:main

main:$(OBJS)
	$(CPP) -o $@ $(OBJS)  $(LDFLAGS)  

%.o:%.cpp
	$(CPP) $(INCLUDE_PATH)  -c $< -o $@ 


clean:  
	rm -f $(OBJS) 
 




CFLAGS=-Wall -O3

MAKEDEPEND=gcc -M $(CPPFLAGS) -o $*.d $<
COMPILE=gcc -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
LINK=gcc $(LDFLAGS) -o $@

S2A_OBJS= symbols.o logging.o symbol2addr.o
A2S_OBJS= symbols.o logging.o addr2symbol.o

.PHONY: all
all: symbol2addr addr2symbol

symbol2addr: $(S2A_OBJS)
	$(LINK) $(S2A_OBJS)

addr2symbol: $(A2S_OBJS)
	$(LINK) $(A2S_OBJS)

%.o : %.c
	$(COMPILE) -MMD
	@cp $*.d $*.P;
	@sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' -e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P
	@rm -f $*.d
	@mv $*.P $*.d


-include $(S2A_OBJS:.o=.d) 
-include $(A2S_OBJS:.o=.d)
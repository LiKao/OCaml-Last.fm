SOURCES:= lastfm.ml
OC:= ocamlc
OCNATIVE:= ocamlopt
OCFIND:=ocamlfind
PACKAGES:= netclient,xml-light

OC_OPTS:=-annot

DESTDIR:=`ocamlfind printconf destdir`/lastfm

BASE_CMOS:= parse_xml.cmo lastfm_base.cmo
MODULE_CMOS:= album.cmo event.cmo group.cmo library.cmo playlist.cmo tag.cmo user.cmo
MODULE_CMOS:= $(MODULE_CMOS) artist.cmo geo.cmo radio.cmo tasteometer.cmo track.cmo venue.cmo

BASE_CMXS:= parse_xml.cmx lastfm_base.cmx
MODULE_CMXS:= album.cmx event.cmx group.cmx library.cmx playlist.cmx tag.cmx user.cmx
MODULE_CMXS:= $(MODULE_CMXS) artist.cmx geo.cmx radio.cmx tasteometer.cmx track.cmx venue.cmx

OBJECTS:= album.o base.o geo.o parse_xml.o radio.o tasteometer.o user.o artist.o event.o
OBJECTS:= $(OBJECTS) group.o library.o playlist.o tag.o track.o venue.o

CMOS:=$(BASE_CMOS) $(MODULE_CMOS)

CMXS:=$(BASE_CMXS) $(MODULE_CMXS)

TARGETS:= lastfm.cma lastfm.cmxa

LIB_MODULE:=lastfm.cmi

all: $(TARGETS) 

lastfm.cma: lastfm.cmo $(LIB_MODULE) $(CMOS)
	$(OC) -a $(CMOS) lastfm.cmo -o $@
	
lastfm.cmxa: lastfm.cmx $(LIB_MODULE) $(CMXS)
	$(OCNATIVE) -a $(CMXS) lastfm.cmx -o $@	
	
lastfm.cmo: lastfm.ml $(CMOS)
	$(OCFIND) $(OC) $(OC_OPTS) -c -I . -package $(PACKAGES) -linkpkg lastfm.ml

lastfm.cmx: lastfm.ml $(CMXS)
	$(OCFIND) $(OCNATIVE) $(OC_OPTS) $(OBJECTS) -c -I . -package $(PACKAGES) -linkpkg lastfm.ml

test: test.cmo lastfm.cma
	$(OCFIND) $(OC) $(OC_OPTS) -o $@ -I . -package $(PACKAGES) -linkpkg lastfm.cma test.cmo 

%.cmx: %.ml
	$(OCFIND) $(OCNATIVE) $(OC_OPTS) -package $(PACKAGES) -c $<

%.cmo: %.ml
	$(OCFIND) $(OC) $(OC_OPTS) -package $(PACKAGES) -c $<
	
%.cmi: %.mli
	$(OCFIND) $(OC) $(OC_OPTS) -package $(PACKAGES) -c $<
	
%.mli: %.ml
	test -e $@ && touch $@ || true
	test -e $@ || ocamlfind $(OC) $(OC_OPTS) -package $(PACKAGES) -I . -i $< > $@

.PHONY: install	
install:
	$(OCFIND) install lastfm META lastfm.cmi lastfm.mli lastfm.cma lastfm.cmxa lastfm.a

.PHONY: uninstall
uninstall:
	ocamlfind remove lastfm
        
reinstall: uninstall install

.PHONY: doc
doc:
	ocamldoc -html -d doc/ lastfm.mli

clean:
	rm -f *.cmo *.cmi *.cma *.cmx *.cmxa *.o *.a *.annot test 

depend:
	ocamldep *.mli *.ml > .depend

include .depend
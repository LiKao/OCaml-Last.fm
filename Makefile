SOURCES:= lastfm.ml
OC:= ocamlc
OC_BIN:= ocamlopt
PACKAGES:= curl,expat

OC_OPTS:=-annot

DESTDIR:=`ocamlfind printconf destdir`/lastfm

BASE_CMOS:= parse_xml.cmo base.cmo
MODULE_CMOS:= album.cmo event.cmo group.cmo library.cmo playlist.cmo tag.cmo user.cmo
MODULE_CMOS:= $(MODULE_CMOS) artist.cmo geo.cmo radio.cmo tasteometer.cmo track.cmo venue.cmo

CMOS:=$(BASE_CMOS) $(MODULE_CMOS)

TARGETS:= lastfm.cma

LIB_MODULE:=lastfm.cmi

all: $(TARGETS) 

lastfm.cma: lastfm.cmo $(LIB_MODULE)
	$(OC) -a $(CMOS) lastfm.cmo -o $@
	
lastfm.cmo: lastfm.ml $(CMOS)
	ocamlfind $(OC) $(OC_OPTS) -c -I . -package $(PACKAGES) -linkpkg lastfm.ml

test: test.cmo lastfm.cma
	ocamlfind $(OC) $(OC_OPTS) -o $@ -I . -package $(PACKAGES) -linkpkg lastfm.cma test.cmo 

%.cmo: %.ml
	ocamlfind $(OC) $(OC_OPTS) -package $(PACKAGES) -c $<
	
%.cmi: %.mli
	ocamlfind $(OC) $(OC_OPTS) -package $(PACKAGES) -c $<
	
%.mli: %.ml
	test -e $@ && touch $@ || true
	test -e $@ || ocamlfind $(OC) $(OC_OPTS) -package $(PACKAGES) -I . -i $< > $@

.PHONY: install	
install:
	ocamlfind install lastfm META lastfm.cmi lastfm.mli lastfm.cma $$extra

.PHONY: uninstall
uninstall:
	ocamlfind remove lastfm
        
reinstall: uninstall install

.PHONY: doc
doc:
	ocamldoc -html -d doc/ lastfm.mli

clean:
	rm -f *.cmo *.cmi *.cma *.annot test 

depend:
	ocamldep *.mli *.ml > .depend

include .depend
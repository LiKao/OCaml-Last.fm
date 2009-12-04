SOURCES:= lastfm.ml
OC:= ocamlc
OC_BIN:= ocamlopt
PACKAGES:= curl,expat

OC_OPTS:=-annot

BASE_CMOS:= parse_xml.cmo lastfm.cmo
MODULE_CMOS:= album.cmo event.cmo group.cmo library.cmo playlist.cmo tag.cmo user.cmo
MODULE_CMOS:= $(MODULE_CMOS) artist.cmo geo.cmo radio.cmo tasteometer.cmo track.cmo venue.cmo

CMOS:=$(BASE_CMOS) $(MODULE_CMOS)

TARGETS:= lastfm.cma


all: $(TARGETS)

lastfm.cma: $(CMOS)
	$(OC) -a  $(CMOS) -o $@

test: test.cmo lastfm.cma
	ocamlfind $(OC) $(OC_OPTS) -o $@ -I . -package $(PACKAGES) -linkpkg lastfm.cma test.cmo 

%.cmo: %.ml
	ocamlfind $(OC) $(OC_OPTS) -package $(PACKAGES) -c $<
	
%.cmi: %.mli
	ocamlfind $(OC) $(OC_OPTS) -package $(PACKAGES) -c $<
	
%.mli: %.ml
	test -e $@ || ocamlfind $(OC) $(OC_OPTS) -package $(PACKAGES) -I . -i $< > $@

clean:
	rm -f *.cmo *.cmi *.cma *.annot test 

depend:
	ocamldep *.mli *.ml > .depend

include .depend
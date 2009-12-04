SOURCES:= lastfm.ml
OC:= ocamlc
OC_BIN:= ocamlopt
PACKAGES:= curl,expat

OC_OPTS:=-annot

CMOS:=parse_xml.cmo lastfm.cmo 
TARGETS:= lastfm.cma


all: $(TARGETS)

lastfm.cma: $(CMOS)
	$(OC) -a  $(CMOS) -o $@

test: test.cmo lastfm.cma
	ocamlfind $(OC) $(OC_OPTS) -o $@ -I . -package $(PACKAGES) -linkpkg lastfm.cma test.cmo 

%.cmo: %.ml
	ocamlfind $(OC) $(OC_OPTS) -package $(PACKAGES) -c $<

clean:
	rm -f *.cmo *.cmi test

depend:
	ocamldep *.mli *.ml > .depend

include .depend
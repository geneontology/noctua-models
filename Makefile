OBO= http://purl.obolibrary.org/obo
GO=../go/ontology
GOX=$(GO)/extensions

# default catalog
CAT=catalog-v001.xml

# fake catalog that rewires go-lego to null
# NOTE: problematic for OWLAPI, lack of declarations
FAKECAT=fake-catalog.xml

# catalog that rewires go-lego to local cache
MIRROR = mirror-catalog.xml

# catalog that rewires go-lego to extracted minimal module
MODCAT = module-catalog.xml

all: noctua-models.owl noctua-models-merged.owl noctua-models-noimport.owl
test: all
clean:
	rm -rf $(MIRROR)

# travis has issues loading the complete set of ontologies in go-lego (memory, timeout)
# instead we therefore perform a bare-bones OWL syntax check using the OWLAPI on each model.
# we use the fake-catalog which rewires go-lego.owl to an empty file. 
travis-test:
	owltools --catalog-xml fake-catalog.xml models/*.ttl

# ----------------------------------------
# COMBINED MODELS
# ----------------------------------------

TTL = -o -f ttl $(subst .owl,.ttl,$@.ttl)

# - combined models
# - imports preserved
noctua-models.owl: $(MIRROR)
	owltools --catalog-xml $(MIRROR) models/*.ttl --merge-support-ontologies --label-abox --set-ontology-id http://model.geneontology.org/noctua-models.owl -o $@ $(TTL)

# - combined models
# - imports -> module -> merged
noctua-models-merged.owl: noctua-models.owl target/go-lego-module.owl
	owltools --catalog-xml $(MODCAT) $< --merge-imports-closure -o $@ $(TTL)

# - combined models
# - imports: REMOVED
noctua-models-noimport.owl: noctua-models.owl
	owltools --catalog-xml $(FAKECAT) $< --remove-imports-declarations -o $@ $(TTL)

# test: add labels to all abox members
noctua-models-labeled.owl: target/go-lego-module.owl
	owltools --catalog-xml catalog-v001.xml $< --label-abox -o -f ttl $@

noctua-importer.owl:
	./util/make-import.pl models > $@ && catalog-yaml-to-xml.py multimodel-catalog.yaml module-catalog.yaml > multimodel-catalog.xml


# Add abox labels
%-labeled.owl: %.owl
	owltools use-catalog $< --label-abox -o -f ttl $@

# combined models, converted to obographs
# note: why merge first?
noctua-models.json: noctua-models.owl
	minerva-cli.sh --catalog-xml $(FAKECAT) --owl-lego-to-json  -i $< --pretty-json -o $@ 

# combined models, no imports, turtle
# (this is an intermediate target)
target/m.owl-ttl:
	owltools --catalog-xml $(FAKECAT) models/* --merge-support-ontologies --remove-imports-declarations -o -f ttl $@

# as above, roundtripped
target/m.ttl: target/m.owl-ttl
	riot $< > $@

# ----------------------------------------
# MODULES
# ----------------------------------------

# create a complete module
target/go-lego-module.owl: $(MIRROR)
	owltools --catalog-xml $(MIRROR) models/* --merge-support-ontologies --extract-module -c -s $(OBO)/go/extensions/go-lego.owl -o $@


# use owltools slurp-import-chain to mirror all imports
$(MIRROR):
	owltools $(OBO)/go/extensions/go-lego.owl --sic -d . -c $@

# ----------------------------------------
# PER-MODEL FILES
# ----------------------------------------

# direct ttl translation, no imports
#target/%.ttl: models/%
#	owltools --catalog-xml $(FAKECAT) $< --remove-imports-declarations -o -f ttl $@



# a module for an individual model
# (intermediate target, see next step)
target/%-module.owl: models/%.ttl $(MIRROR)
	owltools --catalog-xml $(MIRROR) $< --merge-support-ontologies --extract-module -n $(OBO)/go/noctua/$@ -c -s $(OBO)/go/extensions/go-lego.owl -o $@
.PRECIOUS: target/%-module.owl

# a model merged with its module
target/%-plus-module.owl: models/%.ttl target/%-module.owl
	owltools --catalog-xml $(FAKECAT) $^ --merge-support-ontologies  --remove-imports-declarations --label-abox -o  $@

target/%.json: models/%
	owltools --catalog-xml $(FAKECAT) $< --remove-imports-declarations -o -f json $@

%.obo: %.owl
	owltools --catalog-xml $(FAKECAT) $< --set-ontology-id $(OBO)/test/$@ -o -f obo --no-check $@

%.json: %.owl
	owltools --catalog-xml $(FAKECAT) $<  -o -f json  $@

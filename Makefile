OBO= http://purl.obolibrary.org/obo
GO=../go/ontology
GOX=$(GO)/extensions

# default catalog
CAT=catalog-v001.xml

# fake catalog that rewires go-lego to null
FAKECAT=fake-catalog.xml

# catalog that rewires go-lego to local cache
MIRROR = mirror-catalog.xml

# catalog that rewires go-lego to extracted minimal module
MODCAT = module-catalog.xml

all: noctua-models.owl noctua-models-merged.owl
test: all
clean:
	rm -rf $(MIRROR)

noctua-models.owl: $(MIRROR)
	owltools --catalog-xml $(MIRROR) models/[0-9]* --merge-support-ontologies --set-ontology-id http://model.geneontology.org/noctua-models.owl -o -f ttl $@

noctua-models-merged.owl: noctua-models.owl target/go-lego-module.owl
	owltools --catalog-xml $(MODCAT) $< --merge-imports-closure -o $@


noctua-models-noimport.owl: noctua-models.owl
	owltools --catalog-xml $(FAKECAT) $< --remove-imports-declarations -o $@

noctua-models-labeled.owl: target/go-lego-module.owl
	owltools --catalog-xml catalog-v001.xml $< --label-abox -o -f ttl $@

target/go-lego-module.owl: $(MIRROR)
	owltools --catalog-xml $(MIRROR) models/* --merge-support-ontologies --extract-module -c -s $(OBO)/go/extensions/go-lego.owl -o $@

noctua-models.json: noctua-models.owl
	minerva-cli.sh --catalog-xml $(FAKECAT) --owl-lego-to-json  -i $< --pretty-json -o $@ 


target/m.owl-ttl:
	owltools --catalog-xml $(FAKECAT) models/* --merge-support-ontologies --remove-imports-declarations -o -f ttl $@

target/m.ttl: target/m.owl-ttl
	riot $< > $@

$(MIRROR):
	owltools $(OBO)/go/extensions/go-lego.owl --sic -d . -c $@

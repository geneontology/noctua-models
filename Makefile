OBO= http://purl.obolibrary.org/obo
GO=../go/ontology
GOX=$(GO)/extensions
#CAT=$(GOX)/catalog-v001.xml
CAT=catalog-v001.xml
FAKECAT=fake-catalog.xml
MIRROR = mirror-catalog.xml

all: noctua-models.owl
test: all

noctua-models.owl: $(MIRROR)
	owltools --catalog-xml $(MIRROR) models/* --merge-support-ontologies --set-ontology-id http://model.geneontology.org/noctua-models.owl -o -f ttl $@

noctua-models-labeled.owl: target/go-lego-module.owl
	owltools --catalog-xml catalog-v001.xml $< --label-abox -o -f ttl $@

target/go-lego-module.owl: $(MIRROR)
	owltools --catalog-xml $(MIRROR) models/* --merge-support-ontologies --extract-module -c -s $(OBO)/go/extensions/go-lego.owl -o $@



target/m.owl-ttl:
	owltools --catalog-xml $(FAKECAT) models/* --merge-support-ontologies --remove-imports-declarations -o -f ttl $@

target/m.ttl: target/m.owl-ttl
	riot $< > $@

$(MIRROR):
	owltools $(OBO)/go/extensions/go-lego.owl --sic -d . -c catalog-v001.xml

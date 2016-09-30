[![Build Status](https://travis-ci.org/geneontology/noctua-models.svg?branch=master)](https://travis-ci.org/geneontology/noctua-models)
[![DOI](https://zenodo.org/badge/13996/geneontology/noctua-models.svg)](https://zenodo.org/badge/latestdoi/13996/geneontology/noctua-models)

# noctua-models

This is the data repository for the models created and edited with the Noctua tool stack for GO. See https://github.com/geneontology/noctua
for details on the Noctua tool.

The models are stored as OWL in the [models/](models/) directory.

These models can be consumed computationally using the [OWALPI](https://github.com/owlcs/owlapi/) or debugged within Protege.

## OWL Modeling

The native form of a Noctua model is OWL. A Noctua model consists of *ABox* axioms (ie axioms about individuals) - this is in contrast to a traditional ontology which is *TBox* axioms (ie class axioms). We use the term 'LEGO model' when we are talking about an ABox with members that instantiate GO molecular function classes (ie an activity flow diagram). More generally 'Noctua model' for when we have minimal assumptions about ontologies used.

For the specification, see:

https://github.com/geneontology/minerva/blob/master/specs/owl-model.md

A brief description follows

## General modeling paradigm (informal)

A Noctua model is a collection of individuals, typed using one or more
ontologies, interconnected as a graph of triples using relations from
ontologies such as the [OBO Relations Ontology](https://github.com/oborel/obo-relations).

These are typically compacted in the Noctua display into
"annotons". For example, consider a simple model with a single
"annoton", state that gene product `Shh` has kinase activity whilst
localized to the nucleus:

```
   +-------------------+
   | kinase activity   |
   +-------------------+
   | enabled by(Shh)   |
   | occurs_in(nucleus)|
   +-------------------+
```

The underlying RDF/OWL would look like this:

```
:001 rdf:type PR:Shh
:002 rdf:type MF:kinase-activity
:003 rdf:type CC:nucleus

:002 RO:enabled_by :001
:002 BFO:occurs_in :003
```

Here `:001` would typically be a much longer UUID. Note that we are
modeling specific gene products like 'Shh protein' as classes

See other lego docs for full details on relations. 

## Evidence and provenance

All evidence is stored on a per-axiom basis. We create an axiom annotation, that uses a [RO_0002612](http://purl.obolibrary.org/obo/RO_0002612) AnnotationProperty to connect the axiom to the evidence instance IRI (it's necessary for this to be to the IRI not individual because owls). The evidence instance IRI should be for an individual that instantiates an ECO class. From this, other OPEs hang off - publication, supporting object.

Provenance can be at the level of axiom, individual or ontology. The APs are dc:date and dc:contributor are added automatically so you should see a lot of these on new models.

## Availability

Currently stored here:
https://github.com/geneontology/noctua-models

Any existing set of GO associations can be converted, albeit in a 'degenerate' disconnected form. This can still be useful for the purposes of uniform tooling and programmatic access:

    owltools go.owl --gaf my.gaf --gaf-lego-indivduals -o my-lego.owl
    
See this ticket for more details: https://github.com/owlcollab/owltools/issues/117

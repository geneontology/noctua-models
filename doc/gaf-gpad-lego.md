The GO has historically provided access to annotations in a format
called GAF (Gene Association Format). This format allows detailed
representation of evidence and metadata for a GO term association, but
has historically been limited in how well it can express important
details of the cellular biology being described.

This has lead to a number of incremental improvements, while retaining
compatibility, ultimately leading to the new expressive LEGO
format.

## Basic Annotation Formats: GAF and GPAD

Our current production file formats [are documented here](http://geneontology.org/page/go-annotation-file-formats), we
also provide a brief summary here.

The original format was GAF (retrospectively called GAF-1), a 15
column format for association genes or other entities with GO terms.

Two limitations of this format were:

 * Inability to combine ontology terms for a richer description of the biology
 * Inability to specify if the GO term was specific to a single isoform product of the gene

These limitations were addressed in GAF-2, which introduced two new
columns to handle both of these, the annotation extensions column and the isoform column.

Annotation extensions are described in:

Huntley, R. P., Harris, M. a, Alam-Faruque, Y., Blake, J. a, Carbon, S., Dietze, H., ... Mungall, C. J. (2014). __A method for increasing expressivity of Gene Ontology annotations using a compositional approach.__ *BMC Bioinformatics*, 15(1), 155. [doi:10.1186/1471-2105-15-155](http://dx.doi.org/10.1186/1471-2105-15-155)

We later introduced two new formats, GPAD and GPI. We decided to
create two formats to address two separate concerns:

 * Representing *associations* [GPAD](http://geneontology.org/page/gene-product-association-data-gpad-format)
 * Representing *gene product information* [GPI](http://geneontology.org/page/gene-product-information-gpi-format)

Formally, these formats are more *normalized* than GAF. In a GAF, we
repeat the same information about a gene or product if these are
multiple associations for it. Furthermore, a GAF cannot be used to
communicate information about a gene that has no associations.

GPAD and GPI allowed the provision of explicit relationship types
between a gene/product and a GO term

The relationship between these formats can be seen in the following
diagrams. Each format is represented as a box, where containments
represents that one format subsets another (i.e. everything that can
be represented in the contained format can be represented in the container format):

![GAF-GPAD-figure](https://raw.githubusercontent.com/geneontology/noctua-models/master/doc/gaf-gpad.png)

Ultimately all these formats follow the same basic annotation
paradigm, where gene products are associated with ontology terms. What
this paradigm does not allow us to represent is how gene products
function together to achieve a biological objective, which is where
LEGO comes in.

## Connected Annotations: LEGO

For a quick introduction to LEGO concepts, see the [LEGO jamboreereport](http://geneontology.org/article/connecting-together-multiple-go-annotations-report-lego-jamboree), or the [Notcua](http://noctua.berkeleybop.org/) homepage.

LEGO allows curators to bundle pictures of multiple gene products
acting together into what we call *models*. Models consist of
*annoton*s, which can be seen as a combined molecular function,
biological process and cellular component annotations, each
representing a particular activity of a gene product in the context of
the model. These activities can then be connected together with causal
relationships, allowing for a true picture of how cellular activities
are controlled and executed.

Whereas GPAD represented an incremental improvement on GAF-2, and
GAF-2 represented an incremental improvement on GAF-1, LEGO presents a
different way of thinking about how to use ontologies to describe the
function of genes.

The relationship to other formats can be seen in this subsumption diagram:

![GAF-GPAD-LEGO-figure](https://raw.githubusercontent.com/geneontology/noctua-models/master/doc/gaf-gpad-lego.png)

Anything that can be represented in any of the older GO association
formats can be represented in LEGO. However, the converse is not
true. Note that the GO consortium is committed to continuing to make
annotations available in the older formats. However, translation to
these formats is lossy.

Unlike previous association formats, LEGO will not have a tabular flat
file form. The model is too expressive to be effectively communicated
in a tabular fashion (see qualifying note below).

The native form of LEGO annotations is
[OWL](http://www.w3.org/TR/owl2-primer/). The GO has long used OWL for
representing the ontology, now we will be using it for representing
models of gene product functioning.

Currently the LEGO models being produced by GO are not in production, but a beta preview can be see in [this GitHub repository](https://github.com/geneontology/noctua-models)

When these models go into production we will be making them available
as OWL files using [Turtle Syntax](https://www.w3.org/TR/turtle/). We
are also open to other serializations such as JSON-LD. This is in
addition to (lossy) conversion to existing GO association formats.

If you are the developer of a database or a tool that will consume
LEGO we would love to hear from you. We are particularly interested in
novel applications of this new more expressive format.

You can open a ticket on our [Noctua/LEGO issue tracker](https://github.com/geneontology/noctua/issues),
or you can contact us [via this form](http://geneontology.org/form/contact-go)



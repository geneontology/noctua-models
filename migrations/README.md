### Run a SPARQL Update against the triples in the database

*This should be handled with care since direct changes to triples will bypass any validations that typically occur when data are edited via the standard Minerva server API.*

[SPARQL Update](http://www.w3.org/TR/sparql11-update/) is useful for various bulk maintenance operations that may periodically be necessary, e.g. updating all uses of an obsolete property to the current preferred IRI. Before running the update, the server should be stopped, since the Blazegraph journal can only be used from one Java process at a time. Then simply run the command like this:

```bash
java -Xmx32G -jar minerva-cli.jar --sparql-update -j blazegraph.jnl -f update.rq
```

where `update.rq` is a file containing the SPARQL update. For example:

```sparql
PREFIX directly_activates: <http://purl.obolibrary.org/obo/RO_0002406>
PREFIX directly_positively_regulates: <http://purl.obolibrary.org/obo/RO_0002629>
DELETE { 
    GRAPH ?g { ?s directly_activates: ?o . }
}
INSERT { 
    GRAPH ?g { ?s directly_positively_regulates: ?o . }
}
WHERE {
    GRAPH ?g { ?s directly_activates: ?o . }
} 
```

For easy rollback and error checking it is a good practice to dump the database to OWL files, and make a `git commit`, just before and after running the update:

```bash
java -Xmx32G -jar minerva-cli.jar --dump-owl-models -j blazegraph.jnl -f /path/to/noctua-models/models/
```

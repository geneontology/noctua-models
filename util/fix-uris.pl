#!/usr/bin/perl -np
#
# --
# xenbase OK
# sgd OK
# pombase OK
# RNA cental not in identifiers.org - keep as http://rnacentral.org/rna/?
# uniprot uses identifiers.org - consider uniprot PURL
# TAIR: https://github.com/identifiers-org/registry/issues/5
# --
# OTHERS:
s@http://www.informatics.jax.org/accession/MGI:MGI:@http://identifiers.org/mgi/MGI:@g;
s@http://zfin.org/@http://identifiers.org/zfin/@g;
s@http://rgd.mcw.edu/rgdweb/report/gene/main.html?id=@http://identifiers.org/rgd/@g;
s@http://www.wormbase.org/db/gene/gene?name=@http://identifiers.org/wormbase/@g;
s@http://flybase.org/reports/@http://identifiers.org/flybase/@g;
s@http://dictybase.org/gene/@http://identifiers.org/dictybase.gene/@g;
# TODO
s@http://identifiers.org/TAIR:locus:@http://identifiers.org/tair.locus/@g;

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include "mpchash.h"

MODULE = Algorithm::ConsistentHash::MultiProbeXS PACKAGE = Algorithm::ConsistentHash::MultiProbeXS

TYPEMAP: <<HERE
struct mpchash_t *	O_OBJECT
uint64_t	T_UV

OUTPUT

O_OBJECT
  sv_setref_pv( $arg, CLASS, (void*)$var );

INPUT

O_OBJECT
  if ( sv_isobject($arg) && (SvTYPE(SvRV($arg)) == SVt_PVMG) )
    $var = ($type)SvIV((SV*)SvRV( $arg ));
  else
    croak( \"${Package}::$func_name() -- $var is not a blessed SV reference\" );
HERE


struct mpchash_t *
new(CLASS, AV *node_names, size_t k, uint64_t seed1, uint64_t seed2)
    char *CLASS
  PREINIT:
    char **node_names_str;
    size_t *name_lens;
    size_t num_names;
    SV **svp;
    size_t i;
    size_t total_len = 0;
    STRLEN len;
  CODE:
    /* FIXME the memory management using the mortal stack is quite inefficient. */
    num_names = (size_t)(av_len(node_names)+1);

    name_lens = (size_t *)malloc(sizeof(size_t) * num_names);
    if (!name_lens) croak("Out of memory");

    node_names_str = (char **)malloc(sizeof(char *) * num_names);
    if (!node_names_str) {
      free(name_lens);
      croak("Out of memory");
    }

    for (i = 0; i < num_names; ++i) {
      svp = av_fetch(node_names, i, 0);
      if (!svp)
        croak("Invalid node name supplied at index %i", (IV)i);
      node_names_str[i] = SvPV(*svp, len);
      name_lens[i] = (size_t)len;
    }
    
    RETVAL = mpchash_create((const char **)node_names_str, name_lens, num_names, k, seed1, seed2);

    free(name_lens);
    free(node_names_str);

    if (RETVAL == NULL)
      croak("Unknown error");
  OUTPUT: RETVAL


void
DESTROY(self)
    struct mpchash_t *self
  CODE:
    mpchash_free(self);

SV *
lookup(self, key)
    struct mpchash_t *self
    SV *key;
  PREINIT:
    const char *out_str;
    size_t out_str_len;
    const char *key_str;
    STRLEN key_len;
  CODE:
    key_str = SvPVbyte(key, key_len);
    mpchash_lookup(self, key_str, key_len, &out_str, &out_str_len);
    RETVAL = newSVpvn(out_str, out_str_len);
  OUTPUT: RETVAL


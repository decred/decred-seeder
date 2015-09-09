#ifndef __BLAKE256_H_
#define __BLAKE256_H_ 1

#include "blake.h"

void blake256_init(state256 *);
void blake256_update(state256 *, const uint8_t *, uint64_t);
void blake256_final(state256 *, uint8_t *);

#endif

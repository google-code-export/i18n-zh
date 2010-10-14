#define DECNUMDIGITS 63
#include "decNumber.h"          // decNumber library

#include <stdio.h>              // for printf
#include <stdlib.h>             // for strtod

int testNumber()
{
    int i;
    decNumber a, b;
    decContext set;
    char string[72];

    decContextDefault(&set, DEC_INIT_BASE); // initialize
    set.digits = DECNUMDIGITS;
    set.emax = DEC_MAX_MATH;
    set.emin = -DEC_MAX_MATH;

    decNumberFromString(&a, "0.13", &set);
    decNumberFromString(&b, "7.7", &set);

    for (i = 0; i < 10; i++)
        decNumberAdd(&b, &a, &b, &set);    // b += a;

    decNumberToString(&b, string);

    printf("decNumber: 7.7 + 0.13 * 10 => %s\n", string);

    decNumberLog10(&a, &b, &set);
    decNumberToString(&a, string);
    printf("decNumber: Log10 => %s\n", string);

    decNumberPower(&a, &a, &b, &set);
    decNumberToString(&a, string);
    printf("decNumber: Power => %s\n", string);

    return 0;
}

int main(int argc, char *argv[]) {

    decContextTestEndian(0);    // warn if DECLITEND is wrong

    fprintf(stdout, "DECNUMDIGITS: %d\n", (int) DECNUMDIGITS);
    fprintf(stdout, "DECNUMUNITS: %d\n", (int) DECNUMUNITS);
    fprintf(stdout, "DECDPUN: %d\n", (int) DECDPUN);

    testNumber();

    return 0;
}
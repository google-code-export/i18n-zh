#include "decDouble.h"          // decDouble library
#include "decQuad.h"            // decQuad library
#include <stdio.h>              // for printf
#include <stdlib.h>             // for strtod

int testFloat()
{
    int i;
    float a, b;

    a = strtod("0.13", NULL);
    b = strtod("8.7", NULL);

    for (i = 0; i < 10; i++)
        b += a * 10;

    printf("bin032: 8.7 + 0.13 * 10 => %.8f\n", b);
    return 0;
}

int testDouble()
{
    int i;
    double a, b;

    a = strtod("0.13", NULL);
    b = strtod("8.7", NULL);

    for (i = 0; i < 10; i++)
        b += a;

    printf("bin064: 8.7 + 0.13 * 10 => %.16lf\n", b);
    return 0;
}

int testDecDouble()
{
    int i;
    decDouble a, b;
    decContext set;
    char string[DECDOUBLE_String];

    decContextDefault(&set, DEC_INIT_DECDOUBLE); // initialize

    decDoubleFromString(&a, "0.13", &set);
    decDoubleFromString(&b, "8.7", &set);

    for (i = 0; i < 10; i++)
        decDoubleAdd(&b, &a, &b, &set);    // b += a;

    decDoubleToString(&b, string);

    printf("dec064: 8.7 + 0.13 * 10 => %s\n", string);
    return 0;
}

int testDecQuad()
{
    int i;
    decQuad a, b;
    decContext set;
    char string[DECQUAD_String];

    decContextDefault(&set, DEC_INIT_DECQUAD); // initialize

    decQuadFromString(&a, "0.13", &set);
    decQuadFromString(&b, "8.7", &set);

    for (i = 0; i < 10; i++)
        decQuadAdd(&b, &a, &b, &set);    // b += a;

    decQuadToString(&b, string);

    printf("dec128: 8.7 + 0.13 * 10 => %s\n", string);
    return 0;
}

int main(int argc, char *argv[]) {

    decContextTestEndian(0);    // warn if DECLITEND is wrong

    testFloat();
    testDouble();
    testDecDouble();
    testDecQuad();

    return 0;
}
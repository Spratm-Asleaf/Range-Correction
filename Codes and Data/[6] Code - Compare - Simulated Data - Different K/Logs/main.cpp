#include <cstdio>

double Dist[4] = {0.0};

void GetDist(FILE* infile, FILE* outfile)
{
    int id;
    if (! feof(infile))
    {
        fscanf(infile, "tid:%d Seq:%d %lf\t%lf\t%lf\t%lf\t", &id, &id, Dist, Dist+1, Dist+2, Dist+3);
    }

    fprintf(outfile, "%lf\t%lf\t%lf\t%lf\n", *Dist, *(Dist+1), *(Dist+2), *(Dist+3));
}

int main(int argc, char *argv[])
{
    FILE* infile = fopen(argv[1],"r");
    FILE* outfile = fopen(argv[2],"w");

    while(! feof(infile))
    {
        GetDist(infile, outfile);
    }

    return 0;
}

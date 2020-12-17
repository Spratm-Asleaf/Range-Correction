#include <stdio.h>

int main()
{
    FILE* infile = fopen("V2-2Tag Range 21-18-56.log","r");
    FILE* outfile = fopen("wsx.txt","w");
    double Dist[4];
    double Pos[2];
    int i = 0;
    int id;

    while(!feof(infile))
    {
        printf("%d\n",++i);
        fscanf(infile, " mc Seq:%d, %lf %lf %lf %lf ", &id, Dist, Dist+1, Dist+2, Dist+3);
        fprintf(outfile, "%lf\t%lf\t%lf\t%lf\n", Dist[0], Dist[1], Dist[2], Dist[3]);
    }

    return 0;
}

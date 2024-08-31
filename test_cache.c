#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define CACHE_LINES 100
#define CACHE_LINE_SIZE 8
extern void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
int main()
{
  FILE* f=fopen("nu_test_cache","w");
  unsigned long memory0_start = 4;
  char memory0[16 * 16 + 8];
  char reg;
  int i,j;
  FILE* infile = fopen("input/cacheA_in", "r");
  if(infile==NULL)
  return 0;
    for (j = memory0_start; j < 16 * 16 + memory0_start; j++)
    {
        fscanf(infile, "%hhu", &(memory0[j]));
    }

  char **tags = malloc(CACHE_LINES * sizeof(char *));
    for (i = 0; i < CACHE_LINES; i++)
        tags[i] = 0;

    // Initialize empty cache
    char cache[CACHE_LINES][CACHE_LINE_SIZE];
    for (i = 0; i < CACHE_LINES; i++)
    {
        for (j = 0; j < CACHE_LINE_SIZE; j++)
        {
            cache[i][j] = 0;
        }
    } 
    char* address;
    address = (char *)(memory0 + memory0_start + 16 * 0 + 1);
     load(&reg, tags, cache, address,7);
    fprintf(f, "%hhu\n", reg);
     for (j = 0; j < CACHE_LINE_SIZE; j++)
        {
            fprintf(f, "%hhu", cache[7][j]);
            if (j < CACHE_LINE_SIZE - 1)
                fprintf(f, " ");
        }
   free(tags);
   fprintf(f, "\n");
   fclose(f);
  // printf("%p",address);
return 0;
}
    
 

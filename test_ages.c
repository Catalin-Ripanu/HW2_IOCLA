#include <stdio.h>
#include <stdlib.h>
struct my_struct{
    short day;
    short month;
    int year;
} __attribute__((packed));
extern void ages(int len, struct my_struct* present, struct my_struct* dates, int* all_ages);
int main()
{
  struct my_struct present;
  present.day=15;
  present.month=3;
  present.year=2021;
  struct my_struct *dates = malloc(30 * sizeof(struct my_struct));
  dates[0].day=18;
  dates[0].month=3;
  dates[0].year=2008;
  dates[1].day=20;
  dates[1].month=3;
  dates[1].year=2006;
  dates[2].day=15;
  dates[2].month=3;
  dates[2].year=2012;
  dates[3].day=29;
  dates[3].month=3;
  dates[3].year=2021;
  int *all_ages = malloc(30 * sizeof(int));
  int len=4;
  ages(len, &present, dates, all_ages);
        free(dates);
 for(int i=0;i<len;i++)
 printf("%d\n",all_ages[i]);
 free(all_ages);
 return 0;
}



#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int len_haystack;
int len_cheie;
extern void columnar_transposition(int key[], char *haystack, char *ciphertext);
int main()
{
  FILE* f=fopen("nu_test","wb");
  char* plaintext, *ciphertext;
  int *key;
//  int len_haystack,len_cheie;
  len_haystack=27;
  len_cheie=5;
        plaintext = calloc(len_haystack+1, sizeof(*plaintext));
        key = calloc(len_cheie+1, sizeof(*key));
        ciphertext = calloc(len_haystack, sizeof(*ciphertext));
  strcpy(plaintext,"Nu te intreba nimeni nimic!");
 key[0]=0;
 key[1]=2;
 key[2]=4;
 key[3]=1;
 key[4]=3;
 // strcpy(key,"Nimeni nu te-ntreba.");
  columnar_transposition(key,plaintext,ciphertext);
// printf("%s",ciphertext);
// for(int i=0;i<len;i++)
// ciphertext[i]=plaintext[i]^key[len-i-1];
 fwrite(ciphertext, sizeof(char), len_haystack, f);
 free(ciphertext);
 free(plaintext);
 free(key);
 fclose(f);
 return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern void rotp(char *ciphertext, char *plaintext, char *key, int len);
int main()
{
  FILE* f=fopen("nu_test","wb");
  char* plaintext, *key, *ciphertext;
  int len;
  len=20;
        plaintext = calloc(len+1, sizeof(*plaintext));
        key = calloc(len+1, sizeof(*key));
        ciphertext = calloc(len, sizeof(*ciphertext));
  strcpy(plaintext,"Dar cine te intreba?");
  strcpy(key,"Nimeni nu te-ntreba.");
  rotp(ciphertext,plaintext,key,len);
// printf("%s",ciphertext);
// for(int i=0;i<len;i++)
// ciphertext[i]=plaintext[i]^key[len-i-1];
 fwrite(ciphertext, sizeof(char), len, f);
 free(ciphertext);
 free(plaintext);
 free(key);
 fclose(f);
 return 0;
}

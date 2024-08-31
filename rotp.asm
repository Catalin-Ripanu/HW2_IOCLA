        section .text
        global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
;; DO NOT MODIFY
        push ebp
        mov ebp, esp
        pusha

        mov edx, [ebp + 8]             ; ciphertext
        mov esi, [ebp + 12]            ; plaintext
        mov edi, [ebp + 16]            ; key
        mov ecx, [ebp + 20]            ; len
;; DO NOT MODIFY

;; TODO:
       ;; Implment rotp
;; FREESTYLE STARTS HERE
        ;; Initializarea registrelor cu valoarea 0
        xor eax, eax
        xor ebx, ebx
;; Bucla pentru a construi sirul
create_string:
        ;; Se obtine primul caracter din sirul ce se afla la adresa 'plaintext'
        ;; Aceasta adresa se afla in registrul esi
        mov bl, [esi]
        ;; Se efectueaza operatia XOR intre subregistrul bl si continutul de la adresa edi+ecx-1
        ;; ecx reprezinta lungimea sirurilor
        ;; valoarea lui ecx scade intrucat se foloseste instructiunea 'loop'
        xor bl, [edi+ecx-1]
        ;; Se incrementeaza adresa pentru a obtine caracterul urmator
        inc esi
        ;; Se pune caracterul final la adresa edx+eax
        mov [edx+eax], bl
        ;; Se incrementeaza eax pentru a introduce urmatoarele caractere
        inc eax
        ;; Se continua construirea sirului de la adresa 'ciphertext'
        loop create_string
;; FREESTYLE ENDS HERE
;; DO NOT MODIFY
        popa
        leave
        ret
;; DO NOT MODIFY

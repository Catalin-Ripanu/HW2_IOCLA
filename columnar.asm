        section .data
        extern len_cheie, len_haystack
;; Variabile ajutatoare
aux_len:
        dd 0
aux_helper:
        dd 0
copy_len_key:
        dd 0
contor:
        dd 0

        section .text
        global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
;; DO NOT MODIFY
        push ebp
        mov ebp, esp
        pusha

        mov edi, [ebp + 8]             ; key
        mov esi, [ebp + 12]            ; haystack
        mov ebx, [ebp + 16]            ; ciphertext
;; DO NOT MODIFY
;; TODO:
       ;; Implment columnar_transposition
;; FREESTYLE STARTS HERE
        ;; Initializarea variabilelor cu valoarea 0
        mov dword [aux_helper], 0
        mov dword [contor], 0
        mov eax, [len_cheie]
        mov [copy_len_key], eax
        ;; Initializarea registrelor cu valoarea 0
        xor edx, edx
        xor eax, eax
        xor ecx, ecx
        mov eax, [len_haystack]
        div dword [len_cheie]
        ;; Se verifica restul impartirii pentru a calcula numarul de linii
        test edx, edx
        je define_row_column_1
        jmp define_row_column_2

define_row_column_1:
        ;; Se retine in aux_len numarul de linii
        mov [aux_len], eax
        xor eax, eax
        xor edx, edx
        ;; Se formeaza sirul 
        jmp create_ciphertext

define_row_column_2:
        inc eax
        ;; Se retine in aux_len numarul de linii
        mov [aux_len], eax
        xor eax, eax
        xor edx, edx

create_ciphertext:
        ;; Se parcurge vectorul de ordine
        cmp dword [len_cheie], 0
        je end
        ;; Se retine elementul din vector in ecx
        mov ecx, [edi]
        add edi, 4
        ;; Decrementare
        dec dword [len_cheie]

;;Bucla pentru a construi sirul
create_ciphertext_1:
        ;; Se formeaza un indice/index special pentru a parcurge sirul de la adresa 'haystack'
        mov eax, edx
        mul dword [copy_len_key]
        add eax, ecx
        ;; Daca se depaseste lungimea (pentru a evita invalid read of size 1 ->Valgrind)
        cmp eax, [len_haystack]
        jge jump_continue
        ;; Se obtine caracterul de la adresa 'haystack'
        mov al, byte [esi+eax]
        mov edx, [contor]
        ;; Se adauga caracterul la adresa 'ciphertext'
        mov [ebx+edx], al
        ;; Se incrementeaza contorul
        inc dword [contor]
jump_continue:
        ;; Se recupereaza valoarea pierduta 
        mov edx, [aux_helper]
        inc edx
        ;; Se salveaza valoarea lui edx in aux_helper
        mov [aux_helper], edx
        ;; Se repeta pana la depasirea numarului de linii
        cmp edx, [aux_len]
        jl create_ciphertext_1
        xor edx, edx
        mov dword [aux_helper], 0
        ;; Se trece la urmatoarea coloana
        ;; Se trece la urmatorul element din vectorul de ordine
        jmp create_ciphertext
end:

;; FREESTYLE ENDS HERE
;; DO NOT MODIFY
        popa
        leave
        ret
;; DO NOT MODIFY

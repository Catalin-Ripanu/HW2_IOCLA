;; defining constants, you can use these as immediate values in your code
        CACHE_LINES EQU 100
        CACHE_LINE_SIZE EQU 8
        OFFSET_BITS EQU 3
        TAG_BITS EQU 29                ; 32 - OFSSET_BITS

        section .data
;; Variabile ajutatoare
aux_reg:
        dd 0
aux_address:
        dd 0
aux_to_replace:
        dd 0
aux_offset:
        dd 0
contor:
        dd 1
aux_helper_offset:
        dd 0
aux_helper:
        dd 0

        section .text
        global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
;; DO NOT MODIFY
        push ebp
        mov ebp, esp
        pusha

        mov eax, [ebp + 8]             ; address of reg
        mov ebx, [ebp + 12]            ; tags
        mov ecx, [ebp + 16]            ; cache
        mov edx, [ebp + 20]            ; address
        mov edi, [ebp + 24]            ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
;; DO NOT MODIFY
;; TODO:
       ;; Implment load
;; FREESTYLE STARTS HERE
        ;; Initializarea variabilelor
        mov dword [contor], 1
        mov dword [aux_helper_offset], 0
        mov [aux_reg], eax
        mov [aux_to_replace], edi
        ;; Initializarea registrelor cu valoarea 0
        xor eax, eax
        xor edi, edi
        xor esi, esi
;; Bucla pentru a calcula offset-ul
calculate_tag_offset:
        ;; Se calculeaza tag-ul si offset-ul
        mov dword [aux_offset], 1
        ;; aux_offset retine cel mai nesemnificativ bit
        and [aux_offset], edx
        ;; Se formeaza tag-ul cu ajutorul operatiei shr
        ;; Se executa shr de 3 ori
        shr edx, 1
        ;; Daca bitul este 1
        cmp dword [aux_offset], 1
        je calculate_1
        shl dword [contor], 1
continue_calc:
        ;; Incrementare
        inc edi
        cmp edi, OFFSET_BITS
        jl calculate_tag_offset
        jmp exit
calculate_1:
        ;; Se retine valoarea in eax pentru a folosi mul
        mov eax, [aux_offset]
        ;; Se salveaza in aux_address adresa
        mov [aux_address], edx
        mul dword [contor]
        ;; Se recupereaza adresa
        mov edx, [aux_address]
        ;; aux_helper_offset retine offset-ul calculat
        add [aux_helper_offset], eax
        ;; Se inmulteste variabila contor cu 2
        shl dword [contor], 1
        jmp continue_calc

exit:
        ;; Se salveaza tag-ul in aux_address
        mov [aux_address], edx
        xor eax, eax
        xor edi, edi
        xor edx, edx
        mov dword [contor], 0
        ;; Se retine tag-ul in eax
        mov eax, [aux_address]
search_tag:
        ;; Se cauta tag-ul calculat
        cmp eax, [ebx+edx]
        je tag_found
        ;; Se incrementeaza indicele
        inc edx
        cmp edx, CACHE_LINES
        jl search_tag
        ;; Cazul in care tag-ul nu a fost gasit
        mov eax, CACHE_LINE_SIZE
        mul dword [aux_to_replace]
        ;; Se retine in esi o valoare ce va ajuta la pozitionare
        mov esi, eax
        mov [aux_helper], esi
        ;; Se pune in edx tag-ul
        mov edx, [aux_address]
        shl edx, OFFSET_BITS
tag_not_found:
        ;; Se salveaza in eax prima valoare ce trebuie pusa in cache
        mov eax, [edx]
        inc edx
        ;; Se pune in cache valoarea din eax
        ;; Se foloseste acea valoare ce ajuta la pozitionare
        ;; [ecx+esi] reprezinta primul element de pe linia [aux_to_replace]
        mov [ecx+esi], eax
        ;; Se incrementeaza indicele
        inc esi
        inc dword [contor]
        cmp dword [contor], CACHE_LINE_SIZE
        jl tag_not_found
        ;; Se obtine indicele elementului ce trebuie pus in registru
        mov esi, [aux_helper]
        add esi, [aux_helper_offset]
        ;; edi retine elementul ce trebuie pus in registru
        mov edi, [ecx+esi]
        mov esi, [aux_reg]
        ;; Se adauga elementul calculat in registru
        mov [esi], edi
        mov esi, [aux_to_replace]
        ;; Se pune tag-ul calculat in vectorul de tag-uri
        mov edi, [aux_address]
        mov [ebx+esi], edi
        jmp end

tag_found:
        ;; Cazul in care tag-ul a fost gasit
        mov eax, CACHE_LINE_SIZE
        mov esi, edx
        mul esi
        mov esi, eax
        ;; esi retine indicele corespunzator
        add esi, [aux_helper_offset]
        ;; Se obtine valoarea necesara din cache
        mov edi, [ecx+esi]
        ;; esi retine adresa registrului
        mov esi, [aux_reg]
        ;; Se pune in registru valoarea necesara
        mov [esi], edi
end:
;; FREESTYLE ENDS HERE
;; DO NOT MODIFY
        popa
        leave
        ret
;; DO NOT MODIFY


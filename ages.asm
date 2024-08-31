;; This is your structure
        struc my_date
.day:
        resw 1
.month:
        resw 1
.year:
        resd 1
        endstruc

        section .data
aux:
        dd 0

        section .text
        global ages

;; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
;; DO NOT MODIFY
        push ebp
        mov ebp, esp
        pusha

        mov edx, [ebp + 8]             ; len
        mov esi, [ebp + 12]            ; present
        mov edi, [ebp + 16]            ; dates
        mov ecx, [ebp + 20]            ; all_ages
;; DO NOT MODIFY
;; TODO:
       ;; Implement ages
;; FREESTYLE STARTS HERE
        ;; Initializarea registrelor cu valoarea 0
        mov [aux], edx
        xor eax, eax
        xor ebx, ebx
        xor edx, edx
;; Bucla pentru a parcurge elementele
iterate_dates:
        ;; Se parcurg elementele de tipul 'my_date'
        cmp ebx, [aux]
        je end
        ;; Se retine anul fiecarui element de la adresa edi
        mov eax, [edi+my_date_size*ebx+my_date.year]
        cmp eax,0
        jl negative_year
        ;; Se compara anul obtinut cu anul de la adresa 'present'
        cmp eax, [esi+my_date_size*0+my_date.year]
        jl get_year
        ;; Cazul in care data de nastere este dupa data prezenta
        ;; Cazul in care anul obtinut este negativ
negative_year:
        mov [ecx+ebx*4], dword 0
        inc ebx
        jmp iterate_dates

get_year:
        ;; Se efectueaza operatia de scadere pentru a obtine varsta
        sub eax, [esi+my_date_size*0+my_date.year]
        ;; Rezultatul nu trebuie sa fie negatv
        neg eax
        mov dx, [edi+my_date_size*ebx+my_date.month]
        cmp dx, [esi+my_date_size*0+my_date.month]
        ;; Cazul in care luna din data de nastere este dupa luna din 'present'
        jg get_year_decrement
        ;; Cazul in care lunile coincid
        je get_year_decision
        ;; Cazul in care luna din data de nastere este inainte de luna din 'present'
        jmp get_year_normal

get_year_decrement:
        ;; Se decrementeaza varsta calculata
        dec eax
        ;; Se adauga in vector
        mov [ecx+ebx*4], eax
        inc ebx
        ;; Se continua parcurgerea
        jmp iterate_dates
get_year_decision:
        ;; Se obtine ziua din data de nastere
        mov dx, [edi+my_date_size*ebx+my_date.day]
        cmp dx, [esi+my_date_size*0+my_date.day]
        ;; Cazul in care ziua din data de nastere este inainte de ziua din 'present'
        jle get_year_normal
        ;; Cazul in care ziua din data de nastere este dupa ziua din 'present'
        jg get_year_decrement
get_year_normal:
        ;; Se pastreaza varsta calculata
        ;; Se adauga in vector
        mov [ecx+ebx*4], eax
        inc ebx
        ;; Se continua parcurgerea
        jmp iterate_dates
end:

;; FREESTYLE ENDS HERE
;; DO NOT MODIFY
        popa
        leave
        ret
;; DO NOT MODIFY

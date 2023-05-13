#lang racket

(require racket/base)
(require racket/struct)

(provide read-elf-header
         is-elf
         ELF_MAGIC)

(define ELF_MAGIC #"\x7f\x45\x4c\x46")

(define elf-machine-map
  '((#"\x3e\x00" . "AMD x86-64")
    (#"\x3f\x00" . "Sony DSP Processor")))

(define elf-abiversion-map
  '((0 . "UNIX - System V")))

;; Define a struct to represent the ELF header
;; https://man7.org/linux/man-pages/man5/elf.5.html
(define-struct elf-header-struct
    (ei-magic       ; Magic number \x7f\x45\x4c\x46
     ei-class       ; Architecture for this binary
     ei-data        ; Data encoding of the processor-specific data in the file
     ei-version     ; Version number of the ELF specification
     ei-osabi       ; Operating system and ABI to which the object is targeted
     ei-abiversion  ; Version of the ABI to which the object is targeted
     ei-pad         ; Start of padding
     e-type         ; Object file type
     e-machine      ; Machine architecture
     e-version      ; ELF version
     e-entry        ; Entry point address
     e-phoff        ; Program header table offset
     e-shoff        ; Section header table offset
     e-flags        ; Processor-specific flags
     e-ehsize       ; ELF header size
     e-phentsize    ; Program header entry size
     e-phnum        ; Number of program header entries
     e-shentsize    ; Section header entry size
     e-shnum        ; Number of section header entries
     e-shstrndx)    ; Section header table index of the section containing section names
    #:methods gen:custom-write
    [(define (write-proc elf-header-struct port mode)
        (define ei-osabi (dict-ref elf-abiversion-map (elf-header-struct-ei-osabi elf-header-struct)))
        (define e-machine (dict-ref elf-machine-map (elf-header-struct-e-machine elf-header-struct)))
        (show "OS/ABI: " ei-osabi "~n"  port)
        (show "Machine: " e-machine ""  port))
      (define (show prefix str escapes port)
        (fprintf port (string-append-immutable prefix str escapes)))])

;; Read the ELF header
;; Extract fields from the ELF header
(define (read-elf-header elf-header)
    (make-elf-header-struct
      (bytes->string/utf-8 (subbytes elf-header 0 4))
      (bytes-ref elf-header 4)
      (bytes-ref elf-header 5)
      (bytes-ref elf-header 6)
      (bytes-ref elf-header 7)
      (bytes-ref elf-header 8)
      (subbytes elf-header 9 16)
      (subbytes elf-header 16 18)
      (subbytes elf-header 18 20)
      (subbytes elf-header 20 24)
      (subbytes elf-header 24 32)
      (subbytes elf-header 32 40)
      (subbytes elf-header 40 48)
      (subbytes elf-header 48 52)
      (subbytes elf-header 52 54)
      (subbytes elf-header 54 56)
      (subbytes elf-header 56 58)
      (subbytes elf-header 58 60)
      (subbytes elf-header 60 62)
      (subbytes elf-header 62 64)
    ))

(define (is-elf bytes)
    (equal? bytes ELF_MAGIC))


(define (analize source))
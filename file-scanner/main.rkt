#lang racket

(require file/md5)
(require racket/base)

;; Define a struct to represent the ELF header
(struct elf-header
  (ident  ; identification field
   type  ; Object file type
   machine  ; Machine architecture
   version  ; ELF version
   entry  ; Entry point address
   phoff  ; Program header table offset
   shoff  ; Section header table offset
   flags  ; Processor-specific flags
   ehsize  ; ELF header size
   phentsize  ; Program header entry size
   phnum  ; Number of program header entries
   shentsize  ; Section header entry size
   shnum  ; Number of section header entries
   shstrndx  ; Section header table index of the section containing section names
   ))



(define elf-machine-map
  '((#"\x3e\x00" "AMD x86-64")
    (#"\x3f\x00" "Sony DSP Processor")))


;; Read the ELF header from the given port
;; Extract fields from the ELF header
(define (read-elf-header elf-header)
  (define elf-magic (bytes->string/utf-8 (subbytes elf-header 0 4)))
  (define elf-class (bytes-ref elf-header 4))
  (define elf-data (bytes-ref elf-header 5))
  (define elf-version (bytes-ref elf-header 6))
  (define elf-osabi (bytes-ref elf-header 7))
  (define elf-abiversion (bytes-ref elf-header 8))
  (define elf-pad (subbytes elf-header 9 16))
  (define elf-type (subbytes elf-header 16 18))
  (define elf-machine (subbytes elf-header 18 20))
  (define elf-version2 (subbytes elf-header 20 24))
  (define elf-entry (subbytes elf-header 24 32))
  (define elf-phoff (subbytes elf-header 32 40))
  (define elf-shoff (subbytes elf-header 40 48))
  (define elf-flags (subbytes elf-header 48 52))
  (define elf-ehsize (subbytes elf-header 52 54))
  (define elf-phentsize (subbytes elf-header 54 56))
  (define elf-phnum (subbytes elf-header 56 58))
  (define elf-shentsize (subbytes elf-header 58 60))
  (define elf-shnum (subbytes elf-header 60 62))
  (define elf-shstrndx (subbytes elf-header 62 64))
  ;; Return a dictionary of the ELF header fields
  `((magic . ,elf-magic)
    (class . ,elf-class)
    (data . ,elf-data)
    (version . ,elf-version)
    (osabi . ,elf-osabi)
    (abiversion . ,elf-abiversion)
    (type . ,elf-type)
    (machine . ,elf-machine)
    (version2 . ,elf-version2)
    (entry . ,elf-entry)
    (phoff . ,elf-phoff)
    (shoff . ,elf-shoff)
    (flags . ,elf-flags)
    (ehsize . ,elf-ehsize)
    (phentsize . ,elf-phentsize)
    (phnum . ,elf-phnum)
    (shentsize . ,elf-shentsize)
    (shnum . ,elf-shnum)
    (shstrndx . ,elf-shstrndx)))


(define ELF_MAGIC #"\x7f\x45\x4c\x46")


(define DWARFInfo%
  (class object%
    (super-new)
    (init-field md5-hash)))


(define (source filename)
    (file->bytes filename #:mode 'binary))


(define (is-elf bytes)
    (equal? bytes ELF_MAGIC))


(define target-file "crackme05_64bit")

(let ([dwarf (new DWARFInfo% [md5-hash (md5 (source target-file))])])
    (printf "MD5: ~a\n" (get-field md5-hash dwarf)))

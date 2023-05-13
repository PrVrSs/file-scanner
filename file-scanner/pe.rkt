#lang racket

(provide IMAGE_DOS_SIGNATURE
         parse-dos-header
         is-pe)

;; Define constants for the PE file format
(define IMAGE_DOS_SIGNATURE #"\x4D\x5A")  ; MZ header signature
(define IMAGE_NT_SIGNATURE #x4550)   ; PE header signature
(define IMAGE_FILE_MACHINE_I386 #x14C)  ; x86 architecture
(define IMAGE_FILE_MACHINE_AMD64 #x8664) ; x64 architecture
(define IMAGE_FILE_MACHINE_ARM #x1C0)  ; ARM architecture
(define IMAGE_FILE_MACHINE_ARM64 #xAA64) ; ARM64 architecture


;;https://source.winehq.org/source/include/winnt.h
(define-struct dos-header-struct 
    (e_magic     ; 00: MZ Header signature
     e_cblp      ; 02: Bytes on last page of file
     e_cp        ; 04: Pages in file
     e_crlc      ; 06: Relocations
     e_cparhdr   ; 08: Size of header in paragraphs
     e_minalloc  ; 0a: Minimum extra paragraphs needed
     e_maxalloc  ; 0c: Maximum extra paragraphs needed
     e_ss        ; 0e: Initial (relative) SS value
     e_sp        ; 10: Initial SP value
     e_csum      ; 12: Checksum
     e_ip        ; 14: Initial IP value
     e_cs        ; 16: Initial (relative) CS value
     e_lfarlc    ; 18: File address of relocation table
     e_ovno      ; 1a: Overlay number
     e_res       ; 1c: Reserved words
     e_oemid     ; 24: OEM identifier (for e_oeminfo)
     e_oeminfo   ; 26: OEM information; e_oemid specific
     e_res2      ; 28: Reserved words
     e_lfanew))  ; 3c: Offset to extended header


(define (parse-dos-header dos-header)
    (make-dos-header-struct
      (subbytes dos-header 0 2)
      (subbytes dos-header 2 4)
      (subbytes dos-header 4 6)
      (subbytes dos-header 6 8)
      (subbytes dos-header 8 10)
      (subbytes dos-header 10 12)
      (subbytes dos-header 12 14)
      (subbytes dos-header 14 16)
      (subbytes dos-header 16 18)
      (subbytes dos-header 18 20)
      (subbytes dos-header 20 22)
      (subbytes dos-header 22 24)
      (subbytes dos-header 24 26)
      (subbytes dos-header 26 28)
      (subbytes dos-header 28 36)
      (subbytes dos-header 36 38)
      (subbytes dos-header 38 40) 
      (subbytes dos-header 40 60)
      (subbytes dos-header 60 64)))

(define (is-pe bytes)
    (equal? bytes IMAGE_DOS_SIGNATURE))
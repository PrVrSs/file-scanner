#lang racket

(require "elf.rkt")
(require "pe.rkt")

(define (source filename)
    (file->bytes filename #:mode 'binary))

(define elf-target-file "crackme05_64bit")
(define pe-target-file "b6b.exe")

(define elf-header (read-elf-header (source elf-target-file)))
(define pe-header (parse-dos-header (source pe-target-file)))

(displayln (is-elf (subbytes (source elf-target-file) 0 4)))
(displayln (is-pe (subbytes (source pe-target-file) 0 2)))

(displayln elf-header)

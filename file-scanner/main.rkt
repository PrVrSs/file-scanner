#lang racket

(require "elf.rkt")

(define (source filename)
    (file->bytes filename #:mode 'binary))

(define target-file "crackme05_64bit")

(define header (read-elf-header (source target-file)))

(pretty-write header)

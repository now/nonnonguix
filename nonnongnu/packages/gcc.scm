(define-module (nonnongnu packages gcc)
  #:use-module (guix packages)
  #:use-module (guix memoization)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages gcc)
  #:use-module (srfi srfi-1))

(define-public libgccjit-for-gcc
  (mlambda (gcc)
    (package
      (inherit gcc)
      (name "libgccjit")
      (outputs (delete "lib" (package-outputs gcc)))
      (properties (alist-delete 'hidden? (package-properties gcc)))
      (arguments
       (substitute-keyword-arguments `(#:modules ((guix build gnu-build-system)
                                                  (guix build utils)
                                                  (ice-9 regex)
                                                  (srfi srfi-1)
                                                  (srfi srfi-26))
                                       ,@(package-arguments gcc))
         ((#:configure-flags flags)
          `(append '("--disable-bootstrap"
                     "--disable-libatomic"
                     "--disable-libgomp"
                     "--disable-libquadmath"
                     "--disable-libssp"
                     "--enable-host-shared"
                     "--enable-checking=release"
                     "--enable-languages=jit")
                   (remove (cut string-match "--enable-languages.*" <>)
                           ,flags)))
         ((#:phases phases)
          `(modify-phases ,phases
             (add-after 'install 'remove-broken-or-conflicting-files
               (lambda* (#:key outputs #:allow-other-keys)
                 (for-each delete-file
                           (find-files (string-append (assoc-ref outputs "out") "/bin")
                                       ".*(c\\+\\+|cpp|g\\+\\+|gcov|gcc|gcc-.*)"))
                 #t))))))
      (inputs
       (alist-delete "libstdc++"
                     (package-inputs gcc)))
      (native-inputs
       `(("gcc" ,gcc)
         ,@(package-native-inputs gcc))))))

(define-public libgccjit-10
  (libgccjit-for-gcc gcc-10))

(define-public libgccjit-11
  (libgccjit-for-gcc gcc-11))

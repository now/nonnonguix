(define-module (nonnongnu packages linux)
  #:use-module (gnu packages linux)
  #:use-module (guix gexp)
  #:use-module (guix build utils)
  #:use-module (guix utils)
  #:export (more-corrupt-linux))

(define (more-linux-urls version)
  "Return a list of URLS for Linux VERSION."
  (list (string-append "https://www.kernel.org/pub/linux/kernel/v"
                       (version-major version) ".x/linux-" version ".tar.xz")))

(define* (more-corrupt-linux freedo version hash #:key (name "more-linux"))
  (package
    (inherit freedo)
    (name name)
    (version version)
    (source
     (origin
       (method url-fetch)
       (uri (more-linux-urls version))
       (sha256 (base32 hash))))
    (home-page "https://www.kernel.org/")
    (synopsis "Linux kernel with nonfree binary blobs included")
    (description
     "The unmodified Linux kernel, including nonfree blobs, for running Guix
System on hardware which requires nonfree software to function, including mt7921e.")
    (native-imports
     `(("kconfig" ,(search-auxiliary-file "linux/5.17-x86_64.conf"))
       ,@(alist-delete "kconfig" (package-native-inputs freedo))))))

(define-public more-linux-5.17
  (more-corrupt-linux
   linux-libre-5.17
   "5.17.5"
   "11z95wsgmj97pg77yck26l0383gncbla0zwpzv4gjdj4p62x3g4v"))

(define-public more-linux more-linux-5.17)

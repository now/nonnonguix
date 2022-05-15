(define-module (nonnongnu system install)
  #:use-module (gnu system)
  #:use-module (gnu system install)
  #:use-module (nongnu packages linux)
  #:use-module (nonnongnu packages linux)
  #:export (installation-os-more-nonfree))

(define installation-os-more-nonfree
  (operating-system
    (inherit installation-os)
    (kernel more-linux)
    (firmware (list linux-firmware))
    (initrd-modules (cons "sata_nv" %base-initrd-modules))))

installation-os-more-nonfree

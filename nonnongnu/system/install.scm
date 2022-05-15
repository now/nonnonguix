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
    (firmware (list linux-firmware))))

installation-os-more-nonfree

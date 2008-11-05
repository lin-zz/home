(defun xcscope-mode ()
  "cscope settings"
  (require 'xcscope)
  (if (executable-find "cscope-fast") (setq cscope-program "cscope-fast"))
  )

;;
;; Define "sun" mode to get the continuation line indentation properly.
;;
(defun sun-cc-mode (mode-map)
  "Sun C style"
  (c-set-style "linux")
  (define-key mode-map "\C-c\C-c" 'compile)
  ;;(c-toggle-auto-state 1)
  (auto-fill-mode 1)
  
  (setq fill-column 80
	c-label-minimum-indentation 0)

  (setq c-hanging-braces-alist
	(append '((class-open after)
		  (brace-list-close after)
		  (brace-list-intro))
		c-hanging-braces-alist))

  (setq c-cleanup-list
	(append '(brace-else-brace
		  brace-elseif-brace
		  defun-close-semi
		  list-close-comma)
		c-cleanup-list))

  (setq c-offsets-alist
	(append '((arglist-cont . *)
		  (arglist-cont-nonempty . *)
		  (statement-cont . *))
		c-offsets-alist)))

(defun my-xemacs-only-init ()
  " XEmacs only configuration"
  (global-set-key '(button4) 'scroll-down-one)
  (global-set-key '(button5) 'scroll-up-one)
  (setq auto-mode-alist
	(append '(("[Mm]akefile\\..*" . makefile-mode))
		auto-mode-alist))
  )

(defun my-emacs-only-init ()
  " Emacs only configuration"
  (transient-mark-mode t)
  )

(defun my-common-init ()
  " All common configuration staff "
  ;;(add-to-list 'exec-path (expand-file-name "~/bin"))
  (add-to-list 'load-path (expand-file-name "~/.xemacs"))
  (xcscope-mode)
  ;;
  ;; Syntax highlighting, paren highlighting, line:column number
  ;;
  (custom-set-variables
   '(paren-mode (quote blink-paren) nil (paren))
   '(column-number-mode t)
   '(line-number-mode t)
   '(font-lock-mode t nil (font-lock)))
  ;; Tell emacs to not wait for the window manager to apply custom UI settings.
  ;; This makes emacs startup *much* faster.
  (modify-frame-parameters nil '((wait-for-wm . nil)))
  ;; Turn off the blinking cursor.
  (blink-cursor-mode 0)
  (setq-default cursor-type 'box)

  ;;(load-library "gnuserv")
  ;;(gnuserv-start)
  )

;;;;;;;;;;
;; Main ;;
;;;;;;;;;;
(cond
 ((string-match "XEmacs" emacs-version) (my-xemacs-only-init))
 (t (my-emacs-only-init))
 )
(my-common-init)


;;(if (locate-library "tex-site") (require 'tex-site))

;;; flyspell-mode
;;(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
;;(setq ispell-program-name "/usr/bin/enchant")

(add-hook 'hide-ifdef-mode-hook
	  (lambda ()
	    (unless hide-ifdef-define-alist
	      (setq hide-ifdef-define-alist
		    '((cde-ifdef-list SVR4 sun _LARGEFILE64_SOURCE _FILE_OFFSET_BITS=64 i386 __x86 MULTIBYTE NLS16 MESSAGE_CAT _XOPEN_VERSION=4 _XOPEN_SOURCE __EXTENSIONS__ PAM BYPASSLOGIN _REENTRANT NO_OCF_SUPPORT FUNCPROTO=15 BINDIR=\"/usr/openwin/bin\" XDMDIR=\"/var/dt\" TCPCONN UNIXCONN OSMAJORVERSION=5 OSMINORVERSION=11 CDE_INSTALLATION_TOP=\"/usr/ CDE_CONFIGURATION_TOP=\"/etc/dt\")
		      (solaris-ifdef-list sun))
		    ))))
;;(hide-ifdef-use-define-alist 'cde-ifdef-list) ; use cde-ifdef-list by default

;;
;; Load cscope library once is enough
;;
(add-hook 'c-initialization-hook
	  ;; Hook run only once per Emacs session, when CC mode is initialized.
	  (lambda ()
	    (hide-ifdef-mode t)
	    ;;(setq hide-ifdef-initially nil)
	    ))
(add-hook 'c-mode-common-hook
	  ;; Common hook across all languages.
	  ;; It's run immediately before the language specific hook.
	  (lambda () (sun-cc-mode c-mode-base-map)))
;;(add-hook 'c-mode-hook (lambda () (sun-cc-mode c-mode-map)))
;;(add-hook 'c++-mode-hook (lambda () (sun-cc-mode c++-mode-map)))
;;(add-hook 'java-mode-hook (lambda () (sun-cc-mode java-mode-map)))

(add-hook 'makefile-mode-hook
	  (lambda ()
	    (define-key makefile-mode-map "\C-csf" 'cscope-find-this-file)
	    ))

(setq user-mail-address "Lin.Ma@Sun.COM")
(setq user-full-name "Lin Ma")
(setq mail-specify-envelope-from t)
(setq mail-envelope-from "Lin.Ma@Sun.COM")
(setq mail-default-reply-to "Lin.Ma@Sun.COM")
(setq mail-signature t)
(setq mail-archive-file-name "MAILED")

;; GNUS related
;(add-to-list 'load-path (expand-file-name "~/ngnus-0.6/lisp"))
;(add-to-list 'load-path (expand-file-name "~/gnus/lisp"))
;(require 'info)
;(add-to-list 'Info-directory-list (expand-file-name "~/ngnus-0.6/texi"))
;(add-to-list 'Info-directory-list (expand-file-name "~/gnus/texi"))
;(require 'gnus-load)
(add-hook 'gnus-startup-hook
	  (lambda ()
	    (setq gnus-startup-file "~/.newsrc")
	    ;; Read the dribble file on startup without querying the user.
	    (setq gnus-always-read-dribble-file t)
	    ;; BBDB related
	    (and (require 'bbdb) (require 'bbdb-gnus) (bbdb-insinuate-gnus))
	    (require 'smtpmail)
	    ))
(setq mail-user-agent 'gnus-user-agent)

;; VM related
;(setq mail-user-agent 'vm-user-agent)
(setq vm-init-file "~/.vm.el")

;; ange-ftp/efs related
(setq ange-ftp-default-user "ftp")            ;; id for /host:/remote/path
(setq ange-ftp-generate-anonymous-password t) ;; use $USER@`hostname`
(setq ange-ftp-binary-file-name-regexp ".")   ;; xfer in binary mode
(setq ange-ftp-gateway-host "webcache.sfbay"
      ange-ftp-smart-gateway-port "8080"
      ange-ftp-local-host-regexp ".*"
      ange-ftp-smart-gateway t)

;; debug
;(setq debug-on-error t)

;;; make sure URLs get processed by firefox
(setq browse-url-browser-function 'browse-url-mozilla
      browse-url-mozilla-program "firefox"
      browse-url-new-window-flag t
      browse-url-mozilla-new-window-is-tab t
      browse-url-mozilla-arguments '("-a" "firefox"))

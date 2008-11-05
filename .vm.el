;; to get highlighting working

(require 'highlight-headers)

;; URL handoff to netscape always in VM:
(setq
 highlight-headers-follow-url-function 'highlight-headers-follow-url-netscape
 vm-url-browser                        'vm-mouse-send-url-to-netscape)

;; SSL need stunnel
;(setq vm-stunnel-program "stunnel")

;; use remote mail box as folders
(setq vm-imap-server-list
      '(
	"imap-ssl:mail-apac.sun.com:993:inbox:login:lm161491:*"
	))

;; do not use remote mail box as a spool
;(setq vm-spool-files
;      `(
;	("imap-ssl:mail-apac.sun.com:993:inbox:login:lm161491:*")
;	))

(setq vm-imap-auto-expunge-alist
      '(
	;; leave message on the server
	("imap-ssl:mail-apac.sun.com:993:inbox:login:lm161491:*" . nil)
	))

(setq vm-mail-check-interval 300)

; Handle a variety of bogus MIME charsets, and a few legit ones
; that can be reasonably approximated as ASCII.

(add-to-list 'vm-mime-default-face-charsets "Windows-1251")
(add-to-list 'vm-mime-default-face-charsets "Windows-1252")
(add-to-list 'vm-mime-default-face-charsets "Windows-1255")
(add-to-list 'vm-mime-default-face-charsets "Windows-1257")
(add-to-list 'vm-mime-default-face-charsets "ISO8859-1")
(add-to-list 'vm-mime-default-face-charsets "ISO-8859-15")
(add-to-list 'vm-mime-default-face-charsets "GB2312")
(add-to-list 'vm-mime-default-face-charsets "unknown-8bit")
(add-to-list 'vm-mime-default-face-charsets "UTF-8")

;
; purge dups automatically.
;
(defun wsm-delete-dups ()
  (save-excursion
    (if (search-forward "\nMessage-id: " nil t)
        ;; If this message has a message-id, check it
        (let ((b (point))
              mid)
          (end-of-line)
          (setq mid (buffer-substring b (point)))
          (if (member mid wsm-message-id-list)
              ;; If we've already seen this message, delete it
	      (vm-set-deleted-flag message t)
	      ;; This is a new message: remember it
	      (setq wsm-message-id-list 
		    (cons mid wsm-message-id-list))
            ))
      ))
  ;; Housekeeping: don't let the message id list get too long
  (if (< 50 (length wsm-message-id-list))
      (setcdr (nthcdr 20 wsm-message-id-list) nil))
  )
(add-hook 'vm-arrived-message-hook 'wsm-delete-dups)
(defvar wsm-message-id-list nil)

;; We use mostly IMAP folders:
(define-key vm-mode-map "v" 'vm-visit-imap-folder)
(define-key vm-mode-map "s" 'vm-save-message-to-imap-folder) 

;(setq vm-primary-inbox (expand-file-name "~/Mailvm/INBOX"))
;(setq vm-folder-directory (expand-file-name "~/Mailvm/"))
(setq vm-primary-inbox "imap-ssl:mail-apac.sun.com:993:inbox:login:lm161491:*")
(setq vm-folder-directory "imap-ssl:mail-apac.sun.com:993:inbox:login:lm161491:*")
(setq vm-imap-folder-cache-directory "~/Mailvm/")
(setq vm-auto-center-summary t)
(setq vm-delete-after-archiving t)
(setq vm-inhibit-startup-message t)
(setq vm-print-command "lp")
(setq vm-included-text-attribution-format "%f said:\n")
(setq vm-forwarding-subject-format "fwd: %s")
(setq vm-reply-subject-prefix "re: ")
(setq vm-use-toolbar nil)
(setq vm-confirm-quit t)

;; stop VM opening a frame
(setq vm-raise-frame-at-startup nil)
;(setq vm-mutale-frames nil)

;; someday this should be fixed to use regexps...
(setq vm-auto-folder-alist 
      '(
	("Subject"
	 ("BugId"                               . "Bugs"))
	("To:"
	 ("\\(\\w+-code\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("\\(\\w+-discuss\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("\\(\\w+-cteam\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("\\(\\w+-interest\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("\\(\\w*[Aa][Rr][Cc]\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("allsun@sun.com"	.	"comp.allsun")
	 ("bjs0[357]@sun.com"	.	"comp.eri")
	 ("eri.*@sun.com"	.	"comp.eri")
	 ("sceri.*@sun.com"	.	"comp.eri")
	 )
	("CC:"
	 ("\\(\\w+-code\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("\\(\\w+-discuss\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("\\(\\w+-cteam\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("\\(\\w+-interest\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("\\(\\w*ARC|\\w*arc\\)@" .
	  (buffer-substring (match-beginning 1) (match-end 1)))
	 ("allsun@sun.com"	.	"comp.allsun")
	 ("bjs0[357]@sun.com"	.	"comp.eri")
	 ("eri.*@sun.com"	.	"comp.eri")
	 ("sceri.*@sun.com"	.	"comp.eri")
	 )
	("sender"
	 ("owner-linux-security@tarsier.cv.nrao.edu" . "linux-security")
	 )
	)
      )


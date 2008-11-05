;;; default ~/Mail/
(setq gnus-select-method '(nnml "")
      gnus-secondary-select-methods
      '(
	(nnimap "malin@sun"
                (nnimap-address "mail-emea.sun.com")
                (nnimap-stream ssl)
		(nnimap-server-port 993) ; default is 993 for imap-ssl
		;; list almost every thing
		(nnimap-list-pattern ("*" "*/*" "*/*/*"))
		(nnimap-authenticator login)
		)
	))

;(setq debug-on-error t)
;(setq gnus-verbose 10)
;(setq gnus-debug t)
;(setq imap-log "imap-log")
;(setq imap-debug "imag-debug")
;(setq nnimap-debug "nnimap-debug")

;;; check duplicate mail function
;; note since any new mails in INBOX will be checked by this function
;; so the new mails keep in INBOX maybe be checked twice and be considered as
;; the duplicate ones. so we must have a default mailbox where we can put all
;; left new mails there.
;; the better solution is re define key "g" and "M-g" to our functions which
;; do clean duplicate buffer before/after each split running and forbit users
;; directly invork gnus-group-get-new-mail*.
(defun my-nnimap-check-duplicate (dup-group &optional cache-group)
  "If first seen, insert and skip, else move to dup-group."
  (let ((id (message-fetch-field "message-id")))
    (prog2
	(nnmail-cache-open)
	(cond
	 ((not id) nil)
	 ((nnmail-cache-id-exists-p id) dup-group)
	 (t
	  (if (string= gnus-version-number "5.8.8")
	      (nnmail-cache-insert id)
	    (if (not cache-group)
		(let ((cache-group "nnml:cache"))
		  (nnmail-cache-insert id cache-group))))
	  nil))
      (nnmail-cache-close)
      )))

;;; example of nnimap-split-fancy
;;; note \\b is inportant to use regexp-match
;;; (any "\\b\\(\\w+-discuss\\)@.*" (! my-downcase "\\1"))
(defun my-downcase (grpname)
  "a tricky downcase since split-fancy passes a list of string
	while original download does not accept it. And (! func split) need
	a list as its arg while downcase returns a string"
  (setq grpname (car grpname))
  (cons (downcase grpname) ()))

(setq gnus-agent t
      gnus-agent-cache t
      gnus-use-cache t
      gnus-cache-directory "~/Mail/cache/"
      gnus-cache-enter-articles '(ticked dormant read unread)
      gnus-cache-remove-articles nil
      gnus-cacheable-groups "^nnimap"
      gnus-uncacheable-groups "^nnml"
      gnus-asynchronous t
      gnus-use-article-prefetch 30
      ;;gnus-fetch-old-headers t

      ;; DO NOT READ ACTIVE WHEN STARTING and other optimized settings
      ;;gnus-read-active-file nil
      gnus-nov-is-evil nil
      ;;gnus-check-bogus-newsgroups nil
      gnus-save-killed-list nil
      gnus-auto-select-first nil
      gnus-auto-select-subject '(unseen-or-unread)
      ;; special char w/in the set will be filted by GNUS
      ;; and will not displayed
      gnus-invalid-group-regexp ": `'\"[]\\|^$"

      ;; group lines format
      gnus-group-line-format "%M\%S\%p\%P\%5y : %(%-40,40G%) %d\n"
      ;; summary lines format
      ;;gnus-summary-line-format "%U%R%z%I%(%[%3L: %-10,10n%]%) %s\n"

      gnus-visible-headers "^\\(From:\\|Subject:\\|Date:\\|Followup-To:\\|To:\\|CC:\\|X-Newsreader:\\|User-Agent:\\|X-Mailer:\\)"

      ;; post styles
      gnus-posting-styles
      '((".*"
	 (name "Lin Ma")
	 (address "Lin.Ma@Sun.COM")
;	 (signature-file "~/.signature")
	 ))

      ;;mm-automatic-display (remove "text/html" mm-automatic-display)

      gnus-ignored-mime-types '("text/x-vcard")

      ;; expired one should be deleted as thunderbird does
      nnmail-expiry-wait-function
      (lambda (group)
        (cond ((string-match "Trash" group) 'immediate)
              (t 'immediate))
	)
      nnmail-expiry-target
      (lambda (group)
        (cond ((string-match "Trash" group) 'delete)
              (t "nnimap+malin@sun:Trash"))
	)

      ;; save sent mails
      gnus-message-archive-group '(("malin@sun" "nnimap+malin@sun:Sent"))
      
      ;; don't seem work
      gnus-gcc-mark-as-read t
      ;; gnus-novice-user nil

      mail-from-style 'angles
      message-from-style 'angles

      message-yank-prefix ">"

      ;; Use to check dup mails
      nnmail-message-id-cache-length 5000

      ;; Mail filter/spliter
      nnimap-split-crosspost nil
      nnimap-split-inbox '("INBOX")
      nnimap-split-predicate "UNDELETED"
      nnimap-split-rule '(("malin@sun" ("INBOX" nnimap-split-fancy)))
      nnimap-split-fancy
      '(|
	;; 
	;; try to detect duplicate mails
	;;
	;;(: my-nnimap-check-duplicate "Trash/duplicates")
	;;
	;; External mails first
	;;
	;; Opensolaris related
	;;
	("sender" ".*@opensolaris\\.org$"
	 (|
	  ;; opensolaris PROJECT CODE
	  ("sender" "\\b\\(\\w+\\)-\\(dev\\|code\\|usb\\)-bounces@\\(\\w+\\)\\.\\w+" (! my-downcase "\\3/\\1-\\2"))
	  ;; opensolaris DISCUSS
	  ("sender" "\\b\\(driver\\|dtrace\\|mdb\\|zfs\\|nwam\\|networking\\|desktop\\|clearview\\|xen\\|approach\\)-\\(discuss\\)-bounces@\\(\\w+\\)\\.\\w+" (! my-downcase "\\3/\\1-\\2"))
	  ;; opensolaris others
	  ("sender" "jds-notify-.*" "Trash/jds")
	  ("sender" "jds-review-.*" "jds-review")
	  ;; opensolaris ALL others
	  ("sender" "\\b\\(\\w+\\)-\\(\\w+\\)-bounces@\\(\\w+\\)\\.\\w+" (! my-downcase "\\3/opensolaris-discuss"))
	  ))
	(from ".*@defect.opensolaris.org" "opensolaris/bugs")
	;;
	;; Internal mails
	;;
        (to "onnv-gate-notify@.*" "==ON Notify==")
	(to "nv-users@.*" "opensolaris/opensolaris-discuss")
	;; ARC mails
        (to "[PpLl][Ss]?[Aa][Rr][Cc]\\(-\\w*\\)?@.*sun\\.com" "ARC")
	;; split interest mails first due to the duplicate jds
	(to ".*-interest@sun\\.com"
	    (|
	     (to "\\(CC\\|cc\\)-interest@.*" "cc-interest")
	     ;; (to "\\b\\(\\(jds\\)-interest\\)@.*" (! my-downcase "\\1"))
	     ;; interest mails default to misc/interest
	     "misc/interest"
	     ))
	;; jds dev team mails
	(to "jds-.*@sun\\.com"
	    (|
	     (to "jds-dev.*" "jds-dev")
	     (to "jds-commits.*" "Trash")
	     ))
	;; desktop cteam
        (to "desktop-\\(cteam\\|china\\)@sun.com" "desktop-cteam")
	;; nwam-core and nwam-ui should be handled after nwam-discuss
	(to "\\b\\(nwam-\\(core\\|ui\\)\\)@sun.com" (! my-downcase "\\1"))
	;; company mails
        (to "\\(allsun\\|bjs0[357]\\|.*-eriall\\|sceri-.*\\|gcall\\)@sun.com" "comp.sun")
	;; flag-day mails
        (to "\\(onnv-gate\\|on-all\\)@.*" "ARCHIVE/on-all")
	;; others
        (to "my2002@googlegroups.com" "Classmates")
	;; Bugster mails
        ("subject" ".*[ ]*CR [0-9]+ .*" "Bugs")
	;; seems junks to me
	(to "lin@sun.com" "Trash")
	;; default to misc. MUST SET DEFAULT due to the nit in check-dup mails
	"misc"
	)
      )


(defadvice message-send (around my-confirm-message-send)
  (if (yes-or-no-p "Really send message? ")
      ad-do-it))
(ad-activate 'message-send)

;; my scan
(defun my-get-new-news (&optional ARG)
  (interactive)
  (write-region "" nil (expand-file-name "~/.nnmail-cache") nil nil nil nil)
  (gnus-group-get-new-news ARG))
(define-key gnus-group-mode-map [remap gnus-group-get-new-news]
  'my-get-new-news)
(define-key gnus-group-mode-map [remap gnus-group-get-new-news-this-group]
  (lambda (&optional N DONT-SCAN)
    (write-region "" nil (expand-file-name "~/.nnmail-cache") nil nil nil nil)
    (gnus-group-get-new-news-this-group N DONT-SCAN)))

;; check mails every 5 minutes after xemacs is in idle for 5 minutes
(gnus-demon-add-handler 'my-get-new-news 5 5)
(gnus-demon-init)

(add-hook 'mail-mode-hook
	  (lambda ()
	    ;;(flyspell-mode 1)
	    ))
(add-hook 'message-mode-hook
	  (lambda ()
	    ;;(flyspell-mode 1)
	    (setq fill-column 72)
	    (turn-on-auto-fill)))

;;; BBDB related
;;If you don't live in Northern America, you should disable the 
;;syntax check for telephone numbers by saying
(setq bbdb-north-american-phone-numbers-p nil
      ;;Tell bbdb about your email address:
      bbdb-user-mail-names (regexp-opt '("lin\\.ma@sun\\.com"))
      ;;cycling while completing email addresses
      bbdb-complete-name-allow-cycling t
      ;;No popup-buffers
      bbdb-use-pop-up nil
      gnus-optional-headers 'bbdb/gnus-lines-and-from
      bbdb/gnus-header-prefer-real-names t
      bbdb/gnus-header-show-bbdb-names t)

;;; TODO -- remove the mapconcat addition of commas, that get removed by m-t-h
;;; Could go into many hooks:
;;;        message-send-mail-hook
;;;        message-send-news-hook
;;;        message-send-hook
;; currently disable 
;(add-hook 'message-send-hook
;	  (lambda ()
;	    "Add all recipients to BBDB, using this list of headers:
;	from, sender, to, cc, bcc,
;	resent-from, resent-to, resent-cc, resent-bcc."
;	    (let ((fields '("from" "sender" "to" "cc" "bcc"
;			    "resent-from" "resent-to" "resent-cc" "resent-bcc")))
;	      (mapc
;	       (lambda (address)
;		 (bbdb-annotate-message-sender address t t t))
;	       (save-restriction
;		 (message-narrow-to-headers)
;		 (message-tokenize-header (mapconcat 'message-fetch-field fields ",")))))))

;; only auto insert in some groups
;; note only bbdb/news-auto-create-p affect in GNUS
(add-hook 'gnus-select-group-hook
	  (lambda ()
	    (gnus-group-set-timestamp)
	    (setq bbdb/news-auto-create-p
		  (and
		   ;; skip the author in trash
		   (not (string-match "trash" gnus-newsgroup-name))
		   (string-match "^nnimap" gnus-newsgroup-name)
		   t))))

;; default key binding is "\M-\t" "Meta-TAB"
(add-hook 'message-setup-hook
	  (lambda ()
	    (bbdb-insinuate-message)
	    (define-key message-mode-map "\M-a" 'bbdb-complete-name)))

;;; MIME related
;(setq gnus-mime-display-multipart-related-as-mixed nil)
;(setq gnus-mime-display-multipart-as-mixed t)
(eval-after-load "mm-decode"
  '(progn 
    (add-to-list 'mm-discouraged-alternatives "text/html")
    (add-to-list 'mm-discouraged-alternatives "text/richtext")))

;;; SMTP related
(setq starttls-use-gnutls t
      starttls-gnutls-program "gnutls-cli"
      ;;starttls-extra-arguments '("--protocols" "ssl3")
      starttls-extra-arguments nil
      
      ;; Disable SMTP send mail because doesn't support SSL currently
      ;;message-send-mail-function 'smtpmail-send-it
      ;;send-mail-function 'smtpmail-send-it

      smtpmail-debug-info t
      smtpmail-debug-verb t

      smtpmail-smtp-server "mail-emea.sun.com"
      smtpmail-smtp-service 587
      smtpmail-auth-credentials '(("mail-emea.sun.com" 587 "lm161491" nil))
      smtpmail-starttls-credentials '(("mail-emea.sun.com" 587 nil nil))
      )

(gnus-compile)

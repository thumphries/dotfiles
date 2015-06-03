;; This is a hack - fire up a shell to get the PATH.
;; Source and description:
;; http://stackoverflow.com/questions/9435019/how-do-i-source-my-zshrc-within-emacs
(let ((path (shell-command-to-string ". ~/.zshrc; echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path
        (append
         (split-string-and-unquote path ":")
         exec-path)))

;; Package manager stuff
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa-stable.milkbox.net/packages/")))
(package-initialize)

;; smooth-scroll is clunky and doesn't behave like ordinary OS X scrolling
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;; Show columns in modeline
(setq column-number-mode t)

;; Really annoying to have the bell ringing when overscrolling
;; ... best to just disable it, really.
(setq ring-bell-function 'ignore)

;; Disable various visual cruft

(tool-bar-mode -1)
(if window-system
    (scroll-bar-mode -1) ;; scrollbar doesn't exist in cli
    (menu-bar-mode 0))   ;; still want menu bar in OS X

;; Line numbers enabled, but not in certain major modes.
(setq linum-mode-inhibit-modes-list '(eshell-mode
                                      shell-mode
                                      term-mode
                                      org-mode
                                      erc-mode
				      calendar
				      calendar-mode
				      magit-mode))

(defadvice linum-on (around linum-on-inhibit-for-modes)
  "Stop the load of linum-mode for some major modes."
    (unless (member major-mode linum-mode-inhibit-modes-list)
             ad-do-it))

(ad-activate 'linum-on)

(global-linum-mode 1)
(setq linum-format "%4d ") ; Default formatting has no spacing

;; Disable the ridiculous and frustrating electric-indent
(electric-indent-mode 0)

;; Show trailing whitespace in all prog-modes
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; CUA mode for selection / mutation / etc.
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
(global-set-key (kbd "C-x C-v") 'cua-set-rectangle-mark)


;; Color theming and the like
(require 'color-theme)
(color-theme-initialize)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'assemblage t)


;; Foreground and background colors should be distinct from the color scheme
;(add-to-list 'default-frame-alist '(foreground-color . "#C0C0C0"))
;(add-to-list 'default-frame-alist '(background-color . "#171717"))

;; Window management bindings
(global-set-key (kbd "C-x C-1") 'delete-other-windows)
(global-set-key (kbd "C-x C-2") 'split-window-below)
(global-set-key (kbd "C-x C-3") 'split-window-right)
(global-set-key (kbd "C-x C-0") 'delete-window)

;; Better cursor type
(setq cursor-type 'bar)

;; This auto-reloads modified files.
(global-auto-revert-mode t)

;; Proof General
(load-file "~/.emacs.d/ProofGeneral/generic/proof-site.el")

;; Include agda-mode from wherever the hell cabal installed it
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))


;; Garbage from the UI configurator below

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(agda2-include-dirs
   (quote
    ("/Users/tim/src/agda-prelude/src" "/Users/tim/src/lib-0.7" ".")))
 '(custom-safe-themes
   (quote
    ("eab5d2aedb86a40c370945b167efa42de00b354d9e66ebed0f11dda0588fdd14" "c1ab9d4df50c59761db835e29d38d37769d596f14868f8165cd7cf27333afad0" "e2c168d94835051b94f08c0f523798b08012c5992074799b8b5caae1b412c698" "93955537eaadd7b8c1bc1ba6b040135ff502ac03b158548907b7109dec7f8efd" "03eed17bc0e43fc1bb94587c9c89d747fa3af342276d7542e051335ea6800d7f" "751f7a6f7afe58586786c76b1d5a797be28220cd71cb3195c03bde571bd921da" "1177fe4645eb8db34ee151ce45518e47cc4595c3e72c55dc07df03ab353ad132" "d8070384376f6e6a4b672ed0f1637034490a65197ff34f92d9ee4322c421bdd6" "6d1977ebe72065bf27f34974a9e5cb5dc0a7f296804376fad412d981dee7a7e4" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "c5a044ba03d43a725bd79700087dea813abcb6beb6be08c7eb3303ed90782482" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default)))
 '(erc-modules
   (quote
    (autojoin button completion fill keep-place list match menu move-to-prompt netsplit networks noncommands notifications readonly ring scrolltobottom stamp track))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(italic ((t (:slant normal)))))

;; Font stuff
(set-face-attribute 'default nil :height 120)
;;(print (font-family-list))
(set-frame-font "Terminus" nil t)
;(set-frame-font "PragmataPro" nil t)
(setq-default line-spacing 0.1)

(setq mouse-autoselect-window t)
;(setq focus-follows-mouse nil)


(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

; AutoRefill mode to enforce paragraphs (defun toggle-autorefill
(add-hook 'org-mode-hook (lambda () (auto-fill-mode 1)))
;; Enable Agda-style unicode input for Org
(add-hook 'org-mode-hook (lambda () (set-input-method "TeX")))

;; Fine-grained TODO logging
(setq org-log-done t)
(setq org-log-into-drawer t)

;; Keep DONE items out of agenda view
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)

;; Add INBOX and other contexts to agenda pop-up
(setq org-agenda-custom-commands
      '(("i" "INBOX" tags "-{^@}/!" nil)))

;; Global keyword set
(setq org-todo-keywords
      '((type "TODO(!)" "|" "DONE(!)" "WONTDO(@)" "IMPOSSIBLE(@)")))

;; Global tag set
;; XXX This should probably be stored elsewhere
(setq org-tag-alist
      ;; Contexts
      '((:startgroup . nil)
	  ("@online" . ?o)
	  ("@read" . ?r)
	  ("@game" . ?g)
	  ("@homework" . ?h)
	  ("@write" . ?w)
          ("@meta" . ?m)
	(:endgroup . nil)
        ;; Projects
        ("family")
        ("fitness")
        ("social")
	("logistics" . ?l)
	("photography")
        ("music")
        ("movies")
	("career")
        ("thesis")
	("blog")
        ("cooking")
	("flights")
        ;; Place tags
	("Sydney")
        ("Portland")
	("LA")
        ("SF")))

;; org-journal
(require 'org-journal)
(setq org-journal-dir "~/Documents/journal/")
;; Give all journal files a .org suffix, triggering org-mode
(setq org-journal-file-format "%Y%m%d.org")
;; Match date.org files for the calendar view
(setq org-journal-file-pattern
      "^\\(?1:[0-9]\\{4\\}\\)\\(?2:[0-9][0-9]\\)\\(?3:[0-9][0-9]\\).org$")

;; ghc-mod
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; company-mode
(add-hook 'after-init-hook 'global-company-mode)
;; company-ghc
(add-hook 'company-mode-hook (lambda () (add-to-list 'company-backends 'company-ghc)))
(setq company-idle-delay 2)

;; Structured Haskell Mode
;; (add-to-list 'load-path "/Users/tim/.emacs.d/shm")
;; (require 'shm)
;; (add-hook 'haskell-mode-hook 'structured-haskell-mode)

;; recentf for recent file list
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; popwin
(require 'popwin)
(popwin-mode 1)

;; Save backups elsewhere
(setq backup-directory-alist `(("." . "~/.saves")))

;; elm mode
(add-to-list 'load-path "~/.emacs.d/elm-mode")
(require 'elm-mode)

;; magic numbers ahoy - frame size dependent on display resolution
;; subtract a bit for OS X menubar
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if (display-graphic-p)
  (progn
    (let ((h (/ (- (x-display-pixel-height) 50) (frame-char-height)))
	  (w (if (> (x-display-pixel-width) 1440) 120 80)))
	     (set-frame-size (selected-frame) w h)))))

(set-frame-size-according-to-resolution)

(show-paren-mode 1)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;;; Ignored extensions
(add-to-list 'completion-ignored-extensions ".hi")
(add-to-list 'completion-ignored-extensions ".o")
(add-hook 'ido-setup-hook (setq ido-ignore-extensions t))
(add-hook 'ido-setup-hook (lambda ()
			   (add-to-list 'ido-ignore-files "\\.hi")
                           (add-to-list 'ido-ignore-files "\\.o")))



;;; Helm
(require 'helm-config)
;;(helm-autoresize-mode 1)

(add-hook 'helm-mode-hook
          (lambda ()
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; use TAB for action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions
(setq
 helm-candidate-number-limit 25
 helm-quick-update t
 helm-M-x-requires-pattern 3 ; Require at least one character
 helm-ff-file-name-history-use-recentf t
 helm-ff-skip-boring-files t
 ; helm-idle-delay 0.0
 ; helm-input-idle-delay 0.01

 ;; Use Spotlight on OS X to find files
 helm-locate-command
 "mdfind -onlyin $HOME -name %s %s | grep -E -v '/dist/|/Caches/'"
 helm-mini-default-sources '(helm-source-buffers-list
                             helm-source-recentf
                             helm-source-buffer-not-found
                             helm-source-locate))))

(helm-mode t)

;; helm-swoop
(add-to-list 'load-path "~/.emacs.d/helm-swoop")
(require 'helm-swoop)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-s") 'helm-swoop)

(setq tramp-default-method "ssh")

(require 'org-journal)
;; Force a .org suffix on written journal files
(setq org-journal-file-format "%Y%m%d.org")
;; Make sure those files are visible in calendar
(setq org-journal-file-pattern
      (org-journal-format-string->regex org-journal-file-format))
;; Make sure org-agenda can find them
(setq org-agenda-files (list org-journal-dir))

;; AutoRefill mode to enforce paragraphs (defun toggle-autorefill
(add-hook 'org-mode-hook (lambda () (auto-fill-mode 1)))
;; Enable Agda-style unicode input for Org
(add-hook 'org-mode-hook (lambda () (set-input-method "TeX")))

;; ghc-mod
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; company-mode
(add-hook 'after-init-hook 'global-company-mode)
;; company-ghc
(add-hook 'company-mode-hook (lambda () (add-to-list 'company-backends 'company-ghc)))
(setq company-idle-delay 2)

;; Structured Haskell Mode
;; (add-to-list 'load-path "/Users/tim/.emacs.d/shm")
;; (require 'shm)
;; (add-hook 'haskell-mode-hook 'structured-haskell-mode)

;; recentf for recent file list
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; popwin
(require 'popwin)
(popwin-mode 1)

;; Save backups elsewhere
(setq backup-directory-alist `(("." . "~/.saves")))

;; elm mode
(add-to-list 'load-path "~/.emacs.d/elm-mode")
(require 'elm-mode)

;; magic numbers ahoy - frame size dependent on display resolution
;; subtract a bit for OS X menubar
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if (display-graphic-p)
  (progn
    (let ((h (/ (- (x-display-pixel-height) 50) (frame-char-height)))
	  (w (if (> (x-display-pixel-width) 1440) 120 80)))
	     (set-frame-size (selected-frame) w h)))))

(set-frame-size-according-to-resolution)

(show-paren-mode 1)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;;; Ignored extensions
(add-to-list 'completion-ignored-extensions ".hi")
(add-to-list 'completion-ignored-extensions ".o")
(add-hook 'ido-setup-hook (setq ido-ignore-extensions t))
(add-hook 'ido-setup-hook (lambda ()
			   (add-to-list 'ido-ignore-files "\\.hi")
                           (add-to-list 'ido-ignore-files "\\.o")))



;;; Helm
(require 'helm-config)
;;(helm-autoresize-mode 1)

(add-hook 'helm-mode-hook
          (lambda ()
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; use TAB for action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions
(setq
 helm-candidate-number-limit 25
 helm-quick-update t
 helm-M-x-requires-pattern 3 ; Require at least one character
 helm-ff-file-name-history-use-recentf t
 helm-ff-skip-boring-files t
 ; helm-idle-delay 0.0
 ; helm-input-idle-delay 0.01

 ;; Use Spotlight on OS X to find files
 helm-locate-command
 "mdfind -onlyin $HOME -name %s %s | grep -E -v '/dist/|/Caches/'"
 helm-mini-default-sources '(helm-source-buffers-list
                             helm-source-recentf
                             helm-source-buffer-not-found
                             helm-source-locate))))

(helm-mode t)

;; helm-swoop
(add-to-list 'load-path "~/.emacs.d/helm-swoop")
(require 'helm-swoop)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-s") 'helm-swoop)

;; mu4e - maildir mode. Packaged by OS
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)
(setq
 mu4e-maildir "~/Mail"
 mu4e-sent-folder "/utf8.me/INBOX.Sent Items"
 mu4e-drafts-folder "/utf8.me/INBOX.Drafts"
 mu4e-trash-folder "/utf8.me/INBOX.Trash"
 mu4e-refile-folder "/utf8.me/INBOX.Archive")
(setq mu4e-prefer-html t)
  ;;; message view action
    (defun mu4e-msgv-action-view-in-browser (msg)
      "View the body of the message in a web browser."
      (interactive)
      (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
            (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
        (unless html (error "No html part for this message"))
        (with-temp-file tmpfile
        (insert
            "<html>"
            "<head><meta http-equiv=\"content-type\""
            "content=\"text/html;charset=UTF-8\">"
           html))
        (browse-url (concat "file://" tmpfile))))
    (add-to-list 'mu4e-view-actions
      '("View in browser" . mu4e-msgv-action-view-in-browser) t)


;; Tramp
(setq tramp-default-method "ssh")

;; Force file associations for markdown-mode
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; shut up magit
(setq magit-last-seen-setup-instructions "1.4.0")

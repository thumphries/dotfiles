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


(show-paren-mode 1)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
; (setq default fill-column 120)

;; Color theming and the like
;; (require 'color-theme)
;; (color-theme-initialize)
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; (load-theme 'assemblage t)


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

;; Font stuff
(set-face-attribute 'default nil :height 120)
;; (print (font-family-list))
;;(set-frame-font "Terminus (TTF)" nil t)
;;(set-frame-font "Menlo" nil t)
;;(set-frame-font "Essential PragmataPro" nil t)
;; (set-frame-font "ProggyCleanTTSZ" nil t)
;(set-frame-font "PragmataPro" nil t)
;(set-frame-font "Input Mono Narrow" nil t)
;; (setq-default line-spacing 0.1)

(setq mouse-autoselect-window t)
;(setq focus-follows-mouse nil)


(require 'org)
(require 'org-journal)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

;; Set up org dir
(setq org-dir "~/Documents/org/")
(setq org-journal-dir "~/Documents/journal/")
;; Point org-agenda at the org-dir
(setq org-agenda-files (list org-dir org-journal-dir))


; AutoRefill mode to enforce paragraphs (defun toggle-autorefill
(add-hook 'org-mode-hook (lambda () (auto-fill-mode 1)))
;; Enable Agda-style unicode input for Org
(add-hook 'org-mode-hook (lambda () (set-input-method "TeX")))

;; Enable FAILURE
(setq org-todo-keywords
       '((sequence "TODO" "|" "DONE" "NOPE")))

;; Fine-grained TODO logging
(setq org-log-done t)
(setq org-log-into-drawer t)

;; Keep DONE items out of agenda view
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-dim-blocked-tasks t)
(setq org-enforce-todo-dependencies t)

;; Keep SCHEDULED items out of agenda view until date
(setq org-agenda-todo-ignore-scheduled 'future)

;; Set agenda timestamp appearance
(setq org-agenda-deadline-leaders
      '("Deadline:  " "DUE  %3dd: " "LATE  %2dd: "))
(setq org-agenda-scheduled-leaders
      '("Scheduled: " "AVAIL %2dd: "))

;; Add INBOX and other contexts to agenda pop-up
(setq org-agenda-custom-commands
      '(("i" "INBOX" tags "-{^@}/!" nil)))

;; Global keyword set
(setq org-todo-keywords
      '((type "TODO(!)" "DOING(!)" "|" "DONE(!)" "WONTDO(@)" "IMPOSSIBLE(@)")))

;; org-journal
;; Give all journal files a .org suffix, triggering org-mode
(setq org-journal-file-format "%Y%m%d.org")
;; Match date.org files for the calendar view
(setq org-journal-file-pattern
      "^\\(?1:[0-9]\\{4\\}\\)\\(?2:[0-9][0-9]\\)\\(?3:[0-9][0-9]\\).org$")

;; ghc-mod
;(autoload 'ghc-init "ghc" nil t)
;(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;; (add-hook 'haskell-mode-hook (lambda () (ghc-init)))
;; (setq ghc-display-error 'minibuffer)

;; company-mode
(add-hook 'after-init-hook 'global-company-mode)
;; company-ghc
;; (add-hook 'company-mode-hook (lambda () (add-to-list 'company-backends 'company-ghc)))
(setq company-idle-delay 2)

;; Structured Haskell Mode
;; (add-to-list 'load-path "/Users/tim/.emacs.d/shm")
;; (require 'shm)
;; (add-hook 'haskell-mode-hook 'structured-haskell-mode)

;; recentf for recent file list
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; popwin
(require 'popwin)
(popwin-mode 1)

;; Disable backups~ and #autosave#
(setq auto-save-default nil)
(setq make-backup-files nil)

;; magic numbers ahoy - frame size dependent on display resolution
;; subtract a bit for OS X menubar
;; (defun set-frame-size-according-to-resolution ()
;;   (interactive)
;;   (if (display-graphic-p)
;;   (progn
;;     (let ((h (/ (- (x-display-pixel-height) 50) (frame-char-height)))
;;  	  (w (if (> (x-display-pixel-width) 1440) 120 80)))
;;  	     (set-frame-size (selected-frame) w h)))))

;; (set-frame-size-according-to-resolution)

;;;; Ignored extensions
(add-to-list 'completion-ignored-extensions ".hi")
(add-to-list 'completion-ignored-extensions ".o")
(add-hook 'ido-setup-hook (setq ido-ignore-extensions t))
(add-hook 'ido-setup-hook (lambda ()
			   (add-to-list 'ido-ignore-files "\\.hi")
                           (add-to-list 'ido-ignore-files "\\.o")))


;;; projectile
(projectile-global-mode)
(setq projectile-enable-caching t)
(setq projectile-completion-system 'helm)


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
(require 'helm-swoop)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-s") 'helm-swoop)
(global-set-key (kbd "C-x C-r") 'helm-recentf)

(setq tramp-default-method "ssh")

;; markdown mode on markdown files
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

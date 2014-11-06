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
                                      erc-mode))

(defadvice linum-on (around linum-on-inhibit-for-modes)
  "Stop the load of linum-mode for some major modes."
    (unless (member major-mode linum-mode-inhibit-modes-list)
      ad-do-it))

(ad-activate 'linum-on)

(global-linum-mode 1)
(setq linum-format " %d ") ; Default formatting has no spacing

;; Show trailing whitespace in all prog-modes
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; CUA mode for selection / mutation / etc.
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;; Color theming and the like
(require 'color-theme)
(color-theme-initialize)

;; Foreground and background colors should be distinct from the color scheme
(add-to-list 'default-frame-alist '(foreground-color . "#C0C0C0"))
(add-to-list 'default-frame-alist '(background-color . "#171717"))

;; Window management bindings
(global-set-key (kbd "C-x C-1") 'delete-other-windows)
(global-set-key (kbd "C-x C-2") 'split-window-below)
(global-set-key (kbd "C-x C-3") 'split-window-right)
(global-set-key (kbd "C-x C-0") 'delete-window)

;; Better cursor type
(setq cursor-type 'bar)

;; Different cursor styles when in insert mode
;(defun my-update-cursor ()
;  (setq cursor-type (if (or god-local-mode buffer-read-only)
;                        'box
;                      'bar)))

;(add-hook 'god-mode-enabled-hook 'my-update-cursor)
;(add-hook 'god-mode-disabled-hook 'my-update-cursor)

;; This auto-reloads modified files.
(global-auto-revert-mode t)

;; Flycheck
;;(require 'flycheck)

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
 '(agda2-include-dirs (quote ("/Users/tim/src/agda-prelude/src"  "/Users/tim/src/lib-0.7"  ".")))
 '(erc-modules (quote (autojoin button completion fill keep-place list match menu move-to-prompt netsplit networks noncommands notifications readonly ring scrolltobottom stamp track))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Font stuff
(set-face-attribute 'default nil :height 120)
;;(print (font-family-list))
(set-frame-font "Terminus" nil t)
(setq-default line-spacing 0.1)

(setq mouse-autoselect-window t)
;(setq focus-follows-mouse nil)

(require 'org-journal)

;; AutoRefill mode to enforce paragraphs (defun toggle-autorefill
(add-hook 'org-mode-hook (lambda () (auto-fill-mode 1)))
;; Enable Agda-style unicode input for Org
(add-hook 'org-mode-hook (lambda () (set-input-method "TeX")))

;; ghc-mod
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; company-mode
(add-hook 'after-init-hook 'global-company-mode)
;; company-ghc
(add-hook 'company-mode-hook (lambda () (add-to-list 'company-backends 'company-ghc)))
(setq company-idle-delay 0)

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


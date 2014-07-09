(setq user-full-name "Johan Gall")

;--------------------
;--- for emacs 24+ --
;--------------------

;--- packages
(progn
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/")
			   ("melpa" . "http://melpa.milkbox.net/packages/")))
  (package-initialize)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (defvar my-packages '(auto-complete
			grizzl
			smex
			smartparens
			rainbow-delimiters
			projectile
			nrepl
			evil
			god-mode
			evil-god-state))
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(evil-mode 1)
; C-z switches between modes (states in evil parlance)
(evil-define-key 'normal global-map "," 'evil-execute-in-god-state)

;-------------------
;--- basic stuff ---
;-------------------
(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)

;--- Backup files
(setq backup-directory-alist
`((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
`((".*" ,temporary-file-directory t)))

;--- no tabs
(setq c-basic-indent 2)
(setq tab-width 4)
(setq indent-tabs-mode nil)

(ido-mode t)
(ido-everywhere t)
(recentf-mode 1)

;---
(global-set-key "\M- " 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
	try-expand-dabbrev-all-buffers
	try-expand-dabbrev-from-kill try-complete-file-name-partially
	try-complete-file-name try-expand-all-abbrevs
	try-expand-list
	try-expand-line
	try-complete-lisp-symbol-partially
	try-complete-lisp-symbol))

;--- REINDENT!
(define-key global-map (kbd "RET") 'reindent-then-newline-and-indent)

;-------------------
;-------------------

(setq projectile-completion-system 'grizzl)
;(fix-ido-mode t)
;(setq fix-ido-use-faces nil)

(show-paren-mode 1)

;--- regular auto-complete initialization
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(setq ac-delay 0.0)
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 0.05)
(setq ac-use-fuzzy 1)
(setq ac-auto-start 1)
(setq ac-auto-show-menu 1)
(ac-config-default)

(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

; --- projectile (find files in projects)
(projectile-global-mode)
(setq projectile-show-paths-function 'projectile-hashify-with-relative-paths)
(global-set-key (kbd "M-p") 'projectile-find-file)
(global-set-key (kbd "M-o") 'recentf-open-files)

; --- clojure and nrepl hooks for autocompletion and my custom fun
(defvar lisp-mode-hooks
  '(clojure-mode-hook
    clojurescript-mode-hook
    clojure-nrepl-mode-hook
    emacs-lisp-mode-hook
    ielm-mode-hook
    lisp-mode-hook
    lisp-interaction-mode-hook
    geiser-repl-mode-hook
    scheme-mode-hook))

(dolist (h lisp-mode-hooks)
  (add-hook h 'lisp-custom))

(defun lisp-custom ()
  (require 'smartparens-config)
  (smartparens-strict-mode)
  (rainbow-delimiters-mode)
  ;--- navigation
  (local-set-key (kbd "C-f") 'sp-forward-sexp)
  (local-set-key (kbd "M-f") 'sp-backward-sexp)
  (local-set-key (kbd "ESC <up>") 'sp-up-sexp)
  (local-set-key (kbd "ESC <down>") 'sp-down-sexp)
  ;--- manipultation
  (local-set-key (kbd "ESC C-<right>") 'sp-forward-slurp-sexp)
  (local-set-key (kbd "ESC C-<left>") 'sp-forward-barf-sexp)
  ;--- custom entry stuff
  (local-set-key (kbd "<f1>") 'insert-parentheses)
  (local-set-key (kbd "<f2>") 'insert-quote-char))

;--- nrepl
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(add-hook 'clojure-nrepl-mode-hook 'ac-nrepl-setup)

(defun insert-quote-char ()
  (insert-char #x0027)) ; codepoint for ' <- simple quote


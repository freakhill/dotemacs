(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (adwaita)))
 '(global-ede-mode t)
 '(inhibit-startup-screen t)
 '(semantic-mode t)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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
			evil-god-state
                        everything))
  (defun autoinstall ()
    (dolist (p my-packages)
      (when (not (package-installed-p p))
        (package-install p))))
  (condition-case nil
      (autoinstall)
    (error (progn
             (package-refresh-contents)
             (autoinstall)))))

;--------------------------------------- end of autoinstall --------------------

(evil-mode 1)
; C-z switches between modes (states in evil parlance)
(evil-define-key 'normal global-map "," 'evil-execute-in-god-state)

;-------------------
;--- basic stuff ---
;-------------------
(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)

(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode) ; me no liek

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;--- Backup files
(setq backup-directory-alist
`((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
`((".*" ,temporary-file-directory t)))

;--- no tabs
(setq c-basic-indent 2)
(setq tab-width 4)
(setq indent-tabs-mode nil)

;--- ido, recentf, lacarte, hippie-expand, ibuffer, occur
(ido-mode t)
(ido-everywhere t)

(recentf-mode 1)
(setq recentf-max-menu-items 25)

(require 'lacarte)
(global-set-key (kbd "ESC M-x") 'lacarte-execute-command)

(autoload 'ibuffer "ibuffer" "List buffers." t)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-o") 'occur)

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

;--- projectile (find files in projects)
(projectile-global-mode)
(setq projectile-show-paths-function 'projectile-hashify-with-relative-paths)
(global-set-key (kbd "C-p") 'projectile-find-file)
(global-set-key (kbd "C-o") 'recentf-open-files)

;--------------------------------------- all my coding from here ---------------

;--------------
;--- Haskell --
;--------------

; todo

;-----------
;--- Rust --
;-----------

; todo

;------------
;--- Ocaml --
;------------

; todo

;------------
;--- Shell --
;------------

; todo -- i don't know if there is much emacs stuff for that

;-----------
;--- JAVA --
;-----------

; for now i prefer eclipse...

;-----------
;--- Ruby --
;-----------

(add-hook 'ruby-mode-hook 'robe-mode)

;-----------
;--- LISP --
;-----------

;--- clojure and nrepl hooks for autocompletion and my custom fun
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
  ;--- navigation (just merge macos and windows config, will have to
  ; work on refining that!)
  (local-set-key (kbd "C-f") 'sp-forward-sexp)
  (local-set-key (kbd "M-f") 'sp-backward-sexp)
  (local-set-key (kbd "ESC <up>") 'sp-up-sexp)
  (local-set-key (kbd "ESC <down>") 'sp-down-sexp)
  (define-key sp-keymap (kbd "M-<left>") 'sp-backward-sexp)
  (define-key sp-keymap (kbd "M-<right>") 'sp-forward-sexp)
  (define-key sp-keymap (kbd "M-<up>") 'sp-up-sexp)
  (define-key sp-keymap (kbd "M-<down>") 'sp-down-sexp)
  ;--- manipultation
  (local-set-key (kbd "ESC C-<right>") 'sp-forward-slurp-sexp)
  (local-set-key (kbd "ESC C-<left>") 'sp-forward-barf-sexp)
  ;--- custom entry stuff
  (local-set-key (kbd "<f1>") 'insert-parentheses)
  (local-set-key (kbd "<f2>") 'insert-quote-char)
  (local-set-key (kbd "C-:") 'insert-parentheses)
  (local-set-key (kbd "C-;") 'insert-parentheses))

;--- nrepl
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(add-hook 'clojure-nrepl-mode-hook 'ac-nrepl-setup)

(defun insert-quote-char ()
  (insert-char #x0027)) ; codepoint for ' <- simple quote

(defun my-reindent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(setq nrepl-hide-special-buffers t)
;(setq cider-popup-stacktraces nil)
;(setq cider-repl-popup-stacktraces t)
(setq nrepl-popup-stacktraces-in-repl t)
(setq nrepl-history-file "~/nrepl-history.dat")

;-------------------------------------------- os customization from here--------

;-----------------------
;--- OS customization --
;-----------------------

(defun macos-custom ()
  )

(defun windows-custom ()
  (setq everything-use-ftp t)
  (setq everything-host "127.0.0.1")
  (setq everything-port 22222)
  (setq everything-user "emacs")
  ; that should not be on github but... oh well... please don't try to
  ; find me t_t...
  (setq everything-pass "I have made a ceaseless effort not to ridicule, not to bewail, not to scorn human actions, but to understand them.")
  (global-set-key (kbd "C-x f") 'everything-find-file))

(defun linux-custom ()
  )

(cond
 ((string-match "darwin" system-configuration)
  (message "customizing GNU Emacs for MacOS")
  (macos-custom))
 ((string-match "linux" system-configuration)
  (message "customizing GNU Emacs for Linux")
  (linux-custom))
 ((string-match "nt6" system-configuration)
  (message "customizing GNU Emacs for Win 7")
  (windows-custom)))

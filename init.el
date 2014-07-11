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

;TODO!
; need to automate:
; cabal install ghc-mod
; cabal install ariadne
; cabal install stylish-haskell
; cabal install hlint
; cabal install hdevtools

;--------------------
;--- for emacs 24+ --
;--------------------

(defun ensure-dir (d)
  (unless (file-exists-p d)
    (make-directory d)))

(defvar my-save-dir "~/.emacs.d/save")
(ensure-dir my-save-dir)

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
                        ido-ubiquitous
                        flx-ido
			smex
                        undo-tree
			smartparens
			rainbow-delimiters
			projectile
                        helm
                        helm-projectile
			nrepl
			evil
			god-mode
			evil-god-state
                        everything
                        haskell-mode
                        ghci-completion
                        ariadne
                        company-ghc
                        rust-mode
                        exec-path-from-shell
                        vkill
                        utop
                        tuareg))
  (defun autoinstall ()
    (dolist (p my-packages)
      (when (not (package-installed-p p))
        (package-install p))))
  (condition-case nil
      (autoinstall)
    (error (progn
             (package-refresh-contents)
             (autoinstall)))))

;--- extra files
(progn
  (defconst dl-dir "~/.emacs.d/dl")
  (ensure-dir dl-dir)
  (add-to-list 'load-path dl-dir)
  (defvar url "https://raw.githubusercontent.com/buzztaiki/auto-complete/master/ac-company.el")
  (defvar filename (concat dl-dir "/" "ac-company.el"))
  (defvar module-name 'ac-company)
  (defun download-load-remote-module (url filename module-name)
    (unless (file-exists-p filename)
      (url-copy-file url filename))
    (require module-name))
  (ignore-errors
    download-load-remote-module url filename module-name))

;--------------------------------------- end of autoinstall --------------------

;--- evil

; C-z switches between modes (states in evil parlance)
(setq evil-mode-line-format 'before)
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-custor '("gray" box))
(setq evil-visual-state-cursor '("gray" box))
(setq evil-insert-state-cursor '("gray" bar))
(setq evil-motion-state-cursor '("gray" box))

(evil-mode 1)

(evil-set-initial-state 'magit-log-edit-mode 'emacs)
(evil-set-initial-state 'nav-mode 'emacs)
(evil-set-initial-state 'grep-mode 'emacs)
(evil-set-initial-state 'ibuffer-mode 'emacs)

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
	try-expand-dabbrev-from-kill
        try-complete-file-name-partially
	try-complete-file-name
        try-expand-all-abbrevs
	try-expand-list
	try-expand-line
	try-complete-lisp-symbol-partially
	try-complete-lisp-symbol))

;--- REINDENT!
(define-key global-map (kbd "RET") 'reindent-then-newline-and-indent)

;--- set firefox as browser
;(setq browse-url-browser-function 'browse-url-generic
;      browse-url-generic-program "firefox")
; fix it to be multiplatform

;-------------------
;-------------------

(setq projectile-completion-system 'grizzl)
;(fix-ido-mode t)
;(setq fix-ido-use-faces nil)

(show-paren-mode 1)

;--- regular auto-complete initialization
(require 'auto-complete-config)
(progn
  (defconst my-ac-dict-dir "~/.emacs.d/ac-dict")
  (ensure-dir my-ac-dict-dir)
  (add-to-list 'ac-dictionary-directories my-ac-dict-dir))
(progn
  (setq ac-delay 0.0)
  (setq ac-use-quick-help t)
  (setq ac-quick-help-delay 0.05)
  (setq ac-use-fuzzy t)
  (setq ac-auto-start 1)
  (setq ac-auto-show-menu t)
  (ac-config-default))

;--- smex and ido (picked from prelude)
(require 'ido)
(require 'ido-ubiquitous)
(require 'flx-ido)

(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-max-prospects 10
      ido-save-directory-list-file (expand-file-name "ido.hist" my-save-dir)
      ido-default-file-method 'selected-window
      ido-auto-merge-work-directories-length -1)
(ido-mode +1)
(ido-ubiquitous-mode +1)
; smarter fuzzy matching for ido
(flx-ido-mode +1)
; disable ido faces to see flx highlights
(setq ido-use-faces nil)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;--- projectile (find files in projects)

(require 'projectile)
(require 'helm)
(require 'helm-projectile)

(defun my-open-files ()
  "picked from https://www.youtube.com/watch?v=qpv9i_I4jYU -> mr. Renn Seo"
  (interactive)
  (if (projectile-project-p)
      (helm-projectile)
    (helm-for-files)))

(projectile-global-mode)
(setq projectile-show-paths-function 'projectile-hashify-with-relative-paths)
(global-set-key (kbd "C-o") 'my-open-files)
(global-set-key (kbd "C-p") 'recentf-open-files)

;--- undo-tree
(global-set-key (kbd "C-c C-u") 'undo-tree-visualize)
(global-set-key (kbd "C-c C-g") 'magit-status)
;--------------------------------------- all my coding from here ---------------

;--------------
;--- Haskell --
;--------------

(add-hook 'inferior-haskell-mode-hook 'turn-on-ghci-completion)

(add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

(custom-set-variables '(haskell-stylish-on-save t))

(define-key haskell-mode-map (kbd "C-c C-g") 'ariadne-goto-definition)
(custom-set-variables  '(haskell-process-suggest-remove-import-lines t)
                       '(haskell-process-auto-import-loaded-modules t)
                         '(haskell-process-log t))
(define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
(define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
(define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
(define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
(define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
(define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
(define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)
;(define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
;(define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
;(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
;(define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)

(custom-set-variables  '(haskell-process-type 'cabal-repl))
;(custom-set-variables  '(haskell-process-type 'ghci))

;-----------
;--- Rust --
;-----------

; todo

;------------
;--- Ocaml --
;------------

;--- picked up from github manzyuk/emacs-preamble thingies
(autoload 'utop "utop" "Toplevel for OCaml" t)
(setq utop-command "opam config exec \"utop -emacs\"")
(add-to-list 'auto-mode-alist '("\\.ml[ily]?$" . tuareg-mode))

(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
;(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)

(add-hook 'tuareg-mode-hook
          (lambda ()
            (define-key tuareg-mode-map (kbd "C-c C-s" 'tuareg-run-caml))))

;------------
;--- Shell --
;------------

(defun set-shell-to-bash ()
  (setq shell-file-name "bash")
  (setq explicit-shell-file-name shell-file-name))
; used in the os customization part

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
(defconst lisp-mode-hooks
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

(defun my-swap-meta-and-super ()
  "picked from emacs prelude"
  (interactive)
  (if (eq mac-command-modifier 'super)
      (progn
        (setq mac-command-modifier 'meta)
        (setq mac-option-modifier 'super)
        (message "Command is now bound to META and Option is bound to SUPER."))
    (progn
      (setq mac-command-modifier 'meta)
      (setq mac-option-modifier 'super)
      (message "Command is now bound to SUPER and Option is bound to META."))))

(defun macos-custom ()
  (set-shell-to-bash)
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize)
  (setq ns-function-modifier 'hyper)
  (autoload 'vkill "vkill" nil t)
  ; from prelude, proced mode doesnt work on macos
  (global-set-key (kbd "C-x p") 'vkill)
  (global-set-key (kbd "s-/") 'hippie-expand)
  (global-set-key (kbd "C-c w") 'my-swap-meta-and-super))

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
  (set-shell-to-bash))

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

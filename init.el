(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (tango-dark)))
 '(global-ede-mode t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type (quote cabal-repl))
 '(haskell-stylish-on-save t)
 '(inhibit-startup-screen t)
 '(semantic-mode t)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;TODO!
;; need to automate:
;; cabal install ghc-mod
;; cabal install ariadne
;; cabal install stylish-haskell
;; cabal install hlint
;; cabal install hdevtools

;;--------------------
;;--- for emacs 24+ --
;;--------------------

(defun my-basic-init ()
  ;;(desktop-save-mode t)
  (show-paren-mode t)
  (semantic-mode t)

  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

  (blink-cursor-mode -1)

  (setq scroll-margin 0
        scroll-conservatively 100000
        scroll-preserve-screen-position 1)
  
  (defalias 'yes-or-no-p 'y-or-n-p)
  
  (setq large-file-warning-threshold 100000000)
  (defconst backup-dir "~/.backups")
  (my-ensure-dir backup-dir)
  
  (setq inhibit-startup-message t)
  (setq inhibit-startup-echo-area-message t)
  
  (setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))
  (setq
   make-backup-files t
   backup-by-copying t
   version-control t
   delete-old-versions t
   kept-old-versions 6
   kept-new-versions 9
   auto-save-default t
   auto-save-timeout 20
   auto-save-interval 200)
  
  (setq
   dired-recursive-copies 'always
   dired-recursive-deletes 'top
   dired-listing-switches "-lha")

  (add-hook 'dired-mode-hook 'auto-revert-mode)
  
  (setq c-basic-indent 2)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (global-set-key (kbd "C-l") 'goto-line)
  (global-set-key (kbd "M-,") 'point-to-register)
  (global-set-key (kbd "C-,") 'jump-to-register)

  (define-key global-map (kbd "RET") 'reindent-then-newline-and-indent))

;; one day, rewrite emacs in rust, with a better VM, an optional
;; embedded V8, and generally easier way to integrate other languages!
;; And FASTER, FASTER, FASTER!

(defun my-ensure-dir (d)
  (unless (file-exists-p d)
    (make-directory d)))

(defun my-ensure-save-dir ()
  (defvar my-save-dir "~/.emacs.d/save")
  (my-ensure-dir my-save-dir))

;;--- packages
(defun my-ensure-packages ()
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/")
			   ("melpa" . "http://melpa.milkbox.net/packages/")))
  (package-initialize)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (defvar my-packages '(auto-complete
                        ido-ubiquitous
                        ibuffer-vc
                        workgroups2
                        flycheck
                        flycheck-tip
                        flycheck-haskell
                        flycheck-hdevtools
                        nyan-mode
                        golden-ratio
                        recentf-ext
                        dired+
                        vlf
                        diff-hl
                        flx-ido
			grizzl
			smex
                        undo-tree
                        yasnippet
                        auto-yasnippet
			smartparens
			rainbow-delimiters
			nrepl
			projectile
                        helm
                        helm-projectile
			evil
			god-mode
			evil-god-state
                        powerline
                        powerline-evil
                        everything
                        haskell-mode
                        ghci-completion
                        ariadne
                        company-ghc
                        rust-mode
                        exec-path-from-shell
                        vkill
                        discover-my-major
                        utop
                        tuareg))
  (let ((not-yet-installed '()))
    (mapcar (lambda (pkg) (when (not (package-installed-p pkg))
                       (push pkg not-yet-installed)))
	    my-packages)
    (when (not (eq (length not-yet-installed) 0))
      (package-refresh-contents)
      (dolist (pkg not-yet-installed) (package-install pkg)))))

;;--- extra files
(defun my-load-extra-files ()
  (defconst dl-dir "~/.emacs.d/dl")
  (my-ensure-dir dl-dir)
  (add-to-list 'load-path dl-dir)
  (defvar url "https://raw.githubusercontent.com/buzztaiki/auto-complete/master/ac-company.el")
  (defvar filename (concat dl-dir "/" "ac-company.el"))
  (defvar module-name 'ac-company)
  (defun my-download-load-remote-module (url filename module-name)
    (unless (file-exists-p filename)
      (url-copy-file url filename))
    (require module-name))
  (ignore-errors
    my-download-load-remote-module url filename module-name))

(defun my-discover-my-major ()
  (define-key 'help-command (kbd "C-m") 'discover-my-major))

(defun my-evil ()
  ;; C-z switches between modes (states in evil parlance)
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

  (require 'powerline)
  (require 'powerline-evil)
  (powerline-evil-vim-color-theme))

(defun my-windmove ()
  (when (fboundp 'windmove-default-keybindings)
    (windmove-default-keybindings)))

(defun my-recentf ()
  (require 'recentf-ext)
  (recentf-mode 1)
  (setq recentf-max-menu-items 25)
  (setq recentf-max-saved-items 5000))

(defun my-ibuffer ()
  (autoload 'ibuffer "ibuffer" "List buffers." t)
  (global-set-key (kbd "C-c C-b") 'ibuffer)
  (setq ibuffer-use-other-window t)
  (add-hook 'ibuffer-hook
            (lambda () (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))
  (setq ibuffer-formats
        '((mark modified read-only vc-status-mini " "
                (name 18 18 :left :elide)
                " "
                (size 9 -1 :right)
                " "
                (mode 16 16 :left :elide)
                " "
                (vc-status 16 16 :left)
                " "
                filename-and-process))))

(defun my-hippie ()
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
          try-complete-lisp-symbol)))

;;--- set firefox as browser
;;(setq browse-url-browser-function 'browse-url-generic
;;      browse-url-generic-program "firefox")
;; fix it to be multiplatform

(defun my-auto-complete ()
  (require 'auto-complete-config)
  (progn
    (defconst my-ac-dict-dir "~/.emacs.d/ac-dict")
    (my-ensure-dir my-ac-dict-dir)
    (add-to-list 'ac-dictionary-directories my-ac-dict-dir))
  (progn
    (setq ac-delay 0.0)
    (setq ac-use-quick-help t)
    (setq ac-quick-help-delay 0.05)
    (setq ac-use-fuzzy t)
    (setq ac-auto-start 1)
    (setq ac-auto-show-menu t)
    (ac-config-default)))

(defun my-ido ()
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
  ;; smarter fuzzy matching for ido
  (flx-ido-mode +1)
  ;; disable ido faces to see flx highlights
  (setq ido-use-faces nil))

(defun my-flycheck ()
  (require 'flycheck)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (require 'flycheck-tip)
  (flycheck-tip-use-timer 'verbose))

(defun my-golden-ratio ()
  (eval-after-load "golden-ratio"
    '(progn
       (add-to-list 'golden-ratio-exclude-modes "ediff-mode")
       (add-to-list 'golden-ratio-exclude-modes "helm-mode")
       (add-to-list 'golden-ratio-exclude-modes "dired-mode")
       (add-to-list 'golden-ratio-inhibit-functions 'pl/helm-alive-p)))
       ;(add-to-list 'golden-ratio-inhibit-functions 'pl/ediff-comparison-buffer-p)))
  ;(defun pl/ediff-comparison-buffer-p () ediff-this-buffer-ediff-sessions)
  (defun pl/helm-alive-p () (if (boundp 'helm-alive-p) (symbol-value 'helm-alive-p)))
  (setq golden-ratio-exclude-modes '("ediff-mode"
                                     "gdb-locals-mode"
                                     "gdb-frame-modes"
                                     "gud-mode"
                                     "gdb-inferior-io-mode"
                                     "magit-log-mode"
                                     "magit-reflog-mode"
                                     "magit-status-mode"
                                     "eshell-mode"
                                     "dired-mode"))
  (golden-ratio-mode))

(defun my-smex ()
  (require 'smex)
  (smex-initialize)
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands))

(defun my-helm-and-projectile ()
  (require 'helm)
  (require 'projectile)
  (require 'helm-projectile)
  
  (defun my-open-files ()
    "picked from https://www.youtube.com/watch?v=qpv9i_I4jYU -> mr. Renn Seo"
    (interactive)
    (if (projectile-project-p)
        (helm-projectile)
      (helm-mini)))
  
  (global-set-key (kbd "C-x x") 'helm-M-x)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-c C-i") 'helm-semantic-or-imenu)
  (global-set-key (kbd "C-c C-o") 'helm-occur)
  (global-set-key (kbd "C-c C-r") 'helm-all-mark-rings)
  
  (global-set-key (kbd "C-o") 'my-open-files)
  (global-set-key (kbd "C-x C-f" ) 'helm-find-files)
  
  (projectile-global-mode)
  (setq projectile-completion-system 'grizzl)
  (setq projectile-show-paths-function 'projectile-hashify-with-relative-paths))

(defun my-undo-tree ()
  (global-set-key (kbd "C-c C-u") 'undo-tree-visualize))

(defun my-magit ()
  (global-set-key (kbd "C-c C-g") 'magit-status))

(defun my-diff-hl ()
  (global-diff-hl-mode)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode))

(defun my-dired+ ()
  (require 'dired+))

(defun my-vlf ()
  (require 'vlf-integrate)
  (setq vlf-application 'dont-ask))

(defun my-workgroups2 ()
  (require 'workgroups2)
  (setq wg-prefix-key (kbd "C-c C-w"))
  (setq wg-default-session-file (concat "~/.emacs.d/.emacs_workgroups_" system-name))
  (workgroups-mode 1))

(defun my-yasnippet ()
  (require 'yasnippet)
  (require 'auto-yasnippet)
  (global-set-key (kbd "C-c C-c") 'aya-create)
  (global-set-key (kbd "C-c C-v") 'aya-expand))

(defun my-haskell ()
  (add-hook 'inferior-haskell-mode-hook 'turn-on-ghci-completion)
  
  (add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  
  (custom-set-variables '(haskell-stylish-on-save t))
  
  (define-key haskell-mode-map (kbd "C-c C-d") 'ariadne-goto-definition)
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
  ;;(define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
  ;;(define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  ;;(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  ;;(define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)
  
  (custom-set-variables  '(haskell-process-type 'cabal-repl))
  ;;(custom-set-variables  '(haskell-process-type 'ghci))
  )                                        

(defun my-rust ()
  )

(defun my-ocaml ()
  (autoload 'utop "utop" "Toplevel for OCaml" t)
  (setq utop-command "opam config exec \"utop -emacs\"")
  (add-to-list 'auto-mode-alist '("\\.ml[ily]?$" . tuareg-mode))
  
  (autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
  ;;(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
  (autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
  (add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
  
  (add-hook 'tuareg-mode-hook
            (lambda ()
              (define-key tuareg-mode-map (kbd "C-c C-s" 'tuareg-run-caml)))))

(defun my-shell ()
  (defun my-set-shell-to-bash ()
    (setq shell-file-name "bash")
    (setq explicit-shell-file-name shell-file-name)))

(defun my-java ()
  ;; eclipse!
  )

(defun my-ruby ()
  (add-hook 'ruby-mode-hook 'robe-mode))

(defun my-lisp ()
  ;;--- clojure and nrepl hooks for autocompletion and my custom fun
  (defconst my-lisp-mode-hooks
    '(clojure-mode-hook
      clojurescript-mode-hook
      clojure-nrepl-mode-hook
      emacs-lisp-mode-hook
      ielm-mode-hook
      lisp-mode-hook
      lisp-interaction-mode-hook
      geiser-repl-mode-hook
      scheme-mode-hook))

  (dolist (h my-lisp-mode-hooks)
    (add-hook h 'my-lisp-custom))

  (defun my-lisp-custom ()
    (interactive)
    (require 'smartparens-config)
    (smartparens-strict-mode)
    (rainbow-delimiters-mode)
    ;;--- navigation (just merge macos and windows config, will have to
    ;; work on refining that!)
    (local-set-key (kbd "C-f") 'sp-forward-sexp)
    (local-set-key (kbd "M-f") 'sp-backward-sexp)
    (local-set-key (kbd "ESC <up>") 'sp-up-sexp)
    (local-set-key (kbd "ESC <down>") 'sp-down-sexp)
    (define-key sp-keymap (kbd "M-<left>") 'sp-backward-sexp)
    (define-key sp-keymap (kbd "M-<right>") 'sp-forward-sexp)
    (define-key sp-keymap (kbd "M-<up>") 'sp-up-sexp)
    (define-key sp-keymap (kbd "M-<down>") 'sp-down-sexp)
    ;;--- manipulattion
    (local-set-key (kbd "ESC C-<right>") 'sp-forward-slurp-sexp)
    (local-set-key (kbd "ESC C-<left>") 'sp-forward-barf-sexp)
    ;;--- custom entry stuff
    (local-set-key (kbd "<f1>") 'insert-parentheses)
    (local-set-key (kbd "<f2>") 'my-insert-quote-char)
    (local-set-key (kbd "C-:") 'insert-parentheses)
    (local-set-key (kbd "C-;") 'insert-parentheses))

  ;;--- nrepl
  (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
  (add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
  (add-hook 'clojure-nrepl-mode-hook 'ac-nrepl-setup)

  (defun my-insert-quote-char ()
    (insert-char #x0027)) ; codepoint for ' <- simple quote

  (defun my-insert-parentheses ()
    (insert-char 40))
  
  (setq nrepl-hide-special-buffers t)
  ;;(setq cider-popup-stacktraces nil)
  ;;(setq cider-repl-popup-stacktraces t)
  (setq nrepl-popup-stacktraces-in-repl t)
  (setq nrepl-history-file "~/nrepl-history.dat"))

(defun my-os-custom ()
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
  
  (defun my-macos-custom ()
    (my-set-shell-to-bash)
    (require 'exec-path-from-shell)
    (exec-path-from-shell-initialize)
    (setq ns-function-modifier 'hyper)
    (autoload 'vkill "vkill" nil t)
    (setq dired-listing-switches "-lha --group-directories-first")
    ;; from prelude, proced mode doesnt work on macos
    (global-set-key (kbd "C-x p") 'vkill)
    (global-set-key (kbd "s-/") 'hippie-expand)
    (global-set-key (kbd "C-c w") 'my-swap-meta-and-super))
  
  (defun my-windows-custom ()
    (setq everything-use-ftp t)
    (setq everything-host "127.0.0.1")
    (setq everything-port 22222)
    (setq everything-user "emacs")
    ;; that should not be on github but... oh well... please don't try to
    ;; find me t_t...
    (setq everything-pass "I have made a ceaseless effort not to ridicule, not to bewail, not to scorn human actions, but to understand them.")
    (global-set-key (kbd "C-x f") 'everything-find-file))
  
  (defun my-linux-custom ()
    (setq dired-listing-switches "-lha --group-directories-first")
    (my-set-shell-to-bash))
  
  (cond
   ((string-match "darwin" system-configuration)
    (message "customizing GNU Emacs for MacOS")
    (my-macos-custom))
   ((string-match "linux" system-configuration)
    (message "customizing GNU Emacs for Linux")
    (my-linux-custom))
   ((string-match "nt6" system-configuration)
    (message "customizing GNU Emacs for Win 7")
    (my-windows-custom))))

(defun my-init()
  ;; --- before loading external packages
  (my-basic-init)
  (my-ensure-save-dir)
  ;; -- getting external packages
  (my-ensure-packages)
  (my-load-extra-files)
  ;; -- configuring global packages
  (my-discover-my-major)
  (my-evil)
  (my-windmove)
  (my-recentf)
  (my-ibuffer)
  (my-hippie)
  (my-auto-complete)
  ;; -- configuring ide packages
  (my-ido)
  (my-smex)
  (my-flycheck)
  (my-helm-and-projectile)
  (my-diff-hl)
  (my-undo-tree)
  (my-magit)
  (my-yasnippet)
  (my-workgroups2)
  (my-dired+)
  (my-golden-ratio)
  ;; -- configuring language specific packages
  (my-haskell)
  (my-rust)
  (my-ocaml)
  (my-shell)
  (my-ruby)
  (my-java)
  (my-lisp)
  ;; -- os specific customization
  (my-os-custom))

(my-init)

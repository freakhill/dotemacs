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
 '(inhibit-startup-screen t)
 '(semantic-mode t)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(shm-current-face ((t (:background "green"))))
 '(shm-quarantine-face ((t (:background "yellow")))))

;;TODO!
;; need to automate:
;; cabal install ariadne
;; cabal install hlint
;; cabal install hdevtools

;;--------------------
;;--- for emacs 24+ --
;;--------------------

(defun my-ensure-dir (d)
  (unless (file-exists-p d)
    (make-directory d)))

(defvar my-save-dir "~/.emacs.d/save")
(defvar my-temp-dir "~/.emacs.d/tmp")

(defun my-ensure-save-dir ()
  (my-ensure-dir my-save-dir))

(defun my-ensure-temp-dir ()
  (my-ensure-dir my-temp-dir))

(defun my-basic-init ()
  ;;(desktop-save-mode t)
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  (setq inhibit-startup-message t)
  (setq inhibit-startup-echo-area-message t)

  (blink-cursor-mode -1)

  (setq scroll-margin 0
        scroll-conservatively 100000
        scroll-preserve-screen-position 1)

  (defalias 'yes-or-no-p 'y-or-n-p)
  (show-paren-mode t)
  (semantic-mode t)

  (setq large-file-warning-threshold 100000000)
  (defconst backup-dir "~/.backups")
  (my-ensure-dir backup-dir)

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

  (define-key global-map (kbd "RET") 'reindent-then-newline-and-indent)

  (setq tramp-default-method "ssh")

  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*")

  (setq initial-major-mode 'lisp-interaction-mode
	redisplay-dont-pause t
	column-number-mode t
	echo-keystrokes 0.02
	inhibit-startup-message t
	transient-mark-mode t
	shift-select-mode nil
	require-final-newline t
	truncate-partial-width-windows nil
	delete-by-moving-to-trash nil
	confirm-nonexistent-file-or-buffer nil
	query-replace-highlight t
	next-error-highlight t
	next-error-highlight-no-select t)
  ;;set all coding systems to utf-8
  (set-language-environment 'utf-8)
  (set-default-coding-systems 'utf-8)
  (setq locale-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)

  (set-default 'indent-tabs-mode nil)
  (auto-compression-mode t)
  (show-paren-mode 1)

  ;; make emacs use the clipboard
  (setq x-select-enable-clipboard t)
  ;;remove all trailing whitespace and trailing blank lines before
  ;;saving the file
  (defvar live-ignore-whitespace-modes '(markdown-mode))
  (defun live-cleanup-whitespace ()
    (if (not (member major-mode live-ignore-whitespace-modes))
	(let ((whitespace-style '(trailing empty)) )
	  (whitespace-cleanup))))
  (add-hook 'before-save-hook 'live-cleanup-whitespace)
  ;; savehist keeps track of some history
  (setq savehist-additional-variables
	;; search entries
	'(search ring regexp-search-ring)
	;; save every minute
	savehist-autosave-interval 60
	;; keep the home clean
	savehist-file (concat my-temp-dir "savehist"))
  (savehist-mode t))

;; one day, rewrite emacs in rust, with a better VM, an optional
;; embedded V8, and generally easier way to integrate other languages!
;; And FASTER, FASTER, FASTER!

(defun my-highlight-tail ()
  (highlight-tail-mode t))

;;--- packages
(defun my-ensure-packages ()
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/")
			   ("melpa" . "http://melpa.milkbox.net/packages/")))
  (package-initialize)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (defvar my-packages '(auto-complete
			auto-install
			auto-compile
			expand-region
			ace-jump-mode
			ace-jump-buffer
			multiple-cursors
                        ido-ubiquitous
                        ibuffer-vc
                        flycheck
                        flycheck-tip
                        flycheck-haskell
                        flycheck-hdevtools
                        nyan-mode
                        golden-ratio
                        recentf-ext
			popwin
                        dired+
                        vlf
                        diff-hl
                        flx-ido
			grizzl
			smex
                        undo-tree
                        yasnippet
                        auto-yasnippet
			js3-mode
			markdown-mode
                        typed-clojure-mode
                        cljdoc
                        clj-refactor
                        clojure-cheatsheet
                        clojure-mode-extra-font-locking
			smartparens
			rainbow-delimiters
			nrepl
			csharp-mode
			omnisharp
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
                        shm ;; structured haskell mode
                        ghci-completion
			highlight-tail
                        ariadne
                        company-ghc
                        rust-mode
                        exec-path-from-shell
                        vkill
                        discover-my-major
                        utop
                        merlin
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

(defun my-ace-jump-mode ()
  ;;
  ;; ace jump mode major function
  ;;
  (add-to-list 'load-path "/full/path/where/ace-jump-mode.el/in/")
  (autoload  'ace-jump-mode
	      "ace-jump-mode"
	      "Emacs quick move minor mode"
	      t)
  ;; you can select the key you prefer to
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)



  ;;
  ;; enable a more powerful jump back function from ace jump mode
  ;;
  (autoload  'ace-jump-mode-pop-mark
	      "ace-jump-mode"
	      "Ace jump back:-)"
	      t)
  (eval-after-load "ace-jump-mode"
    '(ace-jump-mode-enable-mark-sync))
  (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

  (define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode))

(defun my-ace-jump-buffer ()
  )

(defun my-expand-region ()
  (require 'expand-region)
  (global-set-key (kbd "C-@") 'er/expand-region))

(defun my-multiple-cursors ()
  (require 'multiple-cursors)
  (global-set-key (kbd "C-.") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-,") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-,") 'mc/mark-all-like-this))

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


(defun my-auto-compile ()
  (require 'auto-compile)
  (auto-compile-on-load-mode 1)
  (auto-compile-on-save-mode 1))

(defun my-popwin ()
  (require 'popwin)
  (setq display-buffer-function 'popwin:display-buffer)
  (setq popwin:special-display-config
	'(("*Help*" :height 30)
	  ("*Completions*" :noselect t)
	  ("*Messages*" :noselect t :height 30)
	  ("*Apropos*" :noselect t :height 30)
	  ("*compilation*" :noselect t)
	  ("*Backtrace*" :height 30)
	  ("*Messages*" :height 30)
	  ("*Occur*" :noselect t)
	  ("*Ido Completions*" :noselect t :height 30)
	  ("*magit-commit*" :noselect t :height 40 :width 80 :stick t)
	  ("*magit-diff*" :noselect t :height 40 :width 80)
	  ("*magit-edit-log*" :noselect t :height 15 :width 80)
	  ("\\*ansi-term\\*.*" :regexp t :height 30)
	  ("*shell*" :height 30)
	  (".*overtone.log" :regexp t :height 30)
	  ("*gists*" :height 30)
	  ("*sldb.*":regexp t :height 30)
	  ("*cider-error*" :height 30 :stick t)
	  ("*cider-doc*" :height 30 :stick t)
	  ("*cider-src*" :height 30 :stick t)
	  ("*cider-result*" :height 30 :stick t)
	  ("*cider-macroexpansion*" :height 30 :stick t)
	  ("*Kill Ring*" :height 30)
	  ("*Compile-Log*" :height 30 :stick t)
	  ("*git-gutter:diff*" :height 30 :stick t)))
  (defun live-show-messages ()
    (interactive)
    (popwin:display-buffer "*Messages*"))
  (defun live-display-messages ()
    (interactive)
    (popwin:display-buffer "*Messages*"))
  (defun live-display-ansi ()
    (interactive)
    (popwin:display-buffer "*ansi-term*")))

(defun my-markdown ()
  (require 'markdown-mode)
  (autoload 'markdown-mode "markdown-mode.el"
    "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown" . markdown-mode)))

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
  (require 'undo-tree)
  (global-undo-tree-mode)
  (global-set-key (kbd "C-c C-u") 'undo-tree-visualize))

(defun my-magit ()
  (add-hook 'magit-log-edit-mode-hook
	     (lambda ()
	       (set-fill-column 72)
	       (auto-fill-mode 1)))
  (global-set-key (kbd "C-c C-g") 'magit-status))

(defun my-diff-hl ()
  (global-diff-hl-mode)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode))

(defun my-dired+ ()
  (require 'dired+))

(defun my-vlf ()
  (require 'vlf-integrate)
  (setq vlf-application 'dont-ask))

'(defun my-workgroups2 ()
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
  ;; cabal install hdevtools structured-haskell-mode ghci-ng hlint ariadne
  (add-hook 'haskell-mode-hook 'structured-haskell-mode)

  (eval-after-load 'flycheck '(require 'flycheck-hdevtools))
  (eval-after-load 'haskell-mode '(require 'ariadne))

  ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-unicode-input-method)

  (add-hook 'inferior-haskell-mode-hook 'turn-on-ghci-completion)
  (add-hook 'inferior-haskell-mode-hook 'haskell-auto-insert-module-template)
  (add-hook 'inferior-haskell-mode-hook 'turn-on-haskell-doc-mode)

  ;;(custom-set-variables '(haskell-stylish-on-save t))

  (define-key haskell-mode-map (kbd "C-c C-d") 'ariadne-goto-definition)

  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-c i") 'haskell-interactive-bring)
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

  (custom-set-variables  '(haskell-process-suggest-remove-import-lines t)
                         '(haskell-process-auto-import-loaded-modules t)
                         '(haskell-process-log t))

  (custom-set-variables  '(haskell-process-type 'cabal-repl))
  ;;(custom-set-variables  '(haskell-process-type 'ghci))
  )

(defun my-rust ()
  (autoload 'rust-mode "rust-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

(defun my-ocaml ()
  (autoload 'utop "utop" "Toplevel for OCaml" t)
  (setq utop-command "opam config exec \"utop -emacs\"")
  (add-to-list 'auto-mode-alist '("\\.ml[ily]?$" . tuareg-mode))

  (autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
  ;;(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
  (autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
  (autoload 'merlin-mode "merlin" "Merlin mode" t)
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  (add-hook 'caml-mode-hook 'merlin-mode)
  (add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)

  (add-hook 'tuareg-mode-hook
            (lambda ()
              (define-key tuareg-mode-map (kbd "C-c C-s" 'tuareg-run-caml)))))

(defun my-js ()
  '(js3-auto-indent-p t)
  '(js3-enter-indent-newline t)
  '(js3-indent-on-enter-key t))

(defun my-shell ()
  (defun my-set-shell-to-bash ()
    (setq shell-file-name "bash")
    (setq explicit-shell-file-name shell-file-name)))

(defun my-java ()
  ;; eclipse!
  )

(defun my-ruby ()
  (add-hook 'ruby-mode-hook 'robe-mode)
  (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Thorfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.thor$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode)))

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
    (require 'clojure-mode-extra-font-locking)
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
    (local-set-key (kbd "C-<right>") 'sp-forward-slurp-sexp)
    (local-set-key (kbd "C-<left>") 'sp-forward-barf-sexp)
    ;;--- custom entry stuff
    (local-set-key (kbd "<f2>") 'my-insert-quote-char)
    (local-set-key (kbd "C-:") 'insert-parentheses)
    (local-set-key (kbd "C-;") 'insert-parentheses))

  ;;--- nrepl
  (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
  (add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
  (add-hook 'clojure-nrepl-mode-hook 'ac-nrepl-setup)
  (add-hook 'clojure-mode-hook 'typed-clojure-mode)


  (defun my-insert-quote-char ()
    (interactive)
    (insert-char #x0027)) ; codepoint for ' <- simple quote

  (defun my-insert-parentheses ()
    (interactive)
    (insert-char 40))

  (setq nrepl-hide-special-buffers t)
  ;;(setq cider-popup-stacktraces nil)
  ;;(setq cider-repl-popup-stacktraces t)
  (setq nrepl-popup-stacktraces-in-repl t)
  (setq nrepl-history-file "~/nrepl-history.dat"))

(defun my-csharp ()
  (autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
  (setq auto-mode-alist
        (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))
  (add-hook 'csharp-mode-hook 'omnisharp-mode)
  (eval-after-load 'company-css  '(add-to-list 'company-backends 'company-omnisharp)))

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
    (global-set-key (kbd "C-c w") 'my-swap-meta-and-super)
    ;; Work around a bug on OS X where system-name is a fully qualified
    ;; domain name
    (setq system-name (car (split-string system-name "\\.")))
    ;; Ignore .DS_Store files with ido mode
    (add-to-list 'ido-ignore-files "\\.DS_Store"))

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
  (my-ace-jump-mode)
  (my-ace-jump-buffer)
  (my-expand-region)
  ;;(my-multiple-cursors)
  (my-windmove)
  (my-ibuffer)
  (my-hippie)
  (my-auto-complete)
  (my-popwin)
  (my-auto-compile)
  ;; -- configuring ide packages
  (my-recentf)
  (my-ido)
  (my-smex)
  (my-flycheck)
  (my-helm-and-projectile)
  (my-diff-hl)
  (my-undo-tree)
  (my-magit)
  (my-yasnippet)
  ;; (my-workgroups2)
  (my-dired+)
  ;; (my-golden-ratio)
  ;; -- configuring language specific packages
  (my-haskell)
  (my-rust)
  (my-ruby)
  (my-ocaml)
  (my-js)
  (my-shell)
  (my-ruby)
  (my-java)
  (my-lisp)
  (my-csharp)
  (my-markdown)
  ;; -- os specific customization
  (my-os-custom)
  ;; other
  (my-highlight-tail))

(my-init)

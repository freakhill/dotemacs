(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes (quote ("26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2" "f0b0710b7e1260ead8f7808b3ee13c3bb38d45564e369cbe15fc6d312f0cd7a0" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9" "b71d5d49d0b9611c0afce5c6237aacab4f1775b74e513d8ba36ab67dfab35e5a" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default)))
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages))
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
 '(diff-added ((t (:foreground "Green"))))
 '(diff-removed ((t (:foreground "Red"))))
 '(ediff-even-diff-A ((((class color) (background dark)) (:background "dark green"))) t)
 '(ediff-even-diff-B ((((class color) (background dark)) (:background "dark red"))) t)
 '(ediff-odd-diff-A ((((class color) (background dark)) (:background "dark green"))) t)
 '(ediff-odd-diff-B ((((class color) (background dark)) (:background "dark red"))) t)
 '(mumamo-background-chunk-major ((((class color) (background dark)) (:background "black"))) t)
 '(mumamo-background-chunk-submode1 ((((class color) (background dark)) (:background "black"))) t)
 '(shm-current-face ((t (:background "green" :foreground "black"))) t)
 '(shm-quarantine-face ((t (:background "yellow"))) t))

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
  (put 'narrow-to-region 'disabled nil)

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
  (savehist-mode t)

  (require 'midnight)

  ;; C-x r j E -- to edit my config file
  (set-register ?E `(file . ,user-init-file)))

;; one day, rewrite emacs in my custom lisp
;; And FASTER, FASTER, FASTER!

;;--- packages
(defun my-ensure-packages ()
  (setq package-archives '(("gnu"       . "http://elpa.gnu.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/")
			   ("melpa"     . "http://melpa.milkbox.net/packages/")))
  (package-initialize)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (defvar my-packages '(;; --- themes
                        color-theme
                        color-theme-library
                        monokai-theme
                        zenburn-theme
                        ;; --- mode line
                        smart-mode-line
                        smart-mode-line-powerline-theme
                        ;; --- evil
			evil
                        evil-terminal-cursor-changer
                        evil-numbers
                        evil-surround
			god-mode
			evil-god-state
                        ;; --- completion
                        ;;auto-complete
                        company
                        browse-kill-ring
                        bbyac
                        ;;yasnippet
                        ;;auto-yasnippet
                        guide-key
                        ;; --- flycheck
                        flycheck
                        flycheck-clojure
                        flycheck-pos-tip
                        ;; --- projectile
                        org-projectile
                        ;; --- git
                        magit
                        git-gutter-fringe
                        git-timemachine
                        git-messenger
                        ;; --- ace
			ace-jump-mode
			ace-jump-buffer
                        ;; --- irc
                        rcirc
                        rcirc-color
			rainbow-delimiters
                        ac-cider
                        ac-cider-compliment
			projectile
                        ;; --- helm
                        helm
                        helm-ag
                        helm-make
                        helm-swoop
                        helm-themes
                        helm-projectile
                        helm-mode-manager
                        ;; --- lisp
			smartparens
                        emr
                        paxedit
                        slime
                        ac-slime
                        slime-repl
                        ;; --- clojure
                        slamhound
                        clojure-mode
                        clojure-mode-extra-font-locking
                        cider
                        cider-profile
                        clj-refactor
                        squiggly-clojure
                        typed-clojure-mode
                        cljdoc
                        align-cljlet
                        ;; --- elisp
			;;auto-compile
                        ;; --- racket
                        racket-mode
                        ;; --- rust
                        rust-mode
                        ;; --- c#
			csharp-mode
			omnisharp
                        ;; --- android
                        android-mode
                        ;; --- markdown
			markdown-mode
                        ;; --- various stuff
			smex                  ;;
                        discover-my-major     ;;
                        ido-ubiquitous        ;;
                        flx-ido               ;;
                        ibuffer-vc            ;;
                        dired+                ;;
                        fancy-narrow          ;;
                        epl                   ;;
                        pkg-info              ;;
                        undo-tree             ;; undo tree
                        clipmon               ;; clipboard monitor
                        fill-column-indicator ;;
			multiple-cursors      ;;
                        restclient            ;; rest client
                        json-reformat         ;; json reformatter
                        recentf-ext           ;;
                        buffer-move           ;;
			expand-region         ;;
			popwin                ;;
                        vlf                   ;;
                        diff-hl               ;;
			grizzl                ;;
                        dash                  ;; lib
                        s                     ;; lib
                        exec-path-from-shell  ;;
                        vkill                 ;; view and kill Unix processes
                        rich-minority         ;; hide/highlists list of minor modes
                        highlight             ;;
                        hl-anything           ;;
                        framesize             ;;
                        window-numbering      ;;
                        elmacro               ;; save macros as emacs lisp
                        tiny                  ;; generates linear ranges
                        deft                  ;; quicknote tool sync through my dropbox
                        ))
  (let ((not-yet-installed '()))
    (mapcar (lambda (pkg) (when (not (package-installed-p pkg))
                            (push pkg not-yet-installed)))
	    my-packages)
    (when (not (eq (length not-yet-installed) 0))
      (package-refresh-contents)
      (dolist (pkg not-yet-installed) (with-demoted-errors
                                          "Package install error: %S"
                                        (package-install pkg))))))

;;--- extra files
(defun my-load-extra-files ()
  (let
      ((dl-dir              "~/.emacs.d/dl")
       (ac-dict-dir         "~/.emacs.d/ac-dict")
       (dl-and-load         (lambda (dir url filename &optional module-name)
                              (let ((filename (concat dir "/" filename))
                                    (message (concat "loat extra file: " filename)))
                                (unless (file-exists-p filename)
                                  (url-copy-file url filename))
                                (when module-name
                                  (if (symbolp module-name)
                                      (require module-name)
                                    (load module-name))))))
       (dl-and-load-mode    (lambda (&rest r) (apply dl-and-load (cons dl-dir r))))
       (dl-and-load-ac-dict (lambda (&rest r) (apply dl-and-load (cons ac-dict-dir r)))))
    (my-ensure-dir dl-dir)
    (my-ensure-dir ac-dict-dir)
    (add-to-list 'load-path dl-dir)
    (-each ;; packages
        '(("https://raw.githubusercontent.com/buzztaiki/auto-complete/master/ac-company.el"
           "ac-company.el"
           ac-company)
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/colour-pack/lib/cyberpunk.el"
           "cyberpunk.el"
           "cyberpunk")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/colour-pack/lib/gandalf.el"
           "gandalf.el"
           "gandalf")
          ("http://www.emacswiki.org/emacs-en/download/wide-n.el"
           "wide-n.el"
           wide-n)
          ("http://webonastick.com/emacs-lisp/hide-mode-line.el"
           "hide-mode-line.el"
           hide-mode-line))
      (lambda (pkg)
        (condition-case e
            (apply dl-and-load-mode pkg)
          ((debug error) e))))
    (-each ;; ac-dict dictionaries
        '(("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/c-mode"
           "c-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/caml-mode"
           "caml-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/clojure-mode"
           "clojure-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/clojurescript-mode"
           "clojurescript-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/css-mode"
           "css-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/go-mode"
           "go-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/haskell-mode"
           "haskell-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/java-mode"
           "java-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/javascript-mode"
           "javascript-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/python-mode"
           "python-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/lua-mode"
           "lua-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/ruby-mode"
           "ruby-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/scheme-mode"
           "scheme-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/sh-mode"
           "sh-mode")
          ("https://raw.githubusercontent.com/overtone/emacs-live/master/packs/stable/clojure-pack/lib/auto-complete/dict/tuareg-mode"
           "tuareg-mode"))
      (lambda (dict) (condition-case e
                         (apply dl-and-load-ac-dict dict)
                       ((debug-error) e))))))

(defun my-auto-package-update ()
  (setq auto-package-update-interval 3))

(defun my-discover-my-major ()
  (define-key 'help-command (kbd "C-m") 'discover-my-major))

(defun my-buffer-move ()
  (global-set-key (kbd "C-c <up>") 'buf-move-up)
  (global-set-key (kbd "C-c <down>") 'buf-move-down)
  (global-set-key (kbd "C-c <left>") 'buf-move-left)
  (global-set-key (kbd "C-c <right>") 'buf-move-right))

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
  ;;(require 'powerline)
  ;;(require 'powerline-evil)
  ;;(powerline-evil-vim-color-theme)
  (evil-define-key 'normal global-map (kbd "M") 'evil-goto-mark-line))

(defun my-evil-numbers ()
  (global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
  (global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt))

(defun my-evil-surround ()
  (require 'evil-surround)
  (global-evil-surround-mode 1))

(defun my-modeline ()
  (require 'rich-minority)
  (require 'smart-mode-line)
  (sml/setup)
  (sml/apply-theme 'powerline)
  (setq sml/shorten-modes t
        sml/shorten-directory t)
  (add-to-list 'rm-blacklist '("SkelC" "UndoTree" "Projectile.*" "AC" "SP" "SP/s" "ht"))
  (hide-mode-line))

(defun my-hl-anything ()
  ;; TODO
  )

(defun my-bbyac ()
  (require 'bbyac)
  (bbyac-global-mode 1))

(defun my-ace-jump ()
  ;;
  ;; ace jump mode major function
  ;;
  (autoload  'ace-jump-mode
    "ace-jump-mode"
    "Emacs quick move minor mode"
    t)
  ;; you can select the key you prefer to
  ;; (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

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
  (global-set-key (kbd "C-b") 'ace-jump-buffer)
  (define-key evil-normal-state-map "b" 'ace-jump-buffer))

(defun my-help-swoop ()
  (define-key evil-normal-state-map "s" 'helm-swoop))

(defun my-window-numbering ()
  (window-numbering-mode t)
  (setq window-numbering-assign-func
        (lambda () (when (equal (buffer-name) "*scratch*") 0))))

(defun my-mouse ()
  ;; Mouse in terminal
  (require 'mouse)
  ;; mouse mode must be initialised for each new terminal
  ;; see http://stackoverflow.com/a/6798279/27782
  (defun initialise-mouse-mode (&optional frame)
    "Initialise mouse mode for the current terminal."
    (if (not frame) ;; The initial call.
        (xterm-mouse-mode 1)
      ;; Otherwise called via after-make-frame-functions.
      (if xterm-mouse-mode
          ;; Re-initialise the mode in case of a new terminal.
          (xterm-mouse-mode 1))))
  ;; Evaluate both now (for non-daemon emacs) and upon frame creation
  ;; (for new terminals via emacsclient).
  (initialise-mouse-mode)
  (add-hook 'after-make-frame-functions 'initialise-mouse-mode)
  ;;(setq mouse-yank-at-point t)
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1))))

(defun my-expand-region ()
  ;;(require 'expand-region)
  (global-set-key (kbd "C-SPC") 'er/expand-region))

(defun my-nyan ()
  (nyan-mode t))

(defun my-gnus ()
  ;; stuff picked from www.xsteve.at/prg/gnus
  (setq gnus-select-method '(nntp "news.gmane.org"))
  (setq gnus-use-adaptive-scoring t)
  (setq gnus-score-expiry-days 14)
  (setq gnus-default-adaptive-score-alist
        '((gnus-unread-mark)
          (gnus-ticked-mark (from 4))
          (gnus-dormant-mark (from 5))
          (gnus-saved-mark (from 20) (subject 5))
          (gnus-del-mark (from -2) (subject -5))
          (gnus-read-mark (from 2) (subject 1))))
  (setq gnus-score-decay-constant 1)
  (setq gnus-score-decay-scale 0.03)
  (setq gnus-decay-scores t)

  (setq gnus-global-score-files '("~/Dropbox/gnus/all.SCORE"))
  (setq gnus-summary-expunge-below -999)

  (add-hook 'message-sent-hook 'gnus-score-followup-article)
  (add-hook 'message-sent-hook 'gnus-score-followup-thread)

  (setq gnus-directory "~/Dropbox/gnus")
  (setq message-directory "~/Dropbox/gnus/mail")
  (setq nnml-directory "~/Dropbox/gnus/nnml-mail")
  (setq gnus-article-save-directory "~/Dropbox/gnus/saved")
  (setq gnus-kill-files-directory "~/Dropbox/gnus/scores")
  (setq gnus-cache-directory "~/Dropbox/gnus/cache")

  (setq gnus-summary-line-format "%O%U%R%z%d %B%(%[%4L: %-22,22f%]%) %s\n")
  (setq gnus-summary-mode-line-format "Gnus: %p [%A / Sc:%4z] %Z")

  (setq gnus-summary-same-subject "")
  (setq gnus-sum-thread-tree-root "")
  (setq gnus-sum-thread-tree-single-indent "")
  (setq gnus-sum-thread-tree-leaf-with-other "+-> ")
  (setq gnus-sum-thread-tree-vertical "|")
  (setq gnus-sum-thread-tree-single-leaf "`-> "))

(defun my-multiple-cursors ()
  ;;(require 'multiple-cursors)
  (global-set-key (kbd "C-c C-n") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-c C-p") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-SPC") 'mc/mark-all-like-this))

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
          ("*undo-tree*" :width 72 :heigth 40)
          ("*Completions*" :noselect t)
          ("*Messages*" :noselect t :height 30)
          ("*Apropos*" :noselect t :height 30)
          ("*compilation*" :noselect t)
          ("*Backtrace*" :height 30)
          ("*Messages*" :height 30)
          ("*HTTP Response*" :height 30)
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
          ("*git-gutter:diff*" :height 30 :stick t))))

(defun my-markdown ()
  ;;(require 'markdown-mode)
  (autoload 'markdown-mode "markdown-mode.el"
    "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown" . markdown-mode)))

(defun my-auto-complete ()
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
  (eval-after-load 'flycheck
    '(custom-set-variables
         '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))
  (add-hook 'after-init-hook #'global-flycheck-mode))

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
  (global-undo-tree-mode)
  (define-key undo-tree-map (kbd "C-/") 'undo-tree-visualize)
  (global-set-key (kbd "C-c C-u") 'undo-tree-visualize))

(defun my-magit ()
  (add-hook 'magit-log-edit-mode-hook
            (lambda ()
              (set-fill-column 72)
              (auto-fill-mode 1)))
  ;; ,cgs in god-mode
  (global-set-key (kbd "C-c M-s") 'magit-status))

(defun my-git-messenger ()
  ;; ,cgc in god-mode
  (global-set-key (kbd "C-c M-c") 'git-messenger:popup-message))

(defun my-git-timemachine ()
  (global-set-key (kbd "C-c M-h") 'git-timemachine))

(defun my-diff-hl ()
  (global-diff-hl-mode)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode))

(defun my-dired+ ()
  (require 'dired+)
  (quote (when (eq system-type 'darwin)
             (require 'ls-lisp)
             (setq ls-lisp-use-insert-directory-program nil))))

(defun my-vlf ()
  (require 'vlf-integrate)
  (setq vlf-application 'dont-ask))

(defun my-yasnippet ()
  (global-set-key (kbd "C-c C-c") 'aya-create)
  (global-set-key (kbd "C-c C-v") 'aya-expand)
  (evil-define-key 'insert global-map (kbd "C-<tab>") 'aya-open-line))

(defun my-guide-key ()
  (guide-key-mode t)
  (setq guide-key/recursive-key-sequence-flag t)
  (setq guide-key/guide-key-sequence '("C-x" "C-c")))

(defun my-android ()
  (cond
   ((string= system-name "W010391306024")
    (setq android-mode-sdk-dir "d:/adt-bundle-windows/sdk"))
   ((string= system-name "localhost.localdomain")
    (message "go not configured for my centos vm yet..."))))

(defun my-deft ()
  (setq deft-extension "org")
  (setq deft-directory "~/Dropbox/notes")
  (setq deft-text-mode 'org-mode)
  (setq deft-use-filename-as-title t))

(defun my-history ()
  ;; Add history just before `find-tag' executed.
  ;; (add-to-list 'history-advised-before-functions 'find-tag-noselect t)
  ;; Add history just before `find-file' executed.
  ;; (add-to-list 'history-advised-before-functions 'find-file-noselect t)
  (setq history-history-max 999)
  (history-mode))

(defun my-c++ ()
  (add-hook 'c++-mode (lambda ()
                        (local-set-key (kbd "C-c C-u") 'undo-tree-visualize))))

(defun my-rust ()
  (autoload 'rust-mode "rust-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

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

(defun my-emacs-refactor ()
  (define-key prog-mode-map (kbd "M-RET") 'emr-show-refactor-menu)
  (add-hook 'prog-mode-hook 'emr-initialize))

(defun my-fill-column-indicator ()
  (setq fci-rule-column 80)

  (defun my-fci-enabled-p () (symbol-value 'fci-mode))

  (defvar my-fci-mode-suppressed nil)
  (make-variable-buffer-local 'my-fci-mode-suppressed)

  (defadvice popup-create (before suppress-fci-mode activate)
    "Suspend fci-mode while popups are visible"
    (let ((fci-enabled (my-fci-enabled-p)))
      (when fci-enabled
        (setq my-fci-mode-suppressed fci-enabled)
        (turn-off-fci-mode))))

  (defadvice popup-delete (after restore-fci-mode activate)
    "Restore fci-mode when all popups have closed"
    (when (and my-fci-mode-suppressed
               (null popup-instances))
      (setq my-fci-mode-suppressed nil)
      (turn-on-fci-mode)))
  (add-hook 'prog-mode-hook (lambda () (fci-mode t))))

(defvar my-lisp-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (progn
      (define-key map (kbd "C-f") 'sp-forward-sexp)
      (define-key map (kbd "M-f") 'sp-backward-sexp)
      (define-key map (kbd "C-M-y") 'sp-copy-sexp)
      (define-key map (kbd "C-M-k") 'sp-kill-sexp)
      (define-key map (kbd "C-c C-s") 'sp-splice-sexp)
      (define-key map (kbd "ESC <up>") 'sp-up-sexp)
      (define-key map (kbd "ESC <down>") 'sp-down-sexp)
      (define-key map (kbd "C-<right>") 'sp-forward-slurp-sexp)
      (define-key map (kbd "C-<left>") 'sp-forward-barf-sexp)
      (define-key map (kbd "M-<left>") 'sp-backward-sexp)
      (define-key map (kbd "M-<right>") 'sp-forward-sexp)
      (define-key map (kbd "M-<up>") 'paxedit-backward-up)
      (define-key map (kbd "M-<down>") 'paxedit-backward-end))
    map)
  "Keymap used for `mylisp-minor-mode'.")

(define-minor-mode my-lisp-minor-mode
    "My custom made lisp minor mode."
    :init-value nil
    :lighter " mylisp"
    :group 'my-modes
    :keymap my-lisp-minor-mode-map
    (progn
      (require 'smartparens-config)
      (smartparens-strict-mode t)
      (paxedit-mode t)
      (rainbow-delimiters-mode t)
      (hs-minor-mode t)
      (evil-define-key 'normal my-lisp-minor-mode-map
        (kbd "C-f") 'sp-forward-sexp
        "K" 'paxedit-kill
        "Y" 'paxedit-copy
        "S" 'paxedit-context-new-statement
        "R" 'paxedit-sexp-raise
        "C" 'paxedit-wrap-comment
        "E" 'paxedit-macro-expand-replace
        "T" 'paxedit-transpose-forward)))

(defun my-clojure-custom ()
    (require 'clojure-mode-extra-font-locking)
    (require 'clj-refactor)
    (require 'icomplete) ;; for cider minibuffer completion
    (eval-after-load 'flycheck '(flycheck-clojure-setup))
    (clj-refactor-mode t)
    (flycheck-mode t)
    (cljr-add-keybindings-with-prefix "C-r")
    (local-set-key (kbd "C-c C-a") 'align-cljlet)
    ;; remove the cider bind that overshadows the git messenger bind
    (local-unset-key (kbd "C-c M-c")))

(defun my-lisp ()
  (dolist (h '(clojure-mode-hook
               clojurescript-mode-hook
               cider-mode-hook
               emacs-lisp-mode-hook
               ielm-mode-hook
               lisp-mode-hook
               lisp-interaction-mode-hook
               geiser-repl-mode-hook
               scheme-mode-hook
               racket-mode-hook))
    (add-hook h #'my-lisp-minor-mode))

  (dolist (h '(clojure-mode-hook
               clojurescript-mode-hook))
    (add-hook h 'my-clojure-custom))

  ;;--- cider
  (add-hook 'cider-mode-hook #'company-mode)
  (add-hook 'cider-repl-mode-hook #'company-mode)

  (add-hook 'cider-mode-hook #'eldoc-mode)
  (setq cider-repl-use-clojure-font-lock t)
  (setq cider-repl-tab-command #'indent-for-tab-command)
  (setq cider-prefer-local-resources t)
  (setq nrepl-log-messages t)
  ;;(setq cider-repl-pop-to-buffer-on-connect nil)

  ;;--- typed clojure mode
  (add-hook 'clojure-mode-hook #'typed-clojure-mode)

  (setq nrepl-hide-special-buffers t)
  (setq nrepl-popup-stacktraces-in-repl t)
  (setq nrepl-history-file "~/nrepl-history.dat")
  (add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode)))

(defun my-rtags ()
  (cond
   ((string= system-name "W010391306024")
    (progn
      ))
   ((string= system-name "localhost.localdomain")
    (progn
      (require 'cl-lib)
      (add-to-list 'load-path "~/rtags/src")
      (require 'rtags)
      (rtags-enable-standard-keybindings c-mode-base-map)
      (require 'company-rtags)))))

(defun my-racket ()
  (add-to-list 'auto-mode-alist '("\\.rkt$" . racket-mode))
  (cond
   ((string= system-name "W010391306024")
    (progn
      (setq racket-program "c:\Program Files\Racket\Racket.exe"
            raco-program "c:\Program Files\Racket\raco.exe")))
   ((string= system-name "localhost.localdomain")
    (progn
      (setq racket-program "/usr/local/bin/racket"
            raco-program "/usr/local/bin/raco")))))

(defun my-fancy-narrow ()
  (fancy-narrow-mode))

(defun my-chickenscheme ()
  (add-to-list 'auto-mode-alist '("\\.scm$" . scheme-mode))
  (setq geiser-mode-auto-p nil)
  (setq scheme-program-name "csi -:c")
  (when (string= system-name "localhost.localdomain")
    (add-to-list 'load-path "/usr/lib64/chicken/6")
    (autoload 'chicken-slime "chicken-slime" "SWANK backend for Chicken" t))
  (add-hook 'scheme-mode-hook (lambda () (auto-fill-mode t))))

(defun my-slime ()
  (setq slime-contribs '(slime-fancy slime-banner))
  (cond
   ((string= system-name "localhost.localdomain")
    (setq inferior-lisp-program "/usr/bin/sbcl")))
  (add-hook 'slime-mode-hook 'set-up-slime-ac)
  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
  (eval-after-load "auto-complete"
    '(add-to-list 'ac-modes 'slime-repl-mode)))

(defun my-csharp ()
  (autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
  (setq auto-mode-alist
        (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))
  (add-hook 'csharp-mode-hook 'omnisharp-mode)
  (eval-after-load 'company-css  '(add-to-list 'company-backends 'company-omnisharp)))

(defun my-os-custom ()

  ;;--- set firefox as browser
  ;;(setq browse-url-browser-function 'browse-url-generic
  ;;      browse-url-generic-program "firefox")
  ;; fix it to be multiplatform

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
    ;; (setq system-name (car (split-string system-name "\\.")))
    ;; Ignore .DS_Store files with ido mode
    (add-to-list 'ido-ignore-files "\\.DS_Store"))

  (defun my-windows-custom ()
    (server-start)
    (switch-to-buffer "*Messages*"))

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

(defun my-funcs ()
  (defun myfn-eval-last-sexp-with-value (value &optional prefix)
    (interactive "svalue: \nP")
    (cider-interactive-eval (s-concat "(" (cider-last-sexp) " " value " )")
                            (when prefix (cider-eval-print-handler))))
  (add-hook 'cider-mode-hook (lambda () (define-key cider-mode-map (kbd "C-c e") 'myfn-eval-last-sexp-with-value)))
  ;; ---
  (defun myfn-delete-region-if-uniq ()
    (interactive)
    (setq deactivate-mark t)
    (let ((p1 (region-beginning))
          (p2 (region-end)))
      (if (= 1 (count-matches (buffer-substring p1 p2)))
          (save-excursion
            (progn
              (delete-region p1 p2)
              (message "deleted region.")))
        (message "not unique!"))))
  ;; ---
  (defun myfn-narrow-indirect (start end)
    (interactive "r")
    (deactivate-mark)
    (let ((buf (clone-indirect-buffer nil nil)))
      (with-current-buffer buf
        (narrow-to-region start end)
        (switch-to-buffer buf))))
  (global-set-key (kbd "C-x n i") 'myfn-narrow-indirect))

(defmacro my-wordy (&rest prog)
  (cons 'progn
        (-mapcat (lambda (sexp)
                   (list (list 'message "running %s..." (list 'quote sexp))
                         sexp))
                 prog)))

(defun my-init()
  ;; -- getting external packages
  (message "PACKAGE LOADING!")
  (my-ensure-packages)

  (require 'dash)
  (dash-enable-font-lock)

  (my-wordy
   (my-load-extra-files)
   ;; --- and here we go!
   (my-basic-init)
   (my-ensure-save-dir)
   ;; -- configuring global packages
   (my-discover-my-major)
   (my-evil)
   (my-evil-numbers)
   (my-evil-surround)
   (my-ace-jump)
   (my-ace-jump-buffer)
   (my-help-swoop)
   (my-expand-region)
   (my-multiple-cursors)
   (my-windmove)
   (my-ibuffer)
   (my-hippie)
   ;;(my-auto-complete)
   (my-bbyac)
   (my-popwin)
   ;;(my-auto-compile)
   (my-buffer-move)
   (my-mouse)
   (my-window-numbering)
   ;; -- configuring ide packages
   (my-guide-key)
   (my-hl-anything)
   (my-recentf)
   (my-ido)
   (my-smex)
   (my-flycheck)
   (my-helm-and-projectile)
   (my-diff-hl)
   (my-undo-tree)
   (my-magit)
   (my-git-messenger)
   (my-git-timemachine)
   (my-yasnippet)
   (my-dired+)
   (my-fancy-narrow)
   (my-android)
   (my-fill-column-indicator)
   (my-emacs-refactor)
   (my-c++)
   (my-slime)
   (my-rtags)
   (my-racket)
   (my-rust)
   (my-ruby)
   (my-shell)
   (my-lisp)
   (my-csharp)
   (my-markdown)
   ;; -- os specific customization
   (my-os-custom)
   ;; other
   (my-deft)
   (my-funcs)
   (my-modeline)
   (my-gnus)
   (my-auto-package-update)))

(my-init)

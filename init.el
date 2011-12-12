;; ********************************************************************************
;; Load Path
;;
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/apel")
(add-to-list 'load-path "~/.emacs.d/erlang")
(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path "~/.emacs.d/icicles")
(add-to-list 'load-path "~/.emacs.d/js2-mode")
(add-to-list 'load-path "~/.emacs.d/nxml-mode")
(add-to-list 'load-path "~/.emacs.d/rhtml")
(add-to-list 'load-path "~/.emacs.d/ruby")
;; (add-to-list 'load-path "~/.emacs.d/Enhanced-Ruby-Mode")
(add-to-list 'load-path "~/.emacs.d/python")
(add-to-list 'load-path "~/.emacs.d/yasnippet")


;; ********************************************************************************
;; Requires

(require 'evil)
(require 'cl)
(require 'toggle)
(require 'icicles)
(require 'find-file-in-project)
(require 'browse-kill-ring)
(require 'etags-table)
(require 'etags-select)
(require 'session)
(require 'smart-compile)
(unless (boundp 'aquamacs-version)
  (require 'tabbar))

;; ********************************************************************************
;; Variables
;;
(fset 'yes-or-no-p 'y-or-n-p)
(setq case-fold-search t)
(setq enable-recursive-minibuffers nil)
(setq inhibit-startup-screen t)
(setq list-directory-verbose-switches "")
(setq nxml-slash-auto-complete-flag t)
(setq session-initialize t)
(setq standard-indent 2)
(setq tags-revert-without-query t)
(setq tab-width 4)
(setq toggle-mapping-style 'rspec)

(when (boundp 'aquamacs-version)
  (aquamacs-autoface-mode -1))

(evil-mode 1)
(icy-mode)

(setq toggle-mapping-styles
      '((rspec   . (("app/models/\\1.rb"      . "spec/models.\\1_spec.rb")
		    ("app/controllers/\\1.rb" . "spec/controllers/\\1_spec.rb")
		    ("app/views/\\1.rb"       . "spec/views/\\1_spec.rb")
		    ("app/helpers/\\1.rb"     . "spec/helpers/\\1_spec.rb")
		    ("spec/lib/\\1_spec.rb"   . "lib/\\1.rb")
		    ("lib/\\1.rb"             . "spec/lib/\\1_spec.rb")))
	(ruby    . (("lib/\\1.rb"             . "test/test_\\1.rb")
		    ("\\1.rb"                 . "test_\\1.rb")))))

(defvar autocomplete-initialized nil)

(defun init-autocomplete ()
  (require 'yasnippet)
  (require 'auto-complete-config)
  (require 'auto-complete-yasnippet)

  (yas/initialize)
  (yas/load-directory "~/.emacs.d/yasnippet/snippets")
  (yas/load-directory "~/.emacs.d/snippets/")
  (setq yas/trigger-key "TAB")
  (add-to-list 'ac-dictionary-directories (expand-file-name "~/.emacs.d/ac-dict"))
  (ac-config-default)
  (ac-set-trigger-key "TAB")
  (setq ac-auto-start nil)
  (global-auto-complete-mode t))

(defun init-mode ()
  (unless autocomplete-initialized
    (init-autocomplete)
    (setq autocomplete-initialized t))

  (add-hook 'before-save-hook 'untabify-buffer nil t)
  (setq indent-tabs-mode nil)
  (make-local-variable 'tags-file-name))

;; ********************************************************************************
;; Defuns

(defun lgrep-from-isearch ()
  (interactive)
  (let ((shk-search-string isearch-string))
    (grep-compute-defaults)
    (lgrep (if isearch-regexp shk-search-string (regexp-quote shk-search-string))
           (format "*.%s" (file-name-extension (buffer-file-name)))
           default-directory)
    (isearch-abort)))

(defun occur-from-isearch ()
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))

(define-key isearch-mode-map (kbd "C-O") 'lgrep-from-isearch)
(define-key isearch-mode-map (kbd "C-o") 'occur-from-isearch)

(defun popup-yank-menu()
  (interactive)
  (let ((x-y (posn-x-y (posn-at-point (point)))))
    (popup-menu 'yank-menu (list (list (+ (car x-y) 10)
                                       (+ (cdr x-y) 20))
                                 (selected-window)))))

(defun save-and-exit()
  (interactive)
  ;; (save-buffer)
  (save-buffers-kill-terminal))

(defun close-tab()
  (interactive)
  (let ((tabs (length (tabbar-tabs tabbar-current-tabset))))
    (kill-buffer (buffer-name))
    (if (= tabs 1)
	(if (boundp 'aquamacs-version)
	    (aquamacs-delete-window)
 	  (delete-frame)))))

(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun untabify-buffer ()
  (interactive)
  (save-excursion
    (untabify (point-min) (point-max))))


(defun sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))



(browse-kill-ring-default-keybindings)
(setq kill-ring-max 20)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Desktop
;; (desktop-save-mode t)
;; (setq desktop-globals-to-save nil)
;; (setq desktop-load-locked-desktop t)
;; (setq desktop-save t)

;; ********************************************************************************
;; ibuffer
;;
(setq ibuffer-default-sorting-mode 'major-mode)
(setq ibuffer-enable nil)
(setq ibuffer-expert t)

;; ********************************************************************************
;; Ido
;;
;; (ido-mode t)
;; (setq ido-case-fold t)
;; (setq ido-enable-flex-matching nil)
;; (setq ido-everywhere nil)
;; (setq ido-create-new-buffer 'always)
;; (setq ido-max-prospects 3)
;; (setq ido-enable-tramp-:completion nil)
;; (setq ido-separator "    ")
;; (setq ido-auto-merge-work-directories-length -1)
;; (setq ido-rotate-file-list-default t)
;; (load "ido-goto-symbol")

;; ********************************************************************************
;; I-Menu
;;
(setq imenu-auto-rescan t)
(setq imenu-sort-function 'imenu--sort-by-name)

;; Modes
(setq initial-major-mode 'text-mode)
(column-number-mode t)
(mouse-wheel-mode t)
(partial-completion-mode nil)
(show-paren-mode t)
(transient-mark-mode t)
(recentf-mode)

(if window-system
    (global-hl-line-mode t))

(unless window-system
  (menu-bar-mode 0))

(if (fboundp 'set-scroll-bar-mode)
    (set-scroll-bar-mode nil))

(setq scroll-conservatively 5)
(setq scroll-step 1)

(load "find-tags-file")

(set-face-attribute 'default nil
		    :background "black"
		    :foreground "grey90")

(set-face-attribute 'modeline nil
		    :background "grey10"
		    :foreground "grey90")

(if window-system
    (set-face-attribute 'hl-line nil
			:background "grey10"
			:foreground nil))

(set-face-attribute 'cursor nil
		    :background "white")

(set-face-attribute 'font-lock-builtin-face nil
		    :foreground "cyan")

(set-face-attribute 'font-lock-comment-face nil
		    :foreground "grey50")

(set-face-attribute 'font-lock-constant-face nil
		    :foreground "SkyBlue")

(set-face-attribute 'font-lock-keyword-face nil
		    :foreground "lightgreen")

(set-face-attribute 'font-lock-string-face nil
		    :foreground "chocolate1")

(set-face-attribute 'font-lock-variable-name-face nil
		    :foreground "lightblue")

(set-face-attribute 'font-lock-function-name-face nil
		    :foreground "green")

(set-face-attribute 'region nil
		    :background "blue")

(set-face-attribute 'icicle-search-context-level-1 nil
		    :background "black")


;; ********************************************************************************
;; Autoloads
;;
(autoload 'rdebug "rdebug" "ruby Debug" t)


;; ********************************************************************************
;; Tags
;;
(setq tags-add-tables nil)
(setq etags-table-search-up-depth 5)


;; ********************************************************************************
;; Session
;;
(setq session-initialize t)
(add-hook 'after-init-hook 'session-initialize)

;; ********************************************************************************
;; RI
;;
(setq ri-ruby-script (expand-file-name "~/.emacs.d/ruby/ri-emacs.rb"))
(autoload 'ri "~/.emacs.d/ruby/ri-ruby.el" nil t)


;; ********************************************************************************
;; Erlang Mode
;;
(autoload 'erlang-mode "erlang-mode.el" "Major mode for editing erlang files" t)
(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl\\'" . erlang-mode))


;; ********************************************************************************
;; Markdown Mode
;;
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;; ********************************************************************************
;; Python Mode
;;

(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))


;; ********************************************************************************
;; PHP Mode
;;

(autoload 'php-mode "php-mode" "PHP Mode." t)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'interpreter-mode-alist '("php" . php-mode))

(defun php-mode-on-init ()
  (init-mode)
  (setq tab-width 4)
  (setq c-basic-offset 4)
  (c-set-style "k&r")
  )

(add-hook 'php-mode-hook 'php-mode-on-init)



;; ********************************************************************************
;; Chuck Mode
;;

(autoload 'chuck-mode "chuck-mode" "Chuck Mode." t)
(add-to-list 'auto-mode-alist '("\\.ck\\'" . chuck-mode))


;; ********************************************************************************
;; Erlang Mode
;;
(add-to-list 'auto-mode-alist '("\\.yaws\\'" . erlang-mode))



;; ********************************************************************************
;; Ruby Mode
;;

(setq enh-ruby-program "/Users/soundcloud/.rvm/rubies/ruby-1.9.2-p290/bin/ruby")

(add-to-list 'auto-mode-alist  '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist  '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist  '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist  '("\\.rake$" . ruby-mode))

(defun spec-run-single-file (spec-file &rest opts)
  "Runs spec with the specified options"
  (compile (concat "~/.emacs.d/spin " spec-file " " (mapconcat (lambda (x) x) opts " ")))
  (end-of-buffer-other-window 0))

(defun spec-verify ()
  "Runs the specified spec for the current buffer."
  (interactive)
  (spec-run-single-file (buffer-file-name) "--format" "nested"))

(defun spec-verify-single ()
  "Runs the specified example at the point of the current buffer."
  (interactive)
  (spec-run-single-file (buffer-file-name) "--format" "nested" "--line " (number-to-string (line-number-at-pos))))

(defun ruby-mode-on-init ()
  (init-mode)

  (setq ruby-deep-indent-paren nil)
  (setq ruby-compilation-error-regexp "^\\([^: ]+\.rb\\):\\([0-9]+\\):")

  (setq ac-sources '(ac-source-yasnippet
                     ac-source-words-in-buffer
                     ac-source-words-in-same-mode-buffers))
  )

(add-hook 'ruby-mode-hook 'ruby-mode-on-init) ;


;; ********************************************************************************
;; RHTML Mode
;;
(autoload 'rhtml-mode "rhtml-mode" "RHTML Mode" t)
(add-to-list 'auto-mode-alist '("\\.rhtml$" . rhtml-mode))
(add-to-list 'auto-mode-alist '("\\.html.erb$" . rhtml-mode))

(defun rhtml-mode-on-init ()
  (init-mode)

  (set-face-attribute 'erb-exec-face nil
                      :background "grey10"
                      :foreground "grey90")

  (set-face-attribute 'erb-out-face nil
                      :background "grey10"
                      :foreground "grey90")
  (abbrev-mode nil))

(add-hook 'rhtml-mode-hook 'rhtml-mode-on-init)


;; ********************************************************************************
;; IRB Mode
;;
(defun inferior-ruby-mode-on-init ())

(add-hook 'inferior-ruby-mode-hook 'inferior-ruby-mode-on-init)


;; ********************************************************************************
;; YAML Mode
;;
(autoload 'yaml-mode "yaml-mode" "YAML Mode." t)

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))


;; ********************************************************************************
;; HAML Mode
;;
(autoload 'haml-mode "haml-mode" "HAML Mode." t)

(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))


;; ********************************************************************************
;; JS2 Mode
;;
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(autoload 'js2-mode "js2-mode" "JS2 Mode." t)

(setq js2-mode-dev-mode-p t)
(setq js2-mode-must-byte-compile nil)

(defun js2-mode-on-init ()
  (init-mode)

  (setq ac-sources '(ac-source-yasnippet
                     ac-source-semantic
                     ac-source-words-in-buffer
                     ac-source-words-in-same-mode-buffers))

  (setq js2-allow-keywords-as-property-names nil)
  (setq js2-allow-rhino-new-expr-initializer t)
  (setq js2-basic-offset 2)
  (setq js2-dynamic-idle-timer-adjust 2)
  (setq js2-highlight-level 4)
  (setq js2-idle-timer-delay 5)
  (setq js2-include-browser-externs t)
  (setq js2-include-rhino-externs t)
  (setq js2-language-version 150)
  (setq js2-missing-semi-one-line-override t)
  (setq js2-mode-show-overlay nil)
  (setq js2-mode-show-strict-warnings t)
  (setq js2-mirror-mode t)
  (setq js2-skip-preprocessor-directives t)
  (setq js2-strict-cond-assign-warning t)
  (setq js2-strict-inconsistent-return-warning nil)
  (setq js2-strict-missing-semi-warning t)
  (setq js2-strict-trailing-comma-warning t)
  (setq js2-strict-var-hides-function-arg-warning t)
  (setq js2-strict-var-redeclaration-warning t)

  ;; (define-key js2-mode-map (kbd "<return>") 'reindent-then-newline-and-indent)
  )

(add-hook 'js2-mode-hook 'js2-mode-on-init)

(defun js-mode-on-init ()
  (init-mode)

  (setq ac-sources '(ac-source-yasnippet
                     ac-source-semantic
                     ac-source-words-in-buffer
                     ac-source-words-in-same-mode-buffers))


  (add-hook 'js-mode-hook 'js-mode-on-init))

;; (add-to-list 'auto-mode-alist '("\\.js$" . js-mode))


;; ********************************************************************************
;; Emacs-Lisp Mode
;;
(defun emacs-lisp-mode-on-init ()
  (init-mode)

  (setq ac-sources '(ac-source-yasnippet
		     ac-source-features
		     ac-source-functions
		     ac-source-symbols
		     ac-source-variables
		     ac-source-words-in-buffer))

  (add-hook 'emacs-lisp-mode-hook 'emacs-lisp-mode-on-init))



;; ********************************************************************************
;; HTML Mode
;;
(setq auto-mode-alist (remove-if (lambda (item) (string-equal (car item) "\\.html$")) auto-mode-alist))
(add-to-list 'auto-mode-alist  '("\\.html$" . html-mode))
(add-to-list 'auto-mode-alist  '("\\.liquid$" . html-mode))

(defun html-mode-on-init ()
  (init-mode))

(add-hook 'html-mode-hook 'html-mode-on-init)


;; ********************************************************************************
;; CSS Mode
;;
(defconst css-imenu-generic-expression
  '((nil "^[ \t]*\\([[:word:].:#, \t]+\\)\\s-*{" 1))
  "Regular expression matching any selector. Used by imenu.")

(defun css-mode-on-init ()
  (init-mode)
  (setq cssm-indent-level 4)
  (setq cssm-indent-function #'cssm-c-style-indenter)
  (set (make-local-variable 'imenu-generic-expression)
       css-imenu-generic-expression))

(add-hook 'css-mode-hook 'css-mode-on-init)

;; ********************************************************************************
;; SASS Mode
;;
(defun sass-mode-on-init ()
  (init-mode))

(add-hook 'sass-mode-hook 'sass-mode-on-init)
(autoload 'sass-mode "sass-mode" "Sass Mode" t)
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))


;; ********************************************************************************
;; C Mode
;;
(defun c-mode-on-init ()
  (init-mode)

  (setq ac-sources '(ac-source-yasnippet
		     ac-source-semantic
		     ac-source-words-in-buffer)))

(add-hook 'c-mode-hook 'c-mode-on-init)



;; ********************************************************************************
;; XML Mode
;;
(autoload 'nxml-mode "nxml-mode" "XML Mode" t)
(add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mode))

(defun nxml-mode-on-init ()
  (init-mode)
  (setq ac-sources '(ac-source-yasnippet
		     ac-source-semantic
		     ac-source-words-in-buffer)))

(add-hook 'nxml-mode-hook 'nxml-mode-on-init)


;; ********************************************************************************
;; dired
;;
(defun joc-dired-up-directory()
  (interactive)
  (joc-dired-single-buffer ".."))

(defun dired-mode-on-init ()
  (require 'dired-single)
  (require 'wdired)

  (define-key dired-mode-map (kbd "<return>") 'joc-dired-single-buffer)
  (define-key dired-mode-map (kbd "<down-mouse-1>") 'joc-dired-single-buffer-mouse)
  (define-key dired-mode-map (kbd "<C-up>") 'joc-dired-up-directory)

  (define-key dired-mode-map (kbd "r") 'wdired-change-to-wdired-mode)

  (setq dired-backup-overwrite t)
  (setq dired-listing-switches "-al")
  ;; (setq dired-omit-files "^\\.")
  )

(add-hook 'dired-mode-hook 'dired-mode-on-init)

(defadvice switch-to-buffer-other-window (after auto-refresh-dired (buffer &optional norecord) activate)
  (if (equal major-mode 'dired-mode)
      (revert-buffer)))

(defadvice switch-to-buffer (after auto-refresh-dired (buffer &optional norecord) activate)
  (if (equal major-mode 'dired-mode)
      (revert-buffer)))

(defadvice display-buffer (after auto-refresh-dired (buffer &optional not-this-window frame)  activate)
  (if (equal major-mode 'dired-mode)
      (revert-buffer)))

(defadvice other-window (after auto-refresh-dired (arg &optional all-frame) activate)
  (if (equal major-mode 'dired-mode)
      (revert-buffer)))



;; ********************************************************************************
;; Smart Compile
;;

(add-to-list 'smart-compile-alist '("^Rakefile$"  . "rake -f %f")) ;
(add-to-list 'smart-compile-alist '("\\.js$"      . "node %f"))
(add-to-list 'smart-compile-alist '("\\.rb$"      . "ruby %f"))
(add-to-list 'smart-compile-alist '("_spec\\.rb$" . "spec %f"))
(add-to-list 'smart-compile-alist '("\\.scm$"     . "scheme %f"))
(add-to-list 'smart-compile-alist '(haskell-mode  . "ghc -o %n %f")) ;

(setq ffip-patterns
      '("*.haml" "*.sass" "*.html" "*.org" "*.txt" "*.md" "*.el" "*.clj" "*.py" "*.rb" "*.js" "*.pl"
	"*.sh" "*.erl" "*.hs" "*.ml" "*.yml" "*.css"))




;; ********************************************************************************
;; Global Key Bindings
;;


;; Movement
(global-set-key (kbd "<up>") 'evil-previous-line)
(global-set-key (kbd "<down>") 'evil-next-line)
(global-set-key (kbd "<left>") 'evil-backward-char)
(global-set-key (kbd "<right>") 'evil-forward-char)
(global-set-key (kbd "<C-left>") 'evil-backward-word-begin)
(global-set-key (kbd "<C-right>") 'evil-forward-word-begin)
(global-set-key (kbd "<C-up>") 'evil-backward-paragraph)
(global-set-key (kbd "<C-down>") 'evil-forward-paragraph)
(define-key evil-motion-state-map " " 'evil-visual-char)

(global-set-key (kbd "C-c c") 'smart-compile)
(global-set-key (kbd "C-c f") 'find-file-in-project)
(global-set-key (kbd "C-c s") 'shell)
(global-set-key (kbd "C-c /") 'tags-search)
(global-set-key (kbd "C-c ?") 'etags-select-find-tag-at-point)
(global-set-key (kbd "C-c .") 'etags-select-find-tag)
(global-set-key (kbd "C-c [") 'start-kbd-macro)
(global-set-key (kbd "C-c ]") 'end-kbd-macro)
(global-set-key (kbd "C-c \\") 'call-last-kbd-macro)
(global-set-key (kbd "C-c g") 'rgrep)
(global-set-key (kbd "C-c n") 'next-error)
(global-set-key (kbd "C-c b") 'ibuffer)
(global-set-key (kbd "A-d") 'split-window-horizontally)

(global-set-key (kbd "C-c r") 'recompile)
(global-set-key (kbd "C-c v") 'spec-verify)
(global-set-key (kbd "C-c t") 'toggle-buffer)
(global-set-key (kbd "C-c C-s") 'spec-verify-single)

(global-set-key (kbd "<M-return>") 'icicle-buffer)
(global-set-key (kbd "<A-return>") 'icicle-buffer)

(global-set-key (kbd "C-x C-c") 'save-and-exit)
(global-set-key (kbd "<A-left>") 'tabbar-backward)
(global-set-key (kbd "<A-right>") 'tabbar-forward)


;; (global-set-key (kbd "<C-delete>") 'kill-word)
;; (global-set-key (kbd "<C-backspace>") 'backward-kill-word)

;;; init.el --- Cross-platform Vanilla Emacs Configuration ;;-*- lexical-binding: t; -*-

;; =============================================================================
;; 1. PACKAGE MANAGEMENT & CUSTOM FILE REDIRECT
;; =============================================================================
;; Redirect automatically generated custom code to keep init.el clean
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
                                        ;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

;; =============================================================================
;; 2. EMACS CORE DEFAULTS & GLOBAL MODES
;; =============================================================================
(use-package emacs
  :ensure nil
  :init
  (setq inhibit-startup-message t
        inhibit-startup-screen t
        warning-minimum-level :error
        require-final-newline t)
  (setq-default indent-tabs-mode nil
                tab-width 2)

  (setq native-comp-async-report-warnings-errors 'silent
        warning-suppress-types '((comp)))

  :config
  (window-divider-mode +1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (global-subword-mode +1)
  (column-number-mode +1)
  (show-paren-mode +1)
  (global-hl-line-mode +1)
  (windmove-default-keybindings)
  (defalias 'yes-or-no-p 'y-or-n-p)

  (when (member "Fira Code" (font-family-list))
    (set-frame-font "Fira Code-11" nil t))

  (setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))

  (cond
   ((eq system-type 'windows-nt)
    (let ((go-path (expand-file-name "~/go/bin")))
      (add-to-list 'exec-path go-path)
      (setenv "PATH" (concat go-path ";" (getenv "PATH")))))

   ((eq system-type 'gnu/linux)
    (add-to-list 'exec-path "~/go/bin")
    (add-to-list 'exec-path "~/.local/bin")

    (when (string-match "Linux.*Microsoft.*Linux" (shell-command-to-string "uname -a"))
      (setq browse-url-generic-program  "/mnt/c/Windows/System32/cmd.exe"
            browse-url-generic-args     '("/c" "start")
            browse-url-browser-function #'browse-url-generic))))

  :hook
  (before-save . delete-trailing-whitespace)
  (before-save . my-untabify-buffer))

(defun my-untabify-buffer ()
  "Convert tabs to spaces before saving if indent-tabs-mode is nil."
  (if (not indent-tabs-mode)
      (untabify (point-min) (point-max)))
  nil)

(global-set-key (kbd "C-x C-b") 'ibuffer)

;; =============================================================================
;; 3. AUTOMATED TOOLCHAIN & BOOTSTRAP INSTALLS
;; =============================================================================
(use-package nerd-icons)

(defun my-auto-install-lsp-servers ()
  "Bootstrap required language servers if runtime binaries are found on host."
  (interactive)
  (let ((go-bin (if (eq system-type 'windows-nt) "go.exe" "go"))
        (npm-bin (if (eq system-type 'windows-nt) "npm.cmd" "npm")))

    (when (and (executable-find go-bin) (not (executable-find "gopls")))
      (message "Bootstrapping gopls...")
      (start-process "install-gopls" "*lsp-install*" go-bin "install" "golang.org/x/tools/gopls@latest"))

    (when (and (executable-find npm-bin) (not (executable-find "typescript-language-server")))
      (message "Bootstrapping typescript-language-server...")
      (start-process "install-tsserver" "*lsp-install*" npm-bin "install" "-g" "typescript" "typescript-language-server"))))

(add-hook 'emacs-startup-hook
          (lambda () (run-with-idle-timer 5 nil #'my-auto-install-lsp-servers)))

;; =============================================================================
;; 4. LIGATURES, INTERFACE & DECORATION (Nerd-Icons Version)
;; =============================================================================
(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode
    '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\\\" "{-" "-}"
      "<!--" "-->" "///" "////" "==" "===" "!==" "!=" "<=" ">="
      "=:=" "=:=" "<=>" "<=" ">=" "<>" "<:" "<>" "<-" "->" "-->"
      "->>" "<<-" "<==" "<=>" "==>" "=>" "=>>" ">-" ">=" "<~"
      "<~>" "~>" "~-" "-~" "~@" "[|" "|]" "{|" "|}" "{|" "|}"
      "++" "+++" "::" "::?" "==" "!=" "exact"
      "&&" "&&&" "||" "|||" "!!" "!!" "??" "???" "%%" "%%%"
      "##" "###" "####" ".=" ".-" ".." "..." "..<" ".?" "?."
      "_=" "_|_" "::" "::=" "=:=" "!!" "!!" "??" "???" "%%" "%%%"
      "##" "###" "####" ".=" ".-" ".." "..." "..<" ".?" "?."
      "_=" "_|_" "::" "::=" "=:=" "&&" "&&&" "||" "|||"))
  (global-ligature-mode t))

(use-package vertico :init (vertico-mode))
(use-package marginalia :init (marginalia-mode))
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package gruvbox-theme :config (load-theme 'gruvbox-dark-medium t))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-icon t)
  (doom-modeline-font-family "NerdFont")
  (doom-modeline-buffer-file-name-style 'truncate-with-project))

(use-package dashboard
  :config (dashboard-setup-startup-hook)
  :custom
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-startup-banner 'official)
  (dashboard-items '((recents . 5) (bookmarks . 5) (projects . 5)))
  (dashboard-center-content t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t))

(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

;; =============================================================================
;; 5. IDE INFRASTRUCTURE (LSP, COMPLETION, LINTING)
;; =============================================================================
(use-package eglot
  :ensure nil
  :hook ((go-ts-mode typescript-ts-mode js-ts-mode python-base-mode kotlin-mode) . eglot-ensure))

(use-package corfu :init (global-corfu-mode) :custom ((corfu-auto t) (corfu-quit-no-match 'separator)))
(use-package flymake :ensure nil :hook (prog-mode . flymake-mode))
(use-package dape)
(use-package treesit-auto :custom (treesit-auto-install t) :config (global-treesit-auto-mode))

;; =============================================================================
;; 6. POWER TOOLS & UTILITIES
;; =============================================================================
(use-package magit)
(use-package multiple-cursors)
(use-package sudo-edit)
(use-package restclient)
(use-package atomic-chrome)
(use-package htmlize)
(use-package treemacs)
(use-package pdf-tools :magic ("%PDF" . pdf-view-mode) :config (pdf-tools-install :no-query))
(use-package yasnippet :config (yas-global-mode 1))
(use-package yatemplate :after yasnippet :config (yatemplate-fill-alist))

;; =============================================================================
;; 7. LANGUAGE RUNTIMES
;; =============================================================================
(use-package go-mode
  :init (add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode))
  :hook (go-ts-mode . (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t))))
(use-package go-playground)

(use-package typescript-mode
  :init
  (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))
  (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode)))

(use-package pyvenv)
(when (executable-find "ipython")
  (setq python-shell-interpreter "ipython" python-shell-interpreter-args "--simple-prompt -i"))

(use-package slime
  :init
  (setq inferior-lisp-program "sbcl")
  (when (file-exists-p "~/quicklisp/slime-helper.el") (load (expand-file-name "~/quicklisp/slime-helper.el")))
  :config (slime-setup '(slime-fancy)))

(use-package geiser :custom ((geiser-mode-auto-p t) (geiser-mode-eval-last-sexp-to-buffer t)))
(use-package geiser-racket)

(autoload 'octave-mode "octave-mod" nil t)
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))
(add-hook 'octave-mode-hook (lambda () (abbrev-mode 1) (auto-fill-mode 1)))

(use-package maude-mode)
(use-package graphviz-dot-mode)
(use-package protobuf-mode)
(use-package kotlin-mode)
(use-package yaml-mode)
(use-package json-mode :init (add-to-list 'major-mode-remap-alist '(json-mode . json-ts-mode)))
(use-package k8s-mode :hook (k8s-mode . yas-minor-mode))
(use-package plantuml-mode
  :custom
  (plantuml-jar-path (expand-file-name "~/.emacs.d/plantuml/plantuml.jar"))
  (plantuml-default-exec-mode 'jar)
  (plantuml-output-type "png"))

;; =============================================================================
;; 8. ORG-MODE ECOSYSTEM
;; =============================================================================
(use-package org
  :ensure nil
  :init
  (org-babel-do-load-languages 'org-babel-load-languages '((dot . t) (shell . t) (python . t) (plantuml . t)))
  :hook (org-babel-after-execute . org-redisplay-inline-images)
  :custom
  (org-startup-with-inline-images t)
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-confirm-babel-evaluate nil)
  (org-latex-listings 'minted)
  (org-latex-packages-alist '(("" "minted"))))

(use-package org-ref)
(use-package org-appear :hook (org-mode . org-appear-mode))
(use-package org-modern
  :hook (org-mode . global-org-modern-mode)
  :custom ((org-modern-keyword nil) (org-modern-checkbox nil) (org-modern-table nil)))

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode)
  :custom (org-startup-with-latex-preview t) (org-format-latex-options (plist-put org-format-latex-options :scale 2)))

(use-package markdown-mode)

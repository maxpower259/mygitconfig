;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
                                        ;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(geiser-mode-auto-p t t)
 '(geiser-mode-eval-last-sexp-to-buffer t t)
 '(inferior-octave-startup-args '("-i" "--line-editing"))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(yasnippet-go go-flycheck go-playground go-mode kotlin-mode json-mode maude-mode geiser-racket tex gruvbox-theme pyvenv typescript-mode sudo-edit ac-js2 company-auctex company flycheck js2hl xref-js2 js2-refactor js2-mode web-beautify ein treemacs all-the-icons-dired latex-preview-pane dired-hacks-utils dired-git visual-regexp-steroids multiple-cursors magit pdf-tools geiser slime auctex yasnippet rainbow-delimiters use-package))
 '(tab-width 2)
 '(warning-suppress-types '((use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq inhibit-startup-message t)
(window-divider-mode +1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(setq inferior-lisp-program "sbcl")
(setq c-default-style '((java-mode . "java") (other . "gnu")))

(when (executable-find "ipython")
  (setq python-shell-interpreter "ipython")
  (setq python-shell-interpreter-args "--simple-prompt -i"))

(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;; no tabs by default. modes that really need tabs should enable
;; indent-tabs-mode explicitly. makefile-mode already does that, for
;; example.
(setq-default indent-tabs-mode nil)

(add-hook 'before-save-hook #'delete-trailing-whitespace)
(setq require-final-newline t)

;; if indent-tabs-mode is off, untabify before saving
(add-hook 'write-file-functions
          (lambda ()
            (if (not indent-tabs-mode)
                (untabify (point-min) (point-max)))
            nil ))

;; use built-in ibuffer which has many features from dired and replaces buffer-menu
(global-set-key (kbd "C-x C-b") 'ibuffer)

(show-paren-mode)

(use-package gruvbox-theme
  :init (load-theme 'gruvbox-dark-soft t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package yasnippet)

(use-package auctex)

(use-package json-mode)

(use-package tex
  :ensure auctex)

(use-package slime)

(use-package geiser-racket)

(use-package geiser
  :config
  (setq geiser-mode-auto-p t)
  (setq geiser-mode-eval-last-sexp-to-buffer t))

(use-package pdf-tools
  :load-path "site-lisp/pdf-tools/lisp"
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

(use-package maude-mode)

(use-package magit)

(use-package multiple-cursors)

(use-package visual-regexp-steroids)

(use-package dired-git)

(use-package dired-hacks-utils)

(use-package latex-preview-pane)

(use-package all-the-icons)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package treemacs)

(use-package ein
  :custom
  (ein:output-area-inlined-images t)
  (ein:slice-image t))

(use-package web-beautify)

(use-package js2-mode
  :hook (js-mode . js2-minor-mode)
  :config
  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
  (add-to-list 'js2-global-externs "d3"))

(use-package js2-refactor
  :hook (js2-minor-mode . js2-refactor-mode)
  :config (js2r-add-keybindings-with-prefix "C-c C-r"))

(use-package xref-js2)

(use-package js2hl)

(use-package flycheck
  :hook (after-init . global-flycheck-mode))

(use-package company
  :config (add-to-list 'company-backends 'company-capf)
  :hook (after-init . global-company-mode))

(use-package company-auctex
  :config (add-to-list 'company-backends 'company-auctex))

(use-package ac-js2
  :config
  (add-to-list 'company-backends 'ac-js2-company)
  (setq ac-js2-evaluate-calls t))

(use-package sudo-edit)

(use-package typescript-mode)

(use-package pyvenv)

(use-package go-mode
  :custom (gofmt-command "goimports")
  :hook (before-save . gofmt-before-save))

(use-package go-playground)

(use-package go-flycheck)

(use-package yasnippet-go)

(use-package kotlin-mode)

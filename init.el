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

; (pdf-tools-install :no-query)
(require 'use-package)
(setq use-package-always-ensure nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inferior-octave-startup-args '("-i" "--line-editing"))
 '(inhibit-startup-screen t)
 '(ispell-dictionary nil)
 '(org-latex-src-block-backend 'minted nil nil "Customized with use-package org-mode")
 '(package-selected-packages
   '(restclient flycheck-golangci-lint all-the-icons org-modern plantuml-mode yatemplate atomic-chrome org-ref org-fragtog org-mode org-appear htmlize protobuf-mode graphviz-dot-mode markdown-mode go-playground go-mode kotlin-mode json-mode maude-mode geiser-racket tex gruvbox-theme pyvenv typescript-mode sudo-edit ac-js2 company flycheck js2hl xref-js2 js2-refactor js2-mode web-beautify ein treemacs all-the-icons-dired latex-preview-pane dired-hacks-utils dired-git visual-regexp-steroids multiple-cursors magit pdf-tools geiser slime yasnippet rainbow-delimiters use-package))
 '(tab-width 2)
 '(warning-suppress-log-types '((comp)))
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
(scroll-bar-mode -1)
(global-subword-mode +1)
(column-number-mode +1)
(windmove-default-keybindings)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq exec-path (append exec-path '("~/go/bin")))

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

(when (and (eq system-type 'gnu/linux)
           (string-match
            "Linux.*Microsoft.*Linux"
            (shell-command-to-string "uname -a")))
  (setq
   browse-url-generic-program  "/mnt/c/Windows/System32/cmd.exe"
   browse-url-generic-args     '("/c" "start")
   browse-url-browser-function #'browse-url-generic))

(use-package restclient)

(use-package htmlize)

(use-package atomic-chrome)

(use-package org-mode
  :init
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((dot . t)
     (shell . t)
     (python . t)
     (plantuml . t)))

  :hook
  (org-babel-after-execute . org-redisplay-inline-images)

  :custom
  (org-src-preserve-indentation nil)
  (org-edit-src-content-indentation 0)
  (org-latex-prefer-user-labels t)
  (org-startup-with-inline-images t)
  (org-startup-indented t)
  (org-pretty-entities t)
  (org-use-sub-superscripts "{}")
  (org-hide-emphasis-markers t)
  (org-image-actual-width '(300))
  (org-confirm-babel-evaluate nil)
  (org-latex-listings 'minted)
  (org-latex-packages-alist '(("" "minted")))
  (org-latex-minted-options '(("breaklines" "true")
                              ("breakanywhere" "true")))
  (org-latex-pdf-process
   '("%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
     "bibtex %b"
     "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
     "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (org-plantuml-jar-path (expand-file-name "~/.emacs.d/plantuml/plantuml.jar"))
  )

(use-package org-ref)

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

(use-package org-modern
  :hook
  (org-mode . global-org-modern-mode)
  :custom
  (org-modern-keyword nil)
  (org-modern-checkbox nil)
  (org-modern-table nil))

(use-package org-fragtog
  :after org
  :hook
  (org-mode . org-fragtog-mode)
  :custom
  (org-startup-with-latex-preview t)
  (org-format-latex-options
   (plist-put org-format-latex-options :scale 2)
   (plist-put org-format-latex-options :foreground 'auto)
   (plist-put org-format-latex-options :background 'auto)))

(use-package gruvbox-theme
  :init (load-theme 'gruvbox-dark-medium t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package yasnippet
  :config (yas-global-mode 1))

(use-package yatemplate
  :config (yatemplate-fill-alist))

(use-package json-mode)

(use-package slime)

(use-package geiser-racket)

(use-package geiser
  :custom
  (geiser-mode-auto-p t)
  (geiser-mode-eval-last-sexp-to-buffer t))

(use-package pdf-tools
  :load-path "site-lisp/pdf-tools/lisp"
  :magic ("%PDF" . pdf-view-mode))

(use-package maude-mode)

(use-package magit)

(use-package multiple-cursors)

(use-package visual-regexp-steroids)

(use-package dired-git)

(use-package dired-hacks-utils)

(use-package latex-preview-pane)

; all-the-icons-install-fonts
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

(use-package ac-js2
  :config
  (add-to-list 'company-backends 'ac-js2-company)
  :custom
  (ac-js2-evaluate-calls t))

(use-package sudo-edit)

(use-package typescript-mode)

(use-package pyvenv)

(use-package go-mode
  :custom ((gofmt-command "goimports")
           (display-fill-column-indicator-column 80))
  :hook ((before-save . gofmt-before-save)
         (go-mode . display-fill-column-indicator-mode)))

(use-package go-playground)

(use-package flycheck-golangci-lint
  :hook (go-mode . flycheck-golangci-lint-setup))

(use-package kotlin-mode)

(use-package markdown-mode)

(use-package graphviz-dot-mode)

(use-package protobuf-mode)

(use-package plantuml-mode
  :custom
  (plantuml-jar-path (expand-file-name "~/.emacs.d/plantuml/plantuml.jar"))
  (plantuml-jar-args '("-tpng"))
  (plantuml-default-exec-mode 'jar)
  (plantuml-output-type "png")
  (plantuml-java-args (list "-Djava.awt.headless=true" "-jar")))

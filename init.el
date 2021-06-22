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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.50")
 '(geiser-mode-auto-p t t)
 '(geiser-mode-eval-last-sexp-to-buffer t t)
 '(inferior-octave-startup-args '("-i" "--line-editing"))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(rainbow-delimiters all-the-icons-dired auctex use-package lsp-jedi lsp-ui lsp-treemacs typescript-mode lsp-mode sudo-edit ac-js2 company-tern tern company-jedi company-auctex js2hl xref-js2 xref-js js2-refactor js2-mode web-beautify validate-html yasnippet ein auctex-mode paradox doom-modeline spotify dired-hacks-utils dired-git dired+ visual-regexp-steroids multiple-cursors projectile magit emms mode-line treemacs-icons-dired doom-colors treemacs pdf-tools latex-preview-pane company doom-themes sr-speedbar flycheck haskell-mode slime geiser))
 '(speedbar-show-unknown-files t)
 '(tab-width 4)
 '(window-divider-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq backup-directory-alist
          `(("." . ,(concat user-emacs-directory "backups"))))

(setq inferior-lisp-program "clisp")

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
(add-hook 'write-file-hooks
          (lambda ()
            (if (not indent-tabs-mode)
                (untabify (point-min) (point-max)))
            nil ))

;; use built-in ibuffer which has many features from dired and replaces buffer-menu
(global-set-key (kbd "C-x C-b") 'ibuffer)

(show-paren-mode)

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package yasnippet
  :ensure t)

(use-package tex
  :ensure auctex)

(use-package slime
  :ensure t)

(use-package geiser
  :ensure t
  :config
; (setq geiser-active-implementations '(racket))
  (setq geiser-mode-auto-p t)
  (setq geiser-mode-eval-last-sexp-to-buffer t))

(use-package emms
  :ensure t)

(use-package spotify
  :ensure t)

(use-package pdf-tools
  :ensure t
  :load-path "site-lisp/pdf-tools/lisp"
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

(use-package magit
  :ensure t)

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

(use-package multiple-cursors
  :ensure t)

(use-package visual-regexp-steroids
  :ensure t)

(use-package dired-git
  :ensure t)

(use-package dired-hacks-utils
  :ensure t)

(use-package latex-preview-pane
  :ensure t)

(use-package all-the-icons
  :ensure t)

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package paradox
  :ensure t
  :config
  (paradox-enable))

(use-package doom-modeline
  :ensure t
  :config (doom-modeline-mode 1))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-manegarm t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package treemacs
  :ensure t)

(use-package ein
  :ensure t)

(use-package web-beautify
  :ensure t)

(use-package js2-mode
  :ensure t
  :hook (js-mode . js2-minor-mode)
  :config
  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
  (add-to-list 'js2-global-externs "d3"))

(use-package js2-refactor
  :ensure t
  :hook (js2-minor-mode . js2-refactor-mode)
  :config (js2r-add-keybindings-with-prefix "C-c C-r"))

(use-package xref-js2
  :ensure t)

(use-package js2hl
  :ensure t)

(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(use-package company-auctex
  :ensure t
  :config (add-to-list 'company-backends 'company-auctex))

(use-package lsp-jedi
  :ensure t)

;; first install virtualenv on OS
;; execute M-x "jedi-install-server" once
(use-package company-jedi
  :ensure t
  :config (add-to-list 'company-backends 'company-jedi))

(use-package ac-js2
  :ensure t
  :config
  (add-to-list 'company-backends 'ac-js2-company)
  (setq ac-js2-evaluate-calls t))

(use-package sudo-edit
  :ensure t)

(use-package typescript-mode
  :ensure t)

(use-package lsp-mode
  :ensure t
  :hook
  (typescript-mode . lsp)
  (js-mode . lsp)
  (html-mode . lsp)
  (css-mode . lsp)
  (python-mode . lsp)
  :config
  (setq lsp-clients-angular-language-server-command
        '("node"
          "/usr/lib/node_modules/@angular/language-server"
          "--ngProbeLocations"
          "/usr/lib/node_modules"
          "--tsProbeLocations"
          "/usr/lib/node_modules"
          "--stdio")))

(use-package lsp-ui
  :ensure t)

(use-package lsp-treemacs
  :ensure t)

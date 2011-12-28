(let* ((my-lisp-dir "~/.emacs.d/")
       (default-directory my-lisp-dir))
  (setq load-path (cons my-lisp-dir load-path))
  (normal-top-level-add-subdirs-to-load-path))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.

(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(menu-bar-mode -1)
(tool-bar-mode -1)
(setq make-backup-files nil)
(column-number-mode t)
(setq x-select-enable-clipboard t)
(delete-selection-mode 1)
(setq-default show-trailing-whitespace t)

(setq search-highlight t
      query-replace-highlight t)
(fset 'yes-or-no-p 'y-or-n-p)

(setq completion-ignore-case t
      read-file-name-completion-ignore-case t)
;; C-x n {n, w, p, d} {region, widen(whole buffer), page, defun}
(put 'narrow-to-region 'disabled nil)

(ido-mode t)
(setq ido-enable-flex-matching t
      ido-max-prospects 8
      ido-enable-last-directory-history t)

(setq-default indent-tabs-mode nil)

;; fboundp test the voidness of a symbol's function definition
(when (fboundp 'global-hl-line-mode)
  (global-hl-line-mode t))

(when (fboundp 'show-paren-mode)
  (show-paren-mode t))

;; Save location in file when saving file
(setq save-place-file "~/.emacs.d/.saveplace")
(setq-default save-place t)
(require 'saveplace)

;; Save History (between sessions)
(setq savehist-additional-variables
      '(search ring regexp-search-ring)
      savehist-autosave-interval 60
      savehist-file "~/.emacs.d/.savehist")
(savehist-mode t)

(global-linum-mode t)

(setq inhibit-splash-screen t)

(require 'setup-my-elpa)
(require 'key-bindings)

;; AUCTeX ;; ADD CODE TO CHECK IF AVAILABLE
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; magit
(require 'magit "magit" 'noerror)

;; Dired-X
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))

;; js-mode
(setq js-indent-level 2)

;; ruby mode
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(setq ruby-insert-encoding-magic-comment nil)

(autoload 'scheme-mode "cmuscheme" nil t)
(autoload 'run-scheme "cmuscheme" "Switch to interactive Scheme buffer." t)
(add-hook 'scheme-mode-hook 'turn-on-font-lock)
(setq scheme-program-name "scheme48")

;; FlyMake
(require 'flymake-conf)
(require 'flymake-jshint)
(add-hook 'javascript-mode-hook
          (lambda () (flymake-mode t)))

;; Turns on flymake for all files which have a flymake mode
(add-hook 'find-file-hook 'flymake-find-file-hook)

;; vimpuluse
(require 'vimpulse)
;; emacs in insert
(setq viper-want-emacs-keys-in-insert t)
;; disable vi keys in minibuffer
(remove-hook 'minibuffer-setup-hook 'viper-minibuffer-setup-sentinel)
(defadvice viper-set-minibuffer-overlay (around vimpulse activate) nil)
(define-key minibuffer-local-map (kbd "ESC") 'abort-recursive-edit)
;; comment/uncomment
(vimpulse-vmap ",c" 'comment-dwim)
;; viper shift
(setq default-tab-width 2)
(setq viper-shift-width 2)

;; Go Lang
(require 'go-mode-load)

;; paredit
(require 'paredit)
(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'scheme-mode-hook     'turn-on-paredit)
(add-hook 'lisp-mode-hook       'turn-on-paredit)
(add-hook 'emacs-lisp-mode-hook 'turn-on-paredit)

;; Color Theme
(require 'color-theme)
(require 'color-theme-ir-black)
(color-theme-ir-black)

(global-auto-revert-mode)


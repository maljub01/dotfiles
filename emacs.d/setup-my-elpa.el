;; Adapted from emacs-starter-kit

(require 'cl)

(defvar my-packages (list 'color-theme
                          'color-theme-ir-black
                          'magit
                          'flymake-cursor
                          'paredit
                          'haml-mode
                          'sass-mode
                          'css-mode
                          'haskell-mode
                          'go-mode
                          'auctex
                          'yaml-mode)
  "Libraries that should be installed by default.")

(defun my-elpa-install ()
  "Install all my packages that aren't installed."
  (interactive)
  (defvar fetched-content nil)
  (dolist (package my-packages)
    (unless (or (member package package-activated-list)
                (functionp package))
      (unless fetched-content (package-refresh-contents))
      (message "Installing %s" (symbol-name package))
      (package-install package)
      (setq fetched-content t))))

(defun esk-online? ()
  "See if we're online.

Windows does not have the network-interface-list function, so we
just have to assume it's online."
  ;; TODO how could this work on Windows?
  (if (and (functionp 'network-interface-list)
           (network-interface-list))
      (some (lambda (iface) (unless (equal "lo" (car iface))
                         (member 'up (first (last (network-interface-info
                                                   (car iface)))))))
            (network-interface-list))
    t))

;; On your first run, this should pull in all the base packages.
(when (esk-online?)
  (my-elpa-install))

(provide 'setup-my-elpa)

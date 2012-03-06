(setq column-number-mode t)
(setq font-lock-maximum-decoration t)
(setq inhibit-startup-message t)

(setq-default indent-tabs-mode nil)

(show-paren-mode t)
(tool-bar-mode -1)

(add-to-list 'default-frame-alist (cons 'height 40))
(add-to-list 'default-frame-alist (cons 'width 100))

(global-set-key "\C-m" 'newline-and-indent)
(global-set-key (kbd "C-<return>") 'newline)
(global-set-key (kbd "C-z") '(lambda ()))
(global-set-key (kbd "C-x C-z") '(lambda ()))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
(add-to-list 'load-path
             "/usr/share/emacs/site-lisp/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
             "/usr/share/emacs/site-lisp/auto-complete/ac-dict")
(ac-config-default)

(add-to-list 'ac-modes 'lisp-mode)

;; color-theme
(require 'color-theme)
(color-theme-initialize)
;; (color-theme-classic)

;; develock
(cond ((featurep 'xemacs)
       (require 'develock)
       ;; `turn-on-develock' is equivalent to `turn-on-font-lock',
       ;;  except that it does not highlight the startup screen.
       (add-hook 'lisp-interaction-mode-hook 'turn-on-develock)
       (add-hook 'mail-setup-hook 'turn-on-font-lock))
      ((>= emacs-major-version 20)
       (require 'develock)
       (global-font-lock-mode 1)))

;; ibus
(custom-set-variables '(ibus-python-shell-command-name "python2"))

(require 'ibus)
(add-hook 'after-init-hook 'ibus-mode-on)
(global-set-key (kbd "C-\\") 'ibus-toggle)

;; linum
(require 'linum)
(global-linum-mode 1)

;; scala-mode-indent-fix
(add-to-list 'load-path "/usr/share/emacs/scala-mode")
(require 'scala-mode-auto)

;; slime
(setq inferior-lisp-program "/usr/bin/clisp")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
(require 'slime)
(slime-setup)
(put 'upcase-region 'disabled nil)

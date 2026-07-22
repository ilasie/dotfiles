(setq custom-file "~/.config/emacs/emacs.custom.el")

(add-to-list 'default-frame-alist `(font . "Iosevka-20"))

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
(ido-everywhere 1)
(global-display-line-numbers-mode 1)

(add-to-list 'load-path "~/.config/emacs/emacs.local/")

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(load-file custom-file)

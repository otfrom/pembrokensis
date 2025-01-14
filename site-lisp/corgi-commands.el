;; (use-package corgi-commands
;;   :load-path "corgi-packages/corgi-commands/")

;;; corgi-commands.el --- Custom commands included with Corgi -*- lexical-binding: t -*-
;;
;; Filename: corgi-commands.el
;; Package-Requires: ()
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; Commands that are not available in vanilla emacs, and that are not worth
;; pulling in a separate package to provide them. These should eventually end up
;; in their own utility package, we do not want too much of this stuff directly
;; in the emacs config.
;;
;;; Code:

(require 'seq)

(defun corgi/switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer))))

(defun corgi/switch-to-last-elisp-buffer ()
  (interactive)
  (when-let ((the-buf (seq-find (lambda (b)
                                  (with-current-buffer b
                                    (derived-mode-p 'emacs-lisp-mode)))
                                (buffer-list))))
    (pop-to-buffer the-buf)))

(defun corgi/double-columns ()
  "Simplified version of spacemacs/window-split-double-column"
  (interactive)
  (delete-other-windows)
  (let* ((previous-files (seq-filter #'buffer-file-name
                                     (delq (current-buffer) (buffer-list)))))
    (set-window-buffer (split-window-right)
                       (or (car previous-files) "*scratch*"))
    (balance-windows)))

(defun corgi/open-init-el ()
  "Open the user's init.el file"
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(defun corgi/-locate-file (fname)
  "Like corkey/-locate-file"
  (cond
   ((symbolp fname)
    (corgi/-locate-file (concat (symbol-name fname) ".el")))
   ((file-exists-p (expand-file-name fname user-emacs-directory))
    (expand-file-name fname user-emacs-directory))
   (t (locate-library fname))))

(defun corgi/open-keys-file ()
  "Open the Corgi built-in key binding file"
  (interactive)
  (find-file (corgi/-locate-file 'corgi-keys)))

(defun corgi/open-signals-file ()
  "Open the Corgi built-in signals file"
  (interactive)
  (find-file (corgi/-locate-file 'corgi-signals)))

(defun corgi/open-user-keys-file ()
  "Open the user key binding file in the emacs user directory
Will create one if it doesn't exist."
  (interactive)
  (let ((keys-file (corgi/-locate-file 'user-keys)))
    (when (not keys-file)
      (copy-file (corgi/-locate-file 'user-keys-template)
                 (expand-file-name "user-keys.el" user-emacs-directory)))
    (find-file (corgi/-locate-file 'user-keys))))

(defun corgi/open-user-signals-file ()
  "Open the user signal file in the emacs user directory
Will create one if it doesn't exist."
  (interactive)
  (let ((signals-file (corgi/-locate-file 'user-signals)))
    (when (not signals-file)
      (copy-file (corgi/-locate-file 'user-signals-template)
                 (expand-file-name "user-signals.el" user-emacs-directory)))
    (find-file (corgi/-locate-file 'user-signals))))

(defun corgi/open-straight-corgi-versions-file ()
  "Open the straight versions file for corgi packages"
  (interactive)
  (find-file (expand-file-name "straight/versions/corgi.el" user-emacs-directory)))

(defun corgi/open-straight-default-versions-file ()
  "Open the straight default versions file"
  (interactive)
  (find-file (expand-file-name "straight/versions/default.el" user-emacs-directory)))

;; Taking this out, see explanation in corgi-keys.el
;;
;; (defun corgi/emulate-tab ()
;;   "Emulates pressing <tab>, used for binding to TAB for tab key
;; support in terminals."
;;   (interactive)
;;   (let ((cmd (key-binding (kbd "<tab>"))))
;;     (when (commandp cmd)
;;       (call-interactively cmd))))

(provide 'corgi-commands)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; corgi-commands.el ends here

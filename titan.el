;; titan.el


;; [[file:README.org::*titan.el][titan.el:1]]
;;; titan.el --- a simple package                     -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Jeet Ray

;; Author: Jeet Ray <aiern@protonmail.com>
;; Keywords: lisp
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Adapted From: https://github.com/AndreaCrotti/yasnippet-snippets/blob/master/yasnippet-snippets.el

;;; Code:

(require 'meq)
(require 'yasnippet)
(require 'f)

(defvar meq/var/mecons '((org . org)
    (markdown . md)
    (adoc . adoc)))
    
(defmacro meq/titan-append-modes (mode &rest exts) (let* ((titan-exts (meq/inconcat "meq/var/titan-" (symbol-name mode) "-exts"))) (append (when titan-exts titan-exts) exts)))

(with-eval-after-load 'use-package
    ;; Primarily adapted from https://gitlab.com/to1ne/use-package-hydra/-/blob/master/use-package-hydra.el

    ;; Adapted From: https://github.com/jwiegley/use-package/blob/master/use-package-core.el#L1153
    ;;;###autoload
    (defalias 'use-package-normalize/:tam 'use-package-normalize-forms)

    ;; Adapted From: https://gitlab.com/to1ne/use-package-hydra/-/blob/master/use-package-hydra.el#L79
    ;;;###autoload
    (defun use-package-handler/:tam (name keyword args rest state)
        (use-package-concat (mapcar #'(lambda (def) `(meq/titan-append-modes ,@def)) args)
        (use-package-process-keywords name rest state)))

    (add-to-list 'use-package-keywords :tam t))

(defun meq/ddm (name)
    (let* ((snippets (meq/inconcat "meq/var/" name "-snippets-dir")))
        (defcustom meq/var/titan-snippets-dir user-emacs-directory "The titan snippets directory")
        (when (f-exists? meq/var/titan-snippets-dir)
            (add-to-list 'yas-snippet-dirs meq/var/titan-snippets-dir t)
            (yas-load-directory meq/var/titan-snippets-dir t))
        (eval `(defcustom ,snippets user-emacs-directory (format "The %s snippets directory" ,name)))
        (when (eval `(f-exists? ,snippets))
            (add-to-list 'yas-snippet-dirs (symbol-value snippets) t)
            (eval `(yas-load-directory ,snippets t)))))

(defun meq/mapc-ddm (name exts &optional mecons* &rest args) (mapc #'(lambda (mecons) (interactive)
    (let* ((mode (symbol-name (car mecons)))
            (ext (symbol-name (cdr mecons)))
            (titan-exts (meq/inconcat "meq/var/titan-" mode "-exts"))
            (name-exts (meq/inconcat "meq/var/" name "-" mode "-exts"))
            (all-name-exts (meq/inconcat "meq/var/" name "-exts"))
            (name-mode (meq/inconcat name "-" mode "-mode")))
        ;; (eval `(defvar ,name-exts ',(rassoc name-mode exts)))
        ;; (eval `(setq auto-mode-alist (append auto-mode-alist '(,(symbol-value name-exts)))))
        ;; (if all-name-exts
        ;;     (eval `(setq ,all-name-exts ',(append (symbol-name all-name-exts) (symbol-name name-exts))))
        ;;     (eval `(defvar ,all-name-exts ',(symbol-name name-exts))))
        ;; (if titan-exts
        ;;     (eval `(setq ,titan-exts ',(append (symbol-value titan-exts) (symbol-value name-exts))))
        ;;     (eval `(defvar ,titan-exts ',(symbol-value name-exts))))
        (eval `(defun ,(meq/inconcat "meq/dired-create-" name "-" mode) nil (interactive)
            (when (derived-mode-p 'dired-mode) (let* ((file (f-join

                            ;; Adapted From:
                            ;; Answer: https://stackoverflow.com/a/11046990/10827766
                            ;; User: https://stackoverflow.com/users/324105/phils
                            default-directory

                            (format "%s.%s.%s" (meq/timestamp) ,name ,ext))))
                (with-current-buffer (find-file-noselect file)
                    (meq/insert-snippet (concat (if (featurep 'riot) "org" ,mode) " titan template"))
                    (save-buffer)
                    (kill-buffer))
                (revert-buffer)))))
        (eval `(defun ,(meq/inconcat "meq/dired-create-and-open-" name "-" mode) nil (interactive)
            (when (derived-mode-p 'dired-mode) (let* ((file (f-join

                            ;; Adapted From:
                            ;; Answer: https://stackoverflow.com/a/11046990/10827766
                            ;; User: https://stackoverflow.com/users/324105/phils
                            default-directory

                            (format "%s.%s.%s" (meq/timestamp) ,name ,ext))))
                
                ;; Adapted From:
                ;; Answer: https://stackoverflow.com/a/17984479/10827766
                ;; User: https://stackoverflow.com/users/2321928/bnzmnzhnz
                (unless (display-graphic-p) (other-window -1))

                (find-file file)
                (meq/insert-snippet (concat (if (featurep 'riot) "org" ,mode) " titan template"))))))
        (eval `(define-derived-mode
            ,name-mode
            ,(meq/inconcat "titan-" mode "-mode")
            (meq/ddm ,name)
            ,@args)))) (or mecons* meq/var/mecons)))

(mapc #'(lambda (mecons) (interactive)
    (let* ((mode (symbol-name (car mecons)))
            (ext (symbol-name (cdr mecons))))
        (eval `(define-derived-mode
            ,(meq/inconcat "titan-" mode "-mode")
            ,(meq/inconcat mode "-mode")
            ;; ,(concat "titan-" mode)
            (meq/ddm "titan")
            )))) meq/var/mecons)

(provide 'titan)
;;; titan.el ends here
;; titan.el:1 ends here

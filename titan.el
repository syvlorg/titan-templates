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

;; Put a description of the package here

;;; Code:

(require 'yasnippet)
(require 'yankpad)
(require 'org)
(require 'dash)
(require 'alloy)

(defvar meq/var/ext-def '(org md adoc))
(defvar meq/var/mode-def '(org markdown adoc))

(defun meq/ddm (name ext)
    (let* ((yankpad-file*
                ;; Adapted From: https://github.com/AndreaCrotti/yasnippet-snippets/blob/master/yasnippet-snippets.el#L35
                (expand-file-name
                "yankpad.org"
                (file-name-directory
                    ;; Copied from ‘f-this-file’ from f.el.
                    (cond
                    (load-in-progress load-file-name)
                    ((and (boundp 'byte-compile-current-file) byte-compile-current-file)
                    byte-compile-current-file)
                    (:else (buffer-file-name)))))))
        (when yankpad-file* (setq yankpad-file-backup yankpad-file)
            (setq yankpad-file yankpad-file*)
            (yankpad-append-category (concat name "-mode"))
            (setq yankpad-file yankpad-file-backup)))
    (add-to-list 'auto-mode-alist '((concat "\\." name "." ext "\\'") . (intern (concat name "-mode")))))

(defmacro meq/mapc-ddm (name &optional ext-list &rest args) (mapc #'(lambda (ext*) (interactive)
    (let* ((ext (symbol-name ext*)))
        (eval `(define-derived-mode
            ,(intern (concat name "-" ext "-mode"))
            ,(intern (concat "titan-" ext "-mode"))
            (meq/ddm ,name ,ext)
            ,@args)))) (or ext-list meq/var/ext-def)))

(mapc #'(lambda (mode-cons) (interactive)
    (let* ((mode (symbol-name (car mode-cons)))
            (ext (symbol-name (cdr mode-cons))))
        (eval `(define-derived-mode
            ,(intern (concat "titan-" ext "-mode"))
            ,(intern (concat mode "-mode"))
            ,(concat "titan-" ext)
            ,(meq/ddm "titan" ext))))) (-zip-with #'cons meq/var/mode-def meq/var/ext-def))

(provide 'titan)
;;; titan.el ends here

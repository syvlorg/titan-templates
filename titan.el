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

(require 'yasnippet)
(require 'meq)

(defun meq/setup-titan (name)
    (eval `(defvar ,(meq/inconcat "meq/var/titan-" name "-mode") nil))
    (eval `(defvar ,(meq/inconcat "meq/var/titan-" name "-yankpad-file-backup") nil))
    (eval `(setq
            ,(meq/inconcat name "snippets")
            (expand-file-name
                "snippets"
                (file-name-directory
                    ;; Copied from ‘f-this-file’ from f.el.
                    (cond
                    (load-in-progress load-file-name)
                    ((and (boundp 'byte-compile-current-file) byte-compile-current-file)
                    byte-compile-current-file)
                    (:else (buffer-file-name))))))))

(defun meq/enable-titan (name)
    (eval `(setq ,(meq/inconcat "meq/var/titan-" name "-mode") t))
    (add-to-list 'yas-snippet-dirs (meq/inconcat name "snippets") t)
    (eval `(yas-load-directory ,(meq/inconcat name "snippets") t))
    (yas-minor-mode 1))

(defun meq/disable-titan (name)
    (eval `(setq ,(meq/inconcat "meq/var/titan-" name "-mode") nil))
    (delete (meq/inconcat name "snippets") yas-snippet-dirs)
    (yas-reload-all)
    (yas-minor-mode 0))

(provide 'titan)
;;; titan.el ends here

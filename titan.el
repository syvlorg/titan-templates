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

(defun meq/setup-titan (name)
    (eval `(defvar ,(intern (concat "meq/var/titan-" name "-mode")) nil))
    (eval `(defvar ,(intern (concat "meq/var/titan-" name "-yankpad-file-backup")) nil)))

(defun meq/enable-titan (name)
    (eval `(setq ,(intern (concat "meq/var/titan-" name "-mode")) t))
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
        (when yankpad-file*
            (eval `(setq ,(intern (concat "meq/var/titan-" name "-yankpad-file-backup")) yankpad-file))
            (setq yankpad-file yankpad-file*)
            (yankpad-map)
            (yankpad-set-category name))))

(defun meq/disable-titan (name)
    (eval `(setq ,(intern (concat "meq/var/titan-" name "-mode")) nil))
    (eval `(setq yankpad-file ,(intern (concat "meq/var/titan-" name "-yankpad-file-backup"))))
    (yankpad-map))

(provide 'titan)
;;; titan.el ends here

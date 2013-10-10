;;; pane.el --- Manipulate Emacs's window structure

;; Copyright (C) 2013 by Yuta Yamada

;; Author: Yuta Yamada <cokesboy"at"gmail.com>
;; URL: https://github.com/yuutayamada/package
;; Version: 0.0.1
;; Keywords: Emacs, window

;;; License:
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(eval-when-compile (require 'cl))

(defvar pane-window nil)
(defvar pane-window-horizontally-percentage 70)
(defvar pane-window-vertically-percentage   80)
(defvar pane-window-3pane-buffers '("*scratch*" "*message*"))
(defvar pane-window-2pane-other-buffer "*scratch*")

;;;###autoload
(defun pane-toggle-window-structure ()
  (interactive)
  (when (equal major-mode 'scala-mode)
    (delete-other-windows)
    (if (not current-prefix-arg)
        (case pane-window
          (:3pane (pane-change-to-2pane))
          (:2pane (pane-change-to-3pane))
          (t      (pane-change-to-3pane)))
      (setq pane-window-3pane-buffers
            (reverse pane-window-3pane-buffers))
      (when (equal :3pane pane-window)
        (pane-change-to-3pane)))))

(defun pane-change-to-3pane ()
  (let ((h-percents pane-window-horizontally-percentage)
        (v-percents pane-window-vertically-percentage))
    (split-window-vertically   (/ (* h-percents (window-height)) 100))
    (split-window-horizontally (/ (* v-percents (window-width))  100))
    (windmove-down)
    (switch-to-buffer
     (get-buffer-create (nth 0 pane-window-3pane-buffers)))
    (windmove-up)
    (windmove-right)
    (switch-to-buffer
     (get-buffer-create (nth 1 pane-window-3pane-buffers)))
    (windmove-left)
    (setq-local pane-window :3pane)))

(defun pane-change-to-2pane ()
  (split-window-horizontally)
  (windmove-right)
  (switch-to-buffer
   (get-buffer-create pane-window-2pane-other-buffer))
  (windmove-left)
  (setq-local pane-window :2pane))

(provide 'pane)

;; Local Variables:
;; coding: utf-8
;; mode: emacs-lisp
;; End:

;;; pane.el ends here

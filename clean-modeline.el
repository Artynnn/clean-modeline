(defgroup clean-modeline ()
  "random snippets that provide a cleaner modeline."
  :group 'emacs) ; don't know what group to put it in.

(defun simple-mode-line-render (left right)
  "Return a string of `window-width' length.
Containing LEFT, and RIGHT aligned respectively."
  (let ((available-width
         (- (window-total-width)
            (+ (length (format-mode-line left))
               (length (format-mode-line right))))))
    (append left
            (list (format (format "%%%ds" available-width) ""))
            right)))

;; Display to mode-line buffer name relative to current-project.
;; SOURCE: https://www.reddit.com/r/emacs/comments/8xobt3/tip_in_modeline_show_buffer_file_path_relative_to/
(with-eval-after-load 'subr-x
  (setq-default mode-line-buffer-identification
                '(:eval
                  (format-mode-line
                   (propertized-buffer-identification
                    (or (when-let* ((buffer-file-truename buffer-file-truename)
                                    (prj                  (cdr-safe (project-current)))
                                    (prj-parent           (file-name-directory (directory-file-name (expand-file-name prj)))))
                          (concat (file-relative-name (file-name-directory buffer-file-truename) prj-parent) (file-name-nondirectory buffer-file-truename)))
                        "%b"))))))

(setq-default column-number-mode t
              mode-line-format   '((:eval (simple-mode-line-render '("%e" ; left side
                                                                     mode-line-front-space
                                                                     mode-line-modified
                                                                     mode-line-remote
                                                                     mode-line-frame-identification
                                                                     mode-line-buffer-identification
                                                                     "   "
                                                                     "%l:%c")
                                                                   '("%"
                                                                     mode-line-misc-info  ; right side
                                                                     "  "
                                                                     mode-line-process
                                                                     mode-line-end-spaces
                                                                     "  ")))))


;; (blink-cursor-mode 0)
;; (set-fringe-mode 0)

(provide 'clean-modeline)

;; ********************************************************************************
;; Completion
;;
(load "javascript-symbols")

(defun he-word-beginning ()
  (let ((p
         (save-excursion
           (backward-word 1)
           (point))))
    p))

(defun try-expand-collection (old collection)
  (unless  old
    (he-init-string (he-word-beginning) (point))
    (setq he-expand-list (sort
                          (all-completions he-search-string collection) 'string-lessp)))

  (while (and he-expand-list 
	      (he-string-member (car he-expand-list) he-tried-table))
    (setq he-expand-list (cdr he-expand-list)))

  (if (null he-expand-list)
      (progn
        (when old (he-reset-string))
        ())

    (he-substitute-string (car he-expand-list))
    (setq he-expand-list (cdr he-expand-list))
    t))

(defun try-expand-tag (old)
  (if (not tags-file-name)
      (setq tags-file-name (find-tags-file)))
  (try-expand-collection old 'tags-complete-tag))

(defun try-expand-css-property (old)
  (try-expand-collection old cssm-properties))

(defun try-expand-javascript-symbol (old)
  (try-expand-collection old javascript-symbols))

(defun indent-and-complete ()
  "Indent line and complete"
  (interactive)

  (cond
   ((and (boundp 'snippet) snippet)
    (snippet-next-field))

   ((looking-at "\\_>")
    (hippie-expand nil))

   ((indent-for-tab-command))))

(defun try-expand-abbrev (old)
  (expand-abbrev))

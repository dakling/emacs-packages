(defvar bosss--block-beginning-mark  "==============")

(defvar bosss--block-end-mark  "**************")

(define-derived-mode bosss-mode csharp-mode "bosss"
  ;; (setq bosss-highlights
  ;; 	'("==============" . font-lock-comment-face))
  ;; ;; (setq bosss-highlights
  ;; ;; 	'(("==============" . font-lock-comment-face)
  ;; ;;     ("**************" . font-lock-comment-face)))
  ;; (setq font-lock-defaults (cons (list bosss-highlights (car csharp-font-lock-keywords)) (cdr font-lock-defaults)))
  )

(defun bosss-create-new-field ()
  (interactive)
  (search-forward bosss--block-end-mark)
  (newline)
  (insert bosss--block-beginning-mark)
  (newline)
  (newline)
  (newline)
  (insert bosss--block-end-mark)
  (forward-line -1))

;; TODO define text object for a field

(provide 'bosss)

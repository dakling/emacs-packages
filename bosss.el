(define-derived-mode bosss-mode csharp-mode "bosss-repl"
  (setq bosss-highlights
	'("==============" . font-lock-comment-face))
  ;; (setq bosss-highlights
  ;; 	'(("==============" . font-lock-comment-face)
  ;;     ("**************" . font-lock-comment-face)))
  (setq font-lock-defaults (cons (list bosss-highlights (car csharp-font-lock-keywords)) (cdr font-lock-defaults))))

(provide 'bosss)

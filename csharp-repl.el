(defvar csharp-repl-path "/usr/bin/csharp")

(defvar csharp-repl-arguments '())

(defvar csharp-repl-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    (define-key map "\t" 'completion-at-point)))

(defvar csharp-repl-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)")

(defun run-csharp-repl ()
  (interactive)
  (let* ((csharp-program csharp-repl-path)
	 (buffer (comint-check-proc "csharp")))
    (pop-to-buffer-same-window
     (if (or buffer (not (derived-mode-p 'csharp-mode))
	     (comint-check-proc (current-buffer)))
	 (get-buffer-create (or buffer "*csharp*"))
       (current-buffer)))
    (unless buffer
      (apply 'make-comint-in-buffer "csharp" buffer
       csharp-program csharp-repl-arguments)
      (csharp-repl-mode))))

(defun csharp--repl-initialize ()
  (setq comint-process-echoes t)
  (setq comint-use-prompt-regexp t))

(define-derived-mode csharp-repl-mode comint-mode "csharp-repl"
  (setq comint-prompt-regexp csharp-repl-prompt-regexp)
  (setq comint-prompt-read-only t)
  (set (make-local-variable 'paragraph-separate) "\\'")
  ;; (set (make-local-variable 'font-lock-defaults) '(csharp-repl-font-lock-keywords t))
  (set (make-local-variable 'paragraph-start) csharp-repl-prompt-regexp))

(add-hook 'csharp-repl-mode-hook 'csharp--repl-initialize)

(defun run-csharp-repl-other-frame ()
    (interactive)
    (run-csharp-repl)
    (switch-to-buffer-other-window "*csharp*"))

(defun csharp-repl-send-region (beg end)
  (interactive "r")
  (comint-send-region "*csharp*" beg end))

(provide 'csharp-repl)

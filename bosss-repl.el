(defvar bosss-repl-path "/usr/bin/csharp")

(defvar bosss-repl-arguments '(nil "-r:/home/klingenberg/BoSSS-experimental/internal/src/private-kli/RANS_Solver/bin/Debug/RANS_Solver.exe"))

(defvar bosss-repl-mode-map
  (let ((map (nconc (make-sparse-keymap) comint-mode-map)))
    (define-key map "\t" 'completion-at-point)))

(defvar bosss-repl-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)")

(defun run-bosss-repl ()
  (interactive)
  (let* ((bosss-program bosss-repl-path)
	 (buffer (comint-check-proc "bosss")))
    (pop-to-buffer-same-window
     (if (or buffer (not (derived-mode-p 'bosss-mode))
	     (comint-check-proc (current-buffer)))
	 (get-buffer-create (or buffer "*bosss*"))
       (current-buffer)))
    (unless buffer
      (apply 'make-comint-in-buffer "bosss" buffer
       bosss-program bosss-repl-arguments)
      (bosss-repl-mode))))

(defun bosss--repl-initialize ()
  (setq comint-process-echoes t)
  (setq comint-use-prompt-regexp t))

(define-derived-mode bosss-repl-mode comint-mode "bosss-repl"
  (setq comint-prompt-regexp bosss-repl-prompt-regexp)
  (setq comint-prompt-read-only t)
  (set (make-local-variable 'paragraph-separate) "\\'")
  ;; (set (make-local-variable 'font-lock-defaults) '(bosss-repl-font-lock-keywords t))
  (set (make-local-variable 'paragraph-start) bosss-repl-prompt-regexp))

(add-hook 'bosss-repl-mode-hook 'bosss--repl-initialize)

(defun run-bosss-repl-other-frame ()
    (interactive)
    (run-bosss-repl)
    (switch-to-buffer-other-window "*bosss*"))

(defun bosss-repl-send-region (beg end)
  (interactive "r")
  (comint-send-region "*bosss*" beg end))

(defun bosss-repl-send-current-field ()
  (interactive)
    (search-backward "==============")
    (let ((beg (point)))
    (search-forward "**************")
    (bosss-repl-send-region beg (point))))


(provide 'bosss-repl)

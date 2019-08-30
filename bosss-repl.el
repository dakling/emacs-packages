(defvar bosss-repl-path "/usr/bin/csharp")
;; (defvar bosss-repl-path "/usr/bin/bosss-console")

;; (defvar bosss-repl-arguments
;;   (when bosss-path
;;     (cons nil
;; 	   (mapcar (lambda (entry) (concat "-r:" entry)) (directory-files bosss-path t)))))

(defvar bosss-repl-arguments nil)

(defvar bosss-repl-mode-map (make-sparse-keymap))

(defvar bosss-repl-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)")

(defvar bosss--block-beginning-mark  "==============")

(defvar bosss--block-end-mark  "**************")

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
    (switch-to-buffer-other-window "*bosss*")
    (run-bosss-repl))

(defun bosss-repl-send-region (beg end)
  (interactive "r")
  (comint-send-region "*bosss*" beg end))

(defun bosss-repl-send-current-field ()
  (interactive)
  (save-excursion
   (search-backward bosss--block-beginning-mark)
   (forward-line 1)
   (let ((beg (point)))
     (search-forward bosss--block-end-mark)
     (move-end-of-line 0)
     (bosss-repl-send-region beg (point)))))

(defun bosss-repl-install ()
  "installs the files needed to run the csharp repl with bosss loaded"
  (interactive)
  (if (and (boundp 'bosss-path) bosss-path)
      (progn
       (copy-file "./make-pkg.sh" bosss-path t)
       (let ((default-directory bosss-path))
	 (async-shell-command
	  (concat bosss-path "./make-pkg.sh")))
       (copy-file "./init.cs" "~/.config/csharp/" t))
    (error "Please specify the path to your BoSSS installation")))

(provide 'bosss-repl)

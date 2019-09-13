;; (defvar bosss-repl-path "/usr/bin/bosss-console")
(defvar bosss-repl-path "/usr/local/bin/sdb")

(defvar bosss-repl-arguments nil)

(defvar bosss-repl-mode-map (make-sparse-keymap))

(defvar bosss-repl-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)")

;; (defvar bosss-repl-prompt-regexp ">")

(defvar bosss--block-beginning-mark  "==============")

(defvar bosss--block-end-mark  "**************")

(defun bosss-repl-load-my-assembly ()
  (interactive)
  (when bosss-path-reference
    (comint-send-string "*bosss*" (concat "LoadAssembly(\"" bosss-path-reference "\")\n"))))

(defun bosss-repl-start-bosss-pad ()
  "only useful if bossspad is wrapped inside a debugger"
  (interactive)
  (comint-send-string
   "*bosss*"
   "args --simpleconsole \n")
  (comint-send-string
   "*bosss*"
   (concat "run " bosss-pad-path)))

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

;; (defun bosss-repl-send-region (beg end)
;;   (interactive "r")
;;   (comint-send-region "*bosss*" beg end))

(defun bosss--format-input (input-string)
 (replace-regexp-in-string
                       "\n"
                       ""
                       (replace-regexp-in-string
                        (rx (or (and "\*" (*? anything) "*/") (and "//" (*? anything) eol)))
                        ""
                         input-string)))

(defun bosss-repl-send-region (beg end)
  (interactive "r")
  (comint-send-string "*bosss*"
                      (concat
                       (bosss--format-input
                        (buffer-substring beg end))
                       "\n")))

(defun bosss-repl-send-current-field ()
  (interactive)
  (save-excursion
   (search-backward bosss--block-beginning-mark)
   (forward-line 1)
   (let ((beg (point)))
     (search-forward bosss--block-end-mark)
     (move-end-of-line 0)
     (bosss-repl-send-region beg (point)))))

;; (defun bosss-repl-install-private ()
;;   "installs the files needed to run the csharp repl with bosss loaded"
;;   ;; TODO general file paths
;;   (interactive)
;;    (if (and (boundp 'bosss-path) bosss-path)
;;        (progn
;;          (copy-file "~/.emacs.d/dev/make-pkg.sh" bosss-path t)
;;          (let ((default-directory bosss-path))
;;            (async-shell-command
;;             (concat bosss-path "/make-pkg.sh")))
;;          (copy-file "~/.emacs.d/dev/init.cs" "~/.config/csharp/" t))
;;      (error "Please specify the base path to your BoSSS installation")))

(provide 'bosss-repl)

;;
;; To use perlminlint from flycheck-mode in cperl-mode, load this file.
;;

(add-hook
 'cperl-mode-hook

 (lambda ()
   ;;
   ;; Enable flycheck
   ;;
   (flycheck-mode)
   
   ;;
   ;; perlminlint doesn't work with temporary files.
   ;;
   (set (make-variable-buffer-local
	 'flycheck-check-syntax-automatically)
	'(save))

   ;;
   ;; Same above.
   ;;
   (flycheck-set-checker-properties
    'perl
    '((flycheck-command "perlminlint" source-original)))))

  ;; (message "cperl-mode-hook is: %s" cperl-mode-hook)
)

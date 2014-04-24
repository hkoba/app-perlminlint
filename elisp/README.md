perl-minlint-mode
====================

To use `perl-minlint-mode`, please load `subdirs.el` in this directory.
It will setup `load-path`, `cperl-mode-hook` and `autoload`.

For now, recommended way to install perl-minlint-mode is

```sh
#
# This assumes you have ~/bin in your $PATH
#
cd ~/bin
git clone https://github.com/hkoba/app-perlminlint.git
ln -s app-perlminlint/script/perlminlint .

#
# This assumes you use ~/.emacs.d/init.el (rather than ~/.emacs)
#
cd ~/.emacs.d
ln -s ../app-perlminlint/elisp perlminlint
```

Then you can setup perl-minlint-mode by adding `(load "perlminlint/subdirs")`
to your `~/.emacs.d/init.el`.
(You may need to add `(add-to-list 'load-path "~/.emacs.d")` before above.)

Alternatively, if you want to enable all subdirs.el under `~/.emacs.d`,
try adding following snippet in init.el:

```lisp
;;
;; Load all "*/subdirs.el" under this-dir.
;;
(let ((add-subdirs
       (lambda (this-dir)
	 (let (fn err (default-directory this-dir))
	   (normal-top-level-add-to-load-path (list this-dir)) ;;; fail safe.
	   (dolist (file (cdr (cdr (directory-files this-dir))))
	     (setq fn (concat (file-name-as-directory file) "subdirs.el"))
	     (if (and (file-directory-p file)
		      (file-exists-p fn))
		 (condition-case err
		     (load fn)
		   (error
		    (message "Can't load %s: %s" fn err)))
	       (message "add-subdirs: skipped %s" file)))))))
  (funcall add-subdirs
	   (or (and load-file-name (file-name-directory load-file-name))
	       default-directory)))
```

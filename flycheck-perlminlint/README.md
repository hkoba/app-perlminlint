Flycheck support
====================

To use `perlminlint` from 
[Flycheck](http://flycheck.readthedocs.org/en/latest/index.html),
please load `subdirs.el` in this directory.
It will setup `cperl-mode-hook`.

For now, recommended way to install Flycheck support is

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
ln -s ../app-perlminlint/flycheck-perlminlint .
```

Then you can setup Flycheck support by adding
`(load "~/.emacs.d/flycheck-perlminlint/subdirs")`
to your `~/.emacs.d/init.el`.

Alternatively, you can load **all** `subdirs.el` under `~/.emacs.d`
by adding following snippet in init.el:

```lisp
;;
;; Load all "*/subdirs.el" under this-dir.
;;
(let ((load-all-subdirs
       (lambda (this-dir)
         (let (fn err (default-directory this-dir))
           (dolist (file (cdr (cdr (directory-files this-dir))))
             (setq fn (concat (file-name-as-directory file) "subdirs.el"))
             (if (and (file-directory-p file)
                      (file-exists-p fn))
                 (condition-case err
                     (load fn)
                   (error
                    (message "Can't load %s: %s" fn err)))
               (message "load-all-subdirs: skipped %s" file)))))))
  (funcall load-all-subdirs
           (or (and load-file-name (file-name-directory load-file-name))
               default-directory)))
```

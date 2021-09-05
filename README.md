# GCBAL: Balanced garbage collection

GCBAL is a minor mode for emacs that adjusts the `gc-cons-threshold` based on past performance.

``` emacs-lisp
(setq 
    ;; how many seconds do you want to spend (at worst) on each gc
    gcbal-target-gctime 0.33
    ;; how responsive should the adjustment be
    gcbal-ring-size 5)
```

# TODO
- benchmarking for atoms
- proactive strategy


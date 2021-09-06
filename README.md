# GCBAL: Balanced garbage collection

GCBAL is a minor mode for emacs that adjusts the `gc-cons-threshold` based on past performance.
Its goal is to adjust gc such that it always take a fixed amount of time, in theory giving a _soft_ guarantee for gc runtime.

GCMH mode instead tries to exploit idle times to manually execute garbage collection. I didn't like this approach because
- idle times are subjective (emacs doesn't really know _yet_ how to correctly predict when I am idling)
- too many gc runs, setting a very low gc threshold when idling can cause many gc runs and increase cpu/battery usage

Predictive gc timings help with system stability, like packages making heavy use of timers.

``` emacs-lisp
(setq 
    ;; how many seconds do you want to spend (at worst) on each gc
    gcbal-target-gctime 0.33
    ;; how responsive should the adjustment be
    gcbal-ring-size 5)
```

# TODO
- benchmarking for atoms (to apply more precise weights)
- proactive strategy (with a timer)

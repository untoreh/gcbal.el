# GCBAL: Balanced garbage collection

GCBAL is a minor mode for emacs that adjusts the `gc-cons-threshold` based on past performance.
Its goal is to adjust gc such that it always take a fixed amount of time, in theory giving a _soft_ guarantee for gc runtime.

GCMH mode instead tries to exploit idle times to manually execute garbage collection. I didn't like this approach because
- idle times are subjective (emacs doesn't really know _yet_ how to correctly predict when I am idling)
- too many gc runs, setting a very low gc threshold when idling can cause many gc runs and increase cpu/battery usage

Predictive gc timings help with system stability, like packages making heavy use of timers.

``` emacs-lisp
;; how many seconds do you want to spend (at worst) on each gc
(setq gcbal-target-gctime 0.33)
```

# Benchmarks
I tried to benchmark GC based on different data structures (see functions in `benchs.el`) but didn't find anything conclusive. The assumption was that it takes less time to gc some data structures than others (hence the different weights). However emacs [doesn't make it clear](https://www.gnu.org/software/emacs/manual/html_node/elisp/Mutability.html) what data is mutable and what is immutable, which makes it hard to predict timings or generate meaningful tests..

The default strategy is the `'simple` one. It just splits time units based on the proportion `past-size : past-time = x : this-time`. This works fine, until the emacs heap size grows too big.
The `'offset` strategy instead tries to calculate a base gc time, which is the minimum time it takes to execute a gc run, and adjust the threshold based on the remaining time. This works better as the emacs heap grows, but the equation is still not precise.

# Other strategies
- A preemptive strategy could monitor the number of atoms consed and tune the threshold based on the primitive types (but as written previously it is hard to pin weights.)
- Instead of relying on the threshold, gc could be tailed to other long running (foreground) processes in order to _hide_ the delay (such has refreshing a `magit-status` buffer)

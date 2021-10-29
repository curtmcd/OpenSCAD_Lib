// Invert monotonically increasing function via binary search
// By Curt McDowell <maker@fishlet.com> 2021-10-27
// Licensed under the Creative Commons - Attribution - ShareAlike.
// https://creativecommons.org/licenses/by-sa/4.0/

finvert = function(fn, val, a, b, h)
    let (mid = (a + b) / 2)
        abs(a - b) < h ? mid :
          fn(mid) > val ? finvert(fn, val, a, mid)
                        : finvert(fn, val, mid, b);

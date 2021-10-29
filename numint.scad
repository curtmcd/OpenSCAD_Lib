// Numerical integration using Simpson's Rule
// By Curt McDowell <maker@fishlet.com> 2021-10-27
// Licensed under the Creative Commons - Attribution - ShareAlike.
// https://creativecommons.org/licenses/by-sa/4.0/

_int_loop = function(fn, sum, a, count)
    count ? _int_loop(fn, sum + fn(a), a + _int_h, count - 1) : sum;

_int_simpson = function(fn, sum, a, b)
    let (n = ceil((b - a) / _int_h))
        (fn(a) + fn(a + n * _int_h) +
	 _int_loop(fn, 0, a + _int_h / 2, n) * 4 +
	 _int_loop(fn, 0, a + _int_h, n - 1) * 2) * _int_h / 6;

integrate = function(fn, a, b, h)
    a < b ? _int_simpson(fn, 0, a, b, h) : -_int_simpson(fn, 0, b, a, h);

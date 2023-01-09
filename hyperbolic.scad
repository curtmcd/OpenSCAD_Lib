// Hyperbolic functions
// By Curt McDowell <maker@fishlet.com> 2021-11-02
// Licensed under the Creative Commons - Attribution - ShareAlike.
// https://creativecommons.org/licenses/by-sa/4.0/

cosh = function(x) (exp(x) + exp(-x)) / 2;
sinh = function(x) (exp(x) - exp(-x)) / 2;
tanh = function(x) (exp(x) - exp(-x)) / (exp(x) + exp(-x));

asinh = function(x) ln(x + sqrt(x^2 + 1));
acosh = function(x) ln(x + sqrt(x^2 - 1));
atanh = function(x) (ln(x + 1) - ln(1 - x)) / 2;

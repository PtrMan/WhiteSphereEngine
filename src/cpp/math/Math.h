#pragma once

// helper, branchless version of signum
// http://stackoverflow.com/a/4609795
template <typename NumericType> int sgn(NumericType val) {
    return (static_cast<NumericType>(0) < val) - (val < static_cast<NumericType>(0));
}

// http://stackoverflow.com/a/23717280/388614
template <int N, class T> 
constexpr T pow(const T& x) 
{
    return N > 1 ? x*pow<(N-1)*(N > 1)>(x) 
                 : N < 0 ? T(1)/pow<(-N)*(N < 0)>(x) 
                         : N == 1 ? x 
                                  : T(1);
}


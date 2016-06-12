#pragma once

#include "math/Math.h"

/*

derivation of the formula in the C++ code


p = cp + cd * ct + r * crd
--------------------------

dot2(p - (cp + cd*ct) ) - r*r  = 0
ct = dot(p - cp, cd)

==>

dot2(p - (cp + cd*dot(p - cp, cd)) ) - r*r  = 0


cp : cone position
  cpx
  cpy
  cpz
cd : cone direction
  cdx
  cdy
  cdz

ct : cone "time"
crd : cone radius direction



we can optimize this by setting cp to (0, 0, 0)

==>

dot2(p - (cd*dot(p, cd)) ) - r*r  = 0





ray equation

p = t*rd + rs

rd: ray direction
  rdx
  rdy
  rdz
  
rs: ray start
  rsx
  rsy
  rsz


plug cone thingy into ray equation and expand:
  
  dotPCd = ((t*rdx + rsx)*cdx + (t*rdy + rsy)*cdy + (t*rdz + rsz)*cdz)

  ((t*rdx + rsx) - (cdx*dotPCd))^2 + 
  ((t*rdy + rsy) - (cdy*dotPCd))^2 + 
  ((t*rdz + rsz) - (cdz*dotPCd))^2 + 
   - r*r == 0




expanded = Expand[
  
  ((t*rdx + rsx) - (cdx*((t*rdx + rsx)*cdx + (t*rdy + rsy)*cdy + (t*rdz + rsz)*cdz)))^2 + 
  ((t*rdy + rsy) - (cdy*((t*rdx + rsx)*cdx + (t*rdy + rsy)*cdy + (t*rdz + rsz)*cdz)))^2 + 
  ((t*rdz + rsz) - (cdz*((t*rdx + rsx)*cdx + (t*rdy + rsy)*cdy + (t*rdz + rsz)*cdz)))^2 + 
   - r*r == 0

]

simplified = Simplify[Collect[expanded, t]];
CForm[simplified]


*/

/*

then

in sublime replace regex
Power\((\w+),(\w+)\)
with
pow<$2>($1)

*/
// then a, b, c are ripped out

template<typename NumericType>
NumericType rayCylinderRelativePositionCalcAbc(
  NumericType cdx, NumericType cdy, NumericType cdz, 
  NumericType rsx, NumericType rsy, NumericType rsz,
  NumericType rdx, NumericType rdy, NumericType rdz,

  NumericType &a, NumericType &b, NumericType &c
) {  
  c = 
    pow<2>(rsx) + pow<4>(cdx)*pow<2>(rsx) + pow<2>(cdx)*pow<2>(cdy)*pow<2>(rsx) + pow<2>(cdx)*pow<2>(cdz)*pow<2>(rsx) + 2*pow<3>(cdx)*cdy*rsx*rsy + 
    2*cdx*pow<3>(cdy)*rsx*rsy + 2*cdx*cdy*pow<2>(cdz)*rsx*rsy + pow<2>(rsy) + pow<2>(cdx)*pow<2>(cdy)*pow<2>(rsy) + pow<4>(cdy)*pow<2>(rsy) + 
    pow<2>(cdy)*pow<2>(cdz)*pow<2>(rsy) + 2*pow<3>(cdx)*cdz*rsx*rsz + 2*cdx*pow<2>(cdy)*cdz*rsx*rsz + 2*cdx*pow<3>(cdz)*rsx*rsz + 
    2*pow<2>(cdx)*cdy*cdz*rsy*rsz + 2*pow<3>(cdy)*cdz*rsy*rsz + 2*cdy*pow<3>(cdz)*rsy*rsz + pow<2>(rsz) + pow<2>(cdx)*pow<2>(cdz)*pow<2>(rsz) + 
    pow<2>(cdy)*pow<2>(cdz)*pow<2>(rsz) + pow<4>(cdz)*pow<2>(rsz)  - (pow<2>(r) + 2*pow<2>(cdx*rsx + cdy*rsy + cdz*rsz));


  b =
    2*(pow<3>(cdx)*(cdy*rdy + cdz*rdz)*rsx + cdx*(-2 + pow<2>(cdy) + pow<2>(cdz))*(cdy*rdy + cdz*rdz)*rsx + rdy*rsy - 2*pow<2>(cdy)*rdy*rsy + 
       pow<4>(cdy)*rdy*rsy + pow<2>(cdy)*pow<2>(cdz)*rdy*rsy - 2*cdy*cdz*rdz*rsy + pow<3>(cdy)*cdz*rdz*rsy + cdy*pow<3>(cdz)*rdz*rsy - 
       2*cdy*cdz*rdy*rsz + pow<3>(cdy)*cdz*rdy*rsz + cdy*pow<3>(cdz)*rdy*rsz + rdz*rsz - 2*pow<2>(cdz)*rdz*rsz + pow<2>(cdy)*pow<2>(cdz)*rdz*rsz + 
       pow<4>(cdz)*rdz*rsz + pow<2>(cdx)*(cdy*rdy + cdz*rdz)*(cdy*rsy + cdz*rsz) + 
       rdx*((1 + pow<4>(cdx) + pow<2>(cdx)*(-2 + pow<2>(cdy) + pow<2>(cdz)))*rsx + 
          cdx*(-2 + pow<2>(cdx) + pow<2>(cdy) + pow<2>(cdz))*(cdy*rsy + cdz*rsz)));

  a = ((1 + pow<4>(cdx) + pow<2>(cdx)*(-2 + pow<2>(cdy) + pow<2>(cdz)))*pow<2>(rdx) + 
       (1 + pow<4>(cdy) + pow<2>(cdy)*(-2 + pow<2>(cdx) + pow<2>(cdz)))*pow<2>(rdy) + 
       2*cdy*cdz*(-2 + pow<2>(cdx) + pow<2>(cdy) + pow<2>(cdz))*rdy*rdz + 
       (1 + (-2 + pow<2>(cdx) + pow<2>(cdy))*pow<2>(cdz) + pow<4>(cdz))*pow<2>(rdz) + 
       2*cdx*(-2 + pow<2>(cdx) + pow<2>(cdy) + pow<2>(cdz))*rdx*(cdy*rdy + cdz*rdz));
}

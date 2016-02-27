module helpers.Conversion;

auto convertCStringToD(inout(char)* cstr) {
     import core.stdc.string: strlen;
     return cstr ? cstr[0 .. strlen(cstr)] : cstr[0 .. 0];
}

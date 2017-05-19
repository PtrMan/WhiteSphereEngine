import std.stdio;

import std.math : log10, abs, pow, fmod;
//import std.algorithm.comparison : max;

// calculates the base of an value with a baseFactor, for example with a baseFactor 2.5 the value 2.5 returns the result 0, the value 25.0 returns the result 1 (given powerDivisor = 1)
// doesn't handle 0.0
int calcBaseWithFactor(int powerDivisor, double baseFactor, double value) {
    // abs because logarithm of negative value doesn't make any sense
    double normalizedValue = value.abs / baseFactor;
    
    double unroundedBase = log10(normalizedValue);
    return cast(int)unroundedBase / powerDivisor;
}

class StringSettings {
    public string[] sufixesPositive;
    public string[] sufixesNegative;
    public string punctationDelimiter;
}

struct FormatSettings {
    public StringSettings stringSettings;
    
    public int formatPrecision;
    public bool enableTrailingZeros;
    
    public int powerDivisor;
    public double baseFactor = 1.0;
}

import std.array : Appender;

// formating helper
void formatWithCustomComma(Appender!string sink, string commaSign, int precision, bool enableTrailingZeros, double value) {
    import std.format : singleSpec, FormatSpec, formatValue;
    import std.array : appender;
    
    double afterComma = fmod(value.abs, 1.0);
    double beforeComma = value.abs - afterComma;
    bool isNegative = value < 0.0;
    
    if( isNegative ) {
        sink ~= "-";
    }
    
    FormatSpec!char specBeforeComma = singleSpec("%.0f");
    formatValue(sink, beforeComma, specBeforeComma);
    
    FormatSpec!char specAfterComma = singleSpec("%.1f");
    specAfterComma.precision = precision;
    
    auto appenderAfterComma = appender!string();
    formatValue(appenderAfterComma, afterComma, specAfterComma);
    string stringOfAfterComma = appenderAfterComma.data[2..$];
    
    if( !enableTrailingZeros ) {
        // remove last trailing zero until nonzero or empty
        while( stringOfAfterComma.length > 0 && stringOfAfterComma[$-1] == '0' ) {
            stringOfAfterComma.length--;
        }
    }

    // delimiter
    if( stringOfAfterComma.length > 0 ) { 
        sink ~= commaSign;
    }
    
    
    sink ~= stringOfAfterComma;
}

string formatBaseWithFactor(ref FormatSettings formatSettings, double value, out string sufix) {
    // because we can't calculate the logarithm of 0.0
    int baseWithFactor = (value.abs == 0.0) ? 0 : calcBaseWithFactor(formatSettings.powerDivisor, formatSettings.baseFactor, value);
    
    double valueForFormatation = value / pow(10.0, formatSettings.powerDivisor * baseWithFactor);
    
    // format the string
    {
        import std.array : appender;
        auto w = appender!string();
        
        formatWithCustomComma(w, formatSettings.stringSettings.punctationDelimiter, formatSettings.formatPrecision, formatSettings.enableTrailingZeros, valueForFormatation);
        
        string[] sufixArray = (baseWithFactor >= 0) ? formatSettings.stringSettings.sufixesPositive : formatSettings.stringSettings.sufixesNegative;
        sufix = (baseWithFactor.abs < sufixArray.length) ? sufixArray[baseWithFactor.abs] : "?";
        
        return w.data;
    }
}


void main() {
    
    FormatSettings formatSettings;
    with( formatSettings ) {
        stringSettings = new StringSettings();
        stringSettings.punctationDelimiter = ",";
        stringSettings.sufixesPositive = ["", "k", "m", "b", "t"];
        stringSettings.sufixesNegative = ["milli", "micro", "nano"];
        
        enableTrailingZeros = false;
        
        formatPrecision = 4;
        powerDivisor = 3;
        baseFactor = 2.5;
    }
    
    foreach( iterationValue; [0.0, -0.001, -2, -2.5, -5, 4, 25, 2400, 3000, 3001, 3001.06]) {
        string sufix;
        string formatedNumber = formatBaseWithFactor(formatSettings, iterationValue, sufix);
            writeln(iterationValue, " : ", formatedNumber, " ", sufix);

    }
    
}

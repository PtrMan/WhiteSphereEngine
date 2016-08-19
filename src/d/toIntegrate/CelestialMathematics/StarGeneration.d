import std.math : tan, PI;

class StarGeneration {
  static float calculateLuminosityByTemperature(float temperature) {
    /*
     * an very simple approximation of the "Hertzsprung-Russel Diagram"
     *  http://www.enchantedlearning.com/subjects/astronomy/stars/startypes.shtml
     * uses the tangent functionwith some modifications
     * 
     * returns the base 10 logarithm
     */
    
    if( temperature > 5500.0f ) {
      float temperatureRanged = (temperature - 5500.0f) / (40000.0 - 5500.0f);
      float trigonometricinput = temperatureRanged * 1.40565 ; // wolfram alpha    tan x = 6
      
      return tan(trigonometricinput);
    }
    else {
      float temperatureRanged = (temperature - 3000.0f) / (5500.0f - 3000.0f);
      float trigonometricinput = temperatureRanged * (PI/2.0f - 0.25f); // found 0.25 emperical with wolfram alpha
      
      return -tan(trigonometricinput);
    }
  }
}

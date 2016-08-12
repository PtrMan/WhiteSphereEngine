#include <cstdint>
#include <cstddef>

#include <cmath>



double dotStride4(double *a, double *b) {
  double result = 0.0;
  for( size_t i = 0; i < 4; i++ ) {
    result += (a[i] * b[i+i*4]);
  }
  
  return result;
}

struct Vector4 {
  double values[4];
};

struct Matrix4x4 {
  double values[16];
  
  
};

Vector4 mul(Vector4 vector, Matrix4x4 matrix) {
  Vector4 result;
  result.values[0] = dotStride4(vector.values, &(matrix.values[0]));
  result.values[1] = dotStride4(vector.values, &(matrix.values[1]));
  result.values[2] = dotStride4(vector.values, &(matrix.values[2]));
  result.values[3] = dotStride4(vector.values, &(matrix.values[3]));
  return result;
}

Vector4 homogenize(Vector4 vector) {
  Vector4 result;
  for( size_t i = 0; i < 3; i++ ) {
    result.values[i] = vector.values[i] / vector.values[3];
  }
  
  return result;
}



// helper
Vector4 mulAndHomogenize(Vector4 vector, Matrix4x4 matrix) {
  return homogenize(mul(vector, matrix));
}
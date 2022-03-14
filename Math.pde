float[] solveQuadratic(float a, float b, float c) {
  float x1 = 0, x2 = 0;
  float success = 0;
  
  float D = b * b - 4 * a * c;
  
  if (D >= 0) {
    success = 1;
    float sqrt_D = sqrt(D);
    
    x1 = (-b + sqrt_D) / (2 * a);
    x2 = (-b - sqrt_D) / (2 * a);
    
    if (x1 > x2) {
      float tmp = x2;
      x2 = x1;
      x1 = tmp;
    }
  }
  
  return new float[] {success, x1, x2};
}

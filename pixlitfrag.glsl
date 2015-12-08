
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 hVector;
varying vec3 lightDir;

void main() {  
  vec3 direction = normalize(lightDir);
  vec3 normal = normalize(ecNormal);
  float intensity = max(0.0, dot(direction, normal));
  vec3 h = normalize(hVector);
  float specular = pow(dot(h, normal), 50.0);
//  if(specular > 0.5) specular = 1.0;
//  else specular = 0.0;
  gl_FragColor =  vec4(0.0,0.23,0.31,1.0) * vertColor + vec4(vec3(specular),1.0) * vertColor;
}

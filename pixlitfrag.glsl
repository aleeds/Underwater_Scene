#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform vec4 lightPosition;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 ecVertex;
varying vec3 lightDir;


void main() {   
  vec3 normal = normalize(ecNormal);
  lightDir = normalize(lightPosition.xyz - ecVertex);  
  vec3 direction = normalize(lightDir);
  float intensity = max(0.0, dot(direction, normalize(vec3(lightPosition))));
  float df = max (0.0, dot(direction, lightDir));
  vec3 newColor = vertColor * df + pow(intensity, 4);
  gl_FragColor = vec4(newColor, 0.3);
}


#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec3 cameraPosition;
uniform sampler2D textureFloor;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 hVector;
varying vec3 lightDir;
varying vec3 ecVertex;

void main() {  
  vec3 direction = normalize(lightDir);
  vec3 normal = normalize(ecNormal);
  vec3 toVert = normalize(ecVertex - cameraPosition);
  float theta1 = acos(dot(-toVert, normal));
  float theta2 = asin(1.0/1.33*sin(theta1));
  vec3 refracted = 1.0/1.33*toVert + (1.0/1.33*cos(theta1)-cos(theta2))*normal;
  float t = dot((vec3(0.0,0.0,-800.0)-ecVertex), vec3(0.0,0.0,1.0))/dot(normalize(refracted), vec3(0.0,0.0,1.0));
  vec3 intersect = t * normalize(refracted) + ecVertex;
  vec2 texCoord = vec2((intersect.x + 8192.0)/16384.0,(intersect.y + 8192.0)/16384.0);
  vec4 texColor = texture2D(textureFloor, texCoord);
  float intensity = max(0.0, dot(direction, normal));
  vec3 h = normalize(hVector);
  float specular = pow(dot(h, normal), 50.0);
  
  gl_FragColor =  vec4(0.0,0.46,0.62,1.0) * vertColor * 0.5 + vec4(vec3(specular),1.0) * vertColor + texColor*0.5;
 // gl_FragColor =  texColor;
}

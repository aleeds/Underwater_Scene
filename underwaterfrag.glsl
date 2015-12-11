#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;

void main() {
  gl_FragColor = vertColor +  0.5 * vec4(0.0,0.23,0.47,1.0);
}
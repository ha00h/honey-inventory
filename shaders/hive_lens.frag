#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uAmount;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  vec2 c = uv - vec2(0.5);
  float t = smoothstep(0.0, 0.88, length(c));
  float warped = mix(0.68, 1.0, t);
  float scale = mix(1.0, warped, uAmount);
  vec2 src = vec2(0.5) + c * scale;
  if (src.x < 0.0 || src.x > 1.0 || src.y < 0.0 || src.y > 1.0) {
    fragColor = vec4(0.0);
  } else {
#ifdef IMPELLER_TARGET_OPENGLES
    src.y = 1.0 - src.y;
#endif
    fragColor = texture(uTexture, src);
  }
}

uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform float uColorOffset;
uniform float uColorMultiplier;
uniform vec3 uFogColor;

varying float vElevation;
varying float vDistanceToCamera;

void main()
{
    float mixStrength = (vElevation + uColorOffset) * uColorMultiplier;
    mixStrength = clamp(mixStrength, 0.0, 1.0);
    vec3 color = mix(uDepthColor, uSurfaceColor, mixStrength);

    float mixFogStrength = smoothstep(4.0, 15.0, vDistanceToCamera);
    vec3 fogColor = uFogColor;

    vec3 mixedFogWaveColor = mix(color, fogColor, mixFogStrength * 0.75);

    gl_FragColor = vec4(mixedFogWaveColor, 1.0);
    // gl_FragColor = vec4(vec3(mixFogStrength), 1.0);

    #include <colorspace_fragment>
}
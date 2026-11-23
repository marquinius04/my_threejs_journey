#define PI 3.1415926535897932384626433832795

varying vec2 vUv;

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, float rotation, vec2 mid)
{
    return vec2(
      cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
      cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
    );
}

//	Classic Perlin 2D Noise 
//	by Stefan Gustavson
//
vec2 fade(vec2 t)
{
    return t*t*t*(t*(t*6.0-15.0)+10.0);
}

vec4 permute(vec4 x)
{
    return mod(((x*34.0)+1.0)*x, 289.0);
}

float cnoise(vec2 P)
{
    vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
    Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
    vec4 ix = Pi.xzxz;
    vec4 iy = Pi.yyww;
    vec4 fx = Pf.xzxz;
    vec4 fy = Pf.yyww;
    vec4 i = permute(permute(ix) + iy);
    vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
    vec4 gy = abs(gx) - 0.5;
    vec4 tx = floor(gx + 0.5);
    gx = gx - tx;
    vec2 g00 = vec2(gx.x,gy.x);
    vec2 g10 = vec2(gx.y,gy.y);
    vec2 g01 = vec2(gx.z,gy.z);
    vec2 g11 = vec2(gx.w,gy.w);
    vec4 norm = 1.79284291400159 - 0.85373472095314 * vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
    g00 *= norm.x;
    g01 *= norm.y;
    g10 *= norm.z;
    g11 *= norm.w;
    float n00 = dot(g00, vec2(fx.x, fy.x));
    float n10 = dot(g10, vec2(fx.y, fy.y));
    float n01 = dot(g01, vec2(fx.z, fy.z));
    float n11 = dot(g11, vec2(fx.w, fy.w));
    vec2 fade_xy = fade(Pf.xy);
    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
    return 2.3 * n_xy;
}

// // First pattern
// void main()
// {
//     gl_FragColor = vec4(vUv, 1.0, 1.0);
// }

// // Second pattern
// void main()
// {
//     gl_FragColor = vec4(vUv.x, vUv.y, 0.0, 1.0);
// }

// // Third pattern
// void main()
// {
//     float strength = vUv.x;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Fourth pattern
// void main()
// {
//     float strength = vUv.y;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Fifth pattern
// void main()
// {
//     float strength = 1.0 - vUv.y;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Sixth pattern
// void main()
// {
//     float strength = vUv.y * 10.0;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Seventh pattern
// void main()
// {
//     float strength = mod(vUv.y * 10.0, 1.0);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Eighth pattern
// void main()
// {
//     float strength = mod(vUv.y * 10.0, 1.0);

//     strength = step(0.5, strength);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Ninth pattern
// void main()
// {
//     float strength = mod(vUv.y * 10.0, 1.0);

//     strength = step(0.75, strength);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Tenth pattern
// void main()
// {
//     float strength = mod(vUv.x * 10.0, 1.0);

//     strength = step(0.75, strength);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Eleventh pattern
// void main()
// {
//     float strengthX = mod(vUv.x * 10.0, 1.0);
//     float strengthY = mod(vUv.y * 10.0, 1.0);

//     strengthX = step(0.75, strengthX);
//     strengthY = step(0.75, strengthY);

//     gl_FragColor = vec4(vec3(strengthX + strengthY), 1.0);
// }

// // Twelfth pattern
// void main()
// {
//     float strength = step(0.75, mod(vUv.x * 10.0, 1.0));
//     strength *= step(0.75, mod(vUv.y * 10.0, 1.0));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirteenth pattern
// void main()
// {
//     float strength = step(0.2, mod(vUv.x * 10.0, 1.0));
//     strength *= step(0.75, mod(vUv.y * 10.0, 1.0));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Fourteenth pattern
// void main()
// {
//     float barX = step(0.4, mod(vUv.x * 10.0, 1.0));
//     barX *= step(0.8, mod(vUv.y * 10.0, 1.0));

//     float barY = step(0.4, mod(vUv.y * 10.0, 1.0));
//     barY *= step(0.8, mod(vUv.x * 10.0, 1.0));

//     float strength = barX + barY;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Fifteenth pattern
// void main()
// {
//     float barX = step(0.4, mod(vUv.x * 10.0, 1.0));
//     barX *= step(0.8, mod(vUv.y * 10.0 + 0.2, 1.0));

//     float barY = step(0.8, mod(vUv.x * 10.0 + 0.2, 1.0));
//     barY *= step(0.4, mod(vUv.y * 10.0, 1.0));

//     float strength = barX + barY;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Sixteenth pattern
// void main()
// {
//     float strength = abs(vUv.x - 0.5);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Seventeenth pattern
// void main()
// {
//     float strength = min(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Eighteenth pattern
// void main()
// {
//     float strength = max(abs(vUv.x - 0.5), abs(vUv.y - 0.5));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Nineteenth pattern
// void main()
// {
//     float strength = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twentieth pattern
// void main()
// {
//     float square1 = step(0.2, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));
//     float square2 = 1.0 - step(0.25, max(abs(vUv.x - 0.5), abs(vUv.y - 0.5)));

//     float strength = square1 * square2;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-first pattern
// void main()
// {
//     float strength = floor(vUv.x * 10.0) / 10.0;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-second pattern
// void main()
// {
//     float strength = floor(vUv.x * 10.0) / 10.0;
//     strength *= floor(vUv.y * 10.0) / 10.0;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-third pattern
// void main()
// {
//     float strength = random(vUv);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-fourth pattern
// void main()
// {
//     vec2 gridUv = vec2(
//         floor(vUv.x * 10.0) / 10.0, 
//         floor(vUv.y * 10.0) / 10.0
//     );

//     float strength = random(gridUv);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-fifth pattern
// void main()
// {
//     vec2 gridUv = vec2(
//         floor(vUv.x * 10.0) / 10.0, 
//         floor((vUv.y + vUv.x * 0.5) * 10.0) / 10.0
//     );

//     float strength = random(gridUv);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-sixth pattern
// void main()
// {
//     float strength = length(vUv);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-seventh pattern
// void main()
// {
//     float strength = length(vUv - 0.5);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-eighth pattern
// void main()
// {
//     float strength = 1.0 - length(vUv - 0.5);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Twenty-ninth pattern
// void main()
// {
//     float strength = 0.02 / length(vUv - 0.5);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirtieth pattern
// void main()
// {
//     vec2 lightUv = vec2(
//         vUv.x * 0.1 + 0.45,
//         vUv.y * 0.5 + 0.25
//     );
//     float strength = 0.02 / length(lightUv - 0.5);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-first pattern
// void main()
// {
//     vec2 lightUvX = vec2(vUv.x * 0.1 + 0.45, vUv.y * 0.5 + 0.25);
//     float lightX = 0.02 / length(lightUvX - 0.5);

//     vec2 lightUvY = vec2(vUv.y * 0.1 + 0.45, vUv.x * 0.5 + 0.25);
//     float lightY = 0.02 / length(lightUvY - 0.5);

//     float strength = lightX * lightY;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-second pattern
// void main()
// {
//     vec2 rotatedUv = rotate(vUv, PI * 0.25, vec2(0.5));

//     vec2 lightUvX = vec2(rotatedUv.x * 0.1 + 0.45, rotatedUv.y * 0.5 + 0.25);
//     float lightX = 0.02 / length(lightUvX - 0.5);

//     vec2 lightUvY = vec2(rotatedUv.y * 0.1 + 0.45, rotatedUv.x * 0.5 + 0.25);
//     float lightY = 0.02 / length(lightUvY - 0.5);

//     float strength = lightX * lightY;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-third pattern
// void main()
// {
//     float strength = step(0.25, length(vUv - 0.5));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-fourth pattern
// void main()
// {
//     float strength = abs(length(vUv - 0.5) - 0.25);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-fifth pattern
// void main()
// {
//     float strength = step(0.01, abs(length(vUv - 0.5) - 0.25));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-sixth pattern
// void main()
// {
//     float strength = 1.0 - step(0.01, abs(length(vUv - 0.5) - 0.25));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-seventh pattern
// void main()
// {
//     vec2 wavedUv = vec2(
//         vUv.x,
//         vUv.y + sin(vUv.x * 30.0) * 0.1
//     );

//     float strength = 1.0 - step(0.01, abs(length(wavedUv - 0.5) - 0.25));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-eighth pattern
// void main()
// {
//     vec2 wavedUv = vec2(
//         vUv.x + sin(vUv.y * 30.0) * 0.1,
//         vUv.y + sin(vUv.x * 30.0) * 0.1
//     );

//     float strength = 1.0 - step(0.01, abs(length(wavedUv - 0.5) - 0.25));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Thirty-ninth pattern
// void main()
// {
//     vec2 wavedUv = vec2(
//         vUv.x + sin(vUv.y * 100.0) * 0.1,
//         vUv.y + sin(vUv.x * 100.0) * 0.1
//     );

//     float strength = 1.0 - step(0.01, abs(length(wavedUv - 0.5) - 0.25));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Fortieth pattern
// void main()
// {
//     float angle = atan(vUv.x, vUv.y);
//     float strength = angle;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-first pattern
// void main()
// {
//     float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
//     float strength = angle;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-second pattern
// void main()
// {
//     float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
//     angle /= PI * 2.0;
//     angle += 0.5;
    
//     float strength = angle;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-third pattern
// void main()
// {
//     float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
//     angle /= PI * 2.0;
//     angle += 0.5;
//     angle *= 20.0;
//     angle = mod(angle, 1.0);

//     float strength = angle;

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-fourth pattern
// void main()
// {
//     float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
//     angle /= PI * 2.0;
//     angle += 0.5;

//     float strength = sin(angle * 100.0);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-fifth pattern
// void main()
// {
//     float angle = atan(vUv.x - 0.5, vUv.y - 0.5);
//     angle /= PI * 2.0;
//     angle += 0.5;
//     float sinusoid = sin(angle * 100.0);

//     float radius = 0.25 + sinusoid * 0.02;
//     float strength = 1.0 - step(0.01, abs(length(vUv - 0.5) - radius));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-sixth pattern
// void main()
// {
//     float strength = cnoise(vUv * 10.0);

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-seventh pattern
// void main()
// {
//     float strength = step(0.0, cnoise(vUv * 10.0));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-eighth pattern
// void main()
// {
//     float strength = 1.0 - abs(cnoise(vUv * 10.0));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Forty-ninth pattern
// void main()
// {
//     float strength = step(0.9, sin(cnoise(vUv * 10.0) * 20.0));

//     gl_FragColor = vec4(vec3(strength), 1.0);
// }

// // Fifthieth pattern
// void main()
// {
//     float strength = step(0.9, sin(cnoise(vUv * 10.0) * 20.0));
    
//     // PARA QUE LAS SECCIONES QUE COINCIDEN CON OTRAS NO BRILLEN MÁS DE 1.0
//     strength = clamp(strength, 0.0, 1.0);

//     vec3 blackColor = vec3(0.0);
//     vec3 uvColor = vec3(vUv, 0.5);
//     vec3 mixedColor = mix(blackColor, uvColor, strength);

//     gl_FragColor = vec4(mixedColor, 1.0);
// }
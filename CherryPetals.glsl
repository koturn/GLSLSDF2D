precision mediump float;


// vscode-glsl-canvas
// https://marketplace.visualstudio.com/items?itemName=circledev.glsl-canvas
#define VSCODE 1
// Shadertoy
// https://www.shadertoy.com
#define SHADERTOY 2
// GLSL SANDBOX
// https://glslsandbox.com
#define GLSLSANDBOX 3

// Platform switch.
#define PLATFORM VSCODE
// #define PLATFORM SHADERTOY
// #define PLATFORM GLSLSANDBOX


#if PLATFORM == SHADERTOY
#    define u_time iTime
#    define u_mouse iMouse
#    define u_resolution iResolution
#elif PLATFORM == GLSLSANDBOX
#    define u_time time
#    define u_mouse mouse
#    define u_resolution resolution
#endif


#if PLATFORM == VSCODE || PLATFORM == GLSLSANDBOX
//! Elapsed seconds.
uniform float u_time;
//! Mouse position.
uniform vec2 u_mouse;
//! Screen resolution.
uniform vec2 u_resolution;
#endif


const vec4 kInnerColor = vec4(0.95, 0.6333333, 0.95, 1.0);
const vec4 kOuterColor = vec4(0.0, 0.0, 0.0, 1.0);


#ifndef DOXYGEN
void mainImage(out vec4 fragColor, in vec2 fragCoord);
float map(vec2 p);
float sdCherryPetals(vec2 p, float scale);
#endif


#if PLATFORM != SHADERTOY
/*!
 * @brief Entry point of this fragment shader program.
 */
void main(void)
{
    mainImage(/* out */ gl_FragColor, gl_FragCoord.xy);
}
#endif


/*!
 * @brief Body of fragment shader function.
 * @param [out] fragColor  Color of fragment.
 * @param [in] fragCoord  Coordinate of fragment.
 */
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 position = (fragCoord.xy * 2.0 - u_resolution.xy) / min(u_resolution.x, u_resolution.y);
    fragColor = map(position) <= 0.0 ? kInnerColor : kOuterColor;
}


/*!
 * @brief SDF (Signed Distance Function) of objects.
 * @param [in] p  Coordinate.
 * @return Signed Distance to the objects.
 */
float map(vec2 p)
{
    return sdCherryPetals(p, 0.75);
}


/*!
 * @brief SDF of cherry petals
 * @param [in] p  Coordinate.
 * @param [in] scale  Scale.
 * @return Signed Distance to the cherry petals.
 */
float sdCherryPetals(vec2 p, float scale)
{
    float theta = atan(p.y, p.x) * 2.5;

    vec2 absCs = abs(vec2(cos(theta), sin(theta)));
    absCs += vec2(0.4, 1.0);

    float d = min(absCs.x , absCs.y) * scale;

    return length(p) - d;
}

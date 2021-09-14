#version 300 es

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;

uniform vec4 u_Color; // The color with which to render this instance of geometry.
uniform int u_Time;
// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.

float noise(vec3 p) {
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

void main()
{
//    //achieve a interesting color palette by not normalizing light vec
//     float t = dot(normalize(fs_Nor), fs_LightVec);
//     float t2 = dot(normalize(fs_Nor), normalize(fs_LightVec));

//     vec3 a = vec3(1.8, 0.5, 0.5);
//     vec3 b = vec3(0.5, 0.5, 0.5);
//     vec3 c = vec3(1.f, 0.5, 1.f);
//     vec3 c2 = vec3(1.f, 2, 1.f);
//     vec3 d = vec3(0.f, 1.38, 0.67);

//     out_Col = vec3(a + b * cos(2 * 3.14159 * (c * t + d)));
//     vec3 col2 = vec3(a + b * cos(2 * 3.14159 * (c2 * t2 + d)));

//     out_Col = mix(out_Col, vec3(noise(fs_Pos)*out_Col), vec3(cos(u_Time/10)));
//     out_Col = mix(out_Col, col2, vec3(cos(u_Time/10)));
//     out_Col = clamp(out_Col, 0.f, 1.f)

    // Material base color (before shading)
    vec4 diffuseColor = u_Color;

    // Calculate the diffuse term for Lambert shading
    float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
    // Avoid negative lighting values
    // diffuseTerm = clamp(diffuseTerm, 0, 1);

    float ambientTerm = 0.2;

    diffuseTerm = clamp(diffuseTerm, 0.f, 1.f)

    float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
                                                        //to simulate ambient lighting. This ensures that faces that are not
                                                        //lit by our point light are not completely black.


    // Compute final shaded color
    out_Col = vec4(diffuseColor.rgb * lightIntensity, diffuseColor.a);

}
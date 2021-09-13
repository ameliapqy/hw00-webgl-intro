#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader
uniform int u_Time;

in vec3 fs_Pos;
in vec3 fs_Nor;
in vec3 fs_Col;
in vec3 fs_LightVec;
layout(location = 0) out vec3 out_Col;

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

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
    //achieve a interesting color palette by not normalizing light vec
    float t = dot(normalize(fs_Nor), fs_LightVec);
    float t2 = dot(normalize(fs_Nor), normalize(fs_LightVec));

    vec3 a = vec3(1.8, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.f, 0.5, 1.f);
    vec3 c2 = vec3(1.f, 2, 1.f);
    vec3 d = vec3(0.f, 1.38, 0.67);

    out_Col = vec3(a + b * cos(2 * 3.14159 * (c * t + d)));
    vec3 col2 = vec3(a + b * cos(2 * 3.14159 * (c2 * t2 + d)));

    out_Col = mix(out_Col, vec3(noise(fs_Pos)*out_Col), vec3(cos(u_Time/10)));
    out_Col = mix(out_Col, col2, vec3(cos(u_Time/10)));
}


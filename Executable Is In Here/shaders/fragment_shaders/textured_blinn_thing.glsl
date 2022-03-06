#version 430

#include "../fragments/fs_common_inputs.glsl"

// We output a single color to the color buffer
layout(location = 0) out vec4 frag_color;

////////////////////////////////////////////////////////////////
/////////////// Instance Level Uniforms ////////////////////////
////////////////////////////////////////////////////////////////

// Represents a collection of attributes that would define a material
// For instance, you can think of this like material settings in 
// Unity
struct Material {
	sampler2D Diffuse;
	sampler2D Specular;
	float Shininess;
};
// Create a uniform for the material

uniform Material u_Material;
uniform int doAmbient;

uniform int steps;
uniform sampler1D s_ToonTerm;

uniform int doSpecRamp;
uniform sampler1D s_specRamp;

uniform int doDiffuseRamp;
uniform sampler1D s_diffRamp;

////////////////////////////////////////////////////////////////
///////////// Application Level Uniforms ///////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/multiple_point_lights.glsl"

////////////////////////////////////////////////////////////////
/////////////// Frame Level Uniforms ///////////////////////////
////////////////////////////////////////////////////////////////

#include "../fragments/frame_uniforms.glsl"
#include "../fragments/color_correction.glsl"

// https://learnopengl.com/Advanced-Lighting/Advanced-Lighting
void main() {

//specular


	// Normalize our input normal
	vec3 normal = normalize(inNormal);

	float specPower = texture(u_Material.Specular, inUV).r;

	if(u_Material.Shininess != 0){
		specPower = u_Material.Shininess;
	}

	
	
	vec3 toEye = normalize(u_CamPos.xyz - inWorldPos);
	vec3 environmentDir = reflect(-toEye, normal);
	vec3 reflected = SampleEnvironmentMap(environmentDir);

	vec3 lightAccumulation = CalcAllLightContribution(inWorldPos, normal, u_CamPos.xyz, specPower);
	
	// Use the lighting calculation that we included from our partial file (Calculates specular and diffuse)
	if(doSpecRamp == 1 || doDiffuseRamp == 1){
		lightAccumulation = CalcPointLightContributionWithSpecRamp(inWorldPos, normal, u_CamPos.xyz, specPower, doSpecRamp, s_specRamp, doDiffuseRamp, s_diffRamp);
	}

	// Get the albedo from the diffuse / albedo map
	vec4 textureColor = texture(u_Material.Diffuse, inUV);

	// combine for the final result
	vec3 specular = lightAccumulation  * inColor * textureColor.rgb;

	//vec4 frag_spec_color = vec4(ColorCorrect(mix(result, reflected, specPower)), textureColor.a);
	
	
//ambient

	vec3 lightColor = vec3(1.0, 1.0, 1.0);
	float ambientStrength = 0.9;
	vec3 ambient = ((ambientStrength * lightColor) * inColor * textureColor.rgb);
	
	if(doAmbient == 1){
		frag_color = textureColor;
	} else if(doAmbient == 2){
		frag_color = vec4(ambient, textureColor.a);
	} else if(doAmbient == 3) {
		frag_color = vec4(specular, textureColor.a);
	} else if(doAmbient == 4){
		frag_color = vec4(ambient + specular, textureColor.a);
	} else if(doAmbient == 5){
		vec4 toon = vec4(ambient + specular, textureColor.a);
		toon.r = texture(s_ToonTerm, toon.r).r;
		toon.g = texture(s_ToonTerm, toon.g).g;
		toon.b = texture(s_ToonTerm, toon.b).b;
		
		frag_color = toon;
	} else {
		frag_color = vec4(ambient + specular, textureColor.a);
	}
	
}
/**
 * Technicolor version 1.1
 * Original by DKT70
 * Optimized by CeeJay.dk
 */

uniform float TechniAmount <
	ui_type = "drag";
	ui_min = 0.0; ui_max = 1.0;
> = 0.4;
uniform float TechniPower <
	ui_type = "drag";
	ui_min = 0.0; ui_max = 8.0;
> = 4.0;
uniform float3 NegativeAmount <
	ui_type = "color";
> = float3(0.88, 0.88, 0.88);

#include "ReShade.fxh"

float3 TechnicolorPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	const float3 cyanfilter = float3(0.0, 1.30, 1.0);
	const float3 magentafilter = float3(1.0, 0.0, 1.05);
	const float3 yellowfilter = float3(1.6, 1.6, 0.05);
	const float2 redorangefilter = float2(1.05, 0.620); // RG_
	const float2 greenfilter = float2(0.30, 1.0);       // RG_
	const float2 magentafilter2 = magentafilter.rb;     // R_B

	float3 tcol = tex2D(ReShade::BackBuffer, texcoord).rgb;
	
	float2 negative_mul_r = tcol.rg * (1.0 / (NegativeAmount.r * TechniPower));
	float2 negative_mul_g = tcol.rg * (1.0 / (NegativeAmount.g * TechniPower));
	float2 negative_mul_b = tcol.rb * (1.0 / (NegativeAmount.b * TechniPower));
	float3 output_r = dot(redorangefilter, negative_mul_r).xxx + cyanfilter;
	float3 output_g = dot(greenfilter, negative_mul_g).xxx + magentafilter;
	float3 output_b = dot(magentafilter2, negative_mul_b).xxx + yellowfilter;

	return lerp(tcol, output_r * output_g * output_b, TechniAmount);
}

technique Technicolor
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = TechnicolorPass;
	}
}

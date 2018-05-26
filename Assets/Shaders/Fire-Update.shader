// unity fire effect using customrendertextures @ unitycoder.com
// fire tutorial from https://www.youtube.com/watch?v=X0kjv0MozuY by The Coding Train
// which is based on https://web.archive.org/web/20160418004150/http://freespace.virgin.net/hugo.elias/models/m_fire.htm
// this update shader based on https://raw.githubusercontent.com/keijiro/RDSystem/master/Assets/RDSystem/Update.shader

Shader "UnityLibrary/Effects/Fire-Update"
{
    Properties
    {
		_FireGradient ("Fire Gradient", 2D) = "white" {}
		_CoolTex ("CoolingTexture", 2D) = "white" {}
		_ScrollSpeed ("Cooling Scroll Speed", float) = 2
		_Strength ("Cooling Strength", float) = 0.05
    }

    CGINCLUDE

    #include "UnityCustomRenderTexture.cginc"

	sampler2D _FireGradient;
	sampler2D _CoolTex;
	float _Strength;
	float _ScrollSpeed;


    half4 frag(v2f_customrendertexture i) : SV_Target
    {
        float xs = 1 / _CustomRenderTextureWidth;
        float ys = 1 / _CustomRenderTextureHeight;

        float2 uv = i.globalTexcoord;

        float3 deltaUV = float3(xs, ys, 0);

		// use alpha channel for fire buffer
        half c = 0;
        c += tex2D(_SelfTexture2D, uv - float2(0,ys) + deltaUV.zy).a; // top
        c += tex2D(_SelfTexture2D, uv - float2(0,ys) + deltaUV.xz).a; // right
        c += tex2D(_SelfTexture2D, uv - float2(0,ys) - deltaUV.zy).a; // bottom
        c += tex2D(_SelfTexture2D, uv - float2(0,ys) - deltaUV.xz).a; // left
		c = c*0.25f;

		// minus cooling texture
		float2 scroll = float2(0,-_Time.x*_ScrollSpeed);
        half cooltex = tex2D(_CoolTex, i.globalTexcoord+scroll).r*_Strength;
		c = clamp(c-cooltex.r,0,1);

		// keep bottom on fire
		half b = (i.globalTexcoord.y<0.01);
		c=c+b;

		// get fire color from gradient
        half3 fire = tex2D(_FireGradient, float2(c,0.5)).rgb;
        return half4(fire*c, c);
    }

    ENDCG

    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        Pass
        {
            Name "Update"
            CGPROGRAM
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            ENDCG
        }
    }
}

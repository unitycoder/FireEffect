// based on https://github.com/keijiro/RDSystem/blob/master/Assets/RDSystem/Initialization.shader

Shader "UnityLibrary/Effects/Fire-Init"
{
    CGINCLUDE
    #include "UnityCustomRenderTexture.cginc"

    half4 frag(v2f_init_customrendertexture i) : SV_Target
    {
		// make white line at the bottom
		half c = (i.texcoord.y<0.01);
        return half4(c,c,c,1);
    }

    ENDCG

    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        Pass
        {
            Name "Init"
            CGPROGRAM
            #pragma vertex InitCustomRenderTextureVertexShader
            #pragma fragment frag
            ENDCG
        }
    }
}

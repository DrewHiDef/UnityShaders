Shader "DrewShaders/Shader5Unlit"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Often the struct passed from the vertex shader to the fragmen shader is given the name
            // v2f - short for vertex to fragment.
            struct v2f
            {
                float4 vertex: SV_POSITION; // vertex position mapped from model space to clip space
                float4 position: TEXCOORD1; // model space position
                float2 uv : TEXCOORD0;
            };

            v2f vert( appdata_base v )
            {
                v2f o;
                o.vertex = UnityObjectToClipPos( v.vertex );
                o.position = v.vertex;
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag ( v2f i) : SV_Target
            {
                fixed3 color = saturate(i.position * 2);
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}

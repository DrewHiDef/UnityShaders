Shader "DrewShaders/Shader9Unlit"
{
    Properties
    {
        _Mouse( "Mouse", Vector ) = ( 0,0,0,0 )
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Mouse;

            float rect(float2 pt, float2 size, float2 center){
                float2 p = pt - center;
                float2 halfsize = size * 0.5;

                float horz = step(-halfsize.x, p.x) - step(halfsize.x, p.x);
                float vert = step(-halfsize.y, p.y) - step(halfsize.y, p.y);

                return horz * vert;
            }

            fixed4 frag( v2f_img i ) : SV_Target
            {
                float2 pos = i.uv;
                float square = rect( pos, float2( 0.15, 0.15 ), _Mouse.xy );
                fixed4 color = fixed4(fixed3(1,1,0) * square, 1);
                return color;
            }
            ENDCG
        }
    }
}

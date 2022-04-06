Shader "DrewShaders/Shader14Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,0,1.0)
        _Radius("Radius", Float) = 0.3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members position)
//#pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 position : TEXCOORD1;
                float2 uv: TEXCOORD0;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                o.uv = v.texcoord;
                return o;
            }
           
            fixed4 _Color;
            float _Radius;

            float circle( float2 pt, float2 center, float radius )
            {
                float2 p = pt - center;
                float smoothedge = 0.05;
                return 1.0 - smoothstep( radius - smoothedge, radius + smoothedge, length( p ) );
            }

            float outlinecircle( float2 pt, float2 center, float radius, float linewidth )
            {
                float2 p = pt - center;
                float len = length( p );
                float halfwidth = linewidth * 0.5;
                //return step(radius - halfwidth, len) - step(radius + halfwidth, len);

                float smoothedge = halfwidth;
                return smoothstep( radius - halfwidth - smoothedge, radius - halfwidth, len )
                     - smoothstep( radius + halfwidth, radius + halfwidth + smoothedge, len );
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 pos = i.position * 2;
                fixed3 color = _Color * outlinecircle(pos, float2(0, 0), _Radius, 0.05);
                
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}

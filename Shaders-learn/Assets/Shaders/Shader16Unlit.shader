﻿Shader "DrewShaders/Shader16Unlit"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0,1.0)
        _LineWidth("Line Width", Float) = 0.01
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
                float2 uv: TEXCOORD0;
                float4 position: TEXCOORD1;
                float4 screenPos: TEXCOORD2;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                o.uv = v.texcoord;
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }
           
            fixed4 _Color;
            float _LineWidth;
            
            // normally sin returns from -1 to 1. This normalizes to return from zero to 1.
            float getDelta( float x ){
            	return (sin(x) + 1.0)/2.0;
            }

            float onLine( float a, float b, float line_width, float edge_thickness )
            {
                float half_line_width = line_width * 0.5;
                return smoothstep( a - half_line_width - edge_thickness, a - half_line_width, b )
                    - smoothstep( a + half_line_width, a + half_line_width + edge_thickness, b );
            }
            
            fixed4 frag( v2f i ) : SV_Target
            {
                float2 pos = i.position.xy * 2;
                float2 uv = i.uv; // i.screenPos.xy / i.screenPos.w;
            	
                fixed3 color = lerp(float3(0,0,0), _Color, onLine( uv.y, lerp(0.3, 0.7, getDelta( uv.x * UNITY_TWO_PI)), _LineWidth, _LineWidth*0.1));
                
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}

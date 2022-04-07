Shader "DrewShaders/Shader24Unlit"
{
    Properties
    {
        _BrickColor( "Brick Color", Color ) = ( 0.9, 0.3, 0.4, 1 )
        _MortarColor( "Mortar", Color ) = ( 0.7, 0.7, 0.7, 1 )
        _TileCount( "Tile Count", Int ) = 10

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

            fixed4 _BrickColor;
            fixed4 _MortarColor;
            int _TileCount;
            
            float brick(float2 pt, float mortar_height, float edge_thickness){
                float half_mortar_height = mortar_height * 0.5;

                // draw bottom line
                float result = 1.0 - smoothstep(half_mortar_height, half_mortar_height + edge_thickness, pt.y);

                //draw top line
                result += smoothstep( 1.0 - half_mortar_height - edge_thickness, 1.0 - half_mortar_height, pt.y );

                // draw middle line
                result += smoothstep( 0.5 -half_mortar_height - edge_thickness, 0.5 - half_mortar_height, pt.y );
                result -= smoothstep( 0.5 + half_mortar_height, 0.5 + half_mortar_height + edge_thickness, pt.y );

                if ( pt.y > 0.5 )
                {
                    pt.x = frac( pt.x + 0.5 );
                }

                result += smoothstep( -half_mortar_height - edge_thickness, -half_mortar_height, pt.x );
                result -= smoothstep( half_mortar_height, half_mortar_height + edge_thickness, pt.x );
                result += smoothstep( 1.0 - half_mortar_height - edge_thickness, 1.0 - half_mortar_height, pt.x );

                return saturate(result);
            }
            
            fixed4 frag( v2f_img i ) : SV_Target
            {
                float2 uv = frac( i.uv * _TileCount );
                //float brick_val = brick( uv, 0.05, 0.001 );
                //fixed3 color = brick_val * _MortarColor;
                //color += ( 1.0 - brick_val ) * _BrickColor;

                fixed3 color = lerp( _BrickColor.rgb, _MortarColor.rgb, brick( uv, 0.05, 0.001 ) );
                return fixed4(color, 1.0);
            }
            ENDCG
        }
    }
}

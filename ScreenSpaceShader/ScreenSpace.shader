// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WhiteOaksShaders/ScreenSpace"
{
	Properties
	{
		_SimpleContrastForColorHue("Simple Contrast ForColorHue", Float) = 1
		_SimpleColorblender("Simple Colorblender", Float) = 0
		_ColorHue("ColorHue", Color) = (0,0,0,1)
		_ColorBlender("ColorBlender", Color) = (0,0,0,1)
		_GrayScale("GrayScale", Float) = 0
		_GreyScaleColor("GreyScaleColor", Color) = (0,0,0,1)
		_DestatureateColor("DestatureateColor", Color) = (0,0,0,1)
		_Desaturate("Desaturate", Float) = 0.1
		_ZigzagLength("Zigzag Length", Float) = 0
		_ZigzagTexture("Zigzag Texture", 2D) = "white" {}
		_ZigZagPower("ZigZag Power", Float) = 0
		_Dotspatterntexture("Dots pattern texture", 2D) = "white" {}
		_DotsPatternSize("Dots Pattern Size", Float) = 0
		_DotsOffSetX("DotsOffSet X ", Float) = 0
		_DotsOffSetY("DotsOffSet Y", Float) = 0
		_brickTexture("brickTexture", 2D) = "white" {}
		_Bricksize("Brick size", Float) = 0
		_BrickOffSet("BrickOffSet", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Transparent+0" }
		Cull Front
		Blend One One
		
		AlphaToMask On
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 5.0
		#pragma surface surf StandardCustomLighting keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _SimpleContrastForColorHue;
		uniform float4 _ColorHue;
		uniform float4 _ColorBlender;
		uniform float _SimpleColorblender;
		uniform float4 _GreyScaleColor;
		uniform float _GrayScale;
		uniform float4 _DestatureateColor;
		uniform float _Desaturate;
		uniform sampler2D _ZigzagTexture;
		uniform float4 _ZigzagTexture_ST;
		uniform float _ZigZagPower;
		uniform float _ZigzagLength;
		uniform sampler2D _Dotspatterntexture;
		uniform float4 _Dotspatterntexture_ST;
		uniform float _DotsOffSetX;
		uniform float _DotsOffSetY;
		uniform float _DotsPatternSize;
		uniform float _BrickOffSet;
		uniform sampler2D _brickTexture;
		uniform float4 _brickTexture_ST;
		uniform float _Bricksize;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 temp_output_1_0 = CalculateContrast(_SimpleContrastForColorHue,_ColorHue);
			float4 lerpResult6 = lerp( temp_output_1_0 , temp_output_1_0 , _SimpleContrastForColorHue);
			float4 ColorHue5 = lerpResult6;
			float4 temp_output_20_0 = ( _ColorBlender * _SimpleColorblender );
			float4 blendOpSrc11 = temp_output_20_0;
			float4 blendOpDest11 = temp_output_20_0;
			float4 lerpBlendMode11 = lerp(blendOpDest11,( 1.0 - ( ( 1.0 - blendOpDest11) / max( blendOpSrc11, 0.00001) ) ),temp_output_20_0.r);
			float4 temp_output_11_0 = ( saturate( lerpBlendMode11 ));
			float4 lerpResult16 = lerp( temp_output_11_0 , temp_output_11_0 , float4( 0,0,0,0 ));
			float4 ColorBlending17 = lerpResult16;
			float grayscale21 = Luminance(_GreyScaleColor.rgb);
			float temp_output_23_0 = ( grayscale21 * _GrayScale );
			float lerpResult25 = lerp( temp_output_23_0 , temp_output_23_0 , 0.0);
			float GreyScale26 = lerpResult25;
			float3 desaturateInitialColor30 = _DestatureateColor.rgb;
			float desaturateDot30 = dot( desaturateInitialColor30, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar30 = lerp( desaturateInitialColor30, desaturateDot30.xxx, _Desaturate );
			float4 Desaturate37 = ( float4( desaturateVar30 , 0.0 ) * ColorHue5 );
			float2 uv_ZigzagTexture = i.uv_texcoord * _ZigzagTexture_ST.xy + _ZigzagTexture_ST.zw;
			float2 break20_g1 = ( i.uv_texcoord * tex2D( _ZigzagTexture, uv_ZigzagTexture ).rg );
			float temp_output_1_0_g5 = ( break20_g1.x / _ZigzagLength );
			float temp_output_7_0_g1 = ( ( break20_g1.y / _ZigZagPower ) - ( ( abs( ( ( temp_output_1_0_g5 - floor( ( temp_output_1_0_g5 + 0.5 ) ) ) * 2 ) ) * 2 ) - 1.0 ) );
			float temp_output_11_0_g1 = ( abs( ( temp_output_7_0_g1 - round( temp_output_7_0_g1 ) ) ) * 2.0 );
			float smoothstepResult14_g1 = smoothstep( 0.5 , 0.55 , temp_output_11_0_g1);
			float ZigZag53 = smoothstepResult14_g1;
			float2 uv_Dotspatterntexture = i.uv_texcoord * _Dotspatterntexture_ST.xy + _Dotspatterntexture_ST.zw;
			float2 break16_g7 = ( i.uv_texcoord * tex2D( _Dotspatterntexture, uv_Dotspatterntexture ).rg );
			float2 appendResult7_g7 = (float2(( break16_g7.x + ( _DotsOffSetX * step( 1.0 , ( break16_g7.y % 2.0 ) ) ) ) , ( break16_g7.y + ( _DotsOffSetY * step( 1.0 , ( break16_g7.x % 2.0 ) ) ) )));
			float temp_output_2_0_g7 = _DotsPatternSize;
			float2 appendResult11_g8 = (float2(temp_output_2_0_g7 , temp_output_2_0_g7));
			float temp_output_17_0_g8 = length( ( (frac( appendResult7_g7 )*2.0 + -1.0) / appendResult11_g8 ) );
			float DotsPattern69 = saturate( ( ( 1.0 - temp_output_17_0_g8 ) / fwidth( temp_output_17_0_g8 ) ) );
			float2 uv_brickTexture = i.uv_texcoord * _brickTexture_ST.xy + _brickTexture_ST.zw;
			float4 tex2DNode73 = tex2D( _brickTexture, uv_brickTexture );
			float2 temp_output_15_0_g9 = tex2DNode73.rg;
			float2 break26_g9 = ( i.uv_texcoord * temp_output_15_0_g9 );
			float2 appendResult27_g9 = (float2(( ( _BrickOffSet * step( 1.0 , ( break26_g9.y % 2.0 ) ) ) + break26_g9.x ) , break26_g9.y));
			float2 break12_g9 = temp_output_15_0_g9;
			float temp_output_21_0_g9 = sign( ( break12_g9.y - break12_g9.x ) );
			float temp_output_14_0_g9 = _Bricksize;
			float2 appendResult10_g10 = (float2(( ( ( 1.0 / break12_g9.y ) * max( temp_output_21_0_g9 , 0.0 ) ) + temp_output_14_0_g9 ) , ( temp_output_14_0_g9 + ( ( -1.0 / break12_g9.x ) * min( temp_output_21_0_g9 , 0.0 ) ) )));
			float2 temp_output_11_0_g10 = ( abs( (frac( appendResult27_g9 )*2.0 + -1.0) ) - appendResult10_g10 );
			float2 break16_g10 = ( 1.0 - ( temp_output_11_0_g10 / fwidth( temp_output_11_0_g10 ) ) );
			float temp_output_2_0_g9 = saturate( min( break16_g10.x , break16_g10.y ) );
			float2 break31_g9 = tex2DNode73.rg;
			float dotResult4_g11 = dot( floor( appendResult27_g9 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g11 = lerp( break31_g9.x , break31_g9.y , frac( ( sin( dotResult4_g11 ) * 43758.55 ) ));
			float BrickPattern77 = ( temp_output_2_0_g9 * ( lerpResult10_g11 * temp_output_2_0_g9 ) );
			c.rgb = ( ( ColorHue5 + ColorBlending17 + GreyScale26 + Desaturate37 ) + ZigZag53 + DotsPattern69 + BrickPattern77 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
336;73;1044;845;2516.437;-1617.906;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;9;-2205.316,-20.8969;Inherit;False;891.2384;360.0461;Comment;5;2;3;1;6;5;ColorHue;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;2;-2152.716,43.14919;Inherit;False;Property;_ColorHue;ColorHue;3;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-2155.315,223.1492;Inherit;False;Property;_SimpleContrastForColorHue;Simple Contrast ForColorHue;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1;-1902.261,29.10311;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2207.612,398.6126;Inherit;False;891.2384;360.0461;Comment;6;17;16;11;14;13;20;ColorBlend;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;-2211.059,818.9257;Inherit;False;966.4189;371.7846;Comment;6;22;24;21;23;25;26;GrayScale;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-2224.216,1258.801;Inherit;False;1014.606;347.219;Comment;6;31;30;36;37;43;45;Desaturate;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2135.226,652.7288;Inherit;False;Property;_SimpleColorblender;Simple Colorblender;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;-2161.059,953.1671;Inherit;False;Property;_GreyScaleColor;GreyScaleColor;6;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-2170.844,448.4224;Inherit;False;Property;_ColorBlender;ColorBlender;4;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;6;-1712.76,140.0631;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-1538.077,58.7015;Inherit;False;ColorHue;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;31;-2174.216,1308.801;Inherit;False;Property;_DestatureateColor;DestatureateColor;7;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;21;-1865.886,959.2936;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1858.598,1074.71;Inherit;False;Property;_GrayScale;GrayScale;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;78;-2295.833,3002.071;Inherit;False;1128.331;433.2668;Comment;6;76;75;72;74;77;73;BrickPattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1908.583,626.8306;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2108.972,1476.92;Inherit;False;Property;_Desaturate;Desaturate;8;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1646.958,988.4112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1902.855,1443.624;Inherit;False;5;ColorHue;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;30;-1889.619,1329.253;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;70;-2272.557,2284.267;Inherit;False;910.9567;496.7576;Comment;6;67;66;68;64;69;65;DotsPattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.BlendOpsNode;11;-1869.172,437.6684;Inherit;False;ColorBurn;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;57;-2258.758,1721.063;Inherit;False;898.2103;369.6979;Comment;5;53;59;60;61;63;ZigZag;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;73;-2245.833,3052.071;Inherit;True;Property;_brickTexture;brickTexture;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-2097.069,3233.337;Inherit;False;Property;_Bricksize;Brick size;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2129.069,3319.337;Inherit;False;Property;_BrickOffSet;BrickOffSet;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-2212.228,2665.024;Inherit;False;Property;_DotsOffSetY;DotsOffSet Y;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-2222.557,2334.267;Inherit;True;Property;_Dotspatterntexture;Dots pattern texture;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-2201.922,2577.994;Inherit;False;Property;_DotsOffSetX;DotsOffSet X ;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1960.481,1999.555;Inherit;False;Property;_ZigZagPower;ZigZag Power;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;-1426.64,1003.917;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;72;-1889.619,3114.352;Inherit;False;Bricks Pattern;-1;;9;7d219d3a79fd53a48987a86fa91d6bac;0;4;15;FLOAT2;2,4;False;14;FLOAT;0.65;False;16;FLOAT;0.5;False;17;FLOAT2;0,1;False;2;FLOAT;0;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;61;-2251.16,1773.695;Inherit;True;Property;_ZigzagTexture;Zigzag Texture;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-1974.16,1910.695;Inherit;False;Property;_ZigzagLength;Zigzag Length;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-1695.298,525.3347;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1626.306,1409.044;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-2206.503,2509.287;Inherit;False;Property;_DotsPatternSize;Dots Pattern Size;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;60;-1793.16,1873.695;Inherit;False;Zig Zag;-1;;1;8cd734fbcae021148a58931ed7d68679;2,24,0,17,1;4;19;FLOAT2;0,0;False;22;FLOAT2;1,1;False;15;FLOAT;0.5;False;16;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-1433.61,1417.422;Inherit;False;Desaturate;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-1527.831,482.2573;Inherit;False;ColorBlending;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1559.239,868.9257;Inherit;False;GreyScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;64;-1857.214,2372.849;Inherit;False;Dots Pattern;-1;;7;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;8,8;False;2;FLOAT;0.9;False;4;FLOAT;0.5;False;5;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1560.069,3127.537;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1519.548,1832.471;Inherit;False;ZigZag;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;-877.8755,-28.2431;Inherit;False;5;ColorHue;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-878.6178,123.6173;Inherit;False;26;GreyScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-874.0587,202.592;Inherit;False;37;Desaturate;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-1391.502,3144.191;Inherit;False;BrickPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-897.7381,48.60304;Inherit;False;17;ColorBlending;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-1585.601,2409.722;Inherit;False;DotsPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-664.3491,218.8898;Inherit;False;69;DotsPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-617.411,16.52881;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-670.5476,288.9556;Inherit;False;77;BrickPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-653.9506,152.7964;Inherit;False;53;ZigZag;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-466.5044,16.30183;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1.3,0;Float;False;True;-1;7;ASEMaterialInspector;0;0;CustomLighting;WhiteOaksShaders/ScreenSpace;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Overlay;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;50;10;25;False;1;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;1;2;0
WireConnection;1;0;3;0
WireConnection;6;0;1;0
WireConnection;6;1;1;0
WireConnection;6;2;3;0
WireConnection;5;0;6;0
WireConnection;21;0;22;0
WireConnection;20;0;13;0
WireConnection;20;1;14;0
WireConnection;23;0;21;0
WireConnection;23;1;24;0
WireConnection;30;0;31;0
WireConnection;30;1;36;0
WireConnection;11;0;20;0
WireConnection;11;1;20;0
WireConnection;11;2;20;0
WireConnection;25;0;23;0
WireConnection;25;1;23;0
WireConnection;72;15;73;0
WireConnection;72;14;74;0
WireConnection;72;16;75;0
WireConnection;72;17;73;0
WireConnection;16;0;11;0
WireConnection;16;1;11;0
WireConnection;43;0;30;0
WireConnection;43;1;45;0
WireConnection;60;22;61;0
WireConnection;60;15;59;0
WireConnection;60;16;63;0
WireConnection;37;0;43;0
WireConnection;17;0;16;0
WireConnection;26;0;25;0
WireConnection;64;3;65;0
WireConnection;64;2;66;0
WireConnection;64;4;67;0
WireConnection;64;5;68;0
WireConnection;76;0;72;0
WireConnection;76;1;72;3
WireConnection;53;0;60;0
WireConnection;77;0;76;0
WireConnection;69;0;64;0
WireConnection;10;0;8;0
WireConnection;10;1;18;0
WireConnection;10;2;28;0
WireConnection;10;3;38;0
WireConnection;55;0;10;0
WireConnection;55;1;56;0
WireConnection;55;2;71;0
WireConnection;55;3;79;0
WireConnection;0;13;55;0
ASEEND*/
//CHKSM=BED0B8597DE1F3B1FBB6626A65C010D7292A00B0
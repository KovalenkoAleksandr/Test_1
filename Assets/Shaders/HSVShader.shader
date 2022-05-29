// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/HSVShader" {
	Properties{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		[HideInInspector] _Color("Tint", Color) = (1,1,1,1)
		_HueShift("HueShift", Range(-180,180)) = 0
		_Sat("Saturation", Float) = 1
		_Val("Value", Float) = 1

		[HideInInspector] _StencilComp("Stencil Comparison", Float) = 8
		[HideInInspector] _Stencil("Stencil ID", Float) = 0
		[HideInInspector] _StencilOp("Stencil Operation", Float) = 0
		[HideInInspector] _StencilWriteMask("Stencil Write Mask", Float) = 255
		[HideInInspector] _StencilReadMask("Stencil Read Mask", Float) = 255
		[HideInInspector] _ColorMask("Color Mask", Float) = 15
	}

	SubShader{
		Tags{ 
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}
		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}
		ColorMask[_ColorMask]

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha

	Pass
	{
	CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"
		#include "UnityUI.cginc"

		struct appdata_t
		{
			float4 vertex   : POSITION;
			float4 color    : COLOR;
			float2 texcoord : TEXCOORD0;
		};

		struct v2f
		{
			float4 vertex   : SV_POSITION;
			fixed4 color : COLOR;
			half2 texcoord  : TEXCOORD0;
			float4 worldPosition : TEXCOORD1;
		};

		fixed4 _Color;
		fixed4 _TextureSampleAdd;
		v2f vert(appdata_t IN)
		{
			v2f OUT;
			OUT.worldPosition = IN.vertex;
			OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

			OUT.texcoord = IN.texcoord;

#ifdef UNITY_HALF_TEXEL_OFFSET
			OUT.vertex.xy += (_ScreenParams.zw - 1.0)*float2(-1, 1);
#endif

			OUT.color = IN.color * _Color;
			return OUT;
		}

		float3 shift_col(float3 RGB, float3 shift)
		{
			float3 RESULT = float3(RGB);
			float VSU = shift.z*shift.y*cos(shift.x*3.14159265 / 180);
			float VSW = shift.z*shift.y*sin(shift.x*3.14159265 / 180);

			RESULT.x = (.299*shift.z + .701*VSU + .168*VSW)*RGB.x
				+ (.587*shift.z - .587*VSU + .330*VSW)*RGB.y
				+ (.114*shift.z - .114*VSU - .497*VSW)*RGB.z;

			RESULT.y = (.299*shift.z - .299*VSU - .328*VSW)*RGB.x
				+ (.587*shift.z + .413*VSU + .035*VSW)*RGB.y
				+ (.114*shift.z - .114*VSU + .292*VSW)*RGB.z;

			RESULT.z = (.299*shift.z - .3*VSU + 1.25*VSW)*RGB.x
				+ (.587*shift.z - .588*VSU - 1.05*VSW)*RGB.y
				+ (.114*shift.z + .886*VSU - .203*VSW)*RGB.z;

			return (RESULT);
		}

		sampler2D _MainTex;
		float _HueShift;
		float _Sat;
		float _Val;

		fixed4 frag(v2f IN) : SV_Target
		{
			half4 col = tex2D(_MainTex, IN.texcoord);
			float3 shift = float3(_HueShift, _Sat, _Val);
			return (half4(shift_col(col, shift), col.a) + _TextureSampleAdd) * IN.color;
		}
	ENDCG
	}
	}
}
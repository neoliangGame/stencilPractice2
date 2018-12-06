Shader "neo/neoFillPlane"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_ColorStrength("Color Strength", Range(0,1)) = 0.5

		_Stencil("Stencil ID", Range(0,255)) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry+1"}

		LOD 100

		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			Cull Off
			Stencil
			{
				Ref [_Stencil]
				Comp Equal
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				half3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 light : COLOR0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _Color;
			float _ColorStrength;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				half3 lightDir = normalize(ObjSpaceLightDir(v.vertex));
				half3 normalDir = normalize(v.normal);
				o.light = min(dot(normalDir, lightDir) * 0.6 + 0.6, 1);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col = col * (1 - _ColorStrength) + _Color * _ColorStrength;
				col.xyz *= i.light.xyz;
				return col;
			}
			ENDCG
		}
	}
}

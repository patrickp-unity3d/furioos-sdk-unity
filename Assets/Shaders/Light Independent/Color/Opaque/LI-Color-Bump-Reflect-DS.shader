// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Observ3d/Light Independent/Color/Opaque/LI-Color-Bump-Reflect-DS" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_BumpMap ("Bump Map", 2D) = "bump" {}
		_BumpQuantity ("Bump Quantity", Range (0, 2)) = 1
		
		_ReflectMap ("Reflect Map", Cube) = "gray" { TexGen CubeReflect }
		_ReflectColor ("Reflect Color", Color) = (1,1,1,1)
		_ReflectContrast ("Reflect Contrast", Range (0, 3)) = 1
		_ReflectOffset ("Reflect Offset", Range (-1, 0)) = -0.5
		_Normal_Reflect_Alpha ("Normal Reflect Alpha", Range (0, 1)) = 0.05
		_Fresnel_Curve ("Fresnel Curve", Range (1, 10)) = 4
		_Tangent_Reflect_Alpha ("Tangent Reflect Alpha", Range (0.01, 1)) = 0.5
		
		_AntiFlick ("AntiFlick", Range (0, 0.0001)) = 0
	}
	SubShader {
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		
		Pass {
			ZWrite On
			Lighting Off
			Cull Off
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct VertInput {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
			};
			
			struct FragInput {
				float4 vertex : POSITION;
				float4 worldPosition:TEXCOORD4;
				float3 worldNormal:TEXCOORD3;
				float2 uv_BumpMap : TEXCOORD1;
				float3 worldBinormal:TEXCOORD5;
				float3 worldTangent:TEXCOORD6;
			};
			
			fixed3 _Color;
			
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			fixed _BumpQuantity;
			
			samplerCUBE _ReflectMap;
			fixed _Normal_Reflect_Alpha;
			fixed _Fresnel_Curve;
			fixed _Tangent_Reflect_Alpha;
			fixed _ReflectContrast;
			fixed _ReflectOffset;
			fixed3 _ReflectColor;
			
			half _AntiFlick;
			
			FragInput vert (VertInput v) {
				FragInput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex.z -= _AntiFlick*o.vertex.w;
				o.worldPosition = mul(unity_ObjectToWorld,v.vertex);
				o.worldNormal = normalize( mul((float3x3)unity_ObjectToWorld,v.normal));
				o.uv_BumpMap = TRANSFORM_TEX(v.texcoord, _BumpMap);
				float3 binormal = cross( v.normal, v.tangent.xyz ) * v.tangent.w;
				o.worldBinormal = normalize( mul((float3x3)unity_ObjectToWorld,binormal));
				o.worldTangent = normalize( mul((float3x3)unity_ObjectToWorld,v.tangent.xyz));
				return o;
			}
			
			half4 frag (FragInput IN) : COLOR{
				half3 albedo = _Color.rgb;
				half3 worldViewDir = normalize(_WorldSpaceCameraPos.xyz - IN.worldPosition.xyz);
				fixed3 bumpNormal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
				half3 worldNormal = normalize(IN.worldNormal * bumpNormal.z +
					IN.worldTangent * bumpNormal.x * _BumpQuantity +
					IN.worldBinormal * bumpNormal.y * _BumpQuantity );
				half bump = dot(IN.worldNormal,worldNormal);
				half viewDotProduct = dot(worldViewDir,worldNormal);
				half3 reflecDir =  - worldViewDir + 2.0 * ( worldNormal * viewDotProduct );
				viewDotProduct = abs(viewDotProduct);
				half reflectQty = (_Tangent_Reflect_Alpha - _Normal_Reflect_Alpha) * pow(( 1-viewDotProduct),_Fresnel_Curve) + _Normal_Reflect_Alpha;
				half3 reflectCol = (_ReflectOffset + texCUBE(_ReflectMap, reflecDir ).rgb * _ReflectColor) * _ReflectContrast;
				return half4((albedo.rgb * bump * (1.0-reflectQty)  + (albedo.rgb * (1-_ReflectColor) + reflectCol + 0.5) * reflectQty ) ,1.0);
			}
			
			ENDCG
		}
	}
		Fallback "VertexLit"
		CustomEditor "OBSMaterialInspector"
}

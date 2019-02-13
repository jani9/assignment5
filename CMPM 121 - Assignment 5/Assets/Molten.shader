Shader "Unlit/Molten"
{
    Properties
    {
		_MainTex("Texture", 2D) = "white" {}
		iChannel0("Texture", 2D) = "red" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D iChannel0;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

#define pi (3.14159265358979323846)
#define EPSILON (0.0001)

			float2 rotate(float2 v, float a)
			{
				float c = cos(a);
				float s = sin(a);
				return float2(
					v.x*c - v.y*s,
					v.x*s + v.y*c
				);
			}

			float sphere(float3 p, float r)
			{
				return length(p) - r;
			}

			float scene(float3 p)
			{
				float b = sphere(p, 1.6);
				if (b > 0.001) return b; // optimisation

				float3 disp = 0;
				float f = 0.5;
				disp.x = tex2D(iChannel0, p.zy * 0.05 + _Time.y * 0.02).x * f;
				disp.z = tex2D(iChannel0, p.xy * 0.05 + _Time.y * 0.03).z * f;
				disp.y = tex2D(iChannel0, p.xz * 0.05 + _Time.y * 0.04).y * f;

				return sphere(p + disp, 1.0 + sin(_Time.y*2.4) * 0.15);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 uv = i.uv;
				uv -= 0.5;
				uv /= i.uv;

				float3 cam = float3(0, -0.15, -3.5);
				float3 dir = normalize(float3(uv, 1));

				float cam_a2 = sin(_Time.y) * pi * 0.1;
				cam.yz = rotate(cam.yz, cam_a2);
				dir.yz = rotate(dir.yz, cam_a2);

				float cam_a = _Time.y * pi * 0.1;
				cam.xz = rotate(cam.xz, cam_a);
				dir.xz = rotate(dir.xz, cam_a);

				float4 color = float4(0.16, 0.12, 0.10, 0);

				float t = 0.00001;
				const int maxSteps = 128;
				for (int i = 0; i < maxSteps; ++i) {
					float3 p = cam + dir * t;
					float d = scene(p);

					if (d < 0.0001 * t) {
						color = float4(1.0, length(p) * (0.6 + (sin(_Time.y*3.0) + 1.0) * 0.5 * 0.4), 0, 0);

						break;
					}

					t += d;
				}

				return color;
			}
            ENDCG
        }
    }
}

Shader "Custom/SurfaceShader/DissolveEffectShader_Surf"
{
    Properties
    {
		_MainTex ("Albedo", 2D) = "white" {}
		_BumpMap ("Normal", 2D) = "bump" {}
		_NoiseMap ("Eissolve Map", 2D) = "white" {}
		[Space(30)]
		_Cutoff ("Dissolve", Range(0, 1)) = 0
		[HDR]_BurningColor ("Burning Color", Color) = (1, 0, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue" = "Alphatest" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert 

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _NoiseMap;
		half4 _BurningColor;
		half _Cutoff;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 a = tex2D(_NoiseMap, IN.uv_MainTex);

			// outline
			fixed outline;
			if (a.r < _Cutoff * 1.15)
				outline = 1;
			else
				outline = 0;

			// Alpha CutOut -clip() : 픽셀을 폐기한다
			clip(a.r - _Cutoff);

			o.Albedo = c.rgb;
			o.Alpha = a.r;
			o.Emission = outline * _BurningColor;
			o.Normal = UnpackNormal( tex2D(_BumpMap, IN.uv_BumpMap) );
        }
        ENDCG
    }
    FallBack "Diffuse"
}

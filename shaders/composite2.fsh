#version 330 compatibility

/*
                                                                
                       H                                         
                       HCHCHC                  H                
                       HCHCHCHCHC            HCH                
                       HCHCHCHCHCHCHCH    HCHCHCH               
                      HCHCHCHCHCHCHCHCHCHCHCHCHCHC              
           HCHCHCHCHCHCHCHCHCHCHCHCH HCHCHCHCHCHCHC             
     HCHCHCHCHCHCHCHCHCHCHCHCHCHC  HCHCHCHCHCHCHCHC             
        HCHCHCHCHCHCHC HCHCH         HCHCHCHCHCHCHCH            
          HCHCHCHCHCHC H                     HCHCHCH            
          HCHCHCHCHCH                      HCHCHCHCHCHCHCHCHCH  
         HCHCH HCHCH                        HCHCHCHCHCHCHCHC    
       HCHCHCHCH  HC                          HCHCHCHCHCHCH     
      HCHCHCHCHCH                              HCHCHCHCHCH      
     HCHCHCHCHCHCHC                         HCHC HCHCHCH        
   HCHCHCHCHCHCHCHCH                        HCHCHCHCHCH         
  HCHCHCHCHCHCHCHCHCHC                     HCHCHCHCHC           
            HCHCHCHCH                  HC HCHCHCHCHCHCH         
             HCHCHCHCHCHCHCHCHC   HCHCHCH HCHCHCHCHCHCHCHC      
             HCHCHCHCHCHCHCHC  HCHCHCHCHCHCHCHCHCHCHCHCHCHC     
              HCHCHCHCHCHCHCHCHCHCHCHCHCHCHCHCHC                
              HCHCHCHCHCHCHCHCHCHCHCHCHCH                       
               HCHCHC        HCHCHCHCHCHC                       
                HCH             HCHCHCHCH                       
                                      HCH                       
										H


2021@HyperCol Studios
VacGrd is part of HyperCol Studios
Do not modify this code until you have read the LICENSE contained in the root directory of this shaderpack!

*/

#define SHADOW_MAP_BIAS 0.90


/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------Shadow&Lightning---------------//
//Only enable one of these.
//#define ENABLE_SOFT_SHADOWS		// Simple soft shadows
#define VARIABLE_PENUMBRA_SHADOWS	// Contact-hardening (area) shadows
#define COLORED_SHADOWS // Tinted shadows from stained glass
//#define PIXEL_SHADOWS // Pixel-locked shadows 

#define TORCHLIGHT_BRIGHTNESS 0.5 // How bright is light from torches, fire, etc. [0.25 0.5 0.75 1.0 1.5 2.0 5.0 10.0 13.0 16.0 18.0 20.0 25.0 30.0]

#define GI_RENDER_RESOLUTION 0 // Render resolution of GI. 0 = High. 1 = Low. Set to 1 for faster but blurrier GI. [0 1]

#define NEW_SKY_LIGHT
//#define Disabled_SkyLight_Occlusion

//---------------Atmosphere&Sky---------------//

//Clouds
//#define VOLUMETRIC_CLOUDS // Volumetric clouds
	#define CALCULATECLOUDDEPTH 280           // [100 200 300 400 500 600 700 900 1100 1400 1700 62018]
	#define CALCULATECLOUDSDENSITY 200        // [100 125 150 175 200 225 250 275 300 325 350]
	#define CALCULATECLOUDSCONCENTRATION 2.5  // [0.5 1.0 1.5 2.0 2.5 3.0 4.0 5.0 7.0 9.0]
	#define CALCULATECLOUDSQUALITY 35         // [5 10 20 35 50 70 100]
	#define Vol_Cloud_Coverage 0.18				// Vol_Cloud_Coverage. 0.20 = Lowest Cover. 0.60 = Highest Cover [0.20 0.30 0.45 0.48 0.50 0.52 0.55 0.60 0.70]
	#define High_Altitude_Clouds
	#define CALCLOUD_SPEED 1				  // [0 0.2 0.5 1 2.5 5 8]
	#define CALCLOUDHEIGHT 275				  // [100 150 200 225 250 275 300 325 350 400 450 500 600 700 800]
	#define WHITECLOUDS 1.5                     // [0.01 1 1.5 4 6 9]
	//#define MOREVOLUMETRIC_CLOUDS

#define ATMOSPHERIC_SCATTERING // Blue tint of distant objects to simulate atmospheric scattering

#define RAYLEIGH_AMOUNT 1.0 // Strength of atmospheric scattering (atmospheric density). [0.5 1.0 1.5 2.0 4.0 6.0 8.0 10.0 12.0 14.0 16.0 18.0 20.0 24.0 28.0 30.0 32.0 35.0]

//Aurora
#define AURORA		//Night aurora.
#define AURORA_COLOR blueAurora //[blueAurora purpleAurora greenAurora]
	#define NIGHT_AURORA_R 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define NIGHT_AURORA_G 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define NIGHT_AURORA_B 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define NIGHT_AURORA_L 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define AURORA_STRENGTH 0.7 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.7 2.0 2.5 3.0 4.0 5.0 7.0 10.0 15.0 20.0 30.0 50.0 70.0 100.0]
	#define aurora_power 0.3 //[0.0 0.001 0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
	#define aurora_speed 3.0 //[0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0]
	#define aurora_flash 50.0 //[0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0 19.0 20.0 21.0 22.0 23.0 24.0 25.0 26.0 27.0 28.0 29.0 30.0 31.0 32.0 33.0 34.0 35.0 36.0 37.0 38.0 39.0 40.0 41.0 42.0 43.0 44.0 45.0 46.0 47.0 48.0 49.0 50.0 51.0 52.0 53.0 54.0 55.0 56.0 57.0 58.0 59.0 60.0 61.0 62.0 63.0 64.0 65.0 66.0 67.0 68.0 69.0 70.0 71.0 72.0 73.0 74.0 75.0 76.0 77.0 78.0 79.0 80.0 81.0 82.0 83.0 84.0 85.0 86.0 87.0 88.0 89.0 90.0 91.0 92.0 93.0 94.0 95.0 96.0 97.0 98.0 99.0 100.0]
	//#define AURORA_PRESET_COL //Preset color of aurora

#define STAR

#define RAINBOW

//---------------Water&Ice---------------//

#define WATER_CAUSTICS
	#define WATER_SPEED 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define WATER_COLOR_F_R 0.15 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define WATER_COLOR_F_G 0.6375 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.6375 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define WATER_COLOR_F_B 0.75 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define WATER_COLOR_F_A 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 

#define IceColorR 0.098 //[0.0 0.09 0.098 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
#define IceColorG 0.3843 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.3843 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
#define IceColorB 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
#define IceColorA 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 

#define Fog_Color_R 1 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define Fog_Color_G 1 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define Fog_Color_B 1 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]

#define Fog_luminance 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.5 2.0]

//---------------Others---------------//

//#define BASIC_AMBIENT

#define TEXTURE_RESOLUTION 128 // Resolution of current resource pack. This needs to be set properly for POM! [16 32 64 128 256 512]

//#define Particles_Normals

/////////INTERNAL VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////INTERNAL VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Do not change the name of these variables or their type. The Shaders Mod reads these lines and determines values to send to the inner-workings
//of the shaders mod. The shaders mod only reads these lines and doesn't actually know the real value assigned to these variables in GLSL.
//Some of these variables are critical for proper operation. Change at your own risk.


const int 		shadowMapResolution 	= 2048;	// Shadowmap resolution [1024 2048 4096]
const float 	shadowDistance 			= 120.0; // Shadow distance. Set lower if you prefer nicer close shadows. Set higher if you prefer nicer distant shadows. [80.0 120.0 180.0 240.0]
const float 	shadowIntervalSize 		= 4.0f;
const bool 		shadowHardwareFiltering0 = true;

const bool 		shadowtex1Mipmap = true;
const bool 		shadowtex1Nearest = false;
const bool 		shadowcolor0Mipmap = true;
const bool 		shadowcolor0Nearest = false;
const bool 		shadowcolor1Mipmap = true;
const bool 		shadowcolor1Nearest = false;

const int 		RA8 						= 0;
const int 		RGA8 					= 0;
const int 		RGBA8 					= 1;
const int 		RGBA16 					= 2;
const int 		colortex0Format 			= RGBA16;
const int 		colortex1Format 			= RGBA16;
const int 		colortex2Format 			= RGBA16;
const int 		colortex3Format 		= RGBA16;
const int 		colortex4Format 		= RGBA16;
const int 		colortex5Format 		= RGBA16;
const int 		colortex6Format 		= RGBA16;
const int 		colortex7Format 		= RGBA16;

const bool gaux4Clear = false;

const float 	eyeBrightnessHalflife 	= 10.0f;
const float 	wetnessHalflife 		= 300.0f;
const float 	drynessHalflife 		= 40.0f;

const int 		superSamplingLevel 		= 0;

const float		sunPathRotation 		= 0.0; // [-90.0 -89.5 -89.0 -88.5 -88.0 -87.5 -87.0 -86.5 -86.0 -85.5 -85.0 -84.5 -84.0 -83.5 -83.0 -82.5 -82.0 -81.5 -81.0 -80.5 -80.0 -79.5 -79.0 -78.5 -78.0 -77.5 -77.0 -76.5 -76.0 -75.5 -75.0 -74.5 -74.0 -73.5 -73.0 -72.5 -72.0 -71.5 -71.0 -70.5 -70.0 -69.5 -69.0 -68.5 -68.0 -67.5 -67.0 -66.5 -66.0 -65.5 -65.0 -64.5 -64.0 -63.5 -63.0 -62.5 -62.0 -61.5 -61.0 -60.5 -60.0 -59.5 -59.0 -58.5 -58.0 -57.5 -57.0 -56.5 -56.0 -55.5 -55.0 -54.5 -54.0 -53.5 -53.0 -52.5 -52.0 -51.5 -51.0 -50.5 -50.0 -49.5 -49.0 -48.5 -48.0 -47.5 -47.0 -46.5 -46.0 -45.5 -45.0 -44.5 -44.0 -43.5 -43.0 -42.5 -42.0 -41.5 -41.0 -40.5 -40.0 -39.5 -39.0 -38.5 -38.0 -37.5 -37.0 -36.5 -36.0 -35.5 -35.0 -34.5 -34.0 -33.5 -33.0 -32.5 -32.0 -31.5 -31.0 -30.5 -30.0 -29.5 -29.0 -28.5 -28.0 -27.5 -27.0 -26.5 -26.0 -25.5 -25.0 -24.5 -24.0 -23.5 -23.0 -22.5 -22.0 -21.5 -21.0 -20.5 -20.0 -19.5 -19.0 -18.5 -18.0 -17.5 -17.0 -16.5 -16.0 -15.5 -15.0 -14.5 -14.0 -13.5 -13.0 -12.5 -12.0 -11.5 -11.0 -10.5 -10.0 -9.5 -9.0 -8.5 -8.0 -7.5 -7.0 -6.5 -6.0 -5.5 -5.0 -4.5 -4.0 -3.5 -3.0 -2.5 -2.0 -1.5 -1.0 -0.5 0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0 15.5 16.0 16.5 17.0 17.5 18.0 18.5 19.0 19.5 20.0 20.5 21.0 21.5 22.0 22.5 23.0 23.5 24.0 24.5 25.0 25.5 26.0 26.5 27.0 27.5 28.0 28.5 29.0 29.5 30.0 30.5 31.0 31.5 32.0 32.5 33.0 33.5 34.0 34.5 35.0 35.5 36.0 36.5 37.0 37.5 38.0 38.5 39.0 39.5 40.0 40.5 41.0 41.5 42.0 42.5 43.0 43.5 44.0 44.5 45.0 45.5 46.0 46.5 47.0 47.5 48.0 48.5 49.0 49.5 50.0 50.5 51.0 51.5 52.0 52.5 53.0 53.5 54.0 54.5 55.0 55.5 56.0 56.5 57.0 57.5 58.0 58.5 59.0 59.5 60.0 60.5 61.0 61.5 62.0 62.5 63.0 63.5 64.0 64.5 65.0 65.5 66.0 66.5 67.0 67.5 68.0 68.5 69.0 69.5 70.0 70.5 71.0 71.5 72.0 72.5 73.0 73.5 74.0 74.5 75.0 75.5 76.0 76.5 77.0 77.5 78.0 78.5 79.0 79.5 80.0 80.5 81.0 81.5 82.0 82.5 83.0 83.5 84.0 84.5 85.0 85.5 86.0 86.5 87.0 87.5 88.0 88.5 89.0 89.5 90.0]
const float 	ambientOcclusionLevel 	= 0.01f;

const int 		noiseTextureResolution  = 64;


//END OF INTERNAL VARIABLES//

/* DRAWBUFFERS:0135 */

const bool colortex4MipmapEnabled = true;

#define BANDING_FIX_FACTOR 1.0f

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D gdepthtex;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D shadowtex1;
uniform sampler2DShadow shadow;
uniform sampler2D shadowcolor;
uniform sampler2D shadowcolor1;
uniform sampler2D noisetex;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

in vec4 texcoord;
in vec3 lightVector;
in vec3 upVector;

uniform int worldTime;
uniform int frameCounter;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 shadowProjectionInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform vec3 sunPosition;
uniform vec3 cameraPosition;
uniform vec3 upPosition;

uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
uniform float wetness;
uniform float aspectRatio;
uniform float frameTimeCounter;
uniform float sunAngle;
uniform vec3 skyColor;

uniform int   isEyeInWater;
uniform float eyeAltitude;
uniform ivec2 eyeBrightness;
uniform ivec2 eyeBrightnessSmooth;
uniform int   fogMode;


in float timeSunriseSunset;
in float timeNoon;
in float timeMidnight;
in float timeSkyDark;

in vec3 colorSunlight;
in vec3 colorSkylight;
in vec3 colorSunglow;
in vec3 colorBouncedSunlight;
in vec3 colorScatteredSunlight;
in vec3 colorTorchlight;
in vec3 colorWaterMurk;
in vec3 colorWaterBlue;
in vec3 colorSkyTint;

uniform int heldBlockLightValue;

const vec3 bM = vec3(21e-6);
const vec3 bR = vec3(5.8e-6, 13.5e-6, 33.1e-6);
const float Hr = 7994;
const float Hm = 1200;

/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float HG(in float m, in float g){
  return (0.25 / 3.141592653) * ((1.0 - g*g) / pow(1.0 + g*g - 2.0 * g * m, 1.5));
}

float saturate(float x)
{
	return clamp(x, 0.0, 1.0);
}

//Get gbuffer textures
vec3  	GetAlbedoLinear(in vec2 coord) {			//Function that retrieves the diffuse texture and convert it into linear space.
	return pow(texture(colortex0, coord).rgb, vec3(2.2f));
}

vec3  	GetAlbedoGamma(in vec2 coord) {			//Function that retrieves the diffuse texture and leaves it in gamma space.
	return texture(colortex0, coord).rgb;
}

vec3  	GetWaterNormals(in vec2 coord) {				//Function that retrieves the screen space surface normals. Used for lighting calculations
	return normalize(textureLod(colortex2, coord.st, 0).rgb * 2.0f - 1.0f);
}


vec3  	GetNormals(in vec2 coord) {				//Function that retrieves the screen space surface normals. Used for lighting calculations
	return normalize(textureLod(colortex5, coord.st, 0).rgb * 2.0f - 1.0f);
}

float 	GetDepth(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	return texture(depthtex1, coord).r;
}

float 	GetDepthLinear(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	//return 2.0f * near * far / (far + near - (2.0f * texture(depthtex1, coord).x - 1.0f) * (far - near));
	return (near * far) / (texture(depthtex1, coord).x * (near - far) + far);
}

float 	ExpToLinearDepth(in float depth)
{
	//return 2.0f * near * far / (far + near - (2.0f * depth - 1.0f) * (far - near));
	return (near*far)/(depth*(near-far)+far);
}

float GetParallaxShadow(in vec2 coord)
{
	return 1.0 - texture(colortex3, coord).b;
}


//Lightmaps
float 	GetLightmapTorch(in vec2 coord) {			//Function that retrieves the lightmap of light emitted by emissive blocks like torches and lava
	float lightmap = texture(colortex1, coord).g;

	//Apply inverse square law and normalize for natural light falloff
	lightmap 		= clamp(lightmap * 1.22f, 0.0f, 1.0f);
	lightmap 		= 1.0f - lightmap;
	lightmap 		*= 5.6f;
	lightmap 		= 1.0f / pow((lightmap + 0.8f), 2.0f);
	lightmap 		-= 0.02435f;

	// if (lightmap <= 0.0f)
		// lightmap = 1.0f;

	lightmap 		= max(0.0f, lightmap);
	lightmap 		*= 0.008f;
	lightmap 		= clamp(lightmap, 0.0f, 1.0f);
	lightmap 		= pow(lightmap, 0.9f);
	return lightmap * 1.0;


}

float 	GetLightmapSky(in vec2 coord) {			//Function that retrieves the lightmap of light emitted by the sky. This is a raw value from 0 (fully dark) to 1 (fully lit) regardless of time of day
#ifdef Disabled_SkyLight_Occlusion
	return 1.0;
#else
	//return pow(texture(colortex1, coord).b, 8.3f);

	float light = texture(colortex1, coord).b;

	light = 1.0 - light * 0.834;
	light = 1.0 / light - 1;
	light = light / 5.0;

	light = max(0.0, light * 1.05 - 0.05);

	return pow(light, 2.0);
#endif
}

float GetTransparentLightmapSky(in vec2 coord)
{
	return pow(texture(colortex6, coord).b, 8.3f);
}

float 	GetUnderwaterLightmapSky(in vec2 coord) {
	return texture(colortex3, coord).r;
}


//Specularity
float 	GetSpecularity(in vec2 coord) {			//Function that retrieves how reflective any surface/pixel is in the scene. Used for reflections and specularity
	return texture(colortex3, texcoord.st).r;
}

float 	GetGlossiness(in vec2 coord) {			//Function that retrieves how reflective any surface/pixel is in the scene. Used for reflections and specularity
	return texture(colortex3, texcoord.st).g;
}



//Material IDs
float 	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return texture(colortex1, coord).r;
}

float 	GetTransparentID(in vec2 coord)
{
	return texture(colortex6, coord).a;
}


bool  	GetSky(in vec2 coord) {					//Function that returns true for any pixel that is part of the sky, and false for any pixel that isn't part of the sky
	float matID = GetMaterialIDs(coord);		//Gets texture that has all material IDs stored in it
		  matID = floor(matID * 255.0f);		//Scale texture from 0-1 float to 0-255 integer format

	if (matID == 0.0f) {						//Checks to see if the current pixel's material ID is 0 = the sky
		return true;							//If the current pixel has the material ID of 0 (sky material ID), Return "this pixel is part of the sky"
	} else {
		return false;							//Return "this pixel is not part of the sky"
	}
}

float 	GetMaterialMask(in vec2 coord ,const in int ID, in float matID) {
	matID = round(matID * 255.0f);

	//Catch last part of sky
	if (matID > 254.0f) {
		matID = 0.0f;
	}

	if (matID == ID) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}

float  	GetWaterMask(in vec2 coord, in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = (matID * 255.0f);

	if (matID >= 35.0f && matID <= 51) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}

float  	GetStainedGlassMask(in vec2 coord, in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = (matID * 255.0f);

	if (matID >= 55.0f && matID <= 70.0f) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}

float  	GetIceMask(in vec2 coord, in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = (matID * 255.0f);

	if (matID == 4.0f) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}




//Surface calculations
vec4  	GetScreenSpacePosition(in vec2 coord) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
	float depth = GetDepth(coord);
		  depth += float(GetMaterialMask(coord, 5, GetMaterialIDs(coord))) * 0.38f;
		  //float handMask = float(GetMaterialMask(coord, 5, GetMaterialIDs(coord)));
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;

		 //fragposition.xyz *= mix(1.0f, 15.0f, handMask);

	return fragposition;
}

vec4  	GetScreenSpacePosition(in vec2 coord, in float depth) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
		  //depth += float(GetMaterialMask(coord, 5)) * 0.38f;
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;

	return fragposition;
}

vec4 	GetWorldSpacePosition(in vec2 coord, in float depth)
{
	vec4 pos = GetScreenSpacePosition(coord, depth);
	pos = gbufferModelViewInverse * pos;
	pos.xyz += cameraPosition.xyz;

	return pos;
}

vec4 	GetCloudSpacePosition(in vec2 coord, in float depth, in float distanceMult)
{
	// depth *= 30.0f;

	float linDepth = depth;

	float expDepth = (far * (linDepth - near)) / (linDepth * (far - near));

	//Convert texture coordinates and depth into view space
	vec4 viewPos = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * expDepth - 1.0f, 1.0f);
		 viewPos /= viewPos.w;

	//Convert from view space to world space
	vec4 worldPos = gbufferModelViewInverse * viewPos;

	worldPos.xyz *= distanceMult;
	worldPos.xyz += cameraPosition.xyz;

	return worldPos;
}

vec4 	ScreenSpaceFromWorldSpace(in vec4 worldPosition)
{
	worldPosition.xyz -= cameraPosition;
	worldPosition = gbufferModelView * worldPosition;
	return worldPosition;
}



void 	DoNightEye(inout vec3 color) {			//Desaturates any color input at night, simulating the rods in the human eye

	float amount = 0.2f; 						//How much will the new desaturated and tinted image be mixed with the original image
	vec3 rodColor = vec3(0.2f, 0.4f, 1.0f); 	//Cyan color that humans percieve when viewing extremely low light levels via rod cells in the eye
	float colorDesat = dot(color, vec3(1.0f)); 	//Desaturated color

	color = mix(color, colorDesat * rodColor, timeMidnight * amount);
	//color.rgb = color.rgb;
}


float 	ExponentialToLinearDepth(in float depth)
{
	vec4 worldposition = vec4(depth);
	worldposition = gbufferProjection * worldposition;
	return worldposition.z;
}

float 	LinearToExponentialDepth(in float linDepth)
{
	float expDepth = (far * (linDepth - near)) / (linDepth * (far - near));
	return expDepth;
}

void 	FixLightFalloff(inout float lightmap) { //Fixes the ugly lightmap falloff and creates a nice linear one
	float additive = 5.35f;
	float exponent = 40.0f;

	lightmap += additive;							//Prevent ugly fast falloff
	lightmap = pow(lightmap, exponent);			//Curve light falloff
	lightmap = max(0.0f, lightmap);		//Make sure light properly falls off to zero
	lightmap /= pow(1.0f + additive, exponent);
}


float 	CalculateLuminance(in vec3 color) {
	return (color.r * 0.2126f + color.g * 0.7152f + color.b * 0.0722f);
}

vec3 	Glowmap(in vec3 albedo, in float mask, in float curve, in vec3 emissiveColor) {
	vec3 color = albedo * (mask);
		 color = pow(color, vec3(curve));
		 color = vec3(CalculateLuminance(color));
		 color *= emissiveColor;

	return color;
}


float 	ChebyshevUpperBound(in vec2 moments, in float distance) {
	if (distance <= moments.x)
		return 1.0f;

	float variance = moments.y - (moments.x * moments.x);
		  variance = max(variance, 0.000002f);

	float d = distance - moments.x;
	float pMax = variance / (variance + d*d);

	return pMax;
}

float  	CalculateDitherPattern() {
	const int[4] ditherPattern = int[4] (0, 2, 1, 4);

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 2.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 2.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 2];

	return float(dither) / 4.0f;
}

float R2_dither(){
	vec2 alpha = vec2(0.75487765, 0.56984026);
	
	return fract(alpha.x * gl_FragCoord.x + alpha.y * gl_FragCoord.y);
}

float BlueNoise(vec2 coord)
{
	vec2 noiseCoord = vec2(coord.st * vec2(viewWidth, viewHeight)) / 64.0;
	noiseCoord += vec2(sin(frameCounter * 0.75), cos(frameCounter * 0.75));

	noiseCoord = (floor(noiseCoord * 64.0) + 0.5) / 64.0;

	float blueNoise = textureLod(noisetex, noiseCoord.st, 0).b;

	return blueNoise;
}

vec2 BlueNoiseXY(vec2 coord)
{
	return vec2(BlueNoise(coord.st), BlueNoise(coord.st + 32.0 / vec2(viewWidth, viewHeight)));
}


float  	CalculateDitherPattern2() {
	const int[64] ditherPattern = int[64] ( 1, 49, 13, 61,  4, 52, 16, 64,
										   33, 17, 45, 29, 36, 20, 48, 32,
										    9, 57,  5, 53, 12, 60,  8, 56,
										   41, 25, 37, 21, 44, 28, 40, 24,
										    3, 51, 15, 63,  2, 50, 14, 62,
										   35, 19, 47, 31, 34, 18, 46, 30,
										   11, 59,  7, 55, 10, 58,  6, 54,
										   43, 27, 39, 23, 42, 26, 38, 22);

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 8.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 8.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 8];

	return float(dither) / 64.0f;
}

vec3 	CalculateNoisePattern1(vec2 offset, float size) {
	vec2 coord = texcoord.st;

	coord *= vec2(viewWidth, viewHeight);
	coord = mod(coord + offset, vec2(size));
	coord /= noiseTextureResolution;

	return texture(noisetex, coord).xyz;
}


void DrawDebugSquare(inout vec3 color) {

	vec2 pix = vec2(1.0f / viewWidth, 1.0f / viewHeight);

	vec2 offset = vec2(0.5f);
	vec2 size = vec2(0.0f);
		 size.x = 1.0f / 2.0f;
		 size.y = 1.0f / 2.0f;

	vec2 padding = pix * 0.0f;
		 size += padding;

	if ( texcoord.s + offset.s / 2.0f + padding.x / 2.0f > offset.s &&
		 texcoord.s + offset.s / 2.0f + padding.x / 2.0f < offset.s + size.x &&
		 texcoord.t + offset.t / 2.0f + padding.y / 2.0f > offset.t &&
		 texcoord.t + offset.t / 2.0f + padding.y / 2.0f < offset.t + size.y
		)
	{

		int[16] ditherPattern = int[16] (0, 3, 0, 3,
										 2, 1, 2, 1,
										 0, 3, 0, 3,
										 2, 1, 2, 1);

		vec2 count = vec2(0.0f);
		     count.x = floor(mod(texcoord.s * viewWidth, 4.0f));
			 count.y = floor(mod(texcoord.t * viewHeight, 4.0f));

		int dither = ditherPattern[int(count.x) + int(count.y) * 4];
		color.rgb = vec3(float(dither) / 3.0f);


	}

}

/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct MCLightmapStruct {		//Lightmaps directly from MC engine
	float torch;				//Light emitted from torches and other emissive blocks
	float sky;					//Light coming from the sky
	float lightning;			//Light coming from lightning

	vec3 torchVector; 			//Vector in screen space that represents the direction of average light transfered
	vec3 skyVector;
} mcLightmap;



struct DiffuseAttributesStruct {			//Diffuse surface shading attributes
	float roughness;			//Roughness of surface. More roughness will use Oren Nayar reflectance.
	float translucency; 		//How translucent the surface is. Translucency represents how much energy will be transfered through the surface
	vec3  translucencyColor; 	//Color that will be multiplied with sunlight for backsides of translucent materials.
};

struct SpecularAttributesStruct {			//Specular surface shading attributes
	float specularity;			//How reflective a surface is
	float extraSpecularity;		//Additional reflectance for specular reflections from sun only
	float glossiness;			//How smooth or rough a specular surface is
	float metallic;				//from 0 - 1. 0 representing non-metallic, 1 representing fully metallic.
	float gain;					//Adjust specularity further
	float base;					//Reflectance when the camera is facing directly at the surface normal. 0 allows only the fresnel effect to add specularity
	float fresnelPower; 		//Curve of fresnel effect. Higher values mean the surface has to be viewed at more extreme angles to see reflectance
};

struct SkyStruct { 				//All sky shading attributes
	vec3 	albedo;				//Diffuse texture aka "color texture" of the sky
	vec3 	tintColor; 			//Color that will be multiplied with the sky to tint it
	vec3 	sunglow;			//Color that will be added to the sky simulating scattered light arond the sun/moon
	vec3 	sunSpot; 			//Actual sun surface
};

struct WaterStruct {
	vec3 albedo;
};

struct MaskStruct {

	float matIDs;

	float particles;

	float sky;
	float land;
	float grass;
	float leaves;
	float ice;
	float hand;
	float translucent;
	float glow;
	float sunspot;
	float goldBlock;
	float ironBlock;
	float diamondBlock;
	float emeraldBlock;
	float sand;
	float sandstone;
	float stone;
	float cobblestone;
	float wool;
	float clouds;

	float torch;
	float lava;
	float glowstone;
	float fire;

	float water;

	float volumeCloud;

	float stainedGlass;

};

struct CloudsStruct {
	vec3 albedo;
};

struct AOStruct {
	float skylight;
	float scatteredUpLight;
	float bouncedSunlight;
	float scatteredSunlight;
	float constant;
};

struct Ray {
	vec3 dir;
	vec3 origin;
};

struct Plane {
	vec3 normal;
	vec3 origin;
};

struct SurfaceStruct { 			//Surface shading properties, attributes, and functions

	//Attributes that change how shading is applied to each pixel
		DiffuseAttributesStruct  diffuse;			//Contains all diffuse surface attributes
		SpecularAttributesStruct specular;			//Contains all specular surface attributes

	SkyStruct 	    sky;			//Sky shading attributes and properties
	WaterStruct 	water;			//Water shading attributes and properties
	MaskStruct 		mask;			//Material ID Masks
	CloudsStruct 	clouds;
	AOStruct 		ao;				//ambient occlusion

	//Properties that are required for lighting calculation
		vec3 	albedo;					//Diffuse texture aka "color texture"
		vec3 	normal;					//Screen-space surface normals
		float 	depth;					//Scene depth
		float   linearDepth; 			//Linear depth

		vec4	screenSpacePosition;	//Vector representing the screen-space position of the surface
		vec4 	worldSpacePosition;
		vec3 	viewVector; 			//Vector representing the viewing direction
		vec3 	lightVector; 			//Vector representing sunlight direction
		Ray 	viewRay;
		vec3 	worldLightVector;
		vec3  	upVector;				//Vector representing "up" direction
		float 	NdotL; 					//dot(normal, lightVector). used for direct lighting calculation
		vec3 	debug;

		float 	shadow;
		float 	cloudShadow;

		float 	cloudAlpha;
} surface;

struct LightmapStruct {			//Lighting information to light the scene. These are untextured colored lightmaps to be multiplied with albedo to get the final lit and textured image.
	vec3 sunlight;				//Direct light from the sun
	vec3 skylight;				//Ambient light from the sky
	vec3 bouncedSunlight;		//Fake bounced light, coming from opposite of sun direction and adding to ambient light
	vec3 scatteredSunlight;		//Fake scattered sunlight, coming from same direction as sun and adding to ambient light
	vec3 scatteredUpLight; 		//Fake GI from ground
	vec3 torchlight;			//Light emitted from torches and other emissive blocks
	vec3 lightning;				//Light caused by lightning
	vec3 nolight;				//Base ambient light added to everything. For lighting caves so that the player can barely see even when no lights are present
	vec3 specular;				//Reflected direct light from sun
	vec3 translucent;			//Light on the backside of objects representing thin translucent materials
	vec3 sky;					//Color and brightness of the sky itself
	vec3 underwater;			//underwater lightmap
	vec3 heldLight;
} lightmap;

struct ShadingStruct {			//Shading calculation variables
	float   direct;
	float 	waterDirect;
	float 	bounced; 			//Fake bounced sunlight
	float 	skylight; 			//Light coming from sky
	float 	scattered; 			//Fake scattered sunlight
	float   scatteredUp; 		//Fake GI from ground
	float 	specular; 			//Reflected direct light
	float 	translucent; 		//Backside of objects lit up from the sun via thin translucent materials
	vec3 	sunlightVisibility; //Shadows
	float 	heldLight;
} shading;

struct GlowStruct {
	vec3 torch;
	vec3 lava;
	vec3 glowstone;
	vec3 fire;
};

struct FinalStruct {			//Final textured and lit images sorted by what is illuminating them.

	GlowStruct 		glow;		//Struct containing emissive material final images

	vec3 sunlight;				//Direct light from the sun
	vec3 skylight;				//Ambient light from the sky
	vec3 bouncedSunlight;		//Fake bounced light, coming from opposite of sun direction and adding to ambient light
	vec3 scatteredSunlight;		//Fake scattered sunlight, coming from same direction as sun and adding to ambient light
	vec3 scatteredUpLight; 		//Fake GI from ground
	vec3 torchlight;			//Light emitted from torches and other emissive blocks
	vec3 lightning;				//Light caused by lightning
	vec3 nolight;				//Base ambient light added to everything. For lighting caves so that the player can barely see even when no lights are present
	vec3 translucent;			//Light on the backside of objects representing thin translucent materials
	vec3 sky;					//Color and brightness of the sky itself
	vec3 underwater;			//underwater colors
	vec3 heldLight;


} final;

struct Intersection {
	vec3 pos;
	float distance;
	float angle;
};




/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Mask
void 	CalculateMasks(inout MaskStruct mask) {
		//if (isEyeInWater > 0)
			//mask.sky = 0.0f;
		//else
			mask.sky 			= GetMaterialMask(texcoord.st, 0, mask.matIDs);

		mask.land	 		= GetMaterialMask(texcoord.st, 1, mask.matIDs);
		mask.grass 			= GetMaterialMask(texcoord.st, 2, mask.matIDs);
		mask.leaves	 		= GetMaterialMask(texcoord.st, 3, mask.matIDs);
		mask.hand	 		= GetMaterialMask(texcoord.st, 5, mask.matIDs);
		mask.translucent	= GetMaterialMask(texcoord.st, 6, mask.matIDs);

		mask.glow	 		= GetMaterialMask(texcoord.st, 10, mask.matIDs);
		mask.sunspot 		= GetMaterialMask(texcoord.st, 11, mask.matIDs);

		mask.goldBlock 		= GetMaterialMask(texcoord.st, 20, mask.matIDs);
		mask.ironBlock 		= GetMaterialMask(texcoord.st, 21, mask.matIDs);
		mask.diamondBlock	= GetMaterialMask(texcoord.st, 22, mask.matIDs);
		mask.emeraldBlock	= GetMaterialMask(texcoord.st, 23, mask.matIDs);
		mask.sand	 		= GetMaterialMask(texcoord.st, 24, mask.matIDs);
		mask.sandstone 		= GetMaterialMask(texcoord.st, 25, mask.matIDs);
		mask.stone	 		= GetMaterialMask(texcoord.st, 26, mask.matIDs);
		mask.cobblestone	= GetMaterialMask(texcoord.st, 27, mask.matIDs);
		mask.wool			= GetMaterialMask(texcoord.st, 28, mask.matIDs);
		mask.clouds 		= GetMaterialMask(texcoord.st, 29, mask.matIDs);

		mask.torch 			= GetMaterialMask(texcoord.st, 30, mask.matIDs);
		mask.lava 			= GetMaterialMask(texcoord.st, 31, mask.matIDs);
		mask.glowstone 		= GetMaterialMask(texcoord.st, 32, mask.matIDs);
		mask.fire 			= GetMaterialMask(texcoord.st, 33, mask.matIDs);

		mask.particles		= GetMaterialMask(texcoord.st, 63, mask.matIDs);

		float transparentID = GetTransparentID(texcoord.st);

		mask.water 			= GetWaterMask(texcoord.st, transparentID);
		mask.stainedGlass 	= GetStainedGlassMask(texcoord.st, transparentID);
		mask.ice		 	= GetIceMask(texcoord.st, transparentID);

		mask.volumeCloud 	= 0.0f;
}

//Surface
void 	CalculateNdotL(inout SurfaceStruct surface) {		//Calculates direct sunlight without visibility check
	float direct = dot(surface.normal.rgb, surface.lightVector);
		  direct = direct * 1.0f + 0.0f;
		  //direct = clamp(direct, 0.0f, 1.0f);

	surface.NdotL = direct;
}

float 	CalculateDirectLighting(in SurfaceStruct surface) {

	//Tall grass translucent shading
	if (surface.mask.grass > 0.5f) {

		return clamp(dot(surface.lightVector, surface.upVector) * 0.8 + 0.2, 0.0, 1.0);


	//Leaves
	} else if (surface.mask.leaves > 0.5f) {

		// if (surface.NdotL > -0.01f) {
		// 	return surface.NdotL * 0.99f + 0.01f;
		// } else {
		// 	return abs(surface.NdotL) * 0.25f;
		// }

		return 0.5f;


	//clouds
	} else if (surface.mask.clouds > 0.5f) {

		return 0.5f;


	} else if (surface.mask.ice > 0.5f) {

		return pow(surface.NdotL * 0.5 + 0.5, 2.0f);

	//Default lambert shading
	} else {
		const float PI = 3.14159;
		const float roughness = 0.95;

		// interpolating normals will change the length of the normal, so renormalize the normal.
		vec3 normal = normalize(surface.normal.xyz);


		vec3 eyeDir = normalize(-surface.screenSpacePosition.xyz);

		// normal = normalize(normal + surface.lightVector * pow(clamp(dot(eyeDir, surface.lightVector), 0.0, 1.0), 5.0) * 0.5);

		// normal = normalize(normal + eyeDir * clamp(dot(normal, eyeDir), 0.0f, 1.0f));

		// calculate intermediary values
		float NdotL = dot(normal, surface.lightVector.xyz);
		float NdotV = dot(normal, eyeDir);

		float angleVN = acos(NdotV);
		float angleLN = acos(NdotL);

		float alpha = max(angleVN, angleLN);
		float beta = min(angleVN, angleLN);
		float gamma = dot(eyeDir - normal * dot(eyeDir, normal), surface.lightVector - normal * dot(surface.lightVector, normal));

		float roughnessSquared = roughness * roughness;

		// calculate A and B
		float A = 1.0 - 0.5 * (roughnessSquared / (roughnessSquared + 0.57));

		float B = 0.45 * (roughnessSquared / (roughnessSquared + 0.09));

		float C = sin(alpha) * tan(beta);

		// put it all together
		float L1 = max(0.0, NdotL) * (A + B * max(0.0, gamma) * C);

		//return max(0.0f, surface.NdotL * 0.99f + 0.01f);
		return clamp(L1, 0.0f, 1.0f);
	}
}

vec3 	CalculateSunlightVisibility(inout SurfaceStruct surface, in ShadingStruct shadingStruct) {				//Calculates shadows
	if (rainStrength >= 0.99f)
		return vec3(1.0f);

	if (shadingStruct.direct > 0.0f) {
		float distance = sqrt(  surface.screenSpacePosition.x * surface.screenSpacePosition.x 	//Get surface distance in meters
							  + surface.screenSpacePosition.y * surface.screenSpacePosition.y
							  + surface.screenSpacePosition.z * surface.screenSpacePosition.z);

		vec4 ssp = surface.screenSpacePosition;

		vec4 worldposition = vec4(0.0f);
			 worldposition = gbufferModelViewInverse * ssp;		//Transform from screen space to world space


		#if defined PIXEL_SHADOWS
			worldposition.xyz += cameraPosition.xyz + 0.001;
			worldposition.xyz = floor(worldposition.xyz * TEXTURE_RESOLUTION) / TEXTURE_RESOLUTION;
			worldposition.xyz -= cameraPosition.xyz;
		#endif

		float yDistanceSquared  = worldposition.y * worldposition.y;

		worldposition = shadowModelView * worldposition;	//Transform from world space to shadow space
		float comparedepth = -worldposition.z;				//Surface distance from sun to be compared to the shadow map

		worldposition = shadowProjection * worldposition;
		worldposition /= worldposition.w;

		float dist = sqrt(worldposition.x * worldposition.x + worldposition.y * worldposition.y);
		float distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;
		worldposition.xy *= 0.95f / distortFactor;
		worldposition.z = mix(worldposition.z, 0.5, 0.8);
		worldposition = worldposition * 0.5f + 0.5f;		//Transform from shadow space to shadow map coordinates

		float shadowMult = 0.0f;																			//Multiplier used to fade out shadows at distance
		float shading = 0.0f;

		float fademult = 0.15f;
			shadowMult = clamp((shadowDistance * 41.4f * fademult) - (distance * fademult), 0.0f, 1.0f);	//Calculate shadowMult to fade shadows out

		if (shadowMult > 0.0) 
		{

			float diffthresh = dist * 1.0f + 0.10f;
				  diffthresh *= 1.0f / (shadowMapResolution / 2048.0f);
				  //diffthresh /= shadingStruct.direct + 0.1f;


			#ifdef PIXEL_SHADOWS
				  //diffthresh += 1.5;
			#endif


			#ifdef ENABLE_SOFT_SHADOWS
			#ifndef VARIABLE_PENUMBRA_SHADOWS

				int count = 0;
				float spread = 1.0f / shadowMapResolution;

				vec3 noise = CalculateNoisePattern1(vec2(0.0), 64.0);

				for (float i = -0.5f; i <= 0.5f; i += 1.0f) 
				{
					for (float j = -0.5f; j <= 0.5f; j += 1.0f) 
					{
						float angle = noise.x * 3.14159 * 2.0;

						mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));

						vec2 coord = vec2(i, j) * rot;

						shading += shadow2D(shadow, vec3(worldposition.st + coord * spread, worldposition.z - 0.0008f * diffthresh)).x;
						count += 1;
					}
				}
				shading /= count;

			#endif
			#endif

			#ifdef VARIABLE_PENUMBRA_SHADOWS

				float vpsSpread = 0.125 / distortFactor;

				float avgDepth = 0.0;
				float minDepth = 11.0;
				int c;

				for (int i = -1; i <= 1; i++)
				{
					for (int j = -1; j <= 1; j++)
					{
						vec2 lookupCoord = worldposition.xy + (vec2(i, j) / shadowMapResolution) * 8.0 * vpsSpread;
						//avgDepth += pow(textureLod(shadowtex1, lookupCoord, 2).x, 4.1);
						float depthSample = textureLod(shadowtex1, lookupCoord, 2).x;
						minDepth = min(minDepth, textureLod(shadowtex1, lookupCoord, 2).x);
						avgDepth += pow(min(max(0.0, worldposition.z - depthSample) * 1.0, 0.15), 2.0);
						c++;
					}
				}

				avgDepth /= c;
				avgDepth = pow(avgDepth, 1.0 / 2.0);

				// float penumbraSize = min(abs(worldposition.z - minDepth), 0.15);
				float penumbraSize = avgDepth;

				int count = 0;
				float spread = penumbraSize * 0.0125 * vpsSpread + 0.5 / shadowMapResolution;

				vec3 noise = CalculateNoisePattern1(vec2(0.0), 64.0);

				diffthresh *= 0.5 + avgDepth * 50.0;

				for (float i = -2.0f; i <= 2.0f; i += 1.0f) 
				{
					for (float j = -2.0f; j <= 2.0f; j += 1.0f) 
					{
						float angle = noise.x * 3.14159 * 2.0;

						mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));

						vec2 coord = vec2(i, j) * rot;

						shading += shadow2D(shadow, vec3(worldposition.st + coord * spread, worldposition.z - 0.0012f * diffthresh)).x;
						count += 1;
					}
				}
				shading /= count;

			#endif

			#ifndef VARIABLE_PENUMBRA_SHADOWS
			#ifndef ENABLE_SOFT_SHADOWS
				//diffthresh *= 2.0f;
				shading = shadow2DLod(shadow, vec3(worldposition.st, worldposition.z - 0.0006f * diffthresh), 0).x;
			#endif
			#endif

		}

		//shading = mix(1.0f, shading, shadowMult);

		surface.shadow = shading;

		vec3 result = vec3(shading);


		///*
		#ifdef COLORED_SHADOWS
		float shadowNormalAlpha = textureLod(shadowcolor1, worldposition.st, 0).a;

		vec3 noise2 = CalculateNoisePattern1(vec2(0.0), 64.0);

		//worldposition.st += (noise2.xy * 2.0 - 1.0) / shadowMapResolution;

		if (shadowNormalAlpha < 0.5)
		{
			result = mix(vec3(1.0), pow(textureLod(shadowcolor, worldposition.st, 0).rgb, vec3(1.6)), vec3(1.0 - shading));
			float solidDepth = textureLod(shadowtex1, worldposition.st, 0).x;
			float solidShadow = 1.0 - clamp((worldposition.z - solidDepth) * 1200.0, 0.0, 1.0); 
			result *= solidShadow;
		}
		#endif
		//*/

		result = mix(vec3(1.0), result, shadowMult);

		return result;
	} else {
		return vec3(0.0f);
	}
}

float 	CalculateBouncedSunlight(in SurfaceStruct surface) {

	float NdotL = surface.NdotL;
	float bounced = clamp(-NdotL + 0.95f, 0.0f, 1.95f) / 1.95f;
		  bounced = bounced * bounced * bounced;

	return bounced;
}

float 	CalculateScatteredSunlight(in SurfaceStruct surface) {

	float NdotL = surface.NdotL;
	float scattered = clamp(NdotL * 0.75f + 0.25f, 0.0f, 1.0f);
		  //scattered *= scattered * scattered;

	return scattered;
}

float 	CalculateSkylight(in SurfaceStruct surface) {

	if (surface.mask.clouds > 0.5f) {
		return 1.0f;

	} else if (surface.mask.leaves > 0.5) {

	 	return dot(surface.normal, surface.upVector) * 0.35 + 0.65;

	} else if (surface.mask.grass > 0.5f) {

		return 1.6f;

	} else {

		float skylight = dot(surface.normal, surface.upVector);
			  skylight = skylight * 0.4f + 0.6f;

		return skylight;
	}
}

float 	CalculateScatteredUpLight(in SurfaceStruct surface) {
	float scattered = dot(surface.normal, surface.upVector);
		  scattered = scattered * 0.5f + 0.5f;
		  scattered = 1.0f - scattered;

	return scattered;
}

float CalculateHeldLightShading(in SurfaceStruct surface)
{
	vec3 lightPos = vec3(0.0f);
	vec3 lightVector = normalize(lightPos - surface.screenSpacePosition.xyz);
	float lightDist = length(lightPos.xyz - surface.screenSpacePosition.xyz);

	float atten = 1.0f / (pow(lightDist, 2.0f) + 0.5f);
	float NdotL = 1.0f;

	return atten * NdotL;
}

float   CalculateSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.screenSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

float   CalculateAntiSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.screenSpacePosition.xyz);
	vec3 halfVector2 = normalize(surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

bool   CalculateSunspot(in SurfaceStruct surface) {

	//circular sun
	float curve = 1.0f;

	vec3 npos = normalize(surface.screenSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);

	float sunProximity = 1.0f - dot(halfVector2, npos);

	if (sunProximity > 0.96f && sunAngle > 0.0f && sunAngle < 0.5f) {
		return true;
	} else {
		return false;
	}

	//Sun based on matID

	// if (surface.mask.sunspot)
	// 	return true;
	// else
	// 	return false;
}

void 	GetLightVectors(inout MCLightmapStruct mcLightmap, in SurfaceStruct surface) {

	vec2 torchDiff = vec2(0.0f);
		 torchDiff.x = GetLightmapTorch(texcoord.st) - GetLightmapTorch(texcoord.st + vec2(1.0f / viewWidth, 0.0f));
		 torchDiff.y = GetLightmapTorch(texcoord.st) - GetLightmapTorch(texcoord.st + vec2(0.0f, 1.0f / viewWidth));

		 //torchDiff /= GetDepthLinear(texcoord.st);

	mcLightmap.torchVector.x = torchDiff.x * 200.0f;
	//mcLightmap.torchVector.x *= 1.0f - surface.viewVector.x;

	mcLightmap.torchVector.y = torchDiff.y * 200.0f;

	mcLightmap.torchVector.x = 1.0f;
	mcLightmap.torchVector.y = 0.0f;
	mcLightmap.torchVector.z = sqrt(1.0f - mcLightmap.torchVector.x * mcLightmap.torchVector.x + mcLightmap.torchVector.y + mcLightmap.torchVector.y);




	float torchNormal = dot(surface.normal.rgb, mcLightmap.torchVector.rgb);

	mcLightmap.torchVector.x = torchNormal;


	//mcLightmap.torchVector = mcLightmap.torchVector * 0.5f + 0.5f;
}

void 	AddSkyGradient(inout SurfaceStruct surface) {
	float curve = 5.0f;
	vec3 npos = normalize(surface.screenSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.upVector + npos);
	float skyGradientFactor = dot(halfVector2, npos);
	float skyDirectionGradient = skyGradientFactor;

	if (dot(halfVector2, npos) > 0.75)
		skyGradientFactor = 1.5f - skyGradientFactor;

	skyGradientFactor = pow(skyGradientFactor, curve);

	surface.sky.albedo = CalculateLuminance(surface.sky.albedo) * colorSkylight;

	surface.sky.albedo *= mix(skyGradientFactor, 1.0f, clamp((0.12f - (timeNoon * 0.1f)) + rainStrength, 0.0f, 1.0f));
	surface.sky.albedo *= pow(skyGradientFactor, 2.5f) + 0.2f;
	surface.sky.albedo *= (pow(skyGradientFactor, 1.1f) + 0.425f) * 0.5f;
	surface.sky.albedo.g *= skyGradientFactor * 1.0f + 1.0f;


	vec3 linFogColor = pow(gl_Fog.color.rgb, vec3(2.2f));

	float fogLum = max(max(linFogColor.r, linFogColor.g), linFogColor.b);


	float fade1 = clamp(skyGradientFactor - 0.05f, 0.0f, 0.2f) / 0.2f;
		  fade1 = fade1 * fade1 * (3.0f - 2.0f * fade1);
	vec3 color1 = vec3(12.0f, 8.0, 4.7f) * 0.15f;
		 color1 = mix(color1, vec3(2.0f, 0.55f, 0.2f), vec3(timeSunriseSunset));

	surface.sky.albedo *= mix(vec3(1.0f), color1, vec3(fade1));

	float fade2 = clamp(skyGradientFactor - 0.11f, 0.0f, 0.2f) / 0.2f;
	vec3 color2 = vec3(2.7f, 1.0f, 2.8f) / 20.0f;
		 color2 = mix(color2, vec3(1.0f, 0.15f, 0.5f), vec3(timeSunriseSunset));

	surface.sky.albedo *= mix(vec3(1.0f), color2, vec3(fade2 * 0.5f));



	float horizonGradient = 1.0f - distance(skyDirectionGradient, 0.72f) / 0.72f;
		  horizonGradient = pow(horizonGradient, 10.0f);
		  horizonGradient = max(0.0f, horizonGradient);

	float sunglow = CalculateSunglow(surface);
		  horizonGradient *= sunglow * 2.0f + (0.65f - timeSunriseSunset * 0.55f);

	vec3 horizonColor1 = vec3(1.5f, 1.5f, 1.5f);
		 horizonColor1 = mix(horizonColor1, vec3(1.5f, 1.95f, 1.5f) * 2.0f, vec3(timeSunriseSunset));
	vec3 horizonColor2 = vec3(1.5f, 1.2f, 0.8f) * 1.0f;
		 horizonColor2 = mix(horizonColor2, vec3(1.9f, 0.6f, 0.4f) * 2.0f, vec3(timeSunriseSunset));

	surface.sky.albedo *= mix(vec3(1.0f), horizonColor1, vec3(horizonGradient) * (1.0f - timeMidnight));
	surface.sky.albedo *= mix(vec3(1.0f), horizonColor2, vec3(pow(horizonGradient, 2.0f)) * (1.0f - timeMidnight));

	float grayscale = fogLum / 10.0f;
		  grayscale /= 3.0f;

	surface.sky.albedo = mix(surface.sky.albedo, vec3(grayscale * colorSkylight.r) * 0.06f * vec3(0.85f, 0.85f, 1.0f), vec3(rainStrength));


	surface.sky.albedo /= fogLum;


	surface.sky.albedo *= mix(1.0f, 4.5f, timeNoon);



	// //Fake land
	//vec3 fakeLandColor = vec3(0.7f, 0.9f, 1.0f) * 0.012f;
	//surface.sky.albedo = mix(surface.sky.albedo, fakeLandColor, clamp(skyGradientFactor * 8.0f - 0.7f, 0.0f, 1.0f));


	surface.sky.albedo *= (surface.mask.sky);
}

void 	AddSunglow(inout SurfaceStruct surface) {
	float sunglowFactor = CalculateSunglow(surface);
	float antiSunglowFactor = CalculateAntiSunglow(surface);

	surface.sky.albedo *= 1.0f + pow(sunglowFactor, 1.1f) * (7.0f + timeNoon * 1.0f) * (1.0f - rainStrength) * 0.4;
	surface.sky.albedo *= mix(vec3(1.0f), colorSunlight * 11.0f, pow(clamp(vec3(sunglowFactor) * (1.0f - timeMidnight) * (1.0f - rainStrength), vec3(0.0f), vec3(1.0f)), vec3(2.0f)));
	surface.sky.albedo = mix(surface.sky.albedo, colorSunlight * surface.mask.sky * (0.25 + timeSunriseSunset * 0.25), pow(clamp(vec3(sunglowFactor) * (1.0f - timeMidnight) * (1.0f - rainStrength), vec3(0.0f), vec3(1.0f)), vec3(5.0f)));

	surface.sky.albedo *= 1.0f + antiSunglowFactor * 2.0f * (1.0f - rainStrength);
	//surface.sky.albedo *= mix(vec3(1.0f), colorSunlight, antiSunglowFactor);
}


void 	AddCloudGlow(inout vec3 color, in SurfaceStruct surface) {
	float glow = CalculateSunglow(surface);
		  glow = pow(glow, 1.0f);

	float mult = mix(50.0f, 800.0f, timeSkyDark);

	color.rgb *= 1.0f + glow * mult * (surface.mask.clouds);
}


void 	CalculateUnderwaterFog(in SurfaceStruct surface, inout vec3 finalComposite) {
	vec3 fogColor = colorWaterMurk * vec3(colorSkylight.b);
	// float fogDensity = 0.045f;
	// float fogFactor = exp(GetDepthLinear(texcoord.st) * fogDensity) - 1.0f;
	// 	  fogFactor = min(fogFactor, 1.0f);
	float fogFactor = GetDepthLinear(texcoord.st) / 100.0f;
		  fogFactor = min(fogFactor, 0.7f);
		  fogFactor = sin(fogFactor * 3.1415 / 2.0f);
		  fogFactor = pow(fogFactor, 0.5f);


	finalComposite.rgb = mix(finalComposite.rgb, fogColor * 0.002f, vec3(fogFactor));
	finalComposite.rgb *= mix(vec3(1.0f), colorWaterBlue * colorWaterBlue * colorWaterBlue * colorWaterBlue, vec3(fogFactor));
	//finalComposite.rgb = vec3(0.1f);
}

void 	TestRaymarch(inout vec3 color, in SurfaceStruct surface)
{

	//visualize march steps
	float rayDepth = 0.0f;
	float rayIncrement = 0.05f;
	float fogFactor = 0.0f;

	while (rayDepth < 1.0f)
	{
		vec4 rayPosition = GetScreenSpacePosition(texcoord.st, pow(rayDepth, 0.002f));



		if (abs(rayPosition.z - surface.screenSpacePosition.z) < 0.025f)
		{
			color.rgb = vec3(0.01f, 0.0f, 0.0f);
		}

		// if (SphereTestDistance(vec3(surface.screenSpacePosition.x, surface.screenSpacePosition.y, surface.screenSpacePosition.z)) <= 0.001f)
		// 	fogFactor += 0.001f;

		rayDepth += rayIncrement;

	}

	// color.rgb = mix(color.rgb, vec3(1.0f) * 0.01f, fogFactor);

	// vec4 newPosition = surface.screenSpacePosition;

	// color.rgb = vec3(distance(newPosition.rgb, vec3(0.0f, 0.0f, 0.0f)) * 0.00001f);

}

void InitializeAO(inout SurfaceStruct surface)
{
	surface.ao.skylight = 1.0f;
	surface.ao.bouncedSunlight = 1.0f;
	surface.ao.scatteredUpLight = 1.0f;
	surface.ao.constant = 1.0f;
}

void CalculateAO(inout SurfaceStruct surface)
{
	const int numSamples = 20;
	vec3[numSamples] kernel;

	vec3 stochastic = texture(noisetex, texcoord.st * vec2(viewWidth, viewHeight) / noiseTextureResolution).rgb;

	//Generate positions for sample points in hemisphere
	for (int i = 0; i < numSamples; i++)
	{
		//Random direction
		kernel[i] = vec3(texture(noisetex, vec2(0.0f + (i * 1.0f) / noiseTextureResolution)).r * 2.0f - 1.0f,
					     texture(noisetex, vec2(0.0f + (i * 1.0f) / noiseTextureResolution)).g * 2.0f - 1.0f,
					     texture(noisetex, vec2(0.0f + (i * 1.0f) / noiseTextureResolution)).b * 2.0f - 1.0f);
		//kernel[i] += (stochastic * vec3(2.0f, 2.0f, 1.0f) - vec3(1.0f, 1.0f, 0.0f)) * 0.0f;
		kernel[i] = normalize(kernel[i]);

		//scale randomly to distribute within hemisphere;
		kernel[i] *= pow(texture(noisetex, vec2(0.3f + (i * 1.0f) / noiseTextureResolution)).r * CalculateNoisePattern1(vec2(43.0f), 64.0f).x * 1.0f, 1.2f);
	}

	//Determine origin position and normal
	vec3 origin = surface.screenSpacePosition.xyz;
	vec3 normal = surface.normal.xyz;
		 //normal = lightVector;

	//Create matrix to orient hemisphere according to surface normal
	//vec3 randomRotation = texture(noisetex, texcoord.st * vec2(viewWidth / noiseTextureResolution, viewHeight / noiseTextureResolution)).rgb * 2.0f - 1.0f;
		//float dither1 = CalculateDitherPattern1() * 2.0f - 1.0f;
		//randomRotation = vec3(dither1, mod(dither1 + 0.5f, 2.0f), mod(dither1 + 1.0f, 2.0f));
	vec3	randomRotation = CalculateNoisePattern1(vec2(0.0f), 64.0f).xyz * 2.0f - 1.0f;
	//vec3	randomRotation = vec3(1.0f, 0.0f, 0.0f);


	vec3 tangent = normalize(randomRotation - upVector * dot(randomRotation, upVector));
	vec3 bitangent = cross(upVector, tangent);
	mat3 tbn = mat3(tangent, bitangent, upVector);

	float ao = 0.0f;
	float aoSkylight	= 0.0f;
	float aoUp  		= 0.0f;
	float aoBounced  	= 0.0f;
	float aoScattered  	= 0.0f;


	float aoRadius   = 0.35f * -surface.screenSpacePosition.z;
		  //aoRadius   = 3.0f;
	float zThickness = 0.35f * -surface.screenSpacePosition.z;
		  zThickness = 6.0f;


	vec3 	samplePosition 		= vec3(0.0f);
	float 	intersect 			= 0.0f;
	vec4 	sampleScreenSpace 	= vec4(0.0f);
	float 	sampleDepth 		= 0.0f;
	float 	distanceWeight 		= 0.0f;
	float 	finalRadius 		= 0.0f;

	float skylightWeight = 0.0f;
	float bouncedWeight  = 0.0f;
	float scatteredUpWeight = 0.0f;
	float scatteredSunWeight = 0.0f;
	vec3 bentNormal = vec3(0.0f);

	for (int i = 0; i < numSamples; i++)
	{
		samplePosition = tbn * kernel[i];
		samplePosition = samplePosition * aoRadius + origin;

		intersect = dot(normalize(samplePosition - origin), surface.normal);

		if (intersect > 0.2f) {
			//Convert camera space to screen space
			sampleScreenSpace = gbufferProjection * vec4(samplePosition, 1.0f);
			sampleScreenSpace.xyz /= sampleScreenSpace.w;
			sampleScreenSpace.xyz = sampleScreenSpace.xyz * 0.5f + 0.5f;

			//Check depth at sample point
			sampleDepth = GetScreenSpacePosition(sampleScreenSpace.xy).z;

			//If point is behind geometry, buildup AO
			if (sampleDepth >= samplePosition.z && surface.mask.sky < 0.5f)
			{
				//Reduce halo
				float sampleLength = length(samplePosition - origin) * 4.0f;
				//distanceWeight = 1.0f - clamp(distance(sampleDepth, origin.z) - (sampleLength * 0.5f), 0.0f, sampleLength * 0.5f) / (sampleLength * 0.5f);
				distanceWeight = 1.0f - step(sampleLength, distance(sampleDepth, origin.z));

				//Weigh samples based on light direction
				skylightWeight 			= clamp(dot(normalize(samplePosition - origin), upVector)		* 1.0f - 0.0f , 0.0f, 0.01f) / 0.01f;
				//skylightWeight 		   += clamp(dot(normalize(samplePosition - origin), upVector), 0.0f, 1.0f);
				bouncedWeight 			= clamp(dot(normalize(samplePosition - origin), -lightVector)	* 1.0f - 0.0f , 0.0f, 0.51f) / 0.51f;
				scatteredUpWeight 		= clamp(dot(normalize(samplePosition - origin), -upVector)	 	* 1.0f - 0.0f , 0.0f, 0.51f) / 0.51f;
				scatteredSunWeight 		= clamp(dot(normalize(samplePosition - origin), lightVector)	* 1.0f - 0.25f, 0.0f, 0.51f) / 0.51f;

					  //buildup occlusion more for further facing surfaces
				 	  skylightWeight 			/= clamp(dot(normal, upVector) 			* 0.5f + 0.501f, 0.01f, 1.0f);
				 	  bouncedWeight 			/= clamp(dot(normal, -lightVector) 		* 0.5f + 0.501f, 0.01f, 1.0f);
				 	  scatteredUpWeight 		/= clamp(dot(normal, -upVector) 		* 0.5f + 0.501f, 0.01f, 1.0f);
				 	  scatteredSunWeight 		/= clamp(dot(normal, lightVector) 		* 0.75f + 0.25f, 0.01f, 1.0f);


				//Accumulate ao
				ao 			+= 2.0f * distanceWeight;
				aoSkylight  += 2.0f * distanceWeight * skylightWeight		;
				aoUp 		+= 2.0f * distanceWeight * scatteredUpWeight	;
				aoBounced 	+= 2.0f * distanceWeight * bouncedWeight		;
				aoScattered += 2.0f * distanceWeight * scatteredSunWeight   ;
			} else {
				bentNormal.rgb += normalize(samplePosition - origin);
			}
		}
	}

	bentNormal.rgb /= numSamples;

	ao 			/= numSamples;
	aoSkylight  /= numSamples;
	aoUp 		/= numSamples;
	aoBounced 	/= numSamples;
	aoScattered /= numSamples;

	ao 			= 1.0f - ao;
	aoSkylight 	= 1.0f - aoSkylight;
	aoUp 		= 1.0f - aoUp;
	aoBounced   = 1.0f - aoBounced;
	aoScattered = 1.0f - aoScattered;

	ao 			= clamp(ao, 			0.0f, 1.0f);
	aoSkylight 	= clamp(aoSkylight, 	0.0f, 1.0f);
	aoUp 		= clamp(aoUp, 			0.0f, 1.0f);
	aoBounced 	= clamp(aoBounced,		0.0f, 1.0f);
	aoScattered = clamp(aoScattered, 	0.0f, 1.0f);

	surface.ao.constant 				= pow(ao, 			1.0f);
	surface.ao.skylight 				= pow(aoSkylight, 	3.0f);
	surface.ao.bouncedSunlight 			= pow(aoBounced, 	6.0f);
	surface.ao.scatteredUpLight 		= pow(aoUp, 		6.0f);
	surface.ao.scatteredSunlight 		= pow(aoScattered,  1.0f);

	surface.debug = vec3(pow(aoSkylight, 2.0f) * clamp((dot(surface.normal, upVector) * 0.75f + 0.25f), 0.0f, 1.0f));
	//surface.debug = vec3(dot(normalize(bentNormal), upVector));
}


void 	CalculateRainFog(inout vec3 color, in SurfaceStruct surface)
{
	vec3 fogColor = colorSkylight * 0.055f;

	float fogDensity = 0.00018f * rainStrength;
		  fogDensity *= mix(0.0f, 1.0f, pow(eyeBrightnessSmooth.y / 240.0f, 6.0f));
	float visibility = 1.0f / (pow(exp(distance(surface.screenSpacePosition.xyz, vec3(0.0f)) * fogDensity), 1.0f));
	float fogFactor = 1.0f - visibility;
		  fogFactor = clamp(fogFactor, 0.0f, 1.0f);
		  fogFactor = mix(fogFactor, 1.0f, (surface.mask.sky) * 0.8f * rainStrength);
		  fogFactor = mix(fogFactor, 1.0f, (surface.mask.clouds) * 0.8f * rainStrength);
		  fogFactor *= mix(1.0f, 0.0f, (surface.mask.sky));

	color = mix(color, fogColor, vec3(fogFactor));
}

#define AtmosphereDensity 4.0		//[1.0 2.0 4.0 8.0 16.0 32.0 64.0 70.0 128.0]

uniform vec3 shadowLightVectorView;

void 	CalculateAtmosphericScattering(inout vec3 color, in SurfaceStruct surface) {
	if(max(surface.mask.particles, surface.mask.sky) > 0.5) return;

	float mu = dot(normalize(surface.screenSpacePosition.xyz), shadowLightVectorView);
	vec3 fogColor = colorSkylight + HG(mu, 0.76) * colorSunlight;

	// vec3 fogColor = mix(colorSkylight, colorSunlight, vec3(0.05f)) * 0.11f;

	// float sat = 0.1f;
	// 	 fogColor.r = fogColor.r * (1.0f + sat) - (fogColor.g + fogColor.b) * 0.5f * sat;
	// 	 fogColor.g = fogColor.g * (1.0f + sat) - (fogColor.r + fogColor.b) * 0.5f * sat;
	// 	 fogColor.b = fogColor.b * (1.0f + sat) - (fogColor.r + fogColor.g) * 0.5f * sat;

	//vec3 fogColor = pow(colorSkylight, vec3(1.55f));

	//float sunglow = pow(CalculateSunglow(surface), 2.0f);

	//fogColor *= 1.0 + sunglow;

	//vec3 sunColor = colorSunlight;

	//fogColor += mix(vec3(0.0f), sunColor * 10.0f, sunglow * 0.8f);

	//float fogFactor = pow(surface.linearDepth / 1500.0f, 2.0f);
	//float fogFactor = 1.0 - exp(-length(surface.screenSpacePosition) * 0.0001);
	float fogFactor = 1.0 - exp(-pow(length(surface.screenSpacePosition), 2.0) * 0.000001);
		  //fogFactor = mix(fogFactor, 1.0f, float(surface.mask.sky) * 0.8f * rainStrength);
		  //fogFactor = mix(fogFactor, 1.0f, float(surface.mask.clouds) * 0.8f * rainStrength);

	//fogFactor = mix(fogFactor, 0.0f, min(1.0f, surface.sky.sunSpot.r));
	fogFactor *= mix(1.0f, 0.0f, (surface.mask.sky));
	//fogFactor *= mix(1.0f, 0.75f, (surface.mask.clouds));

	fogFactor *= pow(eyeBrightnessSmooth.y / 240.0f, 1.0f);

	// float redshift = 100.5f * (1.0f - rainStrength);
	// 	  redshift *= float(!surface.mask.sky);

	// //scatter away high frequency light
	// color.b *= 1.0f - clamp(fogFactor * 1.65 * redshift, 0.0f, 0.75f);
	// color.g *= 1.0f - fogFactor * 0.8* redshift;
	// color.g *= 1.0f - clamp(fogFactor - 0.26f, 0.0f, 1.0f) * 0.5* redshift;

	//add scattered low frequency light
	color += fogColor * fogFactor * RAYLEIGH_AMOUNT;

}


Intersection 	RayPlaneIntersectionWorld(in Ray ray, in Plane plane)
{
	float rayPlaneAngle = dot(ray.dir, plane.normal);

	float planeRayDist = 100000000.0f;
	vec3 intersectionPos = ray.dir * planeRayDist;

	if (rayPlaneAngle > 0.0001f || rayPlaneAngle < -0.0001f)
	{
		planeRayDist = dot((plane.origin), plane.normal) / rayPlaneAngle;
		intersectionPos = ray.dir * planeRayDist;
		intersectionPos = -intersectionPos;

		intersectionPos += cameraPosition.xyz;
	}

	Intersection i;

	i.pos = intersectionPos;
	i.distance = planeRayDist;
	i.angle = rayPlaneAngle;

	return i;
}

Intersection 	RayPlaneIntersection(in Ray ray, in Plane plane)
{
	float rayPlaneAngle = dot(ray.dir, plane.normal);

	float planeRayDist = 100000000.0f;
	vec3 intersectionPos = ray.dir * planeRayDist;

	if (rayPlaneAngle > 0.0001f || rayPlaneAngle < -0.0001f)
	{
		planeRayDist = dot((plane.origin - ray.origin), plane.normal) / rayPlaneAngle;
		intersectionPos = ray.origin + ray.dir * planeRayDist;
		// intersectionPos = -intersectionPos;

		// intersectionPos += cameraPosition.xyz;
	}

	Intersection i;

	i.pos = intersectionPos;
	i.distance = planeRayDist;
	i.angle = rayPlaneAngle;

	return i;
}

float CubicSmooth(float x)
{
	return x * x * (3.0 - 2.0 * x);
}

float Get3DNoise(in vec3 pos)
{
	pos.z += 0.0f;

	pos.xyz += 0.5f;

	vec3 p = floor(pos);
	vec3 f = fract(pos);

	// f.x = f.x * f.x * (3.0f - 2.0f * f.x);
	// f.y = f.y * f.y * (3.0f - 2.0f * f.y);
	// f.z = f.z * f.z * (3.0f - 2.0f * f.z);

	vec2 uv =  (p.xy + p.z * vec2(17.0f)) + f.xy;
	vec2 uv2 = (p.xy + (p.z + 1.0f) * vec2(17.0f)) + f.xy;

	// uv -= 0.5f;
	// uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / noiseTextureResolution;
	vec2 coord2 = (uv2 + 0.5f) / noiseTextureResolution;
	float xy1 = texture(noisetex, coord).x;
	float xy2 = texture(noisetex, coord2).x;
	return mix(xy1, xy2, f.z);
}


float Get3DNoise3(in vec3 pos)
{
	pos.z += 0.0f;

	pos.xyz += 0.5f;

	vec3 p = floor(pos);
	vec3 f = fract(pos);

	 f.x = f.x * f.x * (3.0f - 2.0f * f.x);
	 f.y = f.y * f.y * (3.0f - 2.0f * f.y);
	 f.z = f.z * f.z * (3.0f - 2.0f * f.z);

	vec2 uv =  (p.xy + p.z * vec2(17.0f)) + f.xy;
	vec2 uv2 = (p.xy + (p.z + 1.0f) * vec2(17.0f)) + f.xy;

	uv -= 0.5f;
	uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / noiseTextureResolution;
	vec2 coord2 = (uv2 + 0.5f) / noiseTextureResolution;
	float xy1 = texture(noisetex, coord).x;
	float xy2 = texture(noisetex, coord2).x;
	return mix(xy1, xy2, f.z);
}

float GetCoverage(in float coverage, in float density, in float clouds)
{
	clouds = clamp(clouds - (1.0f - coverage), 0.0f, 1.0f -density) / (1.0f - density);
		clouds = max(0.0f, clouds * 1.1f - 0.1f);
	 clouds = clouds = clouds * clouds * (3.0f - 2.0f * clouds);
	 // clouds = pow(clouds, 1.0f);
	return clouds;
}


vec4 CloudColor(in vec4 worldPosition, in float sunglow, in vec3 worldLightVector, in float altitude, in float thickness, const bool isShadowPass)
{

	float cloudHeight = altitude;
	float cloudDepth  = thickness;
	float cloudUpperHeight = cloudHeight + (cloudDepth / 2.0f);
	float cloudLowerHeight = cloudHeight - (cloudDepth / 2.0f);

	//worldPosition.xz /= 1.0f + max(0.0f, length(worldPosition.xz - cameraPosition.xz) / 5000.0f);

	vec3 p = worldPosition.xyz / 150.0f;



	float t = frameTimeCounter * 1.0f;
		  t *= 0.5;


	 p += (Get3DNoise(p * 2.0f + vec3(0.0f, t * 0.00f, 0.0f)) * 2.0f - 1.0f) * 0.10f;
	 p.z -= (Get3DNoise(p * 0.25f + vec3(0.0f, t * 0.00f, 0.0f)) * 2.0f - 1.0f) * 0.45f;
	 p.x -= (Get3DNoise(p * 0.125f + vec3(0.0f, t * 0.00f, 0.0f)) * 2.0f - 1.0f) * 3.2f;
	p.xz -= (Get3DNoise(p * 0.0525f + vec3(0.0f, t * 0.00f, 0.0f)) * 2.0f - 1.0f) * 2.7f;


	p.x *= 0.5f;
	p.x -= t * 0.01f;

	vec3 p1 = p * vec3(1.0f, 0.5f, 1.0f)  + vec3(0.0f, t * 0.01f, 0.0f);
	float noise  = 	Get3DNoise(p * vec3(1.0f, 0.5f, 1.0f) + vec3(0.0f, t * 0.01f, 0.0f));	p *= 2.0f;	p.x -= t * 0.057f;	vec3 p2 = p;
		  noise += (2.0f - abs(Get3DNoise(p) * 2.0f - 0.0f)) * (0.25f);						p *= 3.0f;	p.xz -= t * 0.035f;	p.x *= 2.0f;	vec3 p3 = p;
		  noise += (3.0f - abs(Get3DNoise(p) * 3.0f - 0.0f)) * (0.085f);						p *= 3.0f;	p.xz -= t * 0.035f;	vec3 p4 = p;
		  noise += (3.0f - abs(Get3DNoise(p) * 3.0f - 0.0f)) * (0.035f);						p *= 3.0f;	p.xz -= t * 0.035f;
		  if (!isShadowPass)
		  {
		 		noise += ((Get3DNoise(p))) * (0.039f);												p *= 3.0f;
		  		noise += ((Get3DNoise(p))) * (0.014f);
		  }
		  noise /= 1.575f;

	//cloud edge
	float coverage = 0.67f;
		  coverage = mix(coverage, 0.87f, rainStrength);

		  float dist = length(worldPosition.xz - cameraPosition.xz * 0.5);
		  coverage *= max(0.0f, 1.0f - dist / 4000.0f);
	float density = 0.1f - rainStrength * 0.3;

	if (isShadowPass)
	{
		return vec4(GetCoverage(0.4f, 0.4f, noise));
	}

	noise = GetCoverage(coverage, density, noise);

	const float lightOffset = 0.2f;



	float sundiff = Get3DNoise(p1 + worldLightVector.xyz * lightOffset);
		  sundiff += (2.0f - abs(Get3DNoise(p2 + worldLightVector.xyz * lightOffset / 2.0f) * 2.0f - 0.0f)) * (0.55f);
		  				float largeSundiff = sundiff;
		  				      largeSundiff = -GetCoverage(coverage, 0.0f, largeSundiff * 1.3f);
		  sundiff += (3.0f - abs(Get3DNoise(p3 + worldLightVector.xyz * lightOffset / 5.0f) * 3.0f - 0.0f)) * (0.045f);
		  sundiff += (3.0f - abs(Get3DNoise(p4 + worldLightVector.xyz * lightOffset / 8.0f) * 3.0f - 0.0f)) * (0.015f);
		  sundiff /= 1.5f;
		  sundiff = -GetCoverage(coverage * 1.0f, 0.0f, sundiff);
	float secondOrder 	= pow(clamp(sundiff * 1.1f + 1.45f, 0.0f, 1.0f), 7.0f);
	float firstOrder 	= pow(clamp(largeSundiff * 1.1f + 1.66f, 0.0f, 1.0f), 3.0f);



	float directLightFalloff = firstOrder * secondOrder;
	float anisoBackFactor = mix(clamp(pow(noise, 1.6f) * 2.5f, 0.0f, 1.0f), 1.0f, pow(sunglow, 1.0f));

		  directLightFalloff *= anisoBackFactor;
	 	  directLightFalloff *= mix(11.5f, 1.0f, pow(sunglow, 0.5f));



	vec3 colorDirect = colorSunlight * 0.215f;
		 colorDirect = mix(colorDirect, colorDirect * vec3(0.2f, 0.5f, 1.0f), timeMidnight);
		 colorDirect = mix(colorDirect, colorDirect * vec3(1.0f, 1.0f, 1.0f), timeNoon);
		 colorDirect *= 1.0f + pow(sunglow, 2.0f) * 600.0f * pow(directLightFalloff, 1.1f) * (1.0f - rainStrength);
		 colorDirect *= 1.0f + rainStrength * 3.25;


	vec3 colorAmbient = mix(colorSkylight, colorSunlight * 2.0f, vec3(0.15f)) * 0.03f;
		 colorAmbient *= mix(1.0f, 0.3f, timeMidnight);
		 colorAmbient = mix(colorAmbient, colorAmbient * 3.0f + colorSunlight * 0.05f, vec3(clamp(pow(1.0f - noise, 12.0f) * 1.0f, 0.0f, 1.0f)));


	directLightFalloff *= 2.0f;

	directLightFalloff *= mix(1.0, 0.125, rainStrength);

	//directLightFalloff += (pow(Get3DNoise(p3), 2.0f) * 0.5f + pow(Get3DNoise(p3 * 1.5f), 2.0f) * 0.25f) * 0.02f;
	//directLightFalloff *= Get3DNoise(p2);

	vec3 color = mix(colorAmbient, colorDirect, vec3(min(1.0f, directLightFalloff)));

	color *= 1.0f;

	color = mix(color, color * 0.9, rainStrength);


	vec4 result = vec4(color.rgb, noise);

	return result;

}

float pcurve(float x, float a, float b)
{
	float k = pow(a+b, a+b) / (pow(a,a)*pow(b,b));
	return k * pow(x, a) * pow(1.0 - x, b);
}

vec4 CloudColor2(in vec4 worldPosition, in float sunglow, in vec3 worldLightVector, in float altitude, in float heightFactor, const bool isShadowPass)
{
	vec3 p = worldPosition.xyz / 130.0f;

	float t = frameTimeCounter * 1.0f;
		  t *= 0.05;

	p.x *= 0.5f;
	p.x -= t * 0.01f;

	vec3 p1 = p * vec3(1.0f, 0.5f, 1.0f)  + vec3(0.0f, t * 0.01f, 0.0f);

	float noise  = 	Get3DNoise(p * vec3(1.0f, 0.5f, 1.0f) + vec3(0.0f, t * 0.01f, 0.0f)) * 1.3;		p *= 2.0f;	p.x -= t * 0.557f;	vec3 p2 = p;	
		  noise += (2.0f - abs(Get3DNoise(p) * 2.0f - 0.0f)) * (0.35f);								p *= 3.0f;	p.xz -= t * 0.905f;	p.x *= 2.0f;	vec3 p3 = p; 	float largeNoise = noise;
		  noise += (3.0f - abs(Get3DNoise(p) * 3.0f - 0.0f)) * (0.085f);							p *= 3.0f;	p.xz -= t * 3.905f;	vec3 p4 = p;
		  noise += (3.0f - abs(Get3DNoise(p) * 3.0f - 0.0f)) * (0.035f);							p *= 3.0f;	p.xz -= t * 3.905f;
		  noise += ((Get3DNoise(p))) * (0.04f);												p *= 3.0f;
		  noise /= 2.375f;

	//cloud edge
	float rainy = mix(wetness, 1.0f, rainStrength);
		float coverage = Vol_Cloud_Coverage + rainy * 0.335;
		  coverage = mix(coverage, 0.87f, rainStrength);

	float dist = length(worldPosition.xz - cameraPosition.xz * 0.5) * 0.5;
		  coverage *= max(0.0f, 1.0f - dist / 4000.0f);
	float density = 0.71f - rainStrength * 0.3;

	noise = GetCoverage(coverage, density, noise);

	const float lightOffset = 0.2f;

	noise *= pcurve(heightFactor, 0.5, 2.5) * saturate(heightFactor * 8.0 - 1.0);

	if (noise < 0.0001)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}

	float sundiff = Get3DNoise(p1 + worldLightVector.xyz * lightOffset) * 1.3;
		  sundiff += (2.0f - abs(Get3DNoise(p2 + worldLightVector.xyz * lightOffset / 2.0f) * 2.0f - 0.0f)) * (0.35f);
		  				float largeSundiff = sundiff;
		  				      largeSundiff = -GetCoverage(coverage, 0.0f, largeSundiff * 1.3f);
		  sundiff /= 1.1f;
		  sundiff *= max(0.0f, 1.0f - dist / 10000.0f);
		  sundiff = -GetCoverage(coverage * 1.1f, -0.2f, sundiff);
		  sundiff *= pow(saturate(heightFactor * 1.5), 1.0);
		  sundiff *= mix(1.0, pow(saturate((1.0 - heightFactor) * (1.0 + largeNoise * 1.0)), 1.0), 0.6);
	float secondOrder 	= pow(clamp(sundiff * 1.0f + 1.2f, 0.0f, 1.0f), 2.7f);
	float firstOrder 	= pow(clamp(sundiff * 0.9f + 1.1f, 0.0f, 1.0f), 13.0f);
	float thirdOrder 	= pow(clamp(-largeNoise * 1.0 + 2.0, 0.0, 3.0), 1.0);

	float directLightFalloff = mix(firstOrder * 2.0, secondOrder * 3.0, 0.15);
	float anisoBackFactor = mix(clamp(pow(noise, 1.3f) * 7.5f, 0.0f, 2.0f), 1.0f, pow(sunglow, 1.0f));

		  directLightFalloff *= anisoBackFactor * 0.8 + 0.2;
	 	  
	vec3 colorDirect = colorSunlight * 0.215f;
		 colorDirect = mix(colorDirect, colorDirect * vec3(0.2f, 0.5f, 1.0f), timeMidnight);
	 	 colorDirect *= 1.0 + 115.0 * pow((1.0 - noise), 5.0) * firstOrder * firstOrder * pow(sunglow, 1.0) * (1.0 - rainStrength);


	vec3 colorAmbient = mix(colorSkylight, colorSunlight * 2.0f, vec3(0.15f)) * 0.03f;
		 colorAmbient *= mix(1.0f, 0.3f, timeMidnight);
		 colorAmbient *= mix(1.0, 0.1, heightFactor);
	
	directLightFalloff *= mix(1.0, 0.175, rainStrength);

	 vec3 colorBounced = colorBouncedSunlight * 0.135f;
	 	
	 	  colorBounced *= anisoBackFactor + 0.5;
	 	  colorBounced *= 1.0 - rainStrength;

		vec3 color = mix(colorAmbient, colorDirect, vec3(min(1.0f, directLightFalloff)));
			 color += colorBounced;

	color *= 1.0f;

	color = mix(color, color * 0.9, rainStrength);

	vec4 result = vec4(color.rgb, noise);

	return result;

}

vec4 CloudColorT(in vec4 worldPosition, in float sunglow, in vec3 worldLightVector)
{

	float cloudHeight = CALCLOUDHEIGHT;
	
	
	
	float cloudDepth  = CALCULATECLOUDDEPTH - 3 * CALCULATECLOUDDEPTH * timeMidnight - 0.5 * CALCULATECLOUDDEPTH * timeSunriseSunset * (1-1.5*rainStrength);

	
	
	float cloudUpperHeight = cloudHeight + (cloudDepth / 2.0f);
	float cloudLowerHeight = cloudHeight - (cloudDepth / 2.0f);

	if (worldPosition.y < cloudLowerHeight || worldPosition.y > cloudUpperHeight)
		return vec4(0.0f);
	else
	{

		vec3 p = worldPosition.xyz / 150.0f;

			

		float t = frameTimeCounter * CALCLOUD_SPEED;
		
		
		
			  //t *= 0.001;
		p.x -= t * 0.02f;

		// p += (Get3DNoise(p * 1.0f + vec3(0.0f, t * 0.01f, 0.0f)) * 2.0f - 1.0f) * 0.15f;

		vec3 p1 = p * vec3(1.0f, 0.5f, 1.0f)  + vec3(0.0f, t * 0.01f, 0.0f);
		float noise  = 	Get3DNoise(p * vec3(1.0f, 0.5f, 1.0f) + vec3(0.0f, t * 0.01f, 0.0f));	p *= 2.0f;	p.x -= t * 0.097f;	vec3 p2 = p;
			  noise += (1.0 - abs(Get3DNoise(p) * 1.0f - 0.5f) - 0.1) * 0.55f;					p *= 2.5f;	p.xz -= t * 0.065f;	vec3 p3 = p;
			  noise += (1.0 - abs(Get3DNoise(p) * 3.0f - 1.5f) - 0.2) * 0.065f;					p *= 2.5f;	p.xz -= t * 0.165f;	vec3 p4 = p;
			  noise += (1.0 - abs(Get3DNoise(p) * 3.0f - 1.5f)) * 0.032f;						p *= 2.5f;	p.xz -= t * 0.165f;
			  noise += (1.0 - abs(Get3DNoise(p) * 2.0 - 1.0)) * 0.015f;												p *= 2.5f;
			  // noise += (1.0 - abs(Get3DNoise(p) * 2.0 - 1.0)) * 0.016f;
			  noise /= 1.875f;



		float lightOffset = 0.3f - timeMidnight;


		float heightGradient = clamp(( - (cloudLowerHeight - worldPosition.y) / (cloudDepth * 1.0f)), 0.0f, 1.0f);
		float heightGradient2 = clamp(( - (cloudLowerHeight - (worldPosition.y + worldLightVector.y * lightOffset * 150.0f)) / (cloudDepth * 1.0f)), 0.0f, 1.0f);

		float cloudAltitudeWeight = 1.0f - clamp(distance(worldPosition.y, cloudHeight) / (cloudDepth / 2.0f), 0.0f, 1.0f);
			  cloudAltitudeWeight = (-cos(cloudAltitudeWeight * 3.1415f)) * 0.5 + 0.5;
			  cloudAltitudeWeight = pow(cloudAltitudeWeight, mix(0.33f, 0.8f, rainStrength));
			  //cloudAltitudeWeight *= 1.0f - heightGradient;
			  //cloudAltitudeWeight = 1.0f;

		float cloudAltitudeWeight2 = 1.0f - clamp(distance(worldPosition.y + worldLightVector.y * lightOffset * 150.0f, cloudHeight) / (cloudDepth / 2.0f), 0.0f, 1.0f);
			  cloudAltitudeWeight2 = (-cos(cloudAltitudeWeight2 * 3.1415f)) * 0.5 + 0.5;		
			  cloudAltitudeWeight2 = pow(cloudAltitudeWeight2, mix(0.33f, 0.8f, rainStrength));
			  //cloudAltitudeWeight2 *= 1.0f - heightGradient2;
			  //cloudAltitudeWeight2 = 1.0f;

		noise *= cloudAltitudeWeight;

		//cloud edge
		float coverage = 0.25f + 0.001 * CALCULATECLOUDSDENSITY;
		
		
			  coverage = mix(coverage, 0.77f, rainStrength);

			  float dist = length(worldPosition.xz - cameraPosition.xz);
			  coverage *= max(0.0f, 1.0f - dist / 40000.0f);
		float density = 0.87f;
		noise = GetCoverage(coverage, density, noise);
		noise = pow(noise, 1.5);


		if (noise <= 0.001f)
		{
			return vec4(0.0f, 0.0f, 0.0f, 0.0f);
		}

		//float sunProximity = pow(sunglow, 1.0f);
		//float propigation = mix(15.0f, 9.0f, sunProximity);


		// float directLightFalloff = pow(heightGradient, propigation);
		// 	  directLightFalloff += pow(heightGradient, propigation / 2.0f);
		// 	  directLightFalloff /= 2.0f;






	float sundiff = Get3DNoise(p1 + worldLightVector.xyz * lightOffset);
		  sundiff += (1.0 - abs(Get3DNoise(p2 + worldLightVector.xyz * lightOffset / 2.0f) * 1.0f - 0.5f) - 0.1) * 0.55f;
		  // sundiff += (1.0 - abs(Get3DNoise(p3 + worldLightVector.xyz * lightOffset / 5.0f) * 3.0f - 1.5f) - 0.2) * 0.085f;
		  // sundiff += (1.0 - abs(Get3DNoise(p4 + worldLightVector.xyz * lightOffset / 8.0f) * 3.0f - 1.5f)) * 0.052f;
		  sundiff *= 0.955f;
		  sundiff *= cloudAltitudeWeight2;
	float preCoverage = sundiff;
		  sundiff = -GetCoverage(coverage * 1.0f, density * 0.5, sundiff);
	float sundiff2 = -GetCoverage(coverage * 1.0f, 0.0, preCoverage);
	float firstOrder 	= pow(clamp(sundiff * 1.2f + 1.7f, 0.0f, 1.0f), 8.0f);
	float secondOrder 	= pow(clamp(sundiff2 * 1.2f + 1.1f, 0.0f, 1.0f), 4.0f);



	float anisoBackFactor = mix(clamp(pow(noise, 2.0f) * 1.0f, 0.0f, 1.0f), 1.0f, pow(sunglow, 1.0f));
		  firstOrder *= anisoBackFactor * 0.99 + 0.01;
		  secondOrder *= anisoBackFactor * 0.8 + 0.2;
	float directLightFalloff = mix(firstOrder, secondOrder, 0.2f);
	// float directLightFalloff = max(firstOrder, secondOrder);

		  // directLightFalloff *= anisoBackFactor;
	 	  // directLightFalloff *= mix(11.5f, 1.0f, pow(sunglow, 0.5f));
	


	vec3 colorDirect = colorSunlight * CALCULATECLOUDSCONCENTRATION * (1.0 - timeMidnight);

		 // colorDirect = mix(colorDirect, colorDirect * vec3(0.2f, 0.5f, 1.0f), timeMidnight);
		 DoNightEye(colorDirect);
		 colorDirect *= 1.0f + pow(sunglow, 4.0f) * 2400.0f * pow(firstOrder, 1.1f) * (1.0f - rainStrength);

		
		
	vec3 colorAmbient = colorSkylight * 0.16f * WHITECLOUDS;
	
	
	 
	
		 colorAmbient *= mix(1.0f, 0.3f, timeMidnight);
		 colorAmbient = mix(colorAmbient, colorAmbient * 2.0f + colorSunlight * 0.05f, vec3(clamp(pow(1.0f - noise, 2.0f) * 1.0f, 0.0f, 1.0f)));
		 colorAmbient *= heightGradient * heightGradient + 0.05f;

	 vec3 colorBounced = colorBouncedSunlight * 0.35f;
	 	 colorBounced *= pow((1.0f - heightGradient), 8.0f);
	 	 colorBounced *= anisoBackFactor + 0.5;
	 	 colorBounced *= 1.0 - rainStrength;


		directLightFalloff *= 1.0f - rainStrength * 0.6f;

		// //cloud shadows
		// vec4 shadowPosition = shadowModelView * (worldPosition - vec4(cameraPosition, 0.0f));
		// shadowPosition = shadowProjection * shadowPosition;
		// shadowPosition /= shadowPosition.w;

		// float shadowdist = sqrt(shadowPosition.x * shadowPosition.x + shadowPosition.y * shadowPosition.y);
		// float distortFactor = (1.0f - SHADOW_MAP_BIAS) + shadowdist * SHADOW_MAP_BIAS;
		// shadowPosition.xy *= 1.0f / distortFactor;
		// shadowPosition = shadowPosition * 0.5f + 0.5f;

		// float sunlightVisibility = shadow2DLod(shadow, vec3(shadowPosition.st, shadowPosition.z), 4).x;
		// directLightFalloff *= sunlightVisibility;

		vec3 color = mix(colorAmbient, colorDirect, vec3(min(1.0f, directLightFalloff)));
			 color += colorBounced;
		     // color = colorAmbient;
		     //color = colorDirect * directLightFalloff;
			 //color *= clamp(pow(noise, 0.1f), 0.0f, 1.0f);

		color *= 1.0f;

		//color *= mix(1.0f, 0.4f, timeMidnight);

		vec4 result = vec4(color.rgb, noise);

		return result;
	}
}

void CalculateClouds (inout vec3 color, inout SurfaceStruct surface)
{
	surface.cloudAlpha = 0.0f;

	vec2 coord = texcoord.st * 2.0f;

	vec4 worldPosition = gbufferModelViewInverse * surface.screenSpacePosition;
		 worldPosition.xyz += cameraPosition.xyz;

	float cloudHeight = 180.0f;
	float cloudDepth  = 150.0f;
	float cloudDensity = 2.0f;

	float startingRayDepth = far - 5.0f;
	float rayDepth = startingRayDepth;
	
	float rayIncrement = far / CALCULATECLOUDSQUALITY;
	
		  rayDepth += R2_dither() * rayIncrement;

		int i = 0;

	vec3 cloudColor = colorSunlight;
	vec4 cloudSum = vec4(0.0f);
		 cloudSum.rgb = colorSkylight * 9.2f;
		 cloudSum.rgb = color.rgb;

	float sunglow = CalculateSunglow(surface);

	float cloudDistanceMult = 400.0f / far;

	float surfaceDistance = length(worldPosition.xyz - cameraPosition.xyz);

	while (rayDepth > 0.0f)
	{
	//determine worldspace ray position
		vec4 rayPosition = GetCloudSpacePosition(texcoord.st, rayDepth, cloudDistanceMult);

		float rayDistance = length((rayPosition.xyz - cameraPosition.xyz) / cloudDistanceMult);

		vec4 proximity =  CloudColorT(rayPosition, sunglow, surface.worldLightVector);
			 proximity.a *= cloudDensity;

		 //proximity.a *=  clamp(surfaceDistance - rayDistance, 0.0f, 1.0f);
		 if (surfaceDistance < rayDistance * cloudDistanceMult && surface.mask.sky == 0)
			proximity.a = 0.0f;

		color.rgb = mix(color.rgb, proximity.rgb, vec3(min(1.0f, proximity.a * cloudDensity)));

		surface.cloudAlpha += proximity.a;

	//Increment ray
		rayDepth -= rayIncrement;
		i++;

		if (rayDepth * cloudDistanceMult  < ((cloudHeight - (cloudDepth * 0.5)) - cameraPosition.y))
		{
			break;
		}
	}
}


void CloudPlane(SurfaceStruct surface, inout vec3 color)
{
	//Initialize view ray
	vec4 worldVector = gbufferModelViewInverse * (vec4(-GetScreenSpacePosition(texcoord.st).xyz, 0.0));

	surface.viewRay.dir = normalize(worldVector.xyz);
	surface.viewRay.origin = vec3(0.0f);

	float sunglow = CalculateSunglow(surface);



	float cloudsAltitude = 540.0f;
	float cloudsThickness = 150.0f;

	float cloudsUpperLimit = cloudsAltitude + cloudsThickness * 0.5f;
	float cloudsLowerLimit = cloudsAltitude - cloudsThickness * 0.5f;

	float density = 1.0f;

	float planeHeight = cloudsUpperLimit;
	float stepSize = 25.5f;
	planeHeight -= cloudsThickness * 0.85f;


	Plane pl;
	pl.origin = vec3(0.0f, cameraPosition.y - planeHeight, 0.0f);
	pl.normal = vec3(0.0f, 1.0f, 0.0f);

	Intersection i = RayPlaneIntersectionWorld(surface.viewRay, pl);

	vec3 original = color.rgb;

	if (i.angle < 0.0f)
	{
		if (i.distance < surface.linearDepth || surface.mask.sky > 0.5)
		{
			vec4 cloudSample = CloudColor(vec4(i.pos.xyz * 0.5f + vec3(30.0f) + vec3(1000.0, 0.0, 0.0), 1.0f), sunglow, surface.worldLightVector, cloudsAltitude, cloudsThickness, false);
			 	 cloudSample.a = min(1.0f, cloudSample.a * density);


			color.rgb = mix(color.rgb, cloudSample.rgb * 1.0f, cloudSample.a);

		}
	}
}

float CloudShadow(in SurfaceStruct surface)
{
	float cloudsAltitude = 540.0f;
	float cloudsThickness = 150.0f;

	float cloudsUpperLimit = cloudsAltitude + cloudsThickness * 0.5f;
	float cloudsLowerLimit = cloudsAltitude - cloudsThickness * 0.5f;

	float planeHeight = cloudsUpperLimit;

	planeHeight -= cloudsThickness * 0.85f;

	Plane pl;
	pl.origin = vec3(0.0f, planeHeight, 0.0f);
	pl.normal = vec3(0.0f, 1.0f, 0.0f);

	//Cloud shadow
	Ray surfaceToSun;
	vec4 sunDir = gbufferModelViewInverse * vec4(surface.lightVector, 0.0f);
	surfaceToSun.dir = normalize(sunDir.xyz);
	vec4 surfacePos = gbufferModelViewInverse * surface.screenSpacePosition;
	surfaceToSun.origin = surfacePos.xyz + cameraPosition.xyz;

	Intersection i = RayPlaneIntersection(surfaceToSun, pl);

	float cloudShadow = CloudColor2(vec4(i.pos.xyz * 0.5f + vec3(30.0f), 1.0f), 0.0f, vec3(1.0f), cloudsAltitude, cloudsThickness, true).x;
		  cloudShadow += CloudColor2(vec4(i.pos.xyz * 0.65f + vec3(10.0f) + vec3(i.pos.z * 0.5f, 0.0f, 0.0f), 1.0f), 0.0f, vec3(1.0f), cloudsAltitude, cloudsThickness, true).x;

		  cloudShadow = min(cloudShadow, 1.0f);
		  cloudShadow = 1.0f - cloudShadow;

	return cloudShadow;
	// return 1.0f;
}



void 	SnowShader(inout SurfaceStruct surface)
{
	float snowFactor = dot(surface.normal, upVector);
		  snowFactor = clamp(snowFactor - 0.1f, 0.0f, 0.05f) / 0.05f;
	surface.albedo = mix(surface.albedo.rgb, vec3(1.0f), vec3(snowFactor));
}

void 	Test(inout vec3 color, inout SurfaceStruct surface)
{
	vec4 rayScreenSpace = GetScreenSpacePosition(texcoord.st, 1.0f);
		 rayScreenSpace = -rayScreenSpace;
	     rayScreenSpace = gbufferModelViewInverse * rayScreenSpace;

	float planeAltitude = 100.0f;

	vec3 rayDir = normalize(rayScreenSpace.xyz);
	vec3 planeOrigin = vec3(0.0f, 1.0f, 0.0f);
	vec3 planeNormal = vec3(0.0f, 1.0f, 0.0f);
	vec3 rayOrigin = vec3(0.0f);

	float denom = dot(rayDir, planeNormal);

	vec3 intersectionPos = vec3(0.0f);

	if (denom > 0.0001f || denom < -0.0001f)
	{
		float planeRayDist = dot((planeOrigin - rayOrigin), planeNormal) / denom;	//How far along the ray that the ray intersected with the plane

		//if (planeRayDist > 0.0f)
		intersectionPos = rayDir * planeRayDist;
		intersectionPos = -intersectionPos;

		intersectionPos.xz *= cameraPosition.y - 100.0f;

		intersectionPos += cameraPosition.xyz;

		intersectionPos.x = mod(intersectionPos.x, 1.0f);
		intersectionPos.y = mod(intersectionPos.y, 1.0f);
		intersectionPos.z = mod(intersectionPos.z, 1.0f);
	}


	color += intersectionPos.xyz * 0.1f;
}

vec3 Contrast(in vec3 color, in float contrast)
{
	float colorLength = length(color);
	vec3 nColor = color / colorLength;

	colorLength = pow(colorLength, contrast);

	return nColor * colorLength;
}

float GetAO(in vec4 screenSpacePosition, in vec3 normal, in vec2 coord, in vec3 dither)
{
	//Determine origin position
	vec3 origin = screenSpacePosition.xyz;

	vec3 randomRotation = normalize(dither.xyz * vec3(2.0f, 2.0f, 1.0f) - vec3(1.0f, 1.0f, 0.0f));

	vec3 tangent = normalize(randomRotation - normal * dot(randomRotation, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 tbn = mat3(tangent, bitangent, normal);

	float aoRadius   = 0.15f * -screenSpacePosition.z;
		  //aoRadius   = 0.8f;
	float zThickness = 0.15f * -screenSpacePosition.z;
		  //zThickness = 2.2f;

	vec3 	samplePosition 		= vec3(0.0f);
	float 	intersect 			= 0.0f;
	vec4 	sampleScreenSpace 	= vec4(0.0f);
	float 	sampleDepth 		= 0.0f;
	float 	distanceWeight 		= 0.0f;
	float 	finalRadius 		= 0.0f;

	int numRaysPassed = 0;

	float ao = 0.0f;

	for (int i = 0; i < 4; i++)
	{
		vec3 kernel = vec3(texture(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).r * 2.0f - 1.0f,
					     texture(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).g * 2.0f - 1.0f,
					     texture(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).b * 1.0f);
			 kernel = normalize(kernel);
			 kernel *= pow(dither.x + 0.01f, 1.0f);

		samplePosition = tbn * kernel;
		samplePosition = samplePosition * aoRadius + origin;

			sampleScreenSpace = gbufferProjection * vec4(samplePosition, 0.0f);
			sampleScreenSpace.xyz /= sampleScreenSpace.w;
			sampleScreenSpace.xyz = sampleScreenSpace.xyz * 0.5f + 0.5f;

			//Check depth at sample point
			sampleDepth = GetScreenSpacePosition(sampleScreenSpace.xy).z;

			//If point is behind geometry, buildup AO
			if (sampleDepth >= samplePosition.z && sampleDepth - samplePosition.z < zThickness)
			{
				ao += 1.0f;
			} else {

			}
	}
	ao /= 4;
	ao = 1.0f - ao;
	ao = pow(ao, 2.1f);

	return ao;
}

vec4 BilateralUpsample(const in float scale, in vec2 offset, in float depth, in vec3 normal)
{
	vec2 recipres = vec2(1.0f / viewWidth, 1.0f / viewHeight);

	vec4 light = vec4(0.0f);
	float weights = 0.0f;

	for (float i = -0.5f; i <= 0.5f; i += 1.0f)
	{
		for (float j = -0.5f; j <= 0.5f; j += 1.0f)
		{
			vec2 coord = vec2(i, j) * recipres * 2.0f;

			float sampleDepth = GetDepthLinear(texcoord.st + coord * 2.0f * (exp2(scale)));
			vec3 sampleNormal = GetNormals(texcoord.st + coord * 2.0f * (exp2(scale)));
			//float weight = 1.0f / (pow(abs(sampleDepth - depth) * 1000.0f, 2.0f) + 0.001f);
			float weight = clamp(1.0f - abs(sampleDepth - depth) / 2.0f, 0.0f, 1.0f);
				  weight *= max(0.0f, dot(sampleNormal, normal) * 2.0f - 1.0f);
			//weight = 1.0f;

			light +=	pow(textureLod(colortex4, (texcoord.st) * (1.0f / exp2(scale )) + 	offset + coord, 1), vec4(2.2f, 2.2f, 2.2f, 1.0f)) * weight;

			weights += weight;
		}
	}


	light /= max(0.00001f, weights);

	if (weights < 0.01f)
	{
		light =	pow(textureLod(colortex4, (texcoord.st) * (1.0f / exp2(scale 	)) + 	offset, 2), vec4(2.2f, 2.2f, 2.2f, 1.0f));
	}


	// vec3 light =	textureLod(gcolor, (texcoord.st) * (1.0f / pow(2.0f, 	scale 	)) + 	offset, 2).rgb;


	return light;
}

vec4 Delta(vec3 albedo, vec3 normal, float skylight)
{
	float depth = GetDepthLinear(texcoord.st);

	vec4 delta = BilateralUpsample(GI_RENDER_RESOLUTION, vec2(0.0f, 0.0f), 		depth, normal);

	delta.rgb = delta.rgb * albedo * colorSunlight;

	delta.rgb *= 1.0f;

	delta.rgb *= 3.0f * delta.a * (1.0 - rainStrength) * pow(skylight, 0.05);

	// delta.rgb *= sin(frameTimeCounter) > 0.6 ? 0.0 : 1.0;

	return delta;
}

vec4 textureSmooth(in sampler2D tex, in vec2 coord)
{
	vec2 res = vec2(64.0f, 64.0f);

	coord *= res;
	coord += 0.5f;

	vec2 whole = floor(coord);
	vec2 part  = fract(coord);

	part.x = part.x * part.x * (3.0f - 2.0f * part.x);
	part.y = part.y * part.y * (3.0f - 2.0f * part.y);
	// part.x = 1.0f - (cos(part.x * 3.1415f) * 0.5f + 0.5f);
	// part.y = 1.0f - (cos(part.y * 3.1415f) * 0.5f + 0.5f);

	coord = whole + part;

	coord -= 0.5f;
	coord /= res;

	return texture(tex, coord);
}

float AlmostIdentity(in float x, in float m, in float n)
{
	if (x > m) return x;

	float a = 2.0f * n - m;
	float b = 2.0f * m - 3.0f * n;
	float t = x / m;

	return (a * t + b) * t * t + n;
}


float GetWaves(vec3 position) {
	float speed = 0.9f * WATER_SPEED;

  vec2 p = position.xz / 20.0f;

  p.xy -= position.y / 20.0f;

  p.x = -p.x;

  p.x += (frameTimeCounter / 40.0f) * speed;
  p.y -= (frameTimeCounter / 40.0f) * speed;

  float weight = 1.0f;
  float weights = weight;

  float allwaves = 0.0f;

  float wave = 0.0;
	//wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.2f))  + vec2(0.0f,  p.x * 2.1f) ).x;
	p /= 2.1f; 	/*p *= pow(2.0f, 1.0f);*/ 	p.y -= (frameTimeCounter / 20.0f) * speed; p.x -= (frameTimeCounter / 30.0f) * speed;
  //allwaves += wave;

  weight = 4.1f;
  weights += weight;
      wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.4f))  + vec2(0.0f,  -p.x * 2.1f) ).x;
			p /= 1.5f;/*p *= pow(2.0f, 2.0f);*/ 	p.x += (frameTimeCounter / 20.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 17.25f;
  weights += weight;
      wave = (textureSmooth(noisetex, (p * vec2(1.0f, 0.75f))  + vec2(0.0f,  p.x * 1.1f) ).x);		p /= 1.5f; 	p.x -= (frameTimeCounter / 55.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 15.25f;
  weights += weight;
      wave = (textureSmooth(noisetex, (p * vec2(1.0f, 0.75f))  + vec2(0.0f,  -p.x * 1.7f) ).x);		p /= 1.9f; 	p.x += (frameTimeCounter / 155.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 29.25f;
  weights += weight;
      wave = abs(textureSmooth(noisetex, (p * vec2(1.0f, 0.8f))  + vec2(0.0f,  -p.x * 1.7f) ).x * 2.0f - 1.0f);		p /= 2.0f; 	p.x += (frameTimeCounter / 155.0f) * speed;
      wave = 1.0f - AlmostIdentity(wave, 0.2f, 0.1f);
      wave *= weight;
  allwaves += wave;

  weight = 15.25f;
  weights += weight;
      wave = abs(textureSmooth(noisetex, (p * vec2(1.0f, 0.8f))  + vec2(0.0f,  p.x * 1.7f) ).x * 2.0f - 1.0f);
      wave = 1.0f - AlmostIdentity(wave, 0.2f, 0.1f);
      wave *= weight;
  allwaves += wave;

  allwaves /= weights;

  return allwaves;
}


vec3 GetWavesNormal(vec3 position) {

	vec2 coord = position.xz / 50.0;
	coord.xy -= position.y / 50.0;
	coord -= floor(coord);

	vec3 normal;
	normal.xy = textureLod(colortex6, coord, 1).xy * 2.0 - 1.0;
	normal.z = sqrt(1.0 - dot(normal.xy, normal.xy));

	return normal;

/*
	float WAVE_HEIGHT = 1.5;

	const float sampleDistance = 3.0f;

	position -= vec3(0.005f, 0.0f, 0.005f) * sampleDistance;

	float wavesCenter = GetWaves(position);
	float wavesLeft = GetWaves(position + vec3(0.01f * sampleDistance, 0.0f, 0.0f));
	float wavesUp   = GetWaves(position + vec3(0.0f, 0.0f, 0.01f * sampleDistance));

	vec3 wavesNormal;
		 wavesNormal.r = wavesCenter - wavesLeft;
		 wavesNormal.g = wavesCenter - wavesUp;

		 wavesNormal.r *= 30.0f * WAVE_HEIGHT / sampleDistance;
		 wavesNormal.g *= 30.0f * WAVE_HEIGHT / sampleDistance;

		//  wavesNormal.b = sqrt(1.0f - wavesNormal.r * wavesNormal.r - wavesNormal.g * wavesNormal.g);
		 wavesNormal.b = 1.0;
		 wavesNormal.rgb = normalize(wavesNormal.rgb);



	return wavesNormal.rgb;
	*/
}


vec3 FakeRefract(vec3 vector, vec3 normal, float ior)
{
	return refract(vector, normal, ior);
	//return vector + normal * 0.5;
}


float CalculateWaterCaustics(SurfaceStruct surface, ShadingStruct shading)
{
	//if (shading.direct <= 0.0)
	//{
	//	return 0.0;
	//}
	if (isEyeInWater == 1)
	{
		if (surface.mask.water > 0.5)
		{
			return 1.0;
		}
	}
	vec4 worldPos = gbufferModelViewInverse * surface.screenSpacePosition;
	worldPos.xyz += cameraPosition.xyz;

	vec2 dither = CalculateNoisePattern1(vec2(0.0), 2.0).xy;
	float waterPlaneHeight = 63.0;

	vec4 wlv = gbufferModelViewInverse * vec4(lightVector.xyz, 1.0);
	vec3 worldLightVector = -normalize(wlv.xyz);
	// worldLightVector = normalize(vec3(-1.0, 1.0, 0.0));

	float pointToWaterVerticalLength = min(abs(worldPos.y - waterPlaneHeight), 2.0);
	vec3 flatRefractVector = FakeRefract(worldLightVector, vec3(0.0, 1.0, 0.0), 1.0 / 1.3333);
	float pointToWaterLength = pointToWaterVerticalLength / -flatRefractVector.y;
	vec3 lookupCenter = worldPos.xyz - flatRefractVector * pointToWaterLength;


	const float distanceThreshold = 0.15;

	const int numSamples = 1;
	int c = 0;

	float caustics = 0.0;

	for (int i = -numSamples; i <= numSamples; i++)
	{
		for (int j = -numSamples; j <= numSamples; j++)
		{
			vec2 offset = vec2(i + dither.x, j + dither.y) * 0.2;
			vec3 lookupPoint = lookupCenter + vec3(offset.x, 0.0, offset.y);
			// vec3 wavesNormal = normalize(GetWavesNormal(lookupPoint).xzy + vec3(0.0, 1.0, 0.0) * 100.0);
			vec3 wavesNormal = GetWavesNormal(lookupPoint).xzy;
			vec3 refractVector = FakeRefract(worldLightVector.xyz, wavesNormal.xyz, 1.0 / 1.3333);
			float rayLength = pointToWaterVerticalLength / refractVector.y;
			vec3 collisionPoint = lookupPoint - refractVector * rayLength;

			float dist = distance(collisionPoint, worldPos.xyz);

			caustics += 1.0 - saturate(dist / distanceThreshold);

			c++;
		}
	}

	caustics /= c;

	caustics /= distanceThreshold;


	return pow(caustics, 2.0) * 3.0;
}

void WaterFog(inout vec3 color, in SurfaceStruct surface, in MCLightmapStruct mcLightmap)
{
	// return;
	if (surface.mask.water > 0.5 || isEyeInWater > 0)
	{
		float depth = texture(depthtex1, texcoord.st).x;
		float depthSolid = texture(gdepthtex, texcoord.st).x;

		vec4 viewSpacePosition = GetScreenSpacePosition(texcoord.st, depth);
		vec4 viewSpacePositionSolid = GetScreenSpacePosition(texcoord.st, depthSolid);

		vec3 viewVector = normalize(viewSpacePosition.xyz);


		float waterDepth = distance(viewSpacePosition.xyz, viewSpacePositionSolid.xyz);
		if (isEyeInWater > 0)
		{
			waterDepth = length(viewSpacePosition.xyz) * 0.5;		
			if (surface.mask.water > 0.5)
			{
				waterDepth = length(viewSpacePositionSolid.xyz) * 0.5;		
			}	
		}


		float fogDensity = 0.20;
		float visibility = 1.0f / (pow(exp(waterDepth * fogDensity), 1.0f));
		float visibility2 = 1.0f / (pow(exp(waterDepth * fogDensity), 1.0f));

		vec3 waterNormal = normalize(GetWaterNormals(texcoord.st));

		// vec3 waterFogColor = vec3(1.0, 1.0, 0.1);	//murky water
		// vec3 waterFogColor = vec3(0.2, 0.95, 0.0) * 1.0; //green water
		// vec3 waterFogColor = vec3(0.4, 0.95, 0.05) * 2.0; //green water
		// vec3 waterFogColor = vec3(0.7, 0.95, 0.00) * 0.75; //green water
		// vec3 waterFogColor = vec3(0.2, 0.95, 0.4) * 5.0; //green water
		// vec3 waterFogColor = vec3(0.2, 0.95, 1.0) * 1.0; //clear water
		vec3 waterFogColor = vec3(WATER_COLOR_F_R, WATER_COLOR_F_G, WATER_COLOR_F_B) * WATER_COLOR_F_A; //clear water
			  waterFogColor *= 0.01 * dot(vec3(0.33333), colorSunlight);
			  waterFogColor *= (1.0 - rainStrength * 0.95);
			  waterFogColor *= isEyeInWater * 2.0 + 1.0;

		if (isEyeInWater == 0)
		{
			waterFogColor *= mcLightmap.sky;
		}
		else
		{
			waterFogColor *= pow(eyeBrightnessSmooth.y / 240.0f, 6.0f);
		}

		// float scatter = CalculateSunglow(surface);

		vec3 viewVectorRefracted = refract(viewVector, waterNormal, 1.0 / 1.3333);
		float scatter = 1.0 / (pow(saturate(dot(-lightVector, viewVectorRefracted) * 0.5 + 0.5) * 20.0, 2.0) + 0.1);
		//vec3 reflectedLightVector = reflect(lightVector, upVector);
			  //scatter += (1.0 / (pow(saturate(dot(-reflectedLightVector, viewVectorRefracted) * 0.5 + 0.5) * 30.0, 2.0) + 0.1)) * saturate(1.0 - dot(lightVector, upVector) * 1.4);

		// scatter += pow(saturate(dot(-lightVector, viewVectorRefracted) * 0.5 + 0.5), 3.0) * 0.02;
		if (isEyeInWater < 1)
		{
			waterFogColor = mix(waterFogColor, colorSunlight * 21.0 * waterFogColor, vec3(scatter * (1.0 - rainStrength)));
		}

		// color *= pow(vec3(0.7, 0.88, 1.0) * 0.99, vec3(waterDepth * 0.45 + 0.2));
		// color *= pow(vec3(0.7, 0.88, 1.0) * 0.99, vec3(waterDepth * 0.45 + 1.0));
		color *= pow(vec3(0.4, 0.72, 1.0) * 0.99, vec3(waterDepth * 0.25 + 0.25));
		// color *= pow(vec3(0.7, 1.0, 0.2) * 0.8, vec3(waterDepth * 0.15 + 0.1));
		color = mix(waterFogColor, color, saturate(visibility));



	}
}

void IceFog(inout vec3 color, in SurfaceStruct surface, in MCLightmapStruct mcLightmap)
{
	// return;
	if (surface.mask.ice > 0.5)
	{
		float depth = texture(depthtex1, texcoord.st).x;
		float depthSolid = texture(gdepthtex, texcoord.st).x;

		vec4 viewSpacePosition = GetScreenSpacePosition(texcoord.st, depth);
		vec4 viewSpacePositionSolid = GetScreenSpacePosition(texcoord.st, depthSolid);

		vec3 viewVector = normalize(viewSpacePosition.xyz);


		float waterDepth = distance(viewSpacePosition.xyz, viewSpacePositionSolid.xyz);


		float fogDensity = 0.41;
		float visibility = 1.0f / (pow(exp(waterDepth * fogDensity), 1.0f));
		float visibility2 = 1.0f / (pow(exp(waterDepth * fogDensity), 1.0f));

		vec3 waterNormal = normalize(GetWaterNormals(texcoord.st));

		// vec3 waterFogColor = vec3(1.0, 1.0, 0.1);	//murky water
		// vec3 waterFogColor = vec3(0.2, 0.95, 0.0) * 1.0; //green water
		// vec3 waterFogColor = vec3(0.4, 0.95, 0.05) * 2.0; //green water
		// vec3 waterFogColor = vec3(0.7, 0.95, 0.00) * 0.75; //green water
		// vec3 waterFogColor = vec3(0.2, 0.95, 0.4) * 5.0; //green water
		// vec3 waterFogColor = vec3(0.2, 0.95, 1.0) * 1.0; //clear water
		vec3 waterFogColor = vec3(IceColorR, IceColorG, IceColorB) * IceColorA * 2.0; //clear water
			  waterFogColor *= 0.01 * dot(vec3(0.3216, 0.4824, 1.0), colorSunlight);
			  waterFogColor *= (1.0 - rainStrength * 0.95);


			waterFogColor *= mcLightmap.sky;


		// float scatter = CalculateSunglow(surface);

		vec3 viewVectorRefracted = refract(viewVector, waterNormal, 1.0 / 1.3333);
		float scatter = 1.0 / (pow(saturate(dot(-lightVector, viewVectorRefracted) * 0.5 + 0.5) * 10.0, 2.0) + 0.1);
		//vec3 reflectedLightVector = reflect(lightVector, upVector);
			  //scatter += (1.0 / (pow(saturate(dot(-reflectedLightVector, viewVectorRefracted) * 0.5 + 0.5) * 30.0, 2.0) + 0.1)) * saturate(1.0 - dot(lightVector, upVector) * 1.4);

		// scatter += pow(saturate(dot(-lightVector, viewVectorRefracted) * 0.5 + 0.5), 3.0) * 0.02;
			waterFogColor = mix(waterFogColor, colorSunlight * 21.0 * waterFogColor, vec3(scatter * (1.0 - rainStrength)));

		// color *= pow(vec3(0.7, 0.88, 1.0) * 0.99, vec3(waterDepth * 0.45 + 0.2));
		// color *= pow(vec3(0.7, 0.88, 1.0) * 0.99, vec3(waterDepth * 0.45 + 1.0));
		color *= pow(vec3(0.4, 0.72, 1.0) * 0.99, vec3(waterDepth * 0.25 + 0.25));
		// color *= pow(vec3(0.7, 1.0, 0.2) * 0.8, vec3(waterDepth * 0.15 + 0.1));
		color = mix(waterFogColor, color, saturate(visibility));



	}
}

vec3 NewSkyLight(float p, in SurfaceStruct surface){
	float a = -1.;
	float b = -0.24;
	float c = 6.0;
	float d = -0.8;
	float e = 0.45;
	
	vec3 sunVec = normalize(sunPosition);
	vec3 moonVec = normalize(-sunPosition);
	vec3 upVec = normalize(upPosition);

	vec3 sVector = surface.screenSpacePosition.xyz;
		 sVector = normalize(sVector);
	
	float cosT = dot(sVector, upVec); 
	float absCosT = max(cosT, 0.0);
	float cosS = dot(sunVec, upVec);		
	float cosY = dot(sunVec, sVector);
	float Y = acos(cosY);

	float SdotU = dot(sunVec, upVec);
	float MdotU = dot(moonVec, upVec);
	float sunVisibility = pow(clamp(SdotU+0.1, 0.0, 0.1) / 0.1, 2.0);	
	
	float L = (1 + -(exp(b / (absCosT + 0.01)))) * (1 + c * exp(d * Y) + e * cosY * cosY); 
		  //L = pow(L, 1.0 - rainStrength * 0.8)*(1.0 - rainStrength * 0.83);  
		  
	vec3 lightColor	= vec3(0.0);
		 //lightColor += vec3(1.0, 0.6, 0.0) * 3.0 * timeSunrise;
		 lightColor += vec3(5.5, 2.1, 0.0) * 1.5 * timeSunriseSunset;
		 
		 lightColor += vec3(0.0, 1.1, 5.0) * timeMidnight;
		 
		 lightColor *= 1-rainStrength;
		 
		 lightColor = pow(lightColor, vec3(2.2));
		 lightColor *= 1.0 - exp(-0.005 * pow(L, 4.0) * (1.0 - rainStrength * 0.985));	
		 lightColor *= p;
		 //lightColor = min(lightColor, vec3(p / 10.0));
		 lightColor *= sunVisibility;
		 
	return lightColor;
}

void CalStar(in SurfaceStruct surface, inout vec3 finalComposite) {

	vec4 worldPos = surface.worldSpacePosition;
    //vec4 worldPos = gbufferModelViewInverse * surface.screenSpacePosition;

	float cosT2 = pow(0.89, distance(vec2(0.0), worldPos.xz) / 100.0); // Curved plane.
	vec2 starsCoord = worldPos.xz / worldPos.y / 20.0 * (1.0 + cosT2 * cosT2 * 3.5) + vec2(frameTimeCounter / 800.0 / 16 * 2);


	float stars = max(texture(noisetex, starsCoord * 16).x - 0.94, 0.0) * 2.0;


	float position = abs(worldPos.y + cameraPosition.y - 65);
	float horizonPos= max(exp(1.0 - position / 50.0), 0.0);
		stars = mix(stars * timeMidnight, 0.0, horizonPos);

	finalComposite.rgb = mix(finalComposite.rgb , vec3(0.8,1.2,1.2) * 0.02 - 0.02 * rainStrength, stars * float(surface.mask.sky));

}
void Rainbow(inout vec3 color){
	vec4 fragposition  = gbufferProjectionInverse * (vec4(texcoord.st, texture(depthtex1, texcoord.st).x, 1.0) * 2.0 - 1.0);
	fragposition /= fragposition.w;
	vec3 sunPosNorm = normalize(sunPosition);
	float sunDot = dot(sunPosNorm, normalize(fragposition.xyz)) * 0.5 + 0.5;
	float RAINBOW_DIAMETER = 8.0f;
	float RAINBOW_THICKNESS = 5.5f;
	float RAINBOW_DISTANCE = 155.0f;
	if(length(fragposition.xyz) > RAINBOW_DISTANCE && (worldTime > 0 && worldTime < 12500) && sunPosition.z > 0.0)
	{
		float rainbowStrength = (wetness - rainStrength) * 0.15;
		float rainbowHue = (sunDot - 0.05 * RAINBOW_DIAMETER) * -50.0 / RAINBOW_THICKNESS;
		if (rainbowStrength > 0.01 && rainbowHue > 0.0 && rainbowHue < 1.0) {
			rainbowHue *= 7.0;
			color.r += clamp(1.5 - abs(rainbowHue - 1.5), 0.0, 1.0) * rainbowStrength;
			color.g += clamp(2.0 - abs(rainbowHue - 3.0), 0.0, 1.0) * rainbowStrength;
			color.b += clamp(1.5 - abs(rainbowHue - 4.5), 0.0, 1.0) * rainbowStrength;
			}
		}
}


#include "/libs/Auroras.glsl"

//#define Enabled_God_Rays
	#define God_Rays_Phase 5.0				//[1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0]
	#define God_Rays_Custom_Color			//TODO
	#define God_Rays_Stained_Glass_Tint		//TODO
#define Enabled_Volumetric_Fog
	#define Fog_SunLight_Strength 0.9		//[0.2 0.3 0.4 0.5 0.6 0.7 0.75 0.8 0.85 0.9 0.95 0.99]
	#define Noon_Density 0.0				//[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0]
	#define Sunrise_Sunset_Density 1.0		//[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0]
	#define Night_Density 0.0				//[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0]
	#define Fog_Coverage 0.2				//[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.5 0.6 0.7 0.8 0.9]
	#define Fog_Top 98						//[0 1 2 3 4 4.1 4.2 4.3 4.4 4.5 4.6 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
	#define Fog_Bottom 60					//[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]

uniform vec3 shadowLightVector;
uniform vec3 P;

float rescale(float vmin, float vmax, float v){
	return clamp((v - vmin) / (vmax - vmin), 0.0, 1.0);
}

#if defined(Enabled_God_Rays) || defined(Enabled_Volumetric_Fog)
vec4 CalculateNearVolumetric(inout SurfaceStruct surface){
	vec4 volumetric = vec4(0.0);

	float dither = R2_dither();

	float skyLightMap = clamp(texture(colortex1, texcoord.xy).b * 1.07 - 0.07, 0.0, 1.0);

	#ifdef Disabled_SkyLight_Occlusion
	skyLightMap = 1.0;
	#endif

	int steps = 16;
	float invsteps = 1.0 / float(steps);

	float end = 128.0;
	float start = 1.0;
	float stepLength = (end - start) * invsteps;

	vec4 rayOrigin = surface.worldSpacePosition;
	float viewLength = length(rayOrigin.xyz);
	vec3 rayDirection = normalize(rayOrigin.xyz);

	float mu = dot(shadowLightVector, rayDirection);
	float raysPhase = HG(mu, 1.0 - exp(-God_Rays_Phase));

	float frontPhase = HG(mu, 0.9);
	float backPhase = 0.33;
	float phase = (frontPhase + backPhase) * HG(0.9999, Fog_SunLight_Strength);

	vec3 b = vec3(0.001);

	float t = frameTimeCounter * 0.1;

	float thickness = float(Fog_Top) - float(Fog_Bottom);

	vec4 rayPosition = vec4(rayDirection * start, rayOrigin.w);
	vec3 rayStep = rayDirection * stepLength;

	rayPosition.xyz += rayStep * dither;

	float depth = 0.0;
	float lastDepth = 0.0;

	float fogDensity = timeNoon * Noon_Density + timeSunriseSunset * Sunrise_Sunset_Density + timeMidnight * Night_Density;
	b *= fogDensity;

	vec3 godrays = vec3(0.0);
	vec3 fog = vec3(0.0);

	for(int i = 0; i < steps; i++){
		float rayLength = length(rayPosition.xyz);
		if(bool(step(viewLength, rayLength))) break;

		vec4 shadowCoord = shadowProjection *  shadowModelView * rayPosition; shadowCoord /= shadowCoord.w;
		float distortion = 0.95 / mix(1.0 - SHADOW_MAP_BIAS, 1.0, length(shadowCoord.xy));
		shadowCoord.xy = shadowCoord.xy * distortion; shadowCoord.z = mix(shadowCoord.z, 0.5, 0.8);
		shadowCoord.xyz = shadowCoord.xyz * 0.5 + 0.5;
		shadowCoord.z -= 1.0 / float(shadowMapResolution);

		float visibility = shadow2DLod(shadow, shadowCoord.xyz, 0).x;

		#ifdef Enabled_God_Rays
		godrays += visibility;
		#endif

		#ifdef Enabled_Volumetric_Fog
		float density = 1.0;

		vec3 coord0 = rayPosition.xyz + P;

		vec3 coord1 = coord0 * 0.1; 				coord1.x += t;
		
		density = Get3DNoise(coord1); 				coord1.x += t;
		density += Get3DNoise(coord1 * 2.0) * 0.5; 	coord1.x += t;
		density += Get3DNoise(coord1 * 4.0) * 0.25;
		density /= 1.75;

		density = rescale(Fog_Coverage, 1.0, density) * clamp(1.0 - distance(coord0.y, float(Fog_Bottom) + thickness * 0.5) / thickness * 2.0, 0.0, 1.0);

		vec3 fogColor = visibility * colorSunlight * phase + colorSkylight;

		fogColor = fogColor + vec3(Fog_Color_R/255,Fog_Color_G/255,Fog_Color_B/255) * vec3(Fog_luminance);

		vec3 extin = exp(-b * depth);

		volumetric.rgb += fogColor * density * b * stepLength * extin;

		depth += density * stepLength;
		#endif

		rayPosition.xyz += rayStep;
	}

	volumetric.rgb += colorSunlight * vec3(godrays * raysPhase * stepLength);

	float underground = max(float(eyeBrightness.y) / 240.0, skyLightMap);
	volumetric.rgb *= underground;
	depth *= underground;

	volumetric.a = exp(-length(b) * depth);
	volumetric.rgb *= 1.0 / 3.14159265;

	return volumetric;
}
#endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	//Initialize surface properties required for lighting calculation for any surface that is not part of the sky
	surface.albedo 				= GetAlbedoLinear(texcoord.st);					//Gets the albedo texture
	surface.albedo 				= pow(surface.albedo, vec3(1.0f));

	// surface.albedo = Contrast(surface.albedo, 1.1f);

	//surface.albedo = normalize(surface.albedo) * (pow(length(surface.albedo), 1.2f));

	surface.mask.matIDs 		= GetMaterialIDs(texcoord.st);					//Gets material ids
	CalculateMasks(surface.mask);

	//surface.albedo 				= vec3(0.8f);
	surface.normal 				= GetNormals(texcoord.st);						//Gets the screen-space normals
	surface.depth  				= GetDepth(texcoord.st);						//Gets the scene depth
	surface.screenSpacePosition = GetScreenSpacePosition(texcoord.st); 			//Gets the screen-space position

	if(surface.mask.particles > 0.5) {
		surface.depth 	= texture(gdepthtex, texcoord.xy).x;
		surface.screenSpacePosition = GetScreenSpacePosition(texcoord.xy, texture(gdepthtex, texcoord.xy).x);

		#ifdef Particles_Normals
		surface.normal 	= -normalize(gbufferProjectionInverse[3].xyz);
		#else
		surface.normal	= vec3(1.0);
		#endif
	}

	surface.linearDepth 		= ExpToLinearDepth(surface.depth); 				//Get linear scene depth
	surface.worldSpacePosition  = gbufferModelViewInverse * surface.screenSpacePosition;
	surface.viewVector 			= normalize(surface.screenSpacePosition.rgb);	//Gets the view vector
	surface.lightVector 		= lightVector;									//Gets the sunlight vector
	//vec4 wlv 					= gbufferModelViewInverse * vec4(surface.lightVector, 1.0f);
	vec4 wlv 					= shadowModelViewInverse * vec4(0.0f, 0.0f, 1.0f, 0.0f);
	surface.worldLightVector 	= normalize(wlv.xyz);
	surface.upVector 			= upVector;										//Store the up vector

	if (surface.mask.water > 0.5)
	{
		surface.albedo *= 1.9;
		//surface.albedo = mix(surface.albedo, vec3(0.5, 0.9, 0.1) * 0.15, vec3(0.5));
		//surface.albedo = mix(surface.albedo, vec3(0.5, 0.9, 0.1) * 0.15, vec3(saturate(dot(surface.normal, upVector) * 0.5 + 0.5)));
	}

	surface.albedo *= 1.0f - (surface.mask.sky); 						//Remove the sky from surface albedo, because sky will be handled separately

	//surface.water.albedo = surface.albedo * float(surface.mask.water);		//Store underwater albedo
	//surface.albedo *= 1.0f - float(surface.mask.water);						//Remove water from surface albedo to handle water separately



	//Initialize sky surface properties
	surface.sky.albedo 		= GetAlbedoLinear(texcoord.st) * (min(1.0f, (surface.mask.sky) + (surface.mask.sunspot)));							//Gets the albedo texture for the sky

	surface.sky.tintColor   = vec3(1.0f);
	//surface.sky.tintColor 	= mix(colorSunlight, vec3(colorSunlight.r), vec3(0.8f));									//Initializes the defualt tint color for the sky
	//surface.sky.tintColor 	*= mix(1.0f, 500.0f, timeSkyDark); 													//Boost sky color at night																		//Scale sunglow back to be less intense

	surface.sky.sunSpot   	= vec3(float(CalculateSunspot(surface))) * vec3((min(1.0f, (surface.mask.sky) + (surface.mask.sunspot)))) * colorSunlight;
	surface.sky.sunSpot 	*= 1.0f - timeMidnight;
	surface.sky.sunSpot   	*= 1.0f;
	surface.sky.sunSpot 	*= 1.0f - rainStrength;
	//surface.sky.sunSpot     *= 1.0f - timeMidnight;

	AddSkyGradient(surface);
	AddSunglow(surface);



	//Initialize MCLightmap values
	mcLightmap.torch 		= GetLightmapTorch(texcoord.st);	//Gets the lightmap for light coming from emissive blocks


	mcLightmap.sky   		= GetLightmapSky(texcoord.st);		//Gets the lightmap for light coming from the sky

	// mcLightmap.sky 		= 1.0f / pow((1.0f - mcLightmap.sky + 0.00001f), 2.0f);
	// mcLightmap.sky 		-= 1.0f;
	// mcLightmap.sky 		= max(0.0f, mcLightmap.sky);

	mcLightmap.lightning    = 0.0f;								//gets the lightmap for light coming from lightning
	if (surface.mask.water > 0.5 || surface.mask.ice > 0.5)
	{
		mcLightmap.sky 		= GetTransparentLightmapSky(texcoord.st);
	}

	//Initialize default surface shading attributes
	surface.diffuse.roughness 			= 0.0f;					//Default surface roughness
	surface.diffuse.translucency 		= 0.0f;					//Default surface translucency
	surface.diffuse.translucencyColor 	= vec3(1.0f);			//Default translucency color

	surface.specular.specularity 		= GetSpecularity(texcoord.st);	//Gets the reflectance/specularity of the surface
	surface.specular.extraSpecularity 	= 0.0f;							//Default value for extra specularity
	surface.specular.glossiness 		= GetGlossiness(texcoord.st);
	surface.specular.metallic 			= 0.0f;							//Default value of how metallic the surface is
	surface.specular.gain 				= 1.0f;							//Default surface specular gain
	surface.specular.base 				= 0.0f;							//Default reflectance when the surface normal and viewing normal are aligned
	surface.specular.fresnelPower 		= 5.0f;							//Default surface fresnel power




	//Calculate surface shading
	CalculateNdotL(surface);
	shading.direct  			= CalculateDirectLighting(surface);				//Calculate direct sunlight without visibility check (shadows)
	shading.sunlightVisibility 	= CalculateSunlightVisibility(surface, shading);					//Calculate shadows and apply them to direct lighting
	shading.direct 				*= mix(1.0f, 0.0f, rainStrength);
	float caustics = 1.0;
	#ifdef WATER_CAUSTICS
	if (surface.mask.water > 0.5 || isEyeInWater > 0)
		caustics = CalculateWaterCaustics(surface, shading);
	#endif
	shading.direct *= caustics;
	shading.waterDirect 		= shading.direct;
	shading.direct 				*= pow(mcLightmap.sky, 0.1f);
	// shading.bounced 	= CalculateBouncedSunlight(surface);			//Calculate fake bounced sunlight
	shading.scattered 	= CalculateScatteredSunlight(surface);			//Calculate fake scattered sunlight
	shading.skylight 	= CalculateSkylight(surface);					//Calculate scattered light from sky
	shading.skylight 	*= pow(caustics, 0.5) * 0.4 + 0.6;
	// shading.scatteredUp = CalculateScatteredUpLight(surface);
	shading.heldLight 	= CalculateHeldLightShading(surface);
	shading.heldLight 	*= pow(caustics, 0.5) * 0.4 + 0.6;


	InitializeAO(surface);
	//if (texcoord.s < 0.5f && texcoord.t < 0.5f)
	//CalculateAO(surface);

	float ao = 1.0;

	vec4 delta = vec4(0.0);
	delta.a = 1.0;

	#ifndef BASIC_AMBIENT
		if (isEyeInWater < 1 && surface.mask.particles < 0.5)
		{
			delta = Delta(surface.albedo.rgb, surface.normal.xyz, mcLightmap.sky);
		}

		ao = delta.a;
	#endif

	//Colorize surface shading and store in lightmaps
	lightmap.sunlight 			= vec3(shading.direct) * colorSunlight;
	lightmap.sunlight 			*= shading.sunlightVisibility;
	lightmap.sunlight 			*= GetParallaxShadow(texcoord.st);
	AddCloudGlow(lightmap.sunlight, surface);
	//lightmap.sunlight 			*= 2.0f - AO;

	lightmap.skylight 			= vec3(mcLightmap.sky);
	lightmap.skylight 			*= mix(colorSkylight, colorBouncedSunlight, vec3(max(0.2f, (1.0f - pow(mcLightmap.sky + 0.13f, 1.0f) * 1.0f)))) + colorBouncedSunlight * (mix(0.3f, 2.8f, 0.0)) * (1.0f - rainStrength);
	//lightmap.skylight 			*= mix(colorSkylight, colorBouncedSunlight, vec3(0.2f));
	lightmap.skylight 			*= shading.skylight;
	lightmap.skylight 			*= mix(1.0f, 5.0f, (surface.mask.clouds));
	lightmap.skylight 			*= mix(1.0f, 50.0f, (surface.mask.clouds) * timeSkyDark);
	// lightmap.skylight 			+= vec3(0.5, 0.8, 1.0) * surface.mask.water * mcLightmap.sky * dot(vec3(0.3333), colorSunlight * colorSunlight) * 1.0;	//water ambient
	lightmap.skylight 			*= surface.ao.skylight;
	//lightmap.skylight 			*= surface.ao.constant * 0.5f + 0.5f;
	lightmap.skylight 			+= mix(colorSkylight, colorSunlight, vec3(0.2f)) * vec3(mcLightmap.sky) * surface.ao.constant * 0.05f;
	lightmap.skylight 			*= mix(1.0f, 0.4f, rainStrength);
	lightmap.skylight 			*= ao;



	lightmap.scatteredSunlight  = vec3(shading.scattered) * colorSunlight * (1.0f - rainStrength);
	lightmap.scatteredSunlight 	*= pow(vec3(mcLightmap.sky), vec3(1.0f));
	lightmap.scatteredSunlight 	*= ao;

	lightmap.underwater 		= vec3(mcLightmap.sky) * colorSkylight;

	lightmap.torchlight 		= mcLightmap.torch * colorTorchlight;
	lightmap.torchlight 		*= ao;
	lightmap.torchlight 		*= pow(caustics, 0.5) * 0.4 + 0.6;

	lightmap.nolight 			= vec3(0.05f);
	lightmap.nolight 			*= surface.ao.constant;
	lightmap.nolight 			*= ao;

	// lightmap.scatteredUpLight 	= vec3(shading.scatteredUp) * mix(colorSunlight, colorSkylight, vec3(0.3f));
	// lightmap.scatteredUpLight   *= pow(mcLightmap.sky, 0.5f);
	// lightmap.scatteredUpLight 	*= surface.ao.scatteredUpLight;
	// lightmap.scatteredUpLight 	*= mix(1.0f, 0.1f, rainStrength);
	// lightmap.scatteredUpLight 	*= ao;
	//lightmap.scatteredUpLight   *= surface.ao.constant * 0.5f + 0.5f;

	lightmap.heldLight 			= vec3(shading.heldLight);
	lightmap.heldLight 			*= colorTorchlight;
	lightmap.heldLight 			*= ao;
	lightmap.heldLight 			*= heldBlockLightValue / 16.0f;




	//If eye is in water
	if (isEyeInWater > 0) {
		vec3 halfColor = mix(colorWaterMurk, vec3(1.0f), vec3(0.5f));
		lightmap.sunlight *= mcLightmap.sky * halfColor;
		lightmap.skylight *= halfColor;
		lightmap.bouncedSunlight *= 0.0f;
		lightmap.scatteredSunlight *= halfColor;
		lightmap.nolight *= halfColor;
		lightmap.scatteredUpLight *= halfColor;
	}

	surface.albedo.rgb = mix(surface.albedo.rgb, pow(surface.albedo.rgb, vec3(2.0f)), vec3((surface.mask.fire)));


	//Apply lightmaps to albedo and generate final shaded surface
	final.nolight 			= surface.albedo * lightmap.nolight;
	final.sunlight 			= surface.albedo * lightmap.sunlight;
	final.skylight 			= surface.albedo * lightmap.skylight;
	final.bouncedSunlight 	= surface.albedo * lightmap.bouncedSunlight;
	final.scatteredSunlight = surface.albedo * lightmap.scatteredSunlight;
	final.scatteredUpLight  = surface.albedo * lightmap.scatteredUpLight;
	final.torchlight 		= surface.albedo * lightmap.torchlight;
	final.underwater        = surface.water.albedo * colorWaterBlue;
	// final.underwater 		*= GetUnderwaterLightmapSky(texcoord.st);
	// final.underwater  		+= vec3(0.9f, 1.00f, 0.35f) * float(surface.mask.water) * 0.065f;
	 final.underwater 		*= (lightmap.sunlight * 0.3f) + (lightmap.skylight * 0.06f) + (lightmap.torchlight * 0.0165) + (lightmap.nolight * 0.002f);


	//final.glow.torch 				= pow(surface.albedo, vec3(4.0f)) * float(surface.mask.torch);
	final.glow.lava 				= Glowmap(surface.albedo, surface.mask.lava,      4.0f, vec3(1.0f, 0.05f, 0.001f));

	final.glow.glowstone 			= Glowmap(surface.albedo, surface.mask.glowstone, 2.0f, colorTorchlight*0.1);
	//final.glow.glowstone 		   *= (sin(frameTimeCounter * 3.1415f / 3.0f) * 0.5f + 0.5f) * 3.0f + 1.0f;
	final.torchlight 			   *= 1.0f - (surface.mask.glowstone);

	final.glow.fire 				= surface.albedo * (surface.mask.fire);
	final.glow.fire 				= pow(final.glow.fire, vec3(1.0f));

	//final.glow.torch 				= Glowmap(surface.albedo, surface.mask.torch, 	 16.0f, vec3(1.0f, 0.07f, 0.001f));

	//final.glow.torch 				= surface.albedo * float(surface.mask.torch);
	//final.glow.torch 				*= pow(vec3(CalculateLuminance(final.glow.torch)), vec3(6.0f));
	//final.glow.torch 				= pow(final.glow.torch, vec3(1.4f));


	final.glow.torch 				= pow(surface.albedo * (surface.mask.torch), vec3(4.4f));



	//Remove glow items from torchlight to keep control
	final.torchlight *= 1.0f - (surface.mask.lava);

	final.heldLight = lightmap.heldLight * surface.albedo;


	//Do night eye effect on outdoor lighting and sky
	DoNightEye(final.sunlight);
	DoNightEye(final.skylight);
	DoNightEye(final.bouncedSunlight);
	DoNightEye(final.scatteredSunlight);
	DoNightEye(surface.sky.albedo);
	DoNightEye(final.underwater);
	DoNightEye(delta.rgb);

	DoNightEye(final.nolight);



	surface.cloudShadow = 1.0f;
	const float sunlightMult = 0.21f;

	//Apply lightmaps to albedo and generate final shaded surface
	vec3 finalComposite;
		 finalComposite += final.sunlight 			* 0.9f 	* 1.5f * sunlightMult;				//Add direct sunlight
		 finalComposite += final.skylight 			* 0.03f;				//Add ambient skylight
		 finalComposite += final.nolight 			* 0.0006f; 			//Add base ambient light
		 finalComposite += final.nolight 			* 0.0006f; 			//Add base ambient light
		 finalComposite += final.scatteredSunlight 	* 0.02f		* (1.0f - sunlightMult);					//Add fake scattered sunlight					
		 finalComposite += final.torchlight 			* 2.0f 		* TORCHLIGHT_BRIGHTNESS;	//Add light coming from emissive blocks
		 finalComposite += final.glow.lava			* 1.6f 		* TORCHLIGHT_BRIGHTNESS;
		 finalComposite += final.glow.glowstone		* 1.1f 		* TORCHLIGHT_BRIGHTNESS;
		 finalComposite += final.glow.fire			* 0.025f 	* TORCHLIGHT_BRIGHTNESS;
		 finalComposite += final.glow.torch			* 0.15f 	* TORCHLIGHT_BRIGHTNESS;
		 finalComposite += final.heldLight 			* 0.05f 	* TORCHLIGHT_BRIGHTNESS;
						

	delta.rgb *= mix(vec3(1.0), vec3(0.1, 0.3, 1.0) * 1.0, surface.mask.water);

	//Apply sky to final composite
	surface.sky.albedo *= 6.0f;
	#ifdef NEW_SKY_LIGHT
		 vec3 sL = NewSkyLight(0.045, surface) * float(surface.mask.sky);
		 surface.sky.albedo = surface.sky.albedo * surface.sky.tintColor + surface.sky.sunglow + surface.sky.sunSpot + sL;
	#else
		 surface.sky.albedo = surface.sky.albedo * surface.sky.tintColor + surface.sky.sunglow + surface.sky.sunSpot;
	#endif
		 //DoNightEye(surface.sky.albedo);
		 finalComposite 	+= surface.sky.albedo;		//Add sky to final image
		 finalComposite 	+= delta.rgb * sunlightMult * 1.4;

	//if eye is in water, do underwater fog
	if (isEyeInWater > 0) {
		finalComposite *= 9.0;
		//CalculateUnderwaterFog(surface, finalComposite);
	}

	#ifdef STAR
		if (rainStrength < 0.99) {
			CalStar(surface,finalComposite);
		}
	#endif

	#ifdef AURORA
	NightAurora(finalComposite.rgb, surface.screenSpacePosition.xyz);
	#endif

	#ifdef High_Altitude_Clouds
	CloudPlane(surface, finalComposite);
	#endif
	
	#ifdef VOLUMETRIC_CLOUDS
		CalculateClouds(finalComposite, surface);
	#endif

	WaterFog(finalComposite, surface, mcLightmap);
	IceFog(finalComposite, surface, mcLightmap);



	#ifdef ATMOSPHERIC_SCATTERING
	CalculateAtmosphericScattering(finalComposite.rgb, surface);
	#endif
	#ifdef RAINBOW
	Rainbow(finalComposite);
	#endif

	
	if (surface.mask.stainedGlass > 0.5)
	{
		finalComposite *= 1.5;
	}

	vec4 volumetric = vec4(vec3(0.0), 1.0);

	#if defined(Enabled_God_Rays) || defined(Enabled_Volumetric_Fog)
	volumetric = CalculateNearVolumetric(surface);
	finalComposite.rgb *= volumetric.a;
	finalComposite.rgb += volumetric.rgb;
	#endif

	#ifdef RAINBOW
	Rainbow(finalComposite);
	#endif

	if(surface.mask.particles > 0.5) {
	//	finalComposite = vec3(1.0, 0.0, 0.0);
	}

	finalComposite *= 0.001f;												//Scale image down for HDR
	finalComposite.b *= 1.0f;

	//finalComposite.rgb += crepuscularRays.rgb * 0.0022;

	 finalComposite = pow(finalComposite, vec3(1.0f / 2.2f)); 					//Convert final image into gamma 0.45 space to compensate for gamma 2.2 on displays
	 finalComposite = pow(finalComposite, vec3(1.0f / BANDING_FIX_FACTOR)); 	//Convert final image into banding fix space to help reduce color banding


	if (finalComposite.r > 1.0f) {
		finalComposite.r = 1.0f;
	}

	if (finalComposite.g > 1.0f) {
		finalComposite.g = 1.0f;
	}

	if (finalComposite.b > 1.0f) {
		finalComposite.b = 1.0f;
	}

	//finalComposite *= ao;


	finalComposite += CalculateNoisePattern1(vec2(0.0), 64.0) * (1.0 / 65535.0);

	
	gl_FragData[0] = vec4(finalComposite, texture(colortex0, texcoord.st).a);
	gl_FragData[1] = vec4(surface.mask.matIDs, 1.0, mcLightmap.sky, 1.0f);
	gl_FragData[2] = vec4(surface.specular.specularity, surface.cloudAlpha, surface.specular.glossiness, texture(colortex3, texcoord.st).b);
	gl_FragData[3] = vec4(shading.sunlightVisibility, texture(colortex5, texcoord.st).a);
	// gl_FragData[4] = vec4(pow(surface.albedo.rgb, vec3(1.0f / 2.2f)), 1.0f);
	// gl_FragData[5] = vec4(surface.normal.rgb * 0.5f + 0.5f, 1.0f);

}

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

#define Hardbaked_HDR 0.001

/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------Shadow&Lightning---------------//
//Only enable one of these.
//#define ENABLE_SOFT_SHADOWS		// Simple soft shadows
#define VARIABLE_PENUMBRA_SHADOWS	// Contact-hardening (area) shadows
#define COLORED_SHADOWS // Tinted shadows from stained glass
//#define PIXEL_SHADOWS // Pixel-locked shadows 

#define TORCHLIGHT_BRIGHTNESS 0.5 // How bright is light from torches, fire, etc. [0.25 0.5 0.75 1.0 1.5 2.0]

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

#define RAYLEIGH_AMOUNT 1.0 // Strength of atmospheric scattering (atmospheric density). [0.5 1.0 1.5 2.0]

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

const int 		noiseTextureResolution  = 64;

//END OF INTERNAL VARIABLES//

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
uniform sampler2D depthtex1;
uniform sampler2D depthtex0;

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
	return pow(texture(colortex5, coord).rgb, vec3(2.2f));
}

vec3  	GetAlbedoGamma(in vec2 coord) {			//Function that retrieves the diffuse texture and leaves it in gamma space.
	return texture(colortex5, coord).rgb;
}

vec3  	GetWaterNormals(in vec2 coord) {				//Function that retrieves the screen space surface normals. Used for lighting calculations
	return mat3(gbufferModelView) * normalize(texture(colortex6, coord.st).rgb * 2.0f - 1.0f);
}


vec3  	GetNormals(in vec2 coord) {				//Function that retrieves the screen space surface normals. Used for lighting calculations
	return normalize(texture(colortex2, coord.st).rgb * 2.0f - 1.0f);
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
	return GetMaterialIDs(coord);
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
	matID = (matID * 255.0f);

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

		float transparentID = mask.matIDs;

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

	vec4 fragPosition = gbufferProjectionInverse * vec4(vec3(texcoord.xy, texture(depthtex0, texcoord.xy).x) * 2.0 - 1.0, 1.0);
		 fragPosition /= fragPosition.w;

	if (true) {
		float distance = length(fragPosition);

		vec4 ssp = fragPosition;

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
	if(bool(step(0.5, surface.mask.sky))) return;

	vec4 fragposition  = gbufferProjectionInverse * (vec4(texcoord.st, texture(depthtex0, texcoord.st).x, 1.0) * 2.0 - 1.0);
	fragposition /= fragposition.w;

	float mu = dot(normalize(fragposition.xyz), shadowLightVectorView);
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
	float fogFactor = 1.0 - exp(-pow(length(fragposition.xyz), 2.0) * 0.000001);
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

float pcurve(float x, float a, float b)
{
	float k = pow(a+b, a+b) / (pow(a,a)*pow(b,b));
	return k * pow(x, a) * pow(1.0 - x, b);
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
		color *= 1.5;
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

		vec3 waterNormal = surface.normal;

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	//Initialize surface properties required for lighting calculation for any surface that is not part of the sky
	surface.albedo 				= GetAlbedoLinear(texcoord.st);					//Gets the albedo texture
	surface.albedo 				= pow(surface.albedo, vec3(1.0f));

	surface.normal 				= GetNormals(texcoord.st);						//Gets the screen-space normals
	surface.depth  				= GetDepth(texcoord.st);						//Gets the scene depth
	surface.linearDepth 		= ExpToLinearDepth(surface.depth); 				//Get linear scene depth
	surface.screenSpacePosition = GetScreenSpacePosition(texcoord.st); 			//Gets the screen-space position
	surface.worldSpacePosition  = gbufferModelViewInverse * surface.screenSpacePosition;
	surface.viewVector 			= normalize(surface.screenSpacePosition.rgb);	//Gets the view vector
	surface.lightVector 		= lightVector;									//Gets the sunlight vector
	//vec4 wlv 					= gbufferModelViewInverse * vec4(surface.lightVector, 1.0f);
	vec4 wlv 					= shadowModelViewInverse * vec4(0.0f, 0.0f, 1.0f, 0.0f);
	surface.worldLightVector 	= normalize(wlv.xyz);
	surface.upVector 			= upVector;										//Store the up vector

	vec3 eyeDirection = -normalize(surface.screenSpacePosition.xyz);

	surface.mask.matIDs 		= GetMaterialIDs(texcoord.st);					//Gets material ids
	CalculateMasks(surface.mask);

	//Initialize MCLightmap values
	mcLightmap.torch 		= GetLightmapTorch(texcoord.st);	//Gets the lightmap for light coming from emissive blocks
	mcLightmap.sky   		= GetLightmapSky(texcoord.st);		//Gets the lightmap for light coming from the sky

	// mcLightmap.sky 		= 1.0f / pow((1.0f - mcLightmap.sky + 0.00001f), 2.0f);
	// mcLightmap.sky 		-= 1.0f;
	// mcLightmap.sky 		= max(0.0f, mcLightmap.sky);

	mcLightmap.lightning    = 0.0f;								//gets the lightmap for light coming from lightning
	if (surface.mask.water > 0.5 || surface.mask.ice > 0.5)
	{
	//	mcLightmap.sky 		= GetTransparentLightmapSky(texcoord.st);
	}

	shading.sunlightVisibility 	= CalculateSunlightVisibility(surface, shading);					//Calculate shadows and apply them to direct lighting
	vec3 deferredShadowMap = texture(colortex4, texcoord.xy).rgb;

	vec3 finalComposite = pow(texture(colortex0, texcoord.xy).rgb, vec3(2.2)) / Hardbaked_HDR;

	#ifdef WATER_CAUSTICS
	if(surface.mask.water > 0.9) {
		float caustics = CalculateWaterCaustics(surface, shading);
		finalComposite *= mix(vec3(1.0), vec3(caustics), deferredShadowMap);
	}
	#endif

	WaterFog(finalComposite, surface, mcLightmap);
	IceFog(finalComposite, surface, mcLightmap);

	if(texture(colortex0, texcoord.xy).a <= 0.2 && surface.mask.sky < 0.9) {
		vec3 sun = surface.albedo * colorSunlight * shading.sunlightVisibility;
		vec3 sky = surface.albedo * mcLightmap.sky * colorSkylight * 0.06;
		vec3 torch = surface.albedo * mcLightmap.torch * 100.0 * colorTorchlight * TORCHLIGHT_BRIGHTNESS;

		float sigma_s = 1.0;

		if(surface.mask.ice > 0.9) {
			sigma_s = 0.05;
		}else if(surface.mask.water > 0.9){
			sigma_s = 0.0;
		}else if(surface.mask.stainedGlass > 0.9) {
			sigma_s = 0.0;
		}

		finalComposite = mix(finalComposite, sun + sky + torch, vec3(sigma_s));
	}

	#ifdef ATMOSPHERIC_SCATTERING
		if(texture(colortex0, texcoord.xy).a <= 0.2 || surface.mask.ice > 0.9 || surface.mask.water > 0.9) {
			CalculateAtmosphericScattering(finalComposite.rgb, surface);
		}
	#endif

	finalComposite *= Hardbaked_HDR;												//Scale image down for HDR
	finalComposite = pow(finalComposite, vec3(1.0 / 2.2));

	gl_FragData[0] = vec4(finalComposite, texture(colortex0, texcoord.st).a);
	gl_FragData[1] = vec4(shading.sunlightVisibility, 1.0);
}
/* DRAWBUFFERS:04 */
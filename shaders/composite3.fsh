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

#define Hardbaked_HDR 0.001

//----------------Shadow&Lightning---------------//

#define SHADOW_MAP_BIAS 0.90

#define NEW_SKY_LIGHT
//#define Disabled_SkyLight_Occlusion

//---------------Atmosphere&Sky---------------//

//Clouds
//#define SMOOTH_CLOUDS // Smooth out dither pattern from volumetric clouds. Not necessary if HQ Volumetric Clouds is enabled.

//#define VOLUMETRIC_CLOUDS // Volumetric clouds
	#define CALCULATECLOUDDEPTH 280           // [100 200 300 400 500 600 700 900 1100 1400 1700 62018]
	#define CALCULATECLOUDSDENSITY 200        // [100 125 150 175 200 225 250 275 300 325 350]
	#define CALCULATECLOUDSCONCENTRATION 2.5  // [0.5 1.0 1.5 2.0 2.5 3.0 4.0 5.0 7.0 9.0]
	#define CALCULATECLOUDSQUALITY 35         // [5 10 20 35 50 70 100]
	#define CALCLOUD_SPEED 1				  // [0 0.2 0.5 1 2.5 5 8]
	#define CALCLOUDHEIGHT 275				  // [100 150 200 225 250 275 300 325 350 400 450 500 600 700 800]
	#define WHITECLOUDS 1.5                     // [0.01 1 1.5 4 6 9]
	#define High_Altitude_Clouds
	//#define MOREVOLUMETRIC_CLOUDS

//Rays
#define CREPUSCULAR_RAYS // Light rays from sunlight
	#define RAYS_SAMPLES 16.0  // Ray samples. [8.0 16.0 24.0 32.0 48.0 64.0 72.0 100.0 120.0]
	#define VL_STRENGTH 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.55 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 5.0 6.0 7.0 8.0 9.0 10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0 500.0 1000.0]	#define VL_NOON_R 1.0   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]  
	#define VL_NOON_R 1.0   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]  
	#define VL_NOON_G 0.9   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]
	#define VL_NOON_B 0.78   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.78 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]
	#define VL_NOON_L 1.0   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.78 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]

	#define VL_SUNRISESET_R 1.55    //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]
	#define VL_SUNRISESET_G 0.93    //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.93 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]
	#define VL_SUNRISESET_B 0.0155  //[0.0 0.1 0.15 0.0155 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]
	#define VL_SUNRISESET_L 1.0  //[0.0 0.1 0.15 0.0155 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]

	#define VL_NIGHT_R 1.2   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]
	#define VL_NIGHT_G 2.0   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]
	#define VL_NIGHT_B 2.5   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]
	#define VL_NIGHT_L 1.0   //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]

//Fog (form JMSEUS FCM)
/*------This is VOLUMETRIC FOG from jmeseus, not VOLUMETRIC CLOUDS, but me -the Author- is too lazy to change it's name of #define :P ------*/
#define TRUE_VOLUMETRIC_CLOUDS2  //Now it becomes VOLUMETRIC FOG, it was changed from True Volumetric clouds from Continuum
	//#define SOFT_FLUFFY_CLOUDS2						// dissable to fully remove dither Pattern ripple, adds a little pixel noise on cloud edge
	#define Volumetric_Cloud_Type2					//Turn this off to change the way Volumetric clouds are rendered,If off there will be less detail in the clouds BUT there will be less Dither Pattern ripple in them. Best set Vol_Cloud_Coverage to 0.52 if off!
	#define Cloud3Height2 60						    //[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 80 90 100 120 140 160 180 210 200 220 240 250 300 350 400 500] //Sets the Volumetric clouds3 Height
	#define Cloud3Depth2 100                            //[50 75 100 125 150 175 200 225 250 275 300 350 400]
	#define VOLUMETRIC_CLOUD_SPEED2 1.0				    //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0] //Default is 2.0f, Lower number to slow speed, Higher number to increase speed 
	#define CLOUD_DISPERSE2 64          			// [1 2 3 4 5 7 10 12 15 17 20 25 30 64]increase this for thicker clouds and so that they don't fizzle away when you fly close to them, 10 is default Dont Go Over 30 will lag and maybe crash
	#define CLOUD_PRECISION2 2.0 //[0.5 1.0 2.0 4.0 6.0 8.0 10.0 12.0 16.0 32.0]
	#define Vol_Cloud_Coverage2 0.45   			    // Vol_Cloud_Coverage. 0.20 = Lowest Cover. 0.60 = Highest Cover [0.20 0.30 0.35 0.40 0.42 0.45 0.48 0.50 0.52 0.55 0.60 0.70 0.80 0.90 1.00]
	#define VOLUMETRIC_CLOUD_LIGHTING2 0.5          //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.2 2.5 3.0]

	#define VFCWWT //Dynamic fog amount, which means that the strength of VOLUMETRIC FOG would be change with The worldTime
	#define VFDensityStrength 1.2 //strength of VOLUMETRIC FOG [0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 3.5 4.0 5.0 7.0 10.0 15.0 20.0]

	#define FOGDENS_SUNRISE 1.5   //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.2 2.5 3.0 3.5 4.0 5.0 10.0]
	#define FOGDENS_NOON 1.0      //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.2 2.5 3.0 3.5 4.0 5.0 10.0]
	#define FOGDENS_MIDNIGHT 0.7  //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.2 2.5 3.0 3.5 4.0 5.0 10.0]

	#define CUSTOM_VLFC_R 256 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256]
	#define CUSTOM_VLFC_G 256 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256]
	#define CUSTOM_VLFC_B 256 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256]

//Aurora
#define AURORA		//Night aurora.
	#define NIGHT_AURORA_R 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define NIGHT_AURORA_G 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define NIGHT_AURORA_B 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define NIGHT_AURORA_L 1.0 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
	#define AURORA_COLOR blueAurora //[blueAurora purpleAurora greenAurora]
	#define AURORA_STRENGTH 0.7 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.7 2.0 2.5 3.0 4.0 5.0 7.0 10.0 15.0 20.0 30.0 50.0 70.0 100.0]
	#define aurora_power 0.3 //[0.0 0.001 0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
	#define aurora_speed 3.0 //[0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0]
	#define aurora_flash 50.0 //[0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0 18.0 19.0 20.0 21.0 22.0 23.0 24.0 25.0 26.0 27.0 28.0 29.0 30.0 31.0 32.0 33.0 34.0 35.0 36.0 37.0 38.0 39.0 40.0 41.0 42.0 43.0 44.0 45.0 46.0 47.0 48.0 49.0 50.0 51.0 52.0 53.0 54.0 55.0 56.0 57.0 58.0 59.0 60.0 61.0 62.0 63.0 64.0 65.0 66.0 67.0 68.0 69.0 70.0 71.0 72.0 73.0 74.0 75.0 76.0 77.0 78.0 79.0 80.0 81.0 82.0 83.0 84.0 85.0 86.0 87.0 88.0 89.0 90.0 91.0 92.0 93.0 94.0 95.0 96.0 97.0 98.0 99.0 100.0]
	//#define AURORA_PRESET_COL //Preset color of aurora

#define STAR

//---------------Water---------------//

//#define WATER_SPEED_LIGHT_BAR_LINKER

#define WATER_SPEED 1.0    //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.1 2.32.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define WATER_COLOR_F_R 0.15 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
#define WATER_COLOR_F_G 0.6375 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.6375 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
#define WATER_COLOR_F_B 0.75 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 

//---------------Others---------------//

//---------------Water---------------//

//---------------END---------------//
//---------------END---------------//






/* DRAWBUFFERS:2 */
const int 		shadowMapResolution 	= 2048;	// Shadowmap resolution [1024 2048 4096]
const float 	shadowDistance 			= 120.0; // Shadow distance. Set lower if you prefer nicer close shadows. Set higher if you prefer nicer distant shadows. [80.0 120.0 180.0 240.0]

const int 		noiseTextureResolution  = 64;

const bool colortex0MipmapEnabled = true;
const bool colortex1MipmapEnabled = true;
const bool colortex3MipmapEnabled = false;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D gdepthtex;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2DShadow shadow;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D noisetex;
uniform sampler2D colortex5;
uniform sampler2D colortex6;

uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
uniform float wetness;
uniform float aspectRatio;
uniform float frameTimeCounter;
uniform int worldTime;
uniform int   isEyeInWater;
uniform vec3 upPosition;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 gbufferModelView;

uniform vec3 sunPosition;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform vec3 fogColor;

in vec4 texcoord;

in vec3 lightVector;
in vec3 upVector;
uniform ivec2 eyeBrightnessSmooth;

in float timeSunriseSunset;
in float timeNoon;
in float timeMidnight;
in float timeSkyDark;
uniform float screenBrightness;

in vec3 colorSunlight;
in vec3 colorSkylight;
in vec3 colorBouncedSunlight;




#define ANIMATION_SPEED 1.0f


#define FRAME_TIME frameTimeCounter * ANIMATION_SPEED
#define Vol_Cloud_Coverage 0.18				// Vol_Cloud_Coverage. 0.20 = Lowest Cover. 0.60 = Highest Cover [0.20 0.30 0.45 0.48 0.50 0.52 0.55 0.60 0.70]


/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float saturate(float x)
{
	return clamp(x, 0.0, 1.0);
}

vec3 GetNormals(in vec2 coord) {
	vec3 normal = vec3(0.0f);
		 normal = textureLod(colortex2, coord.st, 0).rgb;
	normal = normal * 2.0f - 1.0f;

	normal = normalize(normal);

	return normal;
}

float GetDepth(in vec2 coord) {
	return texture(gdepthtex, coord).x;
}

float 	ExpToLinearDepth(in float depth)
{
	return 2.0f * near * far / (far + near - (2.0f * depth - 1.0f) * (far - near));
}

float GetDepthLinear(vec2 coord) {
    return 2.0 * near * far / (far + near - (2.0 * texture(gdepthtex, coord).x - 1.0) * (far - near));
}

vec4 	GetTransparentAlbedo(in vec2 coord)
{
	vec3 transparency = vec3(0.0);
	transparency.r = texture(colortex3, coord).a;
	transparency.g = texture(colortex0, coord).a;
	transparency.b = texture(colortex5, coord).a;
	return pow(vec4(transparency, 1.0), vec4(2.2));
}

vec4  	GetViewSpacePosition(in vec2 coord) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
	float depth = GetDepth(coord);
		  //depth += float(GetMaterialMask(coord, 5)) * 0.38f;
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;

	return fragposition;
}

float 	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return textureLod(colortex1, coord, 0).r;
}

float 	GetTransparentID(in vec2 coord)
{
	return texture(colortex6, coord).a;
}

vec3 GetSunlightVisibility(in vec2 coord)
{
	return texture(colortex5, coord).rgb;
}

float cubicPulse(float c, float w, float x)
{
	x = abs(x - c);
	if (x > w) return 0.0f;
	x /= w;
	return 1.0f - x * x * (3.0f - 2.0f * x);
}

bool 	GetMaterialMask(in vec2 coord, in int ID, in float matID) {
		  matID = floor(matID * 255.0f);

	if (matID == ID) {
		return true;
	} else {
		return false;
	}
}

bool 	GetSkyMask(in vec2 coord, in float matID)
{
	matID = floor(matID * 255.0f);

	if (matID < 1.0f || matID > 254.0f)
	{
		return true;
	} else {
		return false;
	}
}

bool 	GetSkyMask(in vec2 coord)
{
	float matID = GetMaterialIDs(coord);
	matID = floor(matID * 255.0f);

	if (matID < 1.0f || matID > 254.0f)
	{
		return true;
	} else {
		return false;
	}
}

float 	GetSpecularity(in vec2 coord)
{
	return texture(colortex3, coord).r;
}

float 	GetRoughness(in vec2 coord)
{
	return pow(texture(colortex3, coord).b, 1.5);
}



bool  	GetWaterMask(in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = floor(matID * 255.0f);

	if (matID >= 35.0f && matID <= 51) {
		return true;
	} else {
		return false;
	}
}

bool  	GetStainedGlassMask(in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = floor(matID * 255.0f);

	if (matID >= 55.0f && matID <= 70.0f) {
		return true;
	} else {
		return false;
	}
}

bool  	GetIceMask(in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = floor(matID * 255.0f);

	if (matID == 4) {
		return true;
	} else {
		return false;
	}
}

bool  	GetWaterMask(in vec2 coord) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	float matID = floor(GetMaterialIDs(coord) * 255.0f);

	if (matID >= 35.0f && matID <= 51) {
		return true;
	} else {
		return false;
	}
}

float 	GetLightmapSky(in vec2 coord) {
#ifdef Disabled_SkyLight_Occlusion
	return 1.0;
#else
	return textureLod(colortex1, texcoord.st, 0).b;
#endif
}

vec3 convertScreenSpaceToWorldSpace(vec2 co) {
    vec4 fragposition = gbufferProjectionInverse * vec4(vec3(co, textureLod(gdepthtex, co, 0).x) * 2.0 - 1.0, 1.0);
    fragposition /= fragposition.w;
    return fragposition.xyz;
}

vec3 convertCameraSpaceToScreenSpace(vec3 cameraSpace) {
    vec4 clipSpace = gbufferProjection * vec4(cameraSpace, 1.0);
    vec3 NDCSpace = clipSpace.xyz / clipSpace.w;
    vec3 screenSpace = 0.5 * NDCSpace + 0.5;
		 screenSpace.z = 0.1f;
    return screenSpace;
}

float  	CalculateDitherPattern1() {
	int[16] ditherPattern = int[16] (0 , 9 , 3 , 11,
								 	 13, 5 , 15, 7 ,
								 	 4 , 12, 2,  10,
								 	 16, 8 , 14, 6 );

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 4.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 4.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 4];

	return float(dither) / 17.0f;
}

float  	CalculateDitherPattern2() {
	int[16] ditherPattern = int[16] (4 , 12, 2,  10,
								 	 16, 8 , 14, 6 ,
								 	 0 , 9 , 3 , 11,
								 	 13, 5 , 15, 7 );

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 4.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 4.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 4];

	return float(dither) / 17.0f;
}

vec3 	CalculateNoisePattern1(vec2 offset, float size) {
	vec2 coord = texcoord.st;

	coord *= vec2(viewWidth, viewHeight);
	coord = mod(coord + offset, vec2(size));
	coord /= 64.0f;

	return texture(noisetex, coord).xyz;
}

float noise (in float offset)
{
	vec2 coord = texcoord.st + vec2(offset);
	float noise = clamp(fract(sin(dot(coord ,vec2(12.9898f,78.233f))) * 43758.5453f),0.0f,1.0f)*2.0f-1.0f;
	return noise;
}

float noise (in vec2 coord, in float offset)
{
	coord += vec2(offset);
	float noise = clamp(fract(sin(dot(coord ,vec2(12.9898f,78.233f))) * 43758.5453f),0.0f,1.0f)*2.0f-1.0f;
	return noise;
}

void 	DoNightEye(inout vec3 color) {			//Desaturates any color input at night, simulating the rods in the human eye

	float amount = 0.8f; 						//How much will the new desaturated and tinted image be mixed with the original image
	vec3 rodColor = vec3(0.2f, 0.5f, 1.0f); 	//Cyan color that humans percieve when viewing extremely low light levels via rod cells in the eye
	float colorDesat = dot(color, vec3(1.0f)); 	//Desaturated color

	color = mix(color, vec3(colorDesat) * rodColor, timeMidnight * amount);
	//color.rgb = color.rgb;
}


float Get3DNoise(in vec3 pos)
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

	// uv -= 0.5f;
	// uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / 64.0f;
	vec2 coord2 = (uv2 + 0.5f) / 64.0f;
	float xy1 = texture(noisetex, coord).x;
	float xy2 = texture(noisetex, coord2).x;
	return mix(xy1, xy2, f.z);
	//return texture(noisetex, pos.xz / 64.0f).x;
}

float Get3DNoiseBillow(in vec3 pos)
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

	// uv -= 0.5f;
	// uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / 64.0f;
	vec2 coord2 = (uv2 + 0.5f) / 64.0f;
	float xy1 = texture(noisetex, coord).x;
	float xy2 = texture(noisetex, coord2).x;
	//return mix(xy1, xy2, f.z);
	return abs(mix(xy1, xy2, f.z) * 2.0 - 1.0);
	//return texture(noisetex, pos.xz / 64.0f).x;
}

float Get3DNoiseRidges(in vec3 pos)
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

	// uv -= 0.5f;
	// uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / 64.0f;
	vec2 coord2 = (uv2 + 0.5f) / 64.0f;
	float xy1 = texture(noisetex, coord).x;
	float xy2 = texture(noisetex, coord2).x;
	//return mix(xy1, xy2, f.z);
	return 1.0 - abs(mix(xy1, xy2, f.z) * 2.0 - 1.0);
	//return texture(noisetex, pos.xz / 64.0f).x;
}

/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct MaskStruct {

	float matIDs;

	bool sky;
	bool land;
	bool tallGrass;
	bool leaves;
	bool ice;
	bool hand;
	bool translucent;
	bool glow;
	bool goldBlock;
	bool ironBlock;
	bool diamondBlock;
	bool emeraldBlock;
	bool sand;
	bool sandstone;
	bool stone;
	bool cobblestone;
	bool wool;

	bool torch;
	bool lava;
	bool glowstone;
	bool fire;

	bool water;
	bool stainedGlass;

};

struct Ray {
	vec3 dir;
	vec3 origin;
};

struct Plane {
	vec3 normal;
	vec3 origin;
};

struct SurfaceStruct {
	MaskStruct 		mask;			//Material ID Masks

	//Properties that are required for lighting calculation
		vec3 	color;					//Diffuse texture aka "color texture"
		vec3 	normal;					//Screen-space surface normals
		float 	depth;					//Scene depth
		float 	linearDepth;			//Scene depth

		float 	rDepth;
		float  	specularity;
		vec3 	specularColor;
		float 	roughness;
		float   fresnelPower;
		float 	baseSpecularity;
		Ray 	viewRay;
		float skylight;


		vec4 	viewSpacePosition;
		vec4 	worldSpacePosition;
		vec3 	worldLightVector;
		vec3  	upVector;
		vec3 	lightVector;

		vec3 	sunlightVisibility;

		vec4 	reflection;

		float 	cloudAlpha;
} surface;

struct Intersection {
	vec3 pos;
	float distance;
	float angle;
};



/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void 	CalculateMasks(inout MaskStruct mask) {
	mask.sky 			= GetSkyMask(texcoord.st, mask.matIDs);
	mask.land	 		= !mask.sky;
	mask.tallGrass 		= GetMaterialMask(texcoord.st, 2, mask.matIDs);
	mask.leaves	 		= GetMaterialMask(texcoord.st, 3, mask.matIDs);
	mask.hand	 		= GetMaterialMask(texcoord.st, 5, mask.matIDs);
	mask.translucent	= GetMaterialMask(texcoord.st, 6, mask.matIDs);

	mask.glow	 		= GetMaterialMask(texcoord.st, 10, mask.matIDs);

	mask.goldBlock 		= GetMaterialMask(texcoord.st, 20, mask.matIDs);
	mask.ironBlock 		= GetMaterialMask(texcoord.st, 21, mask.matIDs);
	mask.diamondBlock	= GetMaterialMask(texcoord.st, 22, mask.matIDs);
	mask.emeraldBlock	= GetMaterialMask(texcoord.st, 23, mask.matIDs);
	mask.sand	 		= GetMaterialMask(texcoord.st, 24, mask.matIDs);
	mask.sandstone 		= GetMaterialMask(texcoord.st, 25, mask.matIDs);
	mask.stone	 		= GetMaterialMask(texcoord.st, 26, mask.matIDs);
	mask.cobblestone	= GetMaterialMask(texcoord.st, 27, mask.matIDs);
	mask.wool			= GetMaterialMask(texcoord.st, 28, mask.matIDs);

	mask.torch 			= GetMaterialMask(texcoord.st, 30, mask.matIDs);
	mask.lava 			= GetMaterialMask(texcoord.st, 31, mask.matIDs);
	mask.glowstone 		= GetMaterialMask(texcoord.st, 32, mask.matIDs);
	mask.fire 			= GetMaterialMask(texcoord.st, 33, mask.matIDs);

	float transparentID = GetTransparentID(texcoord.st);

	mask.water 			= GetWaterMask(transparentID);
	mask.stainedGlass 	= GetStainedGlassMask(transparentID);
	mask.ice 			= GetIceMask(transparentID);
}

vec4 	ComputeRaytraceReflection(inout SurfaceStruct surface)
{
	float reflectionRange = 2.0f;
    float initialStepAmount = 1.0 - clamp(0.1f / 100.0, 0.0, 0.99);
		  initialStepAmount *= 1.0f;


    vec2 screenSpacePosition2D = texcoord.st;
    vec3 cameraSpacePosition = convertScreenSpaceToWorldSpace(screenSpacePosition2D);

    vec3 cameraSpaceNormal = surface.normal;
    	 //cameraSpaceNormal += ditherNormal * 0.65f * surface.roughness;

    vec3 cameraSpaceViewDir = normalize(cameraSpacePosition);
    vec3 cameraSpaceVector = initialStepAmount * normalize(reflect(cameraSpaceViewDir,cameraSpaceNormal));
    vec3 cameraSpaceVectorFar = far * normalize(reflect(cameraSpaceViewDir,cameraSpaceNormal));
	vec3 oldPosition = cameraSpacePosition;
    vec3 cameraSpaceVectorPosition = oldPosition + cameraSpaceVector;
    vec3 currentPosition = convertCameraSpaceToScreenSpace(cameraSpaceVectorPosition);
    vec4 color = vec4(pow(texture(colortex0, screenSpacePosition2D).rgb, vec3(3.0f + 1.2f)), 0.0);
    const int maxRefinements = 3;
	int numRefinements = 0;
    int count = 0;
	vec2 finalSamplePos = vec2(0.0f);

	int numSteps = 0;

    for (int i = 0; i < 40; i++)
    {
        if(currentPosition.x < 0 || currentPosition.x > 1 ||
           currentPosition.y < 0 || currentPosition.y > 1 ||
           currentPosition.z < 0 || currentPosition.z > 1 ||
           /*-cameraSpaceVectorPosition.z > far * 1.4f ||*/
           -cameraSpaceVectorPosition.z < 0.0f)
        {
		   break;
		}

        vec2 samplePos = currentPosition.xy;
        float sampleDepth = convertScreenSpaceToWorldSpace(samplePos).z;

        float currentDepth = cameraSpaceVectorPosition.z;
        float diff = sampleDepth - currentDepth;
        float error = length(cameraSpaceVector / pow(2.0f, numRefinements));

        //If a collision was detected, refine raymarch
        if(diff >= 0 && diff <= error * 2.00f && numRefinements <= maxRefinements)
        {
        	//Step back
        	cameraSpaceVectorPosition -= cameraSpaceVector / pow(2.0f, numRefinements);
        	++numRefinements;
		//If refinements run out
		}
		else if (diff >= 0 && diff <= error * 4.0f && numRefinements > maxRefinements)
		{
			finalSamplePos = samplePos;
			break;
		}



        cameraSpaceVectorPosition += cameraSpaceVector / pow(2.0f, numRefinements);

        if (numSteps > 1)
        cameraSpaceVector *= 1.375f;	//Each step gets bigger

		currentPosition = convertCameraSpaceToScreenSpace(cameraSpaceVectorPosition);
        count++;
        numSteps++;
    }

	color = pow(vec4(textureLod(colortex0, finalSamplePos, 0).rgb, 1.0), vec4(2.2f));
	color.rgb /= Hardbaked_HDR;

	if (finalSamplePos.x == 0.0f || finalSamplePos.y == 0.0f) {
		color.a = 0.0f;
	}

    return color;
}

float 	CalculateLuminance(in vec3 color) {
	return (color.r * 0.2126f + color.g * 0.7152f + color.b * 0.0722f);
}

float   CalculateSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

float   CalculateReflectedSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	surface.lightVector = reflect(surface.lightVector, surface.normal);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

float   CalculateAntiSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	vec3 halfVector2 = normalize(surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

float   CalculateSunspot(in SurfaceStruct surface) {

	float curve = 1.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);

	float sunProximity = abs(1.0f - dot(halfVector2, npos));

	//surface.roughness = 0.5f;

	float sizeFactor = 0.959f - surface.roughness * 0.7f;

	float sunSpot = (clamp(sunProximity, sizeFactor, 0.96f) - sizeFactor) / (0.96f - sizeFactor);
		  sunSpot = pow(cubicPulse(1.0f, 1.0f, sunSpot), 2.0f);

	// if (sunProximity > 0.96f) {
	// 	return 1.0f;
	// } else {
	// 	return 0.0f;
	// }

	float result = sunSpot / (surface.roughness * 20.0f + 0.1f);

	return result;
	//return 0.0f;
}

float   CalculateMoonspot(in SurfaceStruct surface) {

	float curve = 1.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);

	float moonProximity = abs(1.0f - dot(halfVector2, npos));

	float sizeFactor = 0.965f - surface.roughness * 0.7f;

	float moonSpot = (clamp(moonProximity, sizeFactor, 0.97f) - sizeFactor) / (0.97f - sizeFactor);
		  moonSpot = pow(cubicPulse(1.0f, 1.0f, moonSpot), 2.0f);

	float result = moonSpot / (surface.roughness * 20.0f + 0.1f);

	return result;
}

vec3 NewSkyLight(float p, in SurfaceStruct surface){
	float a = -1.;
	float b = -0.24;
	float c = 6.0;
	float d = -0.8;
	float e = 0.45;
	vec3 sunVec = normalize(reflect(sunPosition, surface.normal));
	vec3 upVec = normalize(reflect(surface.upVector, surface.normal));

	vec3 sVector = surface.viewSpacePosition.xyz;
		 sVector = normalize(sVector);
	
	float cosT = dot(sVector, upVec); 
	float absCosT = max(cosT, 0.0);
	float cosS = dot(sunVec, upVec);		
	float cosY = dot(sunVec, sVector);
	float Y = acos(cosY);

	float SdotU = dot(sunVec, upVec);
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

void 	AddSkyGradient(inout vec3 color, in vec3 rayDirection, inout SurfaceStruct surface) {
	float curve = 5.0f;
	vec3 npos = rayDirection;
	vec3 halfVector2 = normalize(-surface.upVector + npos);
	float skyGradientFactor = dot(halfVector2, npos);
	float skyDirectionGradient = skyGradientFactor;

	if (dot(halfVector2, npos) > 0.75)
		skyGradientFactor = 1.5f - skyGradientFactor;

	skyGradientFactor = pow(skyGradientFactor, curve);

	color = colorSkylight;

	color *= mix(skyGradientFactor, 1.0f, clamp((0.12f - (timeNoon * 0.1f)) + rainStrength, 0.0f, 1.0f));
	color *= pow(skyGradientFactor, 2.5f) + 0.2f;
	color *= (pow(skyGradientFactor, 1.1f) + 0.425f) * 0.5f;
	color.g *= skyGradientFactor * 1.0f + 1.0f;


	vec3 linFogColor = pow(gl_Fog.color.rgb, vec3(2.2f));

	float fogLum = max(max(linFogColor.r, linFogColor.g), linFogColor.b);


	float fade1 = clamp(skyGradientFactor - 0.05f, 0.0f, 0.2f) / 0.2f;
		  fade1 = fade1 * fade1 * (3.0f - 2.0f * fade1);
	vec3 color1 = vec3(12.0f, 8.0, 4.7f) * 0.15f;
		 color1 = mix(color1, vec3(2.0f, 0.55f, 0.2f), vec3(timeSunriseSunset));

	color *= mix(vec3(1.0f), color1, vec3(fade1));

	float fade2 = clamp(skyGradientFactor - 0.11f, 0.0f, 0.2f) / 0.2f;
	vec3 color2 = vec3(2.7f, 1.0f, 2.8f) / 20.0f;
		 color2 = mix(color2, vec3(1.0f, 0.15f, 0.5f), vec3(timeSunriseSunset));

	color *= mix(vec3(1.0f), color2, vec3(fade2 * 0.5f));



	float horizonGradient = 1.0f - distance(skyDirectionGradient, 0.72f) / 0.72f;
		  horizonGradient = pow(horizonGradient, 10.0f);
		  horizonGradient = max(0.0f, horizonGradient);

	float sunglow = CalculateSunglow(surface);
		  horizonGradient *= sunglow * 2.0f + (0.65f - timeSunriseSunset * 0.55f);

	vec3 horizonColor1 = vec3(1.5f, 1.5f, 1.5f);
		 horizonColor1 = mix(horizonColor1, vec3(1.5f, 1.95f, 1.5f) * 2.0f, vec3(timeSunriseSunset));
	vec3 horizonColor2 = vec3(1.5f, 1.2f, 0.8f) * 1.0f;
		 horizonColor2 = mix(horizonColor2, vec3(1.9f, 0.6f, 0.4f) * 2.0f, vec3(timeSunriseSunset));

	color *= mix(vec3(1.0f), horizonColor1, vec3(horizonGradient) * (1.0f - timeMidnight));
	color *= mix(vec3(1.0f), horizonColor2, vec3(pow(horizonGradient, 2.0f)) * (1.0f - timeMidnight));

	float grayscale = fogLum / 10.0f;
		  grayscale /= 3.0f;

	color = mix(color, vec3(grayscale * colorSkylight.r) * 0.06f * vec3(0.85f, 0.85f, 1.0f), vec3(rainStrength));


	color /= fogLum;


	color *= mix(1.0f, 4.5f, timeNoon);

	color *= 6.0; //DO NOT FORGET CHANGE THIS VAULE IN COMPOSITE2



	// //Fake land
	//vec3 fakeLandColor = vec3(0.7f, 0.9f, 1.0f) * 0.012f;
	//surface.sky.albedo = mix(surface.sky.albedo, fakeLandColor, clamp(skyGradientFactor * 8.0f - 0.7f, 0.0f, 1.0f));


	//surface.sky.albedo *= (surface.mask.sky);
}

vec3 	ComputeReflectedSkyGradient(in SurfaceStruct surface) {
	float curve = 5.0f;
	surface.viewSpacePosition.xyz = reflect(surface.viewSpacePosition.xyz, surface.normal);
	vec3 npos = normalize(surface.viewSpacePosition.xyz);

	//surface.upVector = reflect(upVector, surface.normal);
	//surface.lightVector = reflect(lightVector, surface.normal);

	vec3 halfVector2 = normalize(-surface.upVector + npos);
	float skyGradientFactor = dot(halfVector2, npos);
	float skyGradientRaw = skyGradientFactor;
	float skyDirectionGradient = skyGradientFactor;

	if (dot(halfVector2, npos) > 0.75)
		skyGradientFactor = 1.5f - skyGradientFactor;

	skyGradientFactor = pow(skyGradientFactor, curve);

	vec3 skyColor = CalculateLuminance(pow(gl_Fog.color.rgb, vec3(2.2f))) * colorSkylight;

	skyColor *= mix(skyGradientFactor, 1.0f, clamp((0.12f - (timeNoon * 0.1f)) + rainStrength, 0.0f, 1.0f));
	skyColor *= pow(skyGradientFactor, 2.5f) + 0.2f;
	skyColor *= (pow(skyGradientFactor, 1.1f) + 0.425f) * 0.5f;
	skyColor.g *= skyGradientFactor * 1.0f + 1.0f;


	vec3 linFogColor = pow(gl_Fog.color.rgb, vec3(2.2f));

	float fogLum = max(max(linFogColor.r, linFogColor.g), linFogColor.b);

	float fade1 = clamp(skyGradientFactor - 0.05f, 0.0f, 0.2f) / 0.2f;
		  fade1 = fade1 * fade1 * (3.0f - 2.0f * fade1);
	vec3 color1 = vec3(12.0f, 8.0, 4.7f) * 0.15f;
		 color1 = mix(color1, vec3(2.0f, 0.55f, 0.2f), vec3(timeSunriseSunset));

	skyColor *= mix(vec3(1.0f), color1, vec3(fade1));

	float fade2 = clamp(skyGradientFactor - 0.11f, 0.0f, 0.2f) / 0.2f;
	vec3 color2 = vec3(2.7f, 1.0f, 2.8f) / 20.0f;
		 color2 = mix(color2, vec3(1.0f, 0.15f, 0.5f), vec3(timeSunriseSunset));


	skyColor *= mix(vec3(1.0f), color2, vec3(fade2 * 0.5f));




	float horizonGradient = 1.0f - distance(skyDirectionGradient, 0.72f) / 0.72f;
		  horizonGradient = pow(horizonGradient, 10.0f);
		  horizonGradient = max(0.0f, horizonGradient);

	float sunglow = CalculateSunglow(surface);
		  horizonGradient *= sunglow * 2.0f+ (0.65f - timeSunriseSunset * 0.55f);

	vec3 horizonColor1 = vec3(1.5f, 1.5f, 1.5f);
		 horizonColor1 = mix(horizonColor1, vec3(1.5f, 1.95f, 1.5f) * 2.0f, vec3(timeSunriseSunset));
	vec3 horizonColor2 = vec3(1.5f, 1.2f, 0.8f) * 1.0f;
		 horizonColor2 = mix(horizonColor2, vec3(1.9f, 0.6f, 0.4f) * 2.0f, vec3(timeSunriseSunset));

	skyColor *= mix(vec3(1.0f), horizonColor1, vec3(horizonGradient) * (1.0f - timeMidnight));
	skyColor *= mix(vec3(1.0f), horizonColor2, vec3(pow(horizonGradient, 2.0f)) * (1.0f - timeMidnight));

	float grayscale = fogLum / 10.0f;
		  grayscale /= 3.0f;

	float rainSkyBrightness = 1.2f;
		  rainSkyBrightness *= mix(0.05f, 10.0f, timeMidnight);

	skyColor = mix(skyColor, vec3(grayscale * colorSkylight.r) * 0.06f * vec3(0.85f, 0.85f, 1.0f), vec3(rainStrength));


	skyColor /= fogLum;


	float antiSunglow = CalculateAntiSunglow(surface);

	skyColor *= 1.0f + pow(sunglow, 1.1f) * (7.0f + timeNoon * 1.0f) * (1.0f - rainStrength) * 0.4;
	skyColor *= mix(vec3(1.0f), colorSunlight * 11.0f, clamp(vec3(sunglow) * (1.0f - timeMidnight) * (1.0f - rainStrength), vec3(0.0f), vec3(1.0f)));
	skyColor *= 1.0f + antiSunglow * 2.0f * (1.0f - rainStrength);


	if (surface.mask.water)
	{
		vec3 sunspot = vec3(CalculateSunspot(surface)) * colorSunlight * surface.sunlightVisibility;
			 sunspot *= 2.0f;
			 sunspot *= 1.0f - timeMidnight;
			 sunspot *= 1.0f - rainStrength;

		vec3 moonSpot = vec3(CalculateMoonspot(surface)) * colorSunlight * surface.sunlightVisibility;
			 moonSpot *= 2.0f;
			 moonSpot *= timeMidnight;
			 moonSpot *= 1.0f - rainStrength;

		DoNightEye(moonSpot);

		skyColor += sunspot + moonSpot;
	}

	skyColor *= pow(1.0f - clamp(skyGradientRaw - 0.75f, 0.0f, 0.25f) / 0.25f, 3.0f);

	skyColor *= mix(1.0f, 4.5f, timeNoon + timeMidnight);

	skyColor = mix(skyColor, colorSunlight * 2.0, pow(sunglow, 6.0) * (1.0 - rainStrength));

	return skyColor * 1.0; 
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

vec4 	GetCloudSpacePosition(in vec2 coord, in SurfaceStruct surface, in float depth, in float distanceMult)
{
	// depth *= 30.0f;

	float linDepth = depth;

	float expDepth = (far * (linDepth - near)) / (linDepth * (far - near));

	//Convert texture coordinates and depth into view space
	vec4 viewPos = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * expDepth - 1.0f, 1.0f);
		 viewPos /= viewPos.w;
		 viewPos.xyz = 2.0 * reflect(viewPos.xyz, surface.normal.xyz);

	//Convert from view space to world space
	vec4 worldPos = gbufferModelViewInverse * viewPos;

	worldPos.xyz *= distanceMult;
	worldPos.xyz += cameraPosition.xyz;

	return worldPos;
}

float CubicSmooth(float x)
{
	return x * x * (3.0 - 2.0 * x);
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

float R2_dither(){
	vec2 alpha = vec2(0.75487765, 0.56984026);
	
	return fract(alpha.x * gl_FragCoord.x + alpha.y * gl_FragCoord.y);
}

void CloudPlane(in SurfaceStruct surface, inout vec3 color)
{
	//Initialize view ray
	vec4 worldVector = gbufferModelViewInverse * (vec4(-reflect(surface.viewSpacePosition.xyz, surface.normal.xyz), 0.0));

	surface.viewRay.dir = normalize(worldVector.xyz);

	float sunglow = CalculateReflectedSunglow(surface);



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
		vec4 cloudSample = CloudColor(vec4(i.pos.xyz * 0.5f + vec3(30.0f) + vec3(1000.0, 0.0, 0.0), 1.0f), sunglow, surface.worldLightVector, cloudsAltitude, cloudsThickness, false);
		 	 cloudSample.a = min(1.0f, cloudSample.a * density);


		color.rgb = mix(color.rgb, cloudSample.rgb * 0.001f, cloudSample.a);
	}
}

void CalculateClouds (inout vec3 color, in SurfaceStruct surface)
{

	vec2 coord = texcoord.st * 2.0f;

	vec4 worldPosition = gbufferModelViewInverse * vec4(-reflect(surface.viewSpacePosition.xyz, surface.normal.xyz), 0.0);
		 //worldPosition.xyz += cameraPosition.xyz;

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

	float sunglow = CalculateReflectedSunglow(surface);

	float cloudDistanceMult = 400.0f / far;

	float surfaceDistance = length(worldPosition.xyz - cameraPosition.xyz);

	while (rayDepth > 0.0f)
	{
	//determine worldspace ray position
		vec4 rayPosition = GetCloudSpacePosition(texcoord.st, surface, rayDepth, cloudDistanceMult);

		float rayDistance = length((rayPosition.xyz - cameraPosition.xyz) / cloudDistanceMult);

		vec4 proximity =  CloudColorT(rayPosition, sunglow, surface.worldLightVector);
			 proximity.a *= cloudDensity;

		 //proximity.a *=  clamp(surfaceDistance - rayDistance, 0.0f, 1.0f);
		 if (surfaceDistance < rayDistance * cloudDistanceMult)
			proximity.a = 0.0f;

		color.rgb = mix(color.rgb, proximity.rgb * 0.001, vec3(min(1.0f, proximity.a * cloudDensity)));

	//Increment ray
		rayDepth -= rayIncrement;
		i++;

		if (rayDepth * cloudDistanceMult  < ((cloudHeight - (cloudDepth * 0.5)) - cameraPosition.y))
		{
			break;
		}
	}
}

void CalStar(in SurfaceStruct surface, inout vec3 finalComposite) {

	vec3 viewPos = normalize(surface.viewSpacePosition.xyz);
		 viewPos = reflect(viewPos, surface.normal.xyz);

	vec4 worldPos = gbufferModelViewInverse * (vec4(-viewPos.xyz, 0.0f));

	float cosT2 = pow(0.89, distance(vec2(0.0), worldPos.xz) / 100.0); // Curved plane.
	vec2 starsCoord = worldPos.xz / worldPos.y / 20.0 * (1.0 + cosT2 * cosT2 * 3.5) + vec2(frameTimeCounter / 800.0 / 16 * 2);


	float stars = max(texture(noisetex, starsCoord * 16).x - 0.94, 0.0) * 2.0;


	float position = abs(worldPos.y - cameraPosition.y - 65);
	float horizonPos= max(exp(1.0 - position / 50.0), 0.0);
		stars = mix(stars * timeMidnight, 0.0, horizonPos);
	float calcSun = min(pow(max(dot(normalize(viewPos.xyz), -surface.lightVector), 0.0), 2000.0), 0.2) * 3.0;
		//stars = mix(stars, 0.0, calcSun);


	finalComposite.rgb = mix(finalComposite.rgb , (vec3(0.8,1.2,1.2) * 0.02 - 0.02 * rainStrength) * 0.0005f, stars);

}

mat2 mm2(in float a){
	
	float c = cos(a), s = sin(a);
	return mat2(c, s, -s, c);
}

mat2 m2 = mat2(0.95534, 0.29552, -0.29552, 0.95534);

float tri(in float x){
	
	return clamp(abs(fract(x) - 0.5), 0.01, 0.49);
}

vec2 tri2(in vec2 p){
	
	return vec2(tri(p.x) + tri(p.y), tri(p.y + tri(p.x)));
}

float triNoise2d(in vec2 p, float spd)
{
    float z=1.8;
    float z2=2.5;
	float rz = 0.0;
	
    p *= mm2(p.x*0.06);
    vec2 bp = p;
	
	for (float i=0.0; i<5.0; i++){
		
        vec2 dg = tri2(bp * 1.85)*0.75;
        dg *= mm2(frameTimeCounter * spd);
        p -= dg / z2;

        bp *= 1.3;
        z2 *= 0.45;
        z  *= 0.42;
		p  *= 1.21 + (rz - 1.0)*0.02;
        
        rz += tri(p.x + tri(p.y))*z;
        p*= -m2;
	}
	
    return clamp(1.0 / pow(rz*29.0, 1.3), 0.0, 0.55);
}

float hash21(in vec2 n){ 

	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453); 
}

vec4 blueAurora = vec4(0.5, 2.0, 4.0,1.5);
vec4 purpleAurora = vec4(4.0, 0.5, 3.0,1.5);
vec4 greenAurora = vec4(0.2, 2.0, 1.5,1.5);

vec4 aurora(vec3 ro, vec3 rd)
{
    vec4 col = vec4(0.0);
    //vec4 avgCol = vec4(0.0);
    
#ifdef AURORA_PRESET_COL
    vec4 avgCol = vec4(0.7,0.4,0.6,1.0);
	vec4 excolor = vec4(4);
#else
	vec4 avgCol = AURORA_COLOR;
	vec4 excolor = AURORA_COLOR;
#endif
	
	
    for(float i=0.0; i<aurora_flash; i++){
		
        float of = 0.006 * hash21(gl_FragCoord.xy) * smoothstep(0.0, 15.0, i);
        float pt = ((0.8 + pow(i, 1.4)*0.002 )- ro.y)/(rd.y*2.0+0.4);
			 pt -= of;
    	
		vec3 bpos = ro + pt * rd;
        vec2 p = bpos.zx;
         float rzt = triNoise2d(p, aurora_speed * 0.1);
		 
        //vec4 col2 = vec4(0.0, 0.0, 0.0, rzt);
		//	 col2.rgb = (sin(1.0 - vec3(2.15, -0.5, 1.2) + i * 0.043)*0.5 + 0.5)*rzt;
			 
        //avgCol =  mix(avgCol, col2, 0.5);
		
		#ifdef AURORA_PRESET_COL
		    vec4 col2 = vec4(0);
		    col2 = vec4(2.5*(i-0.25*aurora_flash), 1.0*(aurora_flash*0.6-i), i*1.3, 1.0) / aurora_flash * rzt;
			avgCol =  mix(avgCol, col2, 0.5);
		#else
            vec4 col2 = vec4(0.0,0.0,0.0, rzt);
            col2.rgb = (sin(1.0-vec3(2.15,-.5, 1.2)+i*0.043)*0.5+0.5)*rzt;
            avgCol =  mix(avgCol, col2, 0.5);
		#endif
		
        col += avgCol * exp2(-i*0.065 - 2.5) * smoothstep(0.0, 5.0, i);
        
    }
    
    col *= (clamp(rd.y*15.0 + 0.4, 0.0, 1.0));
    
		
#ifdef AURORA_PRESET_COL
   
	if(col.r>=0.8)
		col.r=0.8;
	if(col.g>=0.5)
		col.g=0.5;
	if(col.b>=0.7)
		col.b=0.7;

#endif

	
	
    return col*aurora_power * aurora_power;   
}

void NightAurora(inout vec3 color, in SurfaceStruct surface)
{
	if (rainStrength < 0.9) {
		vec3 viewPos = reflect(surface.viewSpacePosition.xyz, surface.normal.xyz);
		vec3 upPos = upPosition;

		vec3 sVector = normalize(viewPos);
	
		float cosT = dot(sVector,upVector);
		vec3 upVec = normalize(upPos);
		vec3 tpos = vec3(gbufferModelViewInverse * vec4(viewPos,1.0));

		vec3 wVector = normalize(tpos);
		vec3 intersection = wVector * (50.0 / (wVector.y));
			 intersection *= mix(1.0, cosT, 0.70 - cosT);
			 intersection.xz = intersection.xz*40.0 + 5.0 * cosT * intersection.xz;
			 
		vec3 iSpos = (gbufferModelView * vec4(intersection, 1.0)).rgb;
		float cosT2 = max(dot(normalize(iSpos), upVec), 0.0);

		float position = dot(normalize(viewPos.xyz), upPos);
		float horizonPos = max(1.0 - abs(position)*0.03, 0.0);

		float horizonBorder = min((1.0 - clamp(position + length(position), 0.0, 1.0)) + horizonPos, 1.0);
	
		vec3 col = vec3(0.0);
		vec3 ro = vec3(0.0);
		vec3 rd = intersection/12392.0f/2.0;
		vec3 brd = rd;
		float fade = smoothstep(0.0, 0.01, abs(brd.y))*0.1 + 0.9;
	
		vec4 aur = smoothstep(0.0, 1.5, aurora(ro, rd)) * fade;
	
			col = col * (1.0 - aur.a) + aur.rgb * pow(cosT2, 0.18) * (1.0 - horizonBorder);
		 
			col = pow(col, vec3(1.5));
   
		color += col * AURORA_STRENGTH * 2.0 * (1-rainStrength) * timeMidnight * (1 - wetness*0.75)*vec3(NIGHT_AURORA_R, NIGHT_AURORA_G, NIGHT_AURORA_B)*NIGHT_AURORA_L;
	}else{
		color += vec3(0.0);	
	}
}

vec3 	ComputeFakeSkyReflection(in SurfaceStruct surface) {

	vec3 cameraSpacePosition = convertScreenSpaceToWorldSpace(texcoord.st);
	vec3 cameraSpaceNormal = surface.normal;
	vec3 cameraSpaceViewDir = normalize(cameraSpacePosition);
	vec3 color = vec3(0.0f);

	vec3 rayDirection = normalize(reflect(cameraSpaceViewDir, cameraSpaceNormal));

	AddSkyGradient(color.rgb, rayDirection, surface);

	float viewVector = dot(cameraSpaceViewDir, cameraSpaceNormal);

	DoNightEye(color.rgb);

	color.rgb *= mix(1.0f, 0.125f, timeMidnight);
#ifdef NEW_SKY_LIGHT
	color.rgb += (NewSkyLight(0.045, surface) / 6.0) * 0.006f;
#endif
	
	color /= Hardbaked_HDR;

#ifdef STAR
	if (rainStrength < 0.99) CalStar(surface, color.rgb);
#endif

#ifdef AURORA
	NightAurora(color.rgb, surface);
#endif

	#ifdef High_Altitude_Clouds
	CloudPlane(surface, color.rgb);
	#endif

#ifdef VOLUMETRIC_CLOUDS
	//ReflectedVolumeClouds(surface, color.rgb);
	CalculateClouds(color.rgb, surface);
#endif

	return color * Hardbaked_HDR;
}

void 	CalculateSpecularReflections(inout SurfaceStruct surface) {

	float specularity = surface.specularity * surface.specularity * surface.specularity;
	      specularity = max(0.0f, specularity * 1.15f - 0.15f);
	surface.specularColor = vec3(1.0f);
	//surface.specularity = 1.0f;
	//surface.roughness *= surface.roughness;

	bool defaultItself = false;

	surface.rDepth = 0.0f;

	vec3 color = surface.color;

	//materials
	vec3 albedo = pow(texture2D(colortex3, texcoord.xy).rgb, vec3(2.2));

	float smoothness = 0.0;
	float roughness = 1.0 - smoothness * smoothness;
	float metallic = 0.02;
	vec3 F0 = vec3(0.02);//mix(vec3(max(0.02, metallic)), albedo, step(0.9, metallic));

	if (surface.mask.sky)
		specularity = 0.0f;



	if (surface.mask.ironBlock)
	{
		surface.baseSpecularity = 1.0f;
		//specularity = 1.0f;
		//surface.roughness = 0.0f;
		metallic = 1.0;
		F0 = albedo;
	}

	if (surface.mask.goldBlock)
	{
		//surface.specularity = 1.0f;
		surface.roughness = 0.4f;
		surface.baseSpecularity = 1.0f;
		surface.specularColor = vec3(1.0f, 0.32f, 0.002f);
		surface.specularColor = mix(surface.specularColor, vec3(1.0f), vec3(0.015f));

		metallic = 1.0;
		F0 = surface.specularColor;
	}

	if (surface.mask.water || surface.mask.ice)
	{
		specularity = 1.0f;
		surface.roughness = 0.0f;
		surface.fresnelPower = 6.0f;
		surface.baseSpecularity = 0.02f;
	}

	vec3 original = surface.color.rgb;

	vec3 worldNormal = mat3(gbufferModelViewInverse) * surface.normal;

	vec3 n = abs(worldNormal);
	vec3 worldGeoNormal = n.x > max(n.y, n.z) ? vec3(step(0.0, worldNormal.x) * 2.0 - 1.0, 0.0, 0.0) : 
						  n.y > max(n.x, n.z) ? vec3(0.0, step(0.0, worldNormal.y) * 2.0 - 1.0, 0.0) : 
						  vec3(0.0, 0.0, step(0.0, worldNormal.z) * 2.0 - 1.0);

	vec3 viewDirection = normalize(surface.viewSpacePosition.xyz);
	vec3 eyeDirection = -viewDirection;

	vec3 tex_normal = surface.normal;
	vec3 geo_normal = mat3(gbufferModelView) * worldGeoNormal;
	vec3 normal = tex_normal;

	vec3 rayDirection = normalize(reflect(viewDirection, normal));

	if (specularity > 0.00f) {
		vec4 ssR = ComputeRaytraceReflection(surface);
		vec3 fakeSkyReflection = ComputeFakeSkyReflection(surface) * (isEyeInWater == 0 ? 1.0 : 0.0) * clamp(surface.skylight * 16 - 5, 0.0f, 1.0f);

		vec3 reflection = mix(fakeSkyReflection.rgb, ssR.rgb, ssR.a);
		
		vec3 fr = mix(F0, vec3(1.0), pow(1.0 - saturate(dot(normalize(eyeDirection + rayDirection), eyeDirection)), 5.0)) * specularity * specularity;//

		color *= (1.0 - metallic) * (1.0 - step(0.9, metallic));
		//color *= 1.0 - specularity * specularity;
		color += reflection * fr;

		/*
		if (isEyeInWater < 0.5) {
			vec4 reflection = ComputeRaytraceReflection(surface);

			vec4 fakeSkyReflection = vec4(0.0);//ComputeFakeSkyReflection(surface);

			vec3 noSkyToReflect = vec3(0.0f);

			if (defaultItself)
			{
				noSkyToReflect = surface.color.rgb;
			}

			fakeSkyReflection.rgb = mix(noSkyToReflect, fakeSkyReflection.rgb, clamp(surface.skylight * 16 - 5, 0.0f, 1.0f));
			reflection.rgb = mix(reflection.rgb, fakeSkyReflection.rgb, pow(vec3(1.0f - reflection.a), vec3(10.1f)));
			reflection.a = fakeSkyReflection.a * specularity;


			reflection.rgb *= surface.specularColor;

			surface.color.rgb = mix(surface.color.rgb, reflection.rgb, vec3(reflection.a));
			surface.reflection = reflection;
		} else {
			vec4 reflection = ComputeRaytraceReflection(surface);
			reflection.rgb *= surface.specularColor;

			vec3 refractCol = vec3(WATER_COLOR_F_R, WATER_COLOR_F_G, WATER_COLOR_F_B);
				 refractCol *= dot(vec3(0.33333), colorSunlight);
				 refractCol *= (1.0 - rainStrength * 0.95);
				 refractCol *= pow(eyeBrightnessSmooth.y / 240.0f, 4.0f) * 0.00002;

			float refractedAmount = abs(dot(normalize(surface.viewSpacePosition.xyz), surface.normal.xyz));
			if(refractedAmount > 1.0 / 1.3333)
			{
				refractCol = surface.color.rgb;
				reflection.a *= 0.6;
			}

			surface.color.rgb = mix(refractCol, reflection.rgb, vec3(reflection.a));
			surface.reflection = reflection;
		}
		*/
	}

	surface.color.rgb = color;//mix(surface.color.rgb, original, vec3(surface.cloudAlpha));
}

void CalculateSpecularHighlight(inout SurfaceStruct surface)
{
	if (!surface.mask.sky && !surface.mask.water || surface.mask.ice)
	{
		//surface.specularity = 0.51f;
		//surface.roughness = 0.2f;


		vec3 halfVector = normalize(lightVector - normalize(surface.viewSpacePosition.xyz));

		float HdotN = max(0.0f, dot(halfVector, surface.normal.xyz));

		float NdotL = clamp(dot(lightVector, surface.normal.xyz), 0.0, 1.0);

		// surface.roughness = sin(FRAME_TIME * 3.1415f) * 0.5f + 0.5f;

		// surface.roughness = 0.75;

		float fresnel = pow(1.0 - dot(halfVector, normalize(-surface.viewSpacePosition.xyz)), 5.0) * 0.99 + 0.01;

		float gloss = pow(1.0f - surface.roughness + 0.01f, 4.5f);
		// gloss = 0.0;

		// gloss = clamp(gloss + fresnel * fresnel * fresnel * 0.1, 0.0f, 1.0f);

		// HdotN = clamp(HdotN * (1.0f + gloss * 0.01f), 0.0f, 1.0f);

		//float spec = pow(HdotN, gloss * 1200.0f + 2.0f);
		//	  spec += pow(HdotN, gloss * 600.0f + 1.0f) * 0.5;
		//	  spec += pow(HdotN, gloss * 300.0f + 1.0f) * 0.25;
		//	  spec += pow(HdotN, gloss * 150.0f + 1.0f) * 0.125;
		float spec = 1.0 / (pow((1.0 - HdotN) * (gloss * 8000.0 + 0.25), 1.5) + 1.1);

		//spec *= float(!surface.mask.sky);



		// float fresnel = pow(clamp(1.0f + dot(normalize(surface.viewSpacePosition.xyz), surface.normal.xyz), 0.0f, 1.0f), surface.fresnelPower) * (1.0f - surface.baseSpecularity) + surface.baseSpecularity;

		float NdotV = dot(surface.normal.xyz, normalize(-surface.viewSpacePosition.xyz));

		spec *= fresnel;
		spec *= NdotL;

		//spec *= pow(1.0f - surface.roughness, 1.5f) * 80000.0f;
		spec *= gloss * 8000.0f + 0.25f;
		// spec *= 100.08;
		spec *= 0.09;
		// spec *= 1.0 + pow((1.0 - clamp(NdotV, 0.0, 1.0)), 20.0) * 100.0;
		// spec *= surface.specularity * surface.specularity * surface.specularity;
		spec *= 1.0f - rainStrength;

		vec3 specularHighlight = spec * mix(colorSunlight, vec3(0.2f, 0.5f, 1.0f) * 0.0005f, vec3(timeMidnight)) * surface.specularColor * surface.sunlightVisibility;

		specularHighlight *= pow(surface.skylight, 0.1);

		surface.color += specularHighlight / 500.0f;
	}
}

vec3 ReorientNormal(vec3 n1, vec3 n2)
{
    float a = 1/(1 + n1.z);
    float b = -n1.x*n1.y*a;

    // Form a basis
    vec3 b1 = vec3(1 - n1.x*n1.x*a, b, -n1.x);
    vec3 b2 = vec3(b, 1 - n1.y*n1.y*a, -n1.y);
    vec3 b3 = n1;

    if (n1.z < -0.9999999) // Handle the singularity
    {
        b1 = vec3( 0, -1, 0);
        b2 = vec3(-1,  0, 0);
    }

    // Rotate n2 via the basis
    vec3 r = n2.x*b1 + n2.y*b2 + n2.z*b3;

    return normalize(r);
}

void CalculateGlossySpecularReflections(inout SurfaceStruct surface)
{
	float specularity = surface.specularity;
	float roughness = 0.7f;
	float spread = 0.01f;

	specularity *= 1.0f - float(surface.mask.sky);

	vec4 reflectionSum = vec4(0.0f);

	surface.fresnelPower = 6.0f;
	surface.baseSpecularity = 0.0f;

	if (surface.mask.ironBlock)
	{
		roughness = 0.9f;
		//specularity = 1.0f;
		//surface.baseSpecularity = 1.0f;
	}

	if (surface.mask.goldBlock)
	{
		specularity = 0.0f;
	}

	surface.baseSpecularity = 0.02;



	//if (specularity > 0.01f)
	//{
		float fresnel = 1.0f - clamp(-dot(normalize(surface.viewSpacePosition.xyz), surface.normal.xyz), 0.0f, 1.0f);

		for (int i = 1; i <= 10; i++)
		{
			vec2 translation = vec2(surface.normal.x, surface.normal.y) * i * spread;
				 translation *= vec2(1.0f, viewWidth / viewHeight);
			//vec2 scaling = (4.0f - vec2(fresnel) * 3.0f);

			float faceFactor = surface.normal.z;
				  faceFactor *= spread * 13.0f;

			vec2 scaling = vec2(1.0f + faceFactor * (i / 10.0f) * 2.0f);

			float r = float(i) + 4.0f;
				  r *= roughness * 0.8f;
			int 	ri = int(floor(r));
			float 	rf = fract(r);

			vec2 finalCoord = (((texcoord.st * 2.0f - 1.0f) * scaling) * 0.5f + 0.5f) + translation;

			float weight = (11 - i + 1) / 10.0f;
			reflectionSum.rgb += pow(textureLod(colortex0, finalCoord, r).rgb, vec3(2.2f));
		}



		reflectionSum.rgb /= 5.0f;

		fresnel *= 0.9 * (1.0 - surface.roughness * 0.3);
		fresnel = pow(fresnel, surface.fresnelPower);

		surface.color = mix(surface.color, reflectionSum.rgb * 1.0f, vec3(2.0) * fresnel * (1.0f - surface.baseSpecularity) + surface.baseSpecularity);
	//	}
	//surface.color.rgb *= vec3(1.0f) + reflectionSum.rgb * 400000.2f;
}

vec4 TextureSmooth(in sampler2D tex, in vec2 coord, in int level)
{
	vec2 res = vec2(viewWidth, viewHeight);
	coord = coord * res + 0.5f;
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	f = f * f * (3.0f - 2.0f * f);
	coord = i + f;
	coord = (coord - 0.5f) / res;
	return texture(tex, coord, level);
}

void SmoothSky(inout SurfaceStruct surface)
{
	const float cloudHeight = 540.0f;
	const float cloudDepth = 140.0f;
	const float cloudMaxHeight = cloudHeight + cloudDepth / 2.0f;
	const float cloudMinHeight = cloudHeight - cloudDepth / 2.0f;

	float cameraHeight = cameraPosition.y;
	float surfaceHeight = surface.worldSpacePosition.y;

	vec3 combined = pow(TextureSmooth(colortex0, texcoord.st, 2).rgb, vec3(2.2f));
	vec3 original = surface.color;

	// surface.color = combined;

	if (surface.cloudAlpha > 0.000001f)
	{
		surface.color = combined;
	}

	if (cameraHeight < cloudMinHeight && surfaceHeight < cloudMinHeight - 10.0f && surface.mask.land)
	{
		surface.color = original;
	}

	if (cameraHeight > cloudMaxHeight && surfaceHeight > cloudMaxHeight && surface.mask.land)
	{
		surface.color = original;
	}

	if (cameraHeight > cloudMaxHeight - 20.0f)
	{
		surface.color = vec3(0.0);
	}
}


void FixNormals(inout vec3 normal, in vec3 viewPosition)
{
	vec3 V = normalize(viewPosition.xyz);
	vec3 N = normal;

	float NdotV = dot(N, V);

	N = normalize(mix(normal, -V, clamp(pow((NdotV * 1.0), 1.0), 0.0, 1.0)));
	N = normalize(N + -V * 0.1 * clamp(NdotV + 0.4, 0.0, 1.0));

	normal = N;
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

float GetWaves(vec3 position, float frameTimeCounter) {
	float speed = 0.9f;
	float waveWaterSpeed = WATER_SPEED;
#ifdef WATER_SPEED_LIGHT_BAR_LINKER
      waveWaterSpeed *= pow(screenBrightness * 2.0f, 4.0);
#endif
#define FRAME_TIME1 frameTimeCounter * waveWaterSpeed
  vec2 p = position.xz / 20.0f;

  p.xy -= position.y / 20.0f;

  p.x = -p.x;

  p.x += (FRAME_TIME1 / 40.0f) * speed;
  p.y -= (FRAME_TIME1 / 40.0f) * speed;

  float weight = 1.0f;
  float weights = weight;

  float allwaves = 0.0f;

  float wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.2f))  + vec2(0.0f,  p.x * 2.1f) ).x; 			p /= 2.1f; 	/*p *= pow(2.0f, 1.0f);*/ 	p.y -= (FRAME_TIME1 / 20.0f) * speed; p.x -= (FRAME_TIME1 / 30.0f) * speed;
  allwaves += wave;

  weight = 4.1f;
  weights += weight;
      wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.4f))  + vec2(0.0f,  -p.x * 2.1f) ).x;	p /= 1.5f;/*p *= pow(2.0f, 2.0f);*/ 	p.x += (FRAME_TIME1 / 20.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 17.25f;
  weights += weight;
      wave = (textureSmooth(noisetex, (p * vec2(1.0f, 0.75f))  + vec2(0.0f,  p.x * 1.1f) ).x);		p /= 1.5f; 	p.x -= (FRAME_TIME1 / 55.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 15.25f;
  weights += weight;
      wave = (textureSmooth(noisetex, (p * vec2(1.0f, 0.75f))  + vec2(0.0f,  -p.x * 1.7f) ).x);		p /= 1.9f; 	p.x += (FRAME_TIME1 / 155.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 29.25f;
  weights += weight;
      wave = abs(textureSmooth(noisetex, (p * vec2(1.0f, 0.8f))  + vec2(0.0f,  -p.x * 1.7f) ).x * 2.0f - 1.0f);		p /= 2.0f; 	p.x += (FRAME_TIME1 / 155.0f) * speed;
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
}

vec3 GetWavesNormal2(vec3 position, float time) {

	float WAVE_HEIGHT = 1.0;

	const float sampleDistance = 11.0f;

	position -= vec3(0.005f, 0.0f, 0.005f) * sampleDistance;

	float wavesCenter = GetWaves(position, time);
	float wavesLeft = GetWaves(position + vec3(0.01f * sampleDistance, 0.0f, 0.0f), time);
	float wavesUp   = GetWaves(position + vec3(0.0f, 0.0f, 0.01f * sampleDistance), time);

	vec3 wavesNormal;
		 wavesNormal.r = wavesCenter - wavesLeft;
		 wavesNormal.g = wavesCenter - wavesUp;

		 wavesNormal.r *= 10.0f * WAVE_HEIGHT / sampleDistance;
		 wavesNormal.g *= 10.0f * WAVE_HEIGHT / sampleDistance;

		 wavesNormal.b = sqrt(1.0f - wavesNormal.r * wavesNormal.r - wavesNormal.g * wavesNormal.g);
		 wavesNormal.rgb = normalize(wavesNormal.rgb);



	return wavesNormal.rgb;
}

void WaterRefraction(inout SurfaceStruct surface)
{
	if (surface.mask.water || surface.mask.ice || surface.mask.stainedGlass)
	{
		vec3 wavesNormal;
		if (surface.mask.water)
			 wavesNormal = GetWavesNormal(surface.worldSpacePosition.xyz + cameraPosition.xyz).xzy;
		else if (surface.mask.ice || surface.mask.stainedGlass)
			 wavesNormal = GetWavesNormal2((surface.worldSpacePosition.xyz + cameraPosition.xyz) * 4.0, 0.0).xzy;


		float opaqueDepth = ExpToLinearDepth(texture(depthtex1, texcoord.st).x);

		float waterDepth = opaqueDepth - surface.linearDepth;

		float refractAmount = saturate(waterDepth / 1.0) * 0.5;

		if (surface.mask.ice || surface.mask.stainedGlass)
		{
			refractAmount *= 0.5;
		}


		vec4 wnv = gbufferModelView * vec4(wavesNormal.xyz, 0.0);
		vec3 wavesNormalView = normalize(wnv.xyz);
		vec4 nv = gbufferModelView * vec4(0.0, 1.0, 0.0, 0.0);
			   nv.xyz = normalize(nv.xyz);
				 wavesNormalView.xy -= nv.xy;
		float aberration = 0.15;
		float refractionAmount = 1.82;
		vec2 refractCoord0 = texcoord.st - wavesNormalView.xy * refractAmount * (refractionAmount) / (surface.linearDepth + 0.0001);
		vec2 refractCoord1 = texcoord.st - wavesNormalView.xy * refractAmount * (refractionAmount + aberration) / (surface.linearDepth + 0.0001);
		vec2 refractCoord2 = texcoord.st - wavesNormalView.xy * refractAmount * (refractionAmount + aberration * 2.0) / (surface.linearDepth + 0.0001);


		if (refractCoord0.x > 1.0 || refractCoord0.x < 0.0 || refractCoord0.y > 1.0 || refractCoord0.y < 0.0)
			refractCoord0 = texcoord.st;

		if (refractCoord1.x > 1.0 || refractCoord1.x < 0.0 || refractCoord1.y > 1.0 || refractCoord1.y < 0.0)
			refractCoord1 = texcoord.st;

		if (refractCoord2.x > 1.0 || refractCoord2.x < 0.0 || refractCoord2.y > 1.0 || refractCoord2.y < 0.0)
			refractCoord2 = texcoord.st;
		// vec2 refractCoord = texcoord.st - wavesNormal.xy * 1.72 / (surface.linearDepth + 0.0001);


		// vec3 fakeViewVector = vec3(texcoord.st * 2.0 - 1.0, 0.1);
		// vec3 fakeRefractCoord = refract(fakeViewVector, surface.normal.xyz, 1.0 / 1.00001);
		
		/*
		surface.color.r = pow(textureLod(colortex0, refractCoord0.xy, 1).r, (2.2));
		surface.color.g = pow(textureLod(colortex0, refractCoord1.xy, 1).g, (2.2));
		surface.color.b = pow(textureLod(colortex0, refractCoord2.xy, 1).b, (2.2));
		*/


		///*

		float fogDensity = 0.40;
		float visibility = 1.0f / (pow(exp(waterDepth * fogDensity), 1.0f));


		vec4 blendWeights = vec4(1.0, 0.5, 0.25, 0.125);
		blendWeights = pow(blendWeights, vec4(visibility));

		float blendWeightsTotal = dot(blendWeights, vec4(1.0));

		surface.color = 
					(
					    pow(textureLod(colortex0, refractCoord0.xy, 1).rgb, vec3(2.2)) * blendWeights.x
					  + pow(textureLod(colortex0, refractCoord0.xy, 2).rgb, vec3(2.2)) * blendWeights.y
					  + pow(textureLod(colortex0, refractCoord0.xy, 3).rgb, vec3(2.2)) * blendWeights.z
					  + pow(textureLod(colortex0, refractCoord0.xy, 4).rgb, vec3(2.2)) * blendWeights.w
					) / blendWeightsTotal / Hardbaked_HDR;
		//*/
	}
}

vec4 textureGather(sampler2D sampler, vec2 coord) {
	vec2 pixel = 1.0 / vec2(viewWidth, viewHeight);
	vec2 c = coord * vec2(viewWidth, viewHeight);
		 c = round(c) * pixel;
		
  return vec4(
    texture(sampler, c + vec2(0.0	,pixel.y)).g,
    texture(sampler, c + vec2(pixel.x,pixel.y)).g,
    texture(sampler, c + vec2(0.0	,pixel.y)).g,
    texture(sampler, c                      ).g
  );
}

vec4 textureGatherOffset(sampler2D sampler, vec2 coord, ivec2 offset) {
	vec2 pixel = 1.0 / vec2(viewWidth, viewHeight);
	vec2 c = coord * vec2(viewWidth, viewHeight);
		 c = (round(c) + vec2(offset)) * pixel;
  
  return vec4(
    texture(sampler, c + vec2(0.0	,pixel.y)).g,
    texture(sampler, c + vec2(pixel.x,pixel.y)).g,
    texture(sampler, c + vec2(0.0	,pixel.y)).g,
    texture(sampler, c                      ).g
  );
}

vec3 WorldPosToShadowProjPosBias(vec3 worldPos, vec3 worldNormal, out float dist, out float distortFactor)
{

	vec4 shadowPos = shadowModelView * vec4(worldPos, 1.0);
		 shadowPos = shadowProjection * shadowPos;
		 shadowPos /= shadowPos.w;

	dist = length(shadowPos.xy);
	distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;

	shadowPos.xy *= 0.95f / distortFactor;
	shadowPos.z = mix(shadowPos.z, 0.5, 0.8);
	shadowPos = shadowPos * 0.5f + 0.5f;		//Transform from shadow space to shadow map coordinates

	return shadowPos.xyz;
}

vec3 CrepuscularRays(inout SurfaceStruct surface)
{
	if(rainStrength > 0.99f) return vec3(0.0);
	vec3 worldPos = surface.worldSpacePosition.xyz;
	float raySamples = RAYS_SAMPLES;

	float rayDistance = length(worldPos); //Get surface distance in meters
	float raySteps = min(shadowDistance, rayDistance) / raySamples;

	vec3 camPosCentre = (gbufferModelViewInverse * vec4(vec3(0.0), 1.0)).xyz;
	vec3 rayDir = normalize(worldPos - camPosCentre) * raySteps;

	float dither = R2_dither();

	float dist, distortFactor;
	float lightIncrease = 0.0;
	float prevLight = 0.0;
	for(int i = 0; i < raySamples; i++){
		worldPos -= rayDir.xyz;

		vec3 rayPos = rayDir.xyz * dither + worldPos;
			 rayPos = WorldPosToShadowProjPosBias(rayPos, surface.normal.xyz, dist, distortFactor);

		//Offsets
		float diffthresh = dist - 0.10f;
			  diffthresh *= 1.5f / (shadowMapResolution / 2048.0f);
		rayPos.z -= diffthresh * 0.0008f;



		float raySample = shadow2D(shadow, rayPos.xyz).x;

		lightIncrease += (raySample + prevLight) * raySteps * 0.5;
		prevLight = raySample;
	}

	lightIncrease += max(rayDistance - shadowDistance, 0.0);
	lightIncrease *= (texture(depthtex0, texcoord.st).x > 0.99999) ? 0.1 : 1.0;



	vec3 rayColor = vec3(lightIncrease * 0.005);

	float sunglow = CalculateSunglow(surface);
	float antiSunglow = CalculateAntiSunglow(surface);

	float anisoHighlight = pow(1.0f / (pow((1.0f - sunglow) * 3.0f, 2.0f) + 1.1f) * 1.5f, 1.5f) + 0.5f;
		  anisoHighlight *= sunglow + 0.0f;
		  anisoHighlight += antiSunglow * 0.05f;
	
	vec3 rayNoonCol       = vec3(VL_NOON_R, VL_NOON_G, VL_NOON_B)* VL_NOON_L * timeNoon;
	vec3 raySunriseSetCol   = vec3(VL_SUNRISESET_R, VL_SUNRISESET_G, VL_SUNRISESET_B)* VL_SUNRISESET_L * timeSunriseSunset;
	vec3 rayNightCol       = vec3(VL_NIGHT_R, VL_NIGHT_G, VL_NIGHT_B) * 0.005 * VL_NIGHT_L * timeMidnight;
	
	vec3 rayColorMain = (rayNoonCol + raySunriseSetCol + rayNightCol) * 0.8;
	
	rayColor *= rayColorMain * anisoHighlight * 120.0f;
	
	DoNightEye(rayColor);

	float rayStrength = 0.0000003 * VL_STRENGTH;

	return rayColor * rayStrength;
}

void CalculateExposure(inout vec3 color) {
	float exposureMax = 1.55f;
		  exposureMax *= mix(1.0f, 0.25f, timeSunriseSunset);
		  exposureMax *= mix(1.0f, 0.0f, timeMidnight);
		  exposureMax *= mix(1.0f, 0.25f, rainStrength);
	float exposureMin = 0.07f;
	float exposure = pow(eyeBrightnessSmooth.y / 240.0f, 6.0f) * exposureMax + exposureMin;

	//exposure = 1.0f;

	color.rgb /= vec3(exposure);
	color.rgb *= 200.0;
}

float BlueNoiseStatic(vec2 coord)
{
	vec2 noiseCoord = vec2(coord.st * vec2(viewWidth, viewHeight)) / 64.0;

	noiseCoord = (floor(noiseCoord * 64.0) + 0.5) / 64.0;

	float blueNoise = textureLod(noisetex, noiseCoord.st, 0).b;

	return blueNoise;
}

////////体积云///////
float Get3DNoise2(in vec3 pos)
{
	pos.z += 0.0f;
	
	vec3 p = floor(pos);
	vec3 f = fract(pos);

	vec2 uv =  (p.xy + p.z * vec2(17.0f)) + f.xy;
	vec2 uv2 = (p.xy + (p.z + 1.0f) * vec2(17.0f)) + f.xy;
	
	vec2 coord =  (uv  + 0.5f) / noiseTextureResolution;
	vec2 coord2 = (uv2 + 0.5f) / noiseTextureResolution;
	
	float xy1 = texture(noisetex, coord).x;
	float xy2 = texture(noisetex, coord2).x;
	return mix(xy1, xy2, f.z);
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

vec4 CloudColor4(in vec4 worldPosition, in float sunglow, in vec3 worldLightVector)
{
	float cloudHeight = Cloud3Height2;

	float cloudDepth  = Cloud3Depth2;

	float cloudUpperHeight = cloudHeight + (cloudDepth / 2.0f);
	float cloudLowerHeight = cloudHeight - (cloudDepth / 2.0f);

	if (worldPosition.y < cloudLowerHeight || worldPosition.y > cloudUpperHeight)
		return vec4(0.0f);
	else
	{

		vec3 p = worldPosition.xyz / 150.0f;

		float t = frameTimeCounter * VOLUMETRIC_CLOUD_SPEED2 ;
		
		
	#ifdef Volumetric_Cloud_Type2	 
		p.x -= t * 0.02f;

		vec3 p1 = p * vec3(1.0f, 0.5f, 1.0f)  + vec3(0.0f, t * 0.01f, 0.0f);
		float noise  = 			   Get3DNoise2(p) 				 * 1.0f;	p *= 4.0f;	p.x += t * 0.02f; vec3 p2 = p;
			  noise += (1.0f - abs(Get3DNoise2(p) * 3.0f - 1.0f)) * 0.20f;	p *= 3.0f;	p.xz += t * 0.05f;
			  noise += (1.0f - abs(Get3DNoise2(p) * 3.0f - 1.5f)-0.2) * 0.065f;	p.xz -=t * 0.165f;	p.xz += t * 0.05f;
			  noise += (1.0f - abs(Get3DNoise2(p) * 3.0f - 1.0f)) * 0.05f;	p *= 2.0f;
			  noise += (1.0 - abs(Get3DNoise3(p) * 2.0 - 1.0)) * 0.015f;
			  noise /= 1.2f;
		
		#else	  
		
	t *= 0.0095;

	p.x *= 0.5f;
	p.x -= t * 0.01f;

	vec3 p1 = p * vec3(1.0f, 0.5f, 1.0f)  + vec3(0.0f, t * 0.01f, 0.0f);

	float noise  = 	Get3DNoise(p * vec3(1.0f, 0.5f, 1.0f) + vec3(0.0f, t * 0.01f, 0.0f)) * 1.3;		p *= 2.0f;	p.x -= t * 0.557f;	vec3 p2 = p;	
		  noise += (2.0f - abs(Get3DNoise(p) * 2.0f - 0.0f)) * (0.35f);								p *= 3.0f;	p.xz -= t * 0.905f;	p.x *= 2.0f;	vec3 p3 = p; 	float largeNoise = noise;
		  noise += (3.0f - abs(Get3DNoise(p) * 3.0f - 0.0f)) * (0.085f);							p *= 3.0f;	p.xz -= t * 3.905f;	vec3 p4 = p;
		  noise += (3.0f - abs(Get3DNoise(p) * 3.0f - 0.0f)) * (0.035f);							p *= 3.0f;	p.xz -= t * 3.905f;
		  noise += ((Get3DNoise(p))) * (0.04f);												p *= 3.0f;
		  noise /= 2.375f;	  
	
	#endif	  

		const float lightOffset = 0.3f;

		float heightGradient = clamp(( - (cloudLowerHeight - worldPosition.y) / (cloudDepth * 1.0f)), 0.0f, 1.0f);
		float heightGradient2 = clamp(( - (cloudLowerHeight - (worldPosition.y + worldLightVector.y * lightOffset * 150.0f)) / (cloudDepth * 1.0f)), 0.0f, 1.0f);

		float cloudAltitudeWeight = 1.0f - clamp(distance(worldPosition.y, cloudHeight) / (cloudDepth / 2.0f), 0.0f, 1.0f);
			  cloudAltitudeWeight = (-cos(cloudAltitudeWeight * 3.1415f)) * 0.5 + 0.5;
			  cloudAltitudeWeight = pow(cloudAltitudeWeight, mix(0.33f, 0.8f, rainStrength));

		float cloudAltitudeWeight2 = 1.0f - clamp(distance(worldPosition.y + worldLightVector.y * lightOffset * 150.0f, cloudHeight) / (cloudDepth / 2.0f), 0.0f, 1.0f);
			  cloudAltitudeWeight2 = (-cos(cloudAltitudeWeight2 * 3.1415f)) * 0.5 + 0.5;
			  cloudAltitudeWeight2 = pow(cloudAltitudeWeight2, mix(0.33f, 0.8f, rainStrength));

		noise *= cloudAltitudeWeight;
	
	
	//cloud edge
		float rainy = mix(wetness, 1.0f, rainStrength);
		float coverage = Vol_Cloud_Coverage2 + rainy * 0.335;		
			  coverage = mix(coverage, 0.77f, rainStrength);
	
		float dist = length(worldPosition.xz - cameraPosition.xz);
		coverage *= max(0.0f, 1.0f - dist / 40000.0f); 
		
		float density = 0.90f;
		noise = GetCoverage(coverage, density, noise);
		noise = pow(noise, 1.5);
		
		if (noise <= 0.001f)
		{
			return vec4(0.0f, 0.0f, 0.0f, 0.0f);
		}

	float sundiff = Get3DNoise2(p1 + worldLightVector.xyz * lightOffset);
		  sundiff += (1.0 - abs(Get3DNoise2(p2 + worldLightVector.xyz * lightOffset / 2.0f) * 1.0f - 0.5f) - 0.1) * 0.55f;
		  sundiff *= 0.955f;
		  sundiff *= cloudAltitudeWeight2;
	float preCoverage = sundiff;
		  sundiff = -GetCoverage(coverage * 1.0f, density * 0.5, sundiff);
	
	float sundiff2 = -GetCoverage(coverage * 1.0f, 0.0, preCoverage);
	float firstOrder 	= pow(clamp(sundiff * 1.2f + 1.7f, 0.0f, 1.0f), 8.0f);
	float secondOrder 	= pow(clamp(sundiff2 * 1.2f + 1.1f, 0.0f, 1.0f), 4.0f);

	float anisoBackFactor = mix(clamp(pow(noise, 1.6f) * 2.5f, 0.0f, 1.0f), 1.0f, pow(sunglow, 1.0f));
		  firstOrder *= anisoBackFactor * 0.99 + 0.01;
		  secondOrder *= anisoBackFactor * 1.19 + 0.9;

	float directLightFalloff = clamp(pow(-(cloudLowerHeight - worldPosition.y) / cloudDepth, 3.5f), 0.0f, 1.0f);
		  directLightFalloff *= mix(	clamp(pow(noise, 0.9f), 0.0f, 1.0f), 	clamp(pow(1.0f - noise, 10.3f), 0.0f, 0.5f), 	pow(sunglow, 0.2f));

	vec3 colorDirect = colorSunlight * 1.0f + vec3(0.5, 0.5, 0.5);
	     colorDirect *= VOLUMETRIC_CLOUD_LIGHTING2 * (1.25 - timeMidnight) * 0.8;
		 colorDirect = mix(colorDirect, colorDirect * vec3(0.1f, 0.2f, 0.3f), timeMidnight);
		 colorDirect = mix(colorDirect, colorDirect * vec3(0.2f, 0.2f, 0.2f), rainStrength);
		 colorDirect *= 1.0f + pow(sunglow, 2.0f) * 50.0f;

	vec3 colorAmbient = mix(colorSkylight, colorSunlight* 0.001, 0.15f) * 0.26f;
		 colorAmbient *= mix(1.0f, 0.3f, timeMidnight);

	 vec3 colorBounced = colorBouncedSunlight * 0.35f;
	 	  colorBounced *= pow((1.0f - heightGradient), 12.0f);
	 	  colorBounced *= anisoBackFactor + 0.5;
	 	  colorBounced *= 1.0 - rainStrength;

		vec3 color = mix(colorAmbient, colorDirect, vec3(directLightFalloff));
			 color += colorBounced;

		//color *= 1.0f;

		vec4 result = vec4(color.rgb, noise);

		return result;
	}
}

void 	CalculateCloud (inout SurfaceStruct surface, out float sumLight) 
{
		vec2 coord = texcoord.st * 2.0f;

		vec4 worldPosition = gbufferModelViewInverse * surface.viewSpacePosition;
			 worldPosition.xyz += cameraPosition.xyz;

		float cloudHeight = 150.0f;
		float cloudDepth  = 140.0f;
		
        float cloudDensity;
		
	#ifdef VFCWWT
        cloudDensity = 0.08 * (FOGDENS_SUNRISE * timeSunriseSunset + FOGDENS_NOON * timeNoon + FOGDENS_MIDNIGHT * timeMidnight);
	#else
		cloudDensity = 0.08;
	#endif

		
		
	
		
        cloudDensity = cloudDensity * VFDensityStrength  * ( 1.0 - rainStrength  * 0.3 ) / CLOUD_PRECISION2;
		
		float startingRayDepth = far - 5.0f;

		float rayDepth = startingRayDepth;
			  
		float rayIncrement = far / CLOUD_DISPERSE2;

		rayDepth += R2_dither() * rayIncrement;

		int i = 0;

		vec3 cloudColor4 = colorSunlight;
		vec4 cloudSum = vec4(0.0f);
			 cloudSum.rgb = surface.color.rgb;

		float sunglow = min(CalculateSunglow(surface), 2.0);
		
		float cloudDistanceMult = 400.0f / far;

		//float surfaceDistance = length(worldPos);
		float surfaceDistance = length(worldPosition.xyz - cameraPosition.xyz);


		while (rayDepth > 0.0f) {
			//determine worldspace ray position
			vec4 rayPosition = GetCloudSpacePosition(texcoord.st, rayDepth, cloudDistanceMult);

			float rayDistance = length((rayPosition.xyz - cameraPosition.xyz) / cloudDistanceMult);

			vec4 proximity =  CloudColor4(rayPosition, sunglow/1.2, surface.worldLightVector);
				 proximity.a *= cloudDensity;

				 if (surfaceDistance < rayDistance * cloudDistanceMult  && !surface.mask.sky)
				 	proximity.a = 0.0f;

			cloudSum.rgb = mix(cloudSum.rgb, proximity.rgb, vec3(min(1.0f, proximity.a * cloudDensity)) );
			cloudSum.a += proximity.a * cloudDensity;

            cloudSum.r *= CUSTOM_VLFC_R * 0.00390625;
			cloudSum.g *= CUSTOM_VLFC_G * 0.00390625;
			cloudSum.b *= CUSTOM_VLFC_B * 0.00390625;

			//Increment ray
			rayDepth -= rayIncrement / CLOUD_PRECISION2;
			i++;
		}

	sumLight = cloudSum.a * 50.0f;
	surface.color.rgb = mix(surface.color.rgb, surface.color.rgb + cloudSum.rgb * 0.001, vec3(min(1.0f, sumLight)));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	surface.color = pow(textureLod(colortex0, texcoord.st, 0).rgb, vec3(2.2f)) / Hardbaked_HDR;
	surface.normal = GetNormals(texcoord.st);
	surface.depth = GetDepth(texcoord.st);
	surface.linearDepth 		= ExpToLinearDepth(surface.depth); 				//Get linear scene depth
	surface.viewSpacePosition = GetViewSpacePosition(texcoord.st);
	surface.worldSpacePosition = gbufferModelViewInverse * surface.viewSpacePosition;
	FixNormals(surface.normal, surface.viewSpacePosition.xyz);
	surface.lightVector = lightVector;
	surface.sunlightVisibility = GetSunlightVisibility(texcoord.st);
	surface.upVector 	= upVector;
	vec4 wlv 					= shadowModelViewInverse * vec4(0.0f, 0.0f, 0.0f, 1.0f);
	surface.worldLightVector 	= normalize(wlv.xyz);

	surface.specularity = GetSpecularity(texcoord.st);
	surface.roughness = 1.0f - GetRoughness(texcoord.st);
	surface.fresnelPower = 6.0f + surface.roughness * 0.0f;
	surface.baseSpecularity = 0.02f;

	surface.mask.matIDs = GetMaterialIDs(texcoord.st);
	CalculateMasks(surface.mask);

	surface.skylight = GetLightmapSky(texcoord.st);


	surface.cloudAlpha = 0.0f;
	#ifdef SMOOTH_CLOUDS
		surface.cloudAlpha = 0.0;//texture(colortex3, texcoord.st, 2).g;
		SmoothSky(surface);
	#endif

	if (surface.mask.water || surface.mask.ice)
		surface.sunlightVisibility = vec3(1.0);

	WaterRefraction(surface);



	vec4 transparentAlbedo = GetTransparentAlbedo(texcoord.st);

	if (surface.mask.stainedGlass/* || surface.mask.ice*/)
	{
		surface.color *= transparentAlbedo.rgb * 1.0;
	}

	CalculateSpecularReflections(surface);
	////CalculateSpecularHighlight(surface);

	//if (isEyeInWater == 0)
	//{
		//CalculateGlossySpecularReflections(surface);
	//}

	float sumLight = 0.0;
	#ifdef TRUE_VOLUMETRIC_CLOUDS2
	    if(isEyeInWater < 0.5){
		    //CalculateCloud(surface, sumLight);
		}
		//sumLight = clamp(sumLight, 0.0, 1.0);
	#endif	

	#ifdef CREPUSCULAR_RAYS
	////	surface.color += CrepuscularRays(surface) * (1.0 + sumLight * 0.2);
	#endif

	surface.color *= Hardbaked_HDR;

	//surface.color = surface.normal * 0.0001f;

	//surface.color = vec3(fwidth(surface.depth)) * 0.01f;

	//surface.color.rgb = surface.reflection.rgb;

	// surface.color += vec3(max(0.0, dot(surface.normal, normalize(surface.viewSpacePosition.xyz)))) / 100.0f;

	//surface.color = mix(surface.color, vec3(0.0), vec3(surface.cloudAlpha));

	surface.color = pow(surface.color, vec3(1.0f / 2.2f));
	gl_FragData[0] = vec4(surface.color, 1.0f);
	//gl_FragData[1] = vec4(surface.normal.xyz * 0.5 + 0.5, 1.0f);

}

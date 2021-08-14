#if !defined INCLUDE_MATERIALS
#define INCLUDE_MATERIALS

float 	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return floor(texture2D(composite, coord).b * 65535.0 + 0.5);
}

float 	GetMaterialMask(in vec2 coord ,const in int ID, in float matID) {
	return step(float(ID) - 0.5, matID) * step(matID, float(ID) + 0.5);
}

float 	GetMaterialMask(in vec2 coord ,const in int ID) {
  float matID = GetMaterialIDs(coord);

	return step(float(ID) - 0.5, matID) * step(matID, float(ID) + 0.5);
}

#endif

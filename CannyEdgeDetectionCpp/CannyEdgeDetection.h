#pragma once

#ifdef CANNYEDGE_EXPORT
#define CANNYEDGEDETECTION_CPP __declspec(dllexport)
#else
#define CANNYEDGEDETECTION_CPP __declspec(dllimport)
#endif

extern "C" CANNYEDGEDETECTION_CPP void ExecuteCannyEdgeCpp(int arraysize, int height, int width, unsigned short* in_redAddr,
	unsigned short* in_greenAddr, unsigned short* in_blueAddr, unsigned short* out_redAddr,
	unsigned short* out_greenAddr, unsigned short* out_blueAddr);

extern "C" void gradMagnitude(unsigned short red, unsigned short green, unsigned short blue);
extern "C" void hysteresisThresholding();
// CannyEdgeDetection.h

#pragma once

#ifdef CANNYEDGEDETECTION_EXPORT
#define CANNYEDGEDETECTION_CPP __declspec(dllexport)
#else
#define CANNYEDGEDETECTION_CPP __declspec(dllimport)
#endif

extern "C" CANNYEDGEDETECTION_CPP void ExecuteCannyEdgeCpp(int arraysize, int height, int width, unsigned short* in_redAddr,
    unsigned short* in_greenAddr, unsigned short* in_blueAddr, unsigned short* out_redAddr,
    unsigned short* out_greenAddr, unsigned short* out_blueAddr);

extern "C" {
    void gradMagnitude(unsigned short red, unsigned short green, unsigned short blue);
    void hysteresisThresholding(unsigned short* edges, int width, int height, unsigned short* result);
    void nonMaximumSuppression(unsigned short* gradientMagnitude, unsigned short* gradientDirection, int width, int height, unsigned short* edges);
}

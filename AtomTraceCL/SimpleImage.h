#ifndef __ATOM_TRACE_CL_SIMPLE_IMAGE_H_
#define __ATOM_TRACE_CL_SIMPLE_IMAGE_H_

class SimpleImage
{
public:
    SimpleImage();
    SimpleImage(unsigned int w, unsigned int h);
    ~SimpleImage();

    //unsigned char GetChannelAt(unsigned int pixel, unsigned int channelIndex);
    bool SetChannelAt(unsigned int pixel, unsigned int channelIndex, unsigned char value);

    const unsigned char* GetRawData() const;

    unsigned int Width() const;
    unsigned int Height() const;

    bool SavePPM(const char* filename) const;
    bool SavePNG(const char* filename) const;

private:
    unsigned char* m_pData; // 3 channel color, RGB
    unsigned int m_width;
    unsigned int m_height;
};

#endif //__ATOM_TRACE_CL_SIMPLE_IMAGE_H_
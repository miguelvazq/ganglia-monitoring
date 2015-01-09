#ifndef _RRD_GRAPH_WRAPPER_HPP_
#define _RRD_GRAPH_WRAPPER_HPP_

#include "DefaultRRDSettings.hpp"

class MemoryBuffer;
class StringArray;

class CRRDGraphWrapper
{
public:
    static MemoryBuffer* getGraph(MemoryBuffer *pSVGBuffer, const StringArray &strArrRRDFiles, const StringArray &strArrClusters,
                                     const StringArray &strArrServers, const long nStartTime, const long nEndTime, int nWidth,
                                        const int nHeight, const char* pTitle, const bool bGenPNG = false, const char* pRRDGraphPath = NULL);
private:
    static void getUniqueID(const char *pID, StringBuffer &strNewID);

    class CUniquePath
    {
    public:
        CUniquePath();

        virtual ~CUniquePath();

        char* getTempPath(char *pUniqueName);

    private:

        StringBuffer m_strTempDirectory;
    };

};

#endif // _RRD_GRAPH_WRAPPER_HPP_

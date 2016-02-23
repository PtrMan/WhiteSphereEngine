# ===========================================================================

#

# FindOpenCL.cmake

#

# 2011 S.Fendt

#

# It tries to find a valid installed OpenCL-Library (ATI or NVidia). If it

# can find a valid installation, it sets the following variables:

#

# OPENCL_FOUND

# OPENCL_INCLUDE_DIR

# OPENCL_INCLUDE_DIRS

# OPENCL_LIBRARY

# OPENCL_LIBRARIES

#

# ===========================================================================

IF( WIN32 )

     # =======================================================================

     # First try to find something for a windows-environment. This is the most

     # tricky part. Nvidia defines NVSDKCOMPUTE_ROOT for this and ATI defines

     # ATISTREAMSDKROOT... So, at first, we test for these two environment-

     # variable-steared cases.

     # =======================================================================

     

     FIND_PATH(     AMD_OPENCL_BASEDIR

                 "include/CL/cl.h"

                 PATH $ENV{ATISTREAMSDKROOT} )

                 

     FIND_PATH(     NVIDIA_OPENCL_BASEDIR

                 "OpenCL/common/inc/CL/cl.h"

                 PATH  $ENV{NVSDKCOMPUTE_ROOT} )

     

     # Setup for AMD/ATI Stream-SDK

     

     IF( AMD_OPENCL_BASEDIR )

     

         FIND_PATH( OPENCL_INCLUDE_DIR

                    NAMES CL/cl.hpp OpenCL/cl.hpp CL/cl.h OpenCL/cl.h

                    PATHS $ENV{ATISTREAMSDKROOT}include )

                    

         MESSAGE( STATUS

                  "AMD/ATI-Stream-OpenCL-Includepath : " ${AMD_OPENCL_INCLUDES} )

         

         IF( OPENCL_64 )

             FIND_LIBRARY( OPENCL_LIBRARY

                        NAMES OpenCL

                        PATHS $ENV{ATISTREAMSDKROOT}lib/x64_64 )

         ELSE()

             FIND_LIBRARY( OPENCL_LIBRARY

                        NAMES OpenCL

                        PATHS $ENV{ATISTREAMSDKROOT}lib/x64 )

         ENDIF()

         

     ELSE()

     

         MESSAGE( "AMD/ATI-Stream-OpenCL-Implementation: NOT_FOUND" )

         

     ENDIF()

     

     IF( NVIDIA_OPENCL_BASEDIR )

     

         FIND_PATH( OPENCL_INCLUDE_DIR

                    NAMES CL/cl.hpp OpenCL/cl.hpp CL/cl.h OpenCL/cl.h

                    PATHS $ENV{NVSDKCOMPUTE_ROOT}/OpenCL/common/inc/ )

                    

         MESSAGE( STATUS

                  "NVidia-CUDA-OpenCL-Includepath : " ${OPENCL_INCLUDE_DIR})

         

         IF( CMAKE_CL_64 )

             FIND_LIBRARY( OPENCL_LIBRARY

                        NAMES OpenCL

                        PATHS $ENV{NVSDKCOMPUTE_ROOT}/OpenCL/common/lib/x64 )

         ELSE()

             FIND_LIBRARY( OPENCL_LIBRARY

                        NAMES OpenCL

                        PATHS $ENV{NVSDKCOMPUTE_ROOT}/OpenCL/common/lib/Win32 )

         ENDIF()

         

         MESSAGE( STATUS

                  "NVidia-CUDA-OpenCL-Librarypath : " ${OPENCL_LIBRARY})

             

     ELSE()

     

         MESSAGE( "NVIDIA-Cuda-OpenCL-Implementation: NOT_FOUND" )

         

     ENDIF()

ENDIF()

IF( LINUX )

     # =======================================================================

     # for Linux this is easy...

     # =======================================================================

     

     FIND_PATH(     OPENCL_INCLUDE_DIR

                 NAMES CL/cl.h OpenCL/cl.h

                 HINTS ENV OPENCL_DIR

                 PATHS     /include

                         /usr/include

                         /usr/local/include

                         ~/include )

     message( STATUS

              "Found OpenCL-include-path is :" ${OPENCL_INCLUDE_DIR} )

          

     FIND_LIBRARY(    OPENCL_LIBRARY

                     NAMES OpenCL

                     HINTS ENV OPENCL_DIR

                     PATHS   /lib

                             /usr/lib

                             /usr/local/lib

                             ~/lib )

     message( STATUS

              "Found OpenCL-library-path is :" ${OPENCL_LIBRARY} )

ENDIF()

IF( MACOSX )

     # =======================================================================

     # ... no idea at all, currently ...

     # =======================================================================

ENDIF()

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS( OPENCL DEFAULT_MESSAGE

                                    OPENCL_INCLUDE_DIR

                                    OPENCL_LIBRARY )

                                    

MARK_AS_ADVANCED(OPENCL_INCLUDE_DIR OPENCL_LIBRARY)

IF( OPENCL_FOUND )

   LIST(APPEND OPENCL_INCLUDE_DIRS ${OPENCL_INCLUDE_DIR})

   LIST(APPEND OPENCL_LIBRARIES ${OPENCL_LIBRARY})

ENDIF()
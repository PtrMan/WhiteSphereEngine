cmake_minimum_required (VERSION 2.8.11)



include(FindPkgConfig)

SET(EIGEN_INCLUDE "" CACHE PATH "Path to eigen include")



SET(CMAKE_CXX_LINK_EXECUTABLE "python ../DFriendlyLinker.py <CMAKE_CXX_COMPILER> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")


project (PtrEngine)

find_package(OpenGL REQUIRED)

#set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/config)
#find_package(OpenCL REQUIRED)
#if(NOT OPENCL_FOUND)
#    message("ERROR: OpenCL not found")
#endif(NOT OPENCL_FOUND)

pkg_search_module(SDL2 REQUIRED sdl2)
pkg_search_module(LIBEPOXY REQUIRED epoxy)


set(THREAD_CXXFLAGS -pthread)
set(THREAD_LIBS pthread)

include_directories(include ${SDL2_INCLUDE_DIRS} ${LIBEPOXY_INCLUDE_DIRS} ${EIGEN_INCLUDE} ${OPENCL_INCLUDE_DIRS})


add_executable(PtrEngine Test0.cpp src/cpp/OpenClWrapper.cpp src/cpp/Fbo.cpp       ../src/d/glExt.o ../src/d/BufferCppBinding.o ../src/d/Buffer.o ../src/d/MemoryBlock.o ../src/d/MemoryAccessor.o ../src/d/DRuntimeStub.o ../src/d/DMain.o ../src/d/ShaderUtilities.o ../src/d/ShaderProgram.o ../src/d/ErrorStack.o ../src/d/Shader.o ../src/d/IDisposable.o ../src/d/glExtQueryAdresses.o)


# force to link opencl

link_directories(/home/r0b3/github/PtrEngine/build)
set(OPENCL_LINK_FORCE -lOpenCL)

target_link_libraries(PtrEngine ${OPENGL_LIBRARIES} ${SDL2_LIBRARIES} ${LIBEPOXY_LIBRARIES} ${OPENCL_LIBRARIES} ${OPENCL_LINK_FORCE} ${THREAD_LIBS} stdc++ druntime-ldc)
# druntime-ldc



set(CMAKE_CXX_FLAGS "-std=c++11 -g -Wall -Wextra -Wshadow ${THREAD_CXXFLAGS}")

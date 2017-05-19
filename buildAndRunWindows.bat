set VK_INSTANCE_LAYERS=VK_LAYER_LUNARG_api_dump

rem -profile=gc
rdmd --build-only -ofSwapchainTest1.exe gdi32.lib -g -wi  -unittest -Icode/d -I../ErupteD/source -I../linopterixed/code/d --extra-file=src/d/math/ConvertMatrix.d --extra-file=../linopterixed/code/d/linopterixed/AlgebraLib/Utilities.d  src/d/SwapChainTest1.d
rem SwapChainTest1

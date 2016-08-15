set VK_INSTANCE_LAYERS=VK_LAYER_LUNARG_api_dump

rdmd --build-only -ofSwapchainTest1.exe gdi32.lib -g -wi -profile=gc -unittest -IC:\Users\r0b3\github\ErupteD\source src/d/SwapChainTest1.d
rem SwapChainTest1

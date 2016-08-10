set VK_INSTANCE_LAYERS=VK_LAYER_LUNARG_api_dump

rdmd --build-only -ofSwapchainTest1.exe gdi32.lib -g -wi -profile=gc -profile -unittest src/d/SwapChainTest1.d
SwapChainTest1

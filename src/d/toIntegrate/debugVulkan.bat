rem VK_LAYER_LUNARG_api_dump

set  VK_INSTANCE_LAYERS=VK_LAYER_LUNARG_api_dump;VK_LAYER_LUNARG_param_checker
set  VK_DEVICE_LAYERS=VK_LAYER_LUNARG_api_dump;VK_LAYER_LUNARG_param_checker

rem extreme

set  VK_INSTANCE_LAYERS=VK_LAYER_LUNARG_api_dump;VK_LAYER_LUNARG_swapchain;VK_LAYER_LUNARG_standard_validation
set  VK_DEVICE_LAYERS=VK_LAYER_LUNARG_api_dump;VK_LAYER_LUNARG_swapchain;VK_LAYER_LUNARG_standard_validation

rem set  VK_INSTANCE_LAYERS=
rem set  VK_DEVICE_LAYERS=

vulkanTest0.exe

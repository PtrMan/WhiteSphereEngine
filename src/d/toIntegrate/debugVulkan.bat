rem VK_LAYER_LUNARG_api_dump

set  VK_INSTANCE_LAYERS=VK_LAYER_LUNARG_api_dump;VK_LAYER_LUNARG_param_checker
set  VK_DEVICE_LAYERS=VK_LAYER_LUNARG_api_dump;VK_LAYER_LUNARG_param_checker

rem set  VK_INSTANCE_LAYERS=
rem set  VK_DEVICE_LAYERS=

vulkanTest0.exe

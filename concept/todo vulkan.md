- use vkCmdBlitImage for copy for the right conversion

- rendring any # of vertices/storing the buffer alongside the mesh


- variable scissor for resolution change (fullscreen/window)



- instantiated rendering

- depth buffer

- deffered rendering
- HDR (mipmap down in renderpass for fast calculation of total illumination)



in memory allocator / allocator usage
- check device limits for memory limit of memory by memory type and possibly resize the first allocation size to this size


queue allocation:
- in the initialisation of the vulkan : check/watch out for max # of queues

- fullscreen rendering
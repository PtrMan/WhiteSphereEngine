bindless texture
	* https://www.opengl.org/wiki/Bindless_Texture

array texture
	https://www.opengl.org/wiki/Array_Texture
	http://stackoverflow.com/questions/6464673/opengl-loading-images-into-texture-array
	http://stackoverflow.com/questions/24146011/what-are-the-limits-of-texture-array-size



	+ many textures under one handle

sparse texture
	* entension for array texture

	https://www.opengl.org/registry/specs/ARB/sparse_texture.txt

# rendering to uint buffer
	https://devtalk.nvidia.com/default/topic/648994/glsl-rendering-to-integer-texture-uint-vs-float/





OpenGL might achieve comparable performance to Vulkan, in draw calls per second, but also regarding general driver overhead:

# The most recent OpenGL extensions actually remove a lot of driver overhead by making everything bindless (e.g. ARB_direct_state_access (4.5 core), ARB_bindless_texture, ...).
# NV_command_list

# arb_buffer_storage, core in 4.4
	https://www.youtube.com/watch?v=-bCeNzgiJ8I

	With persistent mapping (ARB_buffer_storage, core in 4.4) the buffer memory can be accessed directly by the CPU, thus the synchronization with the GPU is also explicit, just like Vulkan.  <-- usable for concurrent texture upload, particle data upload



OTHER TECHNIQUES
================

https://www.opengl.org/wiki/Transform_Feedback

virtual textures
	http://dl.acm.org/citation.cfm?id=2343488


PRESENTATIONS
=============



http://de.slideshare.net/CassEveritt/beyond-porting


async texture upload
http://higherorderfun.com/blog/2011/05/26/multi-thread-opengl-texture-loading/


// we just copy the input image to the output image

__constant sampler_t sampler =
CLK_NORMALIZED_COORDS_FALSE
| CLK_ADDRESS_CLAMP_TO_EDGE
| CLK_FILTER_NEAREST;

__kernel void kernelCopyImage(
	__read_only image2d_t input,
	__write_only image2d_t output
) {
	const int2 pos = {get_global_id(0), get_global_id(1)};

	float4 pixelValue = read_imagef(input, sampler, pos);

	write_imagef(output, (int2)(pos.x, pos.y), pixelValue);
}

module glExt;

import gl;


// edited and copy pasted from opengl https://www.opengl.org/registry/oldspecs/glext.h

////#ifndef GL_VERSION_1_2
;static const uint  GL_UNSIGNED_BYTE_3_3_2           = 0x8032
;static const uint  GL_UNSIGNED_SHORT_4_4_4_4        = 0x8033
;static const uint  GL_UNSIGNED_SHORT_5_5_5_1        = 0x8034
;static const uint  GL_UNSIGNED_INT_8_8_8_8          = 0x8035
;static const uint  GL_UNSIGNED_INT_10_10_10_2       = 0x8036
;static const uint  GL_TEXTURE_BINDING_3D            = 0x806A
;static const uint  GL_PACK_SKIP_IMAGES              = 0x806B
;static const uint  GL_PACK_IMAGE_HEIGHT             = 0x806C
;static const uint  GL_UNPACK_SKIP_IMAGES            = 0x806D
;static const uint  GL_UNPACK_IMAGE_HEIGHT           = 0x806E
;static const uint  GL_TEXTURE_3D                    = 0x806F
;static const uint  GL_PROXY_TEXTURE_3D              = 0x8070
;static const uint  GL_TEXTURE_DEPTH                 = 0x8071
;static const uint  GL_TEXTURE_WRAP_R                = 0x8072
;static const uint  GL_MAX_3D_TEXTURE_SIZE           = 0x8073
;static const uint  GL_UNSIGNED_BYTE_2_3_3_REV       = 0x8362
;static const uint  GL_UNSIGNED_SHORT_5_6_5          = 0x8363
;static const uint  GL_UNSIGNED_SHORT_5_6_5_REV      = 0x8364
;static const uint  GL_UNSIGNED_SHORT_4_4_4_4_REV    = 0x8365
;static const uint  GL_UNSIGNED_SHORT_1_5_5_5_REV    = 0x8366
;static const uint  GL_UNSIGNED_INT_8_8_8_8_REV      = 0x8367
;static const uint  GL_UNSIGNED_INT_2_10_10_10_REV   = 0x8368
;static const uint  GL_BGR                           = 0x80E0
;static const uint  GL_BGRA                          = 0x80E1
;static const uint  GL_MAX_ELEMENTS_VERTICES         = 0x80E8
;static const uint  GL_MAX_ELEMENTS_INDICES          = 0x80E9
;static const uint  GL_CLAMP_TO_EDGE                 = 0x812F
;static const uint  GL_TEXTURE_MIN_LOD               = 0x813A
;static const uint  GL_TEXTURE_MAX_LOD               = 0x813B
;static const uint  GL_TEXTURE_BASE_LEVEL            = 0x813C
;static const uint  GL_TEXTURE_MAX_LEVEL             = 0x813D
;static const uint  GL_SMOOTH_POINT_SIZE_RANGE       = 0x0B12
;static const uint  GL_SMOOTH_POINT_SIZE_GRANULARITY = 0x0B13
;static const uint  GL_SMOOTH_LINE_WIDTH_RANGE       = 0x0B22
;static const uint  GL_SMOOTH_LINE_WIDTH_GRANULARITY = 0x0B23
;static const uint  GL_ALIASED_LINE_WIDTH_RANGE      = 0x846E
;static const uint  GL_RESCALE_NORMAL                = 0x803A
;static const uint  GL_LIGHT_MODEL_COLOR_CONTROL     = 0x81F8
;static const uint  GL_SINGLE_COLOR                  = 0x81F9
;static const uint  GL_SEPARATE_SPECULAR_COLOR       = 0x81FA
;static const uint  GL_ALIASED_POINT_SIZE_RANGE      = 0x846D
//

////#ifndef GL_ARB_imaging
;static const uint  GL_CONSTANT_COLOR                = 0x8001
;static const uint  GL_ONE_MINUS_CONSTANT_COLOR      = 0x8002
;static const uint  GL_CONSTANT_ALPHA                = 0x8003
;static const uint  GL_ONE_MINUS_CONSTANT_ALPHA      = 0x8004
;static const uint  GL_BLEND_COLOR                   = 0x8005
;static const uint  GL_FUNC_ADD                      = 0x8006
;static const uint  GL_MIN                           = 0x8007
;static const uint  GL_MAX                           = 0x8008
;static const uint  GL_BLEND_EQUATION                = 0x8009
;static const uint  GL_FUNC_SUBTRACT                 = 0x800A
;static const uint  GL_FUNC_REVERSE_SUBTRACT         = 0x800B
;static const uint  GL_CONVOLUTION_1D                = 0x8010
;static const uint  GL_CONVOLUTION_2D                = 0x8011
;static const uint  GL_SEPARABLE_2D                  = 0x8012
;static const uint  GL_CONVOLUTION_BORDER_MODE       = 0x8013
;static const uint  GL_CONVOLUTION_FILTER_SCALE      = 0x8014
;static const uint  GL_CONVOLUTION_FILTER_BIAS       = 0x8015
;static const uint  GL_REDUCE                        = 0x8016
;static const uint  GL_CONVOLUTION_FORMAT            = 0x8017
;static const uint  GL_CONVOLUTION_WIDTH             = 0x8018
;static const uint  GL_CONVOLUTION_HEIGHT            = 0x8019
;static const uint  GL_MAX_CONVOLUTION_WIDTH         = 0x801A
;static const uint  GL_MAX_CONVOLUTION_HEIGHT        = 0x801B
;static const uint  GL_POST_CONVOLUTION_RED_SCALE    = 0x801C
;static const uint  GL_POST_CONVOLUTION_GREEN_SCALE  = 0x801D
;static const uint  GL_POST_CONVOLUTION_BLUE_SCALE   = 0x801E
;static const uint  GL_POST_CONVOLUTION_ALPHA_SCALE  = 0x801F
;static const uint  GL_POST_CONVOLUTION_RED_BIAS     = 0x8020
;static const uint  GL_POST_CONVOLUTION_GREEN_BIAS   = 0x8021
;static const uint  GL_POST_CONVOLUTION_BLUE_BIAS    = 0x8022
;static const uint  GL_POST_CONVOLUTION_ALPHA_BIAS   = 0x8023
;static const uint  GL_HISTOGRAM                     = 0x8024
;static const uint  GL_PROXY_HISTOGRAM               = 0x8025
;static const uint  GL_HISTOGRAM_WIDTH               = 0x8026
;static const uint  GL_HISTOGRAM_FORMAT              = 0x8027
;static const uint  GL_HISTOGRAM_RED_SIZE            = 0x8028
;static const uint  GL_HISTOGRAM_GREEN_SIZE          = 0x8029
;static const uint  GL_HISTOGRAM_BLUE_SIZE           = 0x802A
;static const uint  GL_HISTOGRAM_ALPHA_SIZE          = 0x802B
;static const uint  GL_HISTOGRAM_LUMINANCE_SIZE      = 0x802C
;static const uint  GL_HISTOGRAM_SINK                = 0x802D
;static const uint  GL_MINMAX                        = 0x802E
;static const uint  GL_MINMAX_FORMAT                 = 0x802F
;static const uint  GL_MINMAX_SINK                   = 0x8030
;static const uint  GL_TABLE_TOO_LARGE               = 0x8031
;static const uint  GL_COLOR_MATRIX                  = 0x80B1
;static const uint  GL_COLOR_MATRIX_STACK_DEPTH      = 0x80B2
;static const uint  GL_MAX_COLOR_MATRIX_STACK_DEPTH  = 0x80B3
;static const uint  GL_POST_COLOR_MATRIX_RED_SCALE   = 0x80B4
;static const uint  GL_POST_COLOR_MATRIX_GREEN_SCALE = 0x80B5
;static const uint  GL_POST_COLOR_MATRIX_BLUE_SCALE  = 0x80B6
;static const uint  GL_POST_COLOR_MATRIX_ALPHA_SCALE = 0x80B7
;static const uint  GL_POST_COLOR_MATRIX_RED_BIAS    = 0x80B8
;static const uint  GL_POST_COLOR_MATRIX_GREEN_BIAS  = 0x80B9
;static const uint  GL_POST_COLOR_MATRIX_BLUE_BIAS   = 0x80BA
;static const uint  GL_POST_COLOR_MATRIX_ALPHA_BIAS  = 0x80BB
;static const uint  GL_COLOR_TABLE                   = 0x80D0
;static const uint  GL_POST_CONVOLUTION_COLOR_TABLE  = 0x80D1
;static const uint  GL_POST_COLOR_MATRIX_COLOR_TABLE = 0x80D2
;static const uint  GL_PROXY_COLOR_TABLE             = 0x80D3
;static const uint  GL_PROXY_POST_CONVOLUTION_COLOR_TABLE= 0x80D4
;static const uint  GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE= 0x80D5
;static const uint  GL_COLOR_TABLE_SCALE             = 0x80D6
;static const uint  GL_COLOR_TABLE_BIAS              = 0x80D7
;static const uint  GL_COLOR_TABLE_FORMAT            = 0x80D8
;static const uint  GL_COLOR_TABLE_WIDTH             = 0x80D9
;static const uint  GL_COLOR_TABLE_RED_SIZE          = 0x80DA
;static const uint  GL_COLOR_TABLE_GREEN_SIZE        = 0x80DB
;static const uint  GL_COLOR_TABLE_BLUE_SIZE         = 0x80DC
;static const uint  GL_COLOR_TABLE_ALPHA_SIZE        = 0x80DD
;static const uint  GL_COLOR_TABLE_LUMINANCE_SIZE    = 0x80DE
;static const uint  GL_COLOR_TABLE_INTENSITY_SIZE    = 0x80DF
;static const uint  GL_CONSTANT_BORDER               = 0x8151
;static const uint  GL_REPLICATE_BORDER              = 0x8153
;static const uint  GL_CONVOLUTION_BORDER_COLOR      = 0x8154
//

////#ifndef GL_VERSION_1_3
;static const uint  GL_TEXTURE0                      = 0x84C0
;static const uint  GL_TEXTURE1                      = 0x84C1
;static const uint  GL_TEXTURE2                      = 0x84C2
;static const uint  GL_TEXTURE3                      = 0x84C3
;static const uint  GL_TEXTURE4                      = 0x84C4
;static const uint  GL_TEXTURE5                      = 0x84C5
;static const uint  GL_TEXTURE6                      = 0x84C6
;static const uint  GL_TEXTURE7                      = 0x84C7
;static const uint  GL_TEXTURE8                      = 0x84C8
;static const uint  GL_TEXTURE9                      = 0x84C9
;static const uint  GL_TEXTURE10                     = 0x84CA
;static const uint  GL_TEXTURE11                     = 0x84CB
;static const uint  GL_TEXTURE12                     = 0x84CC
;static const uint  GL_TEXTURE13                     = 0x84CD
;static const uint  GL_TEXTURE14                     = 0x84CE
;static const uint  GL_TEXTURE15                     = 0x84CF
;static const uint  GL_TEXTURE16                     = 0x84D0
;static const uint  GL_TEXTURE17                     = 0x84D1
;static const uint  GL_TEXTURE18                     = 0x84D2
;static const uint  GL_TEXTURE19                     = 0x84D3
;static const uint  GL_TEXTURE20                     = 0x84D4
;static const uint  GL_TEXTURE21                     = 0x84D5
;static const uint  GL_TEXTURE22                     = 0x84D6
;static const uint  GL_TEXTURE23                     = 0x84D7
;static const uint  GL_TEXTURE24                     = 0x84D8
;static const uint  GL_TEXTURE25                     = 0x84D9
;static const uint  GL_TEXTURE26                     = 0x84DA
;static const uint  GL_TEXTURE27                     = 0x84DB
;static const uint  GL_TEXTURE28                     = 0x84DC
;static const uint  GL_TEXTURE29                     = 0x84DD
;static const uint  GL_TEXTURE30                     = 0x84DE
;static const uint  GL_TEXTURE31                     = 0x84DF
;static const uint  GL_ACTIVE_TEXTURE                = 0x84E0
;static const uint  GL_MULTISAMPLE                   = 0x809D
;static const uint  GL_SAMPLE_ALPHA_TO_COVERAGE      = 0x809E
;static const uint  GL_SAMPLE_ALPHA_TO_ONE           = 0x809F
;static const uint  GL_SAMPLE_COVERAGE               = 0x80A0
;static const uint  GL_SAMPLE_BUFFERS                = 0x80A8
;static const uint  GL_SAMPLES                       = 0x80A9
;static const uint  GL_SAMPLE_COVERAGE_VALUE         = 0x80AA
;static const uint  GL_SAMPLE_COVERAGE_INVERT        = 0x80AB
;static const uint  GL_TEXTURE_CUBE_MAP              = 0x8513
;static const uint  GL_TEXTURE_BINDING_CUBE_MAP      = 0x8514
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_X   = 0x8515
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_X   = 0x8516
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_Y   = 0x8517
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y   = 0x8518
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_Z   = 0x8519
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z   = 0x851A
;static const uint  GL_PROXY_TEXTURE_CUBE_MAP        = 0x851B
;static const uint  GL_MAX_CUBE_MAP_TEXTURE_SIZE     = 0x851C
;static const uint  GL_COMPRESSED_RGB                = 0x84ED
;static const uint  GL_COMPRESSED_RGBA               = 0x84EE
;static const uint  GL_TEXTURE_COMPRESSION_HINT      = 0x84EF
;static const uint  GL_TEXTURE_COMPRESSED_IMAGE_SIZE = 0x86A0
;static const uint  GL_TEXTURE_COMPRESSED            = 0x86A1
;static const uint  GL_NUM_COMPRESSED_TEXTURE_FORMATS= 0x86A2
;static const uint  GL_COMPRESSED_TEXTURE_FORMATS    = 0x86A3
;static const uint  GL_CLAMP_TO_BORDER               = 0x812D
;static const uint  GL_CLIENT_ACTIVE_TEXTURE         = 0x84E1
;static const uint  GL_MAX_TEXTURE_UNITS             = 0x84E2
;static const uint  GL_TRANSPOSE_MODELVIEW_MATRIX    = 0x84E3
;static const uint  GL_TRANSPOSE_PROJECTION_MATRIX   = 0x84E4
;static const uint  GL_TRANSPOSE_TEXTURE_MATRIX      = 0x84E5
;static const uint  GL_TRANSPOSE_COLOR_MATRIX        = 0x84E6
;static const uint  GL_MULTISAMPLE_BIT               = 0x20000000
;static const uint  GL_NORMAL_MAP                    = 0x8511
;static const uint  GL_REFLECTION_MAP                = 0x8512
;static const uint  GL_COMPRESSED_ALPHA              = 0x84E9
;static const uint  GL_COMPRESSED_LUMINANCE          = 0x84EA
;static const uint  GL_COMPRESSED_LUMINANCE_ALPHA    = 0x84EB
;static const uint  GL_COMPRESSED_INTENSITY          = 0x84EC
;static const uint  GL_COMBINE                       = 0x8570
;static const uint  GL_COMBINE_RGB                   = 0x8571
;static const uint  GL_COMBINE_ALPHA                 = 0x8572
;static const uint  GL_SOURCE0_RGB                   = 0x8580
;static const uint  GL_SOURCE1_RGB                   = 0x8581
;static const uint  GL_SOURCE2_RGB                   = 0x8582
;static const uint  GL_SOURCE0_ALPHA                 = 0x8588
;static const uint  GL_SOURCE1_ALPHA                 = 0x8589
;static const uint  GL_SOURCE2_ALPHA                 = 0x858A
;static const uint  GL_OPERAND0_RGB                  = 0x8590
;static const uint  GL_OPERAND1_RGB                  = 0x8591
;static const uint  GL_OPERAND2_RGB                  = 0x8592
;static const uint  GL_OPERAND0_ALPHA                = 0x8598
;static const uint  GL_OPERAND1_ALPHA                = 0x8599
;static const uint  GL_OPERAND2_ALPHA                = 0x859A
;static const uint  GL_RGB_SCALE                     = 0x8573
;static const uint  GL_ADD_SIGNED                    = 0x8574
;static const uint  GL_INTERPOLATE                   = 0x8575
;static const uint  GL_SUBTRACT                      = 0x84E7
;static const uint  GL_CONSTANT                      = 0x8576
;static const uint  GL_PRIMARY_COLOR                 = 0x8577
;static const uint  GL_PREVIOUS                      = 0x8578
;static const uint  GL_DOT3_RGB                      = 0x86AE
;static const uint  GL_DOT3_RGBA                     = 0x86AF
//

////#ifndef GL_VERSION_1_4
;static const uint  GL_BLEND_DST_RGB                 = 0x80C8
;static const uint  GL_BLEND_SRC_RGB                 = 0x80C9
;static const uint  GL_BLEND_DST_ALPHA               = 0x80CA
;static const uint  GL_BLEND_SRC_ALPHA               = 0x80CB
;static const uint  GL_POINT_FADE_THRESHOLD_SIZE     = 0x8128
;static const uint  GL_DEPTH_COMPONENT16             = 0x81A5
;static const uint  GL_DEPTH_COMPONENT24             = 0x81A6
;static const uint  GL_DEPTH_COMPONENT32             = 0x81A7
;static const uint  GL_MIRRORED_REPEAT               = 0x8370
;static const uint  GL_MAX_TEXTURE_LOD_BIAS          = 0x84FD
;static const uint  GL_TEXTURE_LOD_BIAS              = 0x8501
;static const uint  GL_INCR_WRAP                     = 0x8507
;static const uint  GL_DECR_WRAP                     = 0x8508
;static const uint  GL_TEXTURE_DEPTH_SIZE            = 0x884A
;static const uint  GL_TEXTURE_COMPARE_MODE          = 0x884C
;static const uint  GL_TEXTURE_COMPARE_FUNC          = 0x884D
;static const uint  GL_POINT_SIZE_MIN                = 0x8126
;static const uint  GL_POINT_SIZE_MAX                = 0x8127
;static const uint  GL_POINT_DISTANCE_ATTENUATION    = 0x8129
;static const uint  GL_GENERATE_MIPMAP               = 0x8191
;static const uint  GL_GENERATE_MIPMAP_HINT          = 0x8192
;static const uint  GL_FOG_COORDINATE_SOURCE         = 0x8450
;static const uint  GL_FOG_COORDINATE                = 0x8451
;static const uint  GL_FRAGMENT_DEPTH                = 0x8452
;static const uint  GL_CURRENT_FOG_COORDINATE        = 0x8453
;static const uint  GL_FOG_COORDINATE_ARRAY_TYPE     = 0x8454
;static const uint  GL_FOG_COORDINATE_ARRAY_STRIDE   = 0x8455
;static const uint  GL_FOG_COORDINATE_ARRAY_POINTER  = 0x8456
;static const uint  GL_FOG_COORDINATE_ARRAY          = 0x8457
;static const uint  GL_COLOR_SUM                     = 0x8458
;static const uint  GL_CURRENT_SECONDARY_COLOR       = 0x8459
;static const uint  GL_SECONDARY_COLOR_ARRAY_SIZE    = 0x845A
;static const uint  GL_SECONDARY_COLOR_ARRAY_TYPE    = 0x845B
;static const uint  GL_SECONDARY_COLOR_ARRAY_STRIDE  = 0x845C
;static const uint  GL_SECONDARY_COLOR_ARRAY_POINTER = 0x845D
;static const uint  GL_SECONDARY_COLOR_ARRAY         = 0x845E
;static const uint  GL_TEXTURE_FILTER_CONTROL        = 0x8500
;static const uint  GL_DEPTH_TEXTURE_MODE            = 0x884B
;static const uint  GL_COMPARE_R_TO_TEXTURE          = 0x884E
//

////#ifndef GL_VERSION_1_5
;static const uint  GL_BUFFER_SIZE                   = 0x8764
;static const uint  GL_BUFFER_USAGE                  = 0x8765
;static const uint  GL_QUERY_COUNTER_BITS            = 0x8864
;static const uint  GL_CURRENT_QUERY                 = 0x8865
;static const uint  GL_QUERY_RESULT                  = 0x8866
;static const uint  GL_QUERY_RESULT_AVAILABLE        = 0x8867
;static const uint  GL_ARRAY_BUFFER                  = 0x8892
;static const uint  GL_ELEMENT_ARRAY_BUFFER          = 0x8893
;static const uint  GL_ARRAY_BUFFER_BINDING          = 0x8894
;static const uint  GL_ELEMENT_ARRAY_BUFFER_BINDING  = 0x8895
;static const uint  GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING= 0x889F
;static const uint  GL_READ_ONLY                     = 0x88B8
;static const uint  GL_WRITE_ONLY                    = 0x88B9
;static const uint  GL_READ_WRITE                    = 0x88BA
;static const uint  GL_BUFFER_ACCESS                 = 0x88BB
;static const uint  GL_BUFFER_MAPPED                 = 0x88BC
;static const uint  GL_BUFFER_MAP_POINTER            = 0x88BD
;static const uint  GL_STREAM_DRAW                   = 0x88E0
;static const uint  GL_STREAM_READ                   = 0x88E1
;static const uint  GL_STREAM_COPY                   = 0x88E2
;static const uint  GL_STATIC_DRAW                   = 0x88E4
;static const uint  GL_STATIC_READ                   = 0x88E5
;static const uint  GL_STATIC_COPY                   = 0x88E6
;static const uint  GL_DYNAMIC_DRAW                  = 0x88E8
;static const uint  GL_DYNAMIC_READ                  = 0x88E9
;static const uint  GL_DYNAMIC_COPY                  = 0x88EA
;static const uint  GL_SAMPLES_PASSED                = 0x8914
;static const uint  GL_SRC1_ALPHA                    = 0x8589
;static const uint  GL_VERTEX_ARRAY_BUFFER_BINDING   = 0x8896
;static const uint  GL_NORMAL_ARRAY_BUFFER_BINDING   = 0x8897
;static const uint  GL_COLOR_ARRAY_BUFFER_BINDING    = 0x8898
;static const uint  GL_INDEX_ARRAY_BUFFER_BINDING    = 0x8899
;static const uint  GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING= 0x889A
;static const uint  GL_EDGE_FLAG_ARRAY_BUFFER_BINDING= 0x889B
;static const uint  GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING= 0x889C
;static const uint  GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING= 0x889D
;static const uint  GL_WEIGHT_ARRAY_BUFFER_BINDING   = 0x889E
;static const uint  GL_FOG_COORD_SRC                 = 0x8450
;static const uint  GL_FOG_COORD                     = 0x8451
;static const uint  GL_CURRENT_FOG_COORD             = 0x8453
;static const uint  GL_FOG_COORD_ARRAY_TYPE          = 0x8454
;static const uint  GL_FOG_COORD_ARRAY_STRIDE        = 0x8455
;static const uint  GL_FOG_COORD_ARRAY_POINTER       = 0x8456
;static const uint  GL_FOG_COORD_ARRAY               = 0x8457
;static const uint  GL_FOG_COORD_ARRAY_BUFFER_BINDING= 0x889D
;static const uint  GL_SRC0_RGB                      = 0x8580
;static const uint  GL_SRC1_RGB                      = 0x8581
;static const uint  GL_SRC2_RGB                      = 0x8582
;static const uint  GL_SRC0_ALPHA                    = 0x8588
;static const uint  GL_SRC2_ALPHA                    = 0x858A
//

////#ifndef GL_VERSION_2_0
;static const uint  GL_BLEND_EQUATION_RGB            = 0x8009
;static const uint  GL_VERTEX_ATTRIB_ARRAY_ENABLED   = 0x8622
;static const uint  GL_VERTEX_ATTRIB_ARRAY_SIZE      = 0x8623
;static const uint  GL_VERTEX_ATTRIB_ARRAY_STRIDE    = 0x8624
;static const uint  GL_VERTEX_ATTRIB_ARRAY_TYPE      = 0x8625
;static const uint  GL_CURRENT_VERTEX_ATTRIB         = 0x8626
;static const uint  GL_VERTEX_PROGRAM_POINT_SIZE     = 0x8642
;static const uint  GL_VERTEX_ATTRIB_ARRAY_POINTER   = 0x8645
;static const uint  GL_STENCIL_BACK_FUNC             = 0x8800
;static const uint  GL_STENCIL_BACK_FAIL             = 0x8801
;static const uint  GL_STENCIL_BACK_PASS_DEPTH_FAIL  = 0x8802
;static const uint  GL_STENCIL_BACK_PASS_DEPTH_PASS  = 0x8803
;static const uint  GL_MAX_DRAW_BUFFERS              = 0x8824
;static const uint  GL_DRAW_BUFFER0                  = 0x8825
;static const uint  GL_DRAW_BUFFER1                  = 0x8826
;static const uint  GL_DRAW_BUFFER2                  = 0x8827
;static const uint  GL_DRAW_BUFFER3                  = 0x8828
;static const uint  GL_DRAW_BUFFER4                  = 0x8829
;static const uint  GL_DRAW_BUFFER5                  = 0x882A
;static const uint  GL_DRAW_BUFFER6                  = 0x882B
;static const uint  GL_DRAW_BUFFER7                  = 0x882C
;static const uint  GL_DRAW_BUFFER8                  = 0x882D
;static const uint  GL_DRAW_BUFFER9                  = 0x882E
;static const uint  GL_DRAW_BUFFER10                 = 0x882F
;static const uint  GL_DRAW_BUFFER11                 = 0x8830
;static const uint  GL_DRAW_BUFFER12                 = 0x8831
;static const uint  GL_DRAW_BUFFER13                 = 0x8832
;static const uint  GL_DRAW_BUFFER14                 = 0x8833
;static const uint  GL_DRAW_BUFFER15                 = 0x8834
;static const uint  GL_BLEND_EQUATION_ALPHA          = 0x883D
;static const uint  GL_MAX_VERTEX_ATTRIBS            = 0x8869
;static const uint  GL_VERTEX_ATTRIB_ARRAY_NORMALIZED= 0x886A
;static const uint  GL_MAX_TEXTURE_IMAGE_UNITS       = 0x8872
;static const uint  GL_FRAGMENT_SHADER               = 0x8B30
;static const uint  GL_VERTEX_SHADER                 = 0x8B31
;static const uint  GL_MAX_FRAGMENT_UNIFORM_COMPONENTS= 0x8B49
;static const uint  GL_MAX_VERTEX_UNIFORM_COMPONENTS = 0x8B4A
;static const uint  GL_MAX_VARYING_FLOATS            = 0x8B4B
;static const uint  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS= 0x8B4C
;static const uint  GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS= 0x8B4D
;static const uint  GL_SHADER_TYPE                   = 0x8B4F
;static const uint  GL_FLOAT_VEC2                    = 0x8B50
;static const uint  GL_FLOAT_VEC3                    = 0x8B51
;static const uint  GL_FLOAT_VEC4                    = 0x8B52
;static const uint  GL_INT_VEC2                      = 0x8B53
;static const uint  GL_INT_VEC3                      = 0x8B54
;static const uint  GL_INT_VEC4                      = 0x8B55
;static const uint  GL_BOOL                          = 0x8B56
;static const uint  GL_BOOL_VEC2                     = 0x8B57
;static const uint  GL_BOOL_VEC3                     = 0x8B58
;static const uint  GL_BOOL_VEC4                     = 0x8B59
;static const uint  GL_FLOAT_MAT2                    = 0x8B5A
;static const uint  GL_FLOAT_MAT3                    = 0x8B5B
;static const uint  GL_FLOAT_MAT4                    = 0x8B5C
;static const uint  GL_SAMPLER_1D                    = 0x8B5D
;static const uint  GL_SAMPLER_2D                    = 0x8B5E
;static const uint  GL_SAMPLER_3D                    = 0x8B5F
;static const uint  GL_SAMPLER_CUBE                  = 0x8B60
;static const uint  GL_SAMPLER_1D_SHADOW             = 0x8B61
;static const uint  GL_SAMPLER_2D_SHADOW             = 0x8B62
;static const uint  GL_DELETE_STATUS                 = 0x8B80
;static const uint  GL_COMPILE_STATUS                = 0x8B81
;static const uint  GL_LINK_STATUS                   = 0x8B82
;static const uint  GL_VALIDATE_STATUS               = 0x8B83
;static const uint  GL_INFO_LOG_LENGTH               = 0x8B84
;static const uint  GL_ATTACHED_SHADERS              = 0x8B85
;static const uint  GL_ACTIVE_UNIFORMS               = 0x8B86
;static const uint  GL_ACTIVE_UNIFORM_MAX_LENGTH     = 0x8B87
;static const uint  GL_SHADER_SOURCE_LENGTH          = 0x8B88
;static const uint  GL_ACTIVE_ATTRIBUTES             = 0x8B89
;static const uint  GL_ACTIVE_ATTRIBUTE_MAX_LENGTH   = 0x8B8A
;static const uint  GL_FRAGMENT_SHADER_DERIVATIVE_HINT= 0x8B8B
;static const uint  GL_SHADING_LANGUAGE_VERSION      = 0x8B8C
;static const uint  GL_CURRENT_PROGRAM               = 0x8B8D
;static const uint  GL_POINT_SPRITE_COORD_ORIGIN     = 0x8CA0
;static const uint  GL_LOWER_LEFT                    = 0x8CA1
;static const uint  GL_UPPER_LEFT                    = 0x8CA2
;static const uint  GL_STENCIL_BACK_REF              = 0x8CA3
;static const uint  GL_STENCIL_BACK_VALUE_MASK       = 0x8CA4
;static const uint  GL_STENCIL_BACK_WRITEMASK        = 0x8CA5
;static const uint  GL_VERTEX_PROGRAM_TWO_SIDE       = 0x8643
;static const uint  GL_POINT_SPRITE                  = 0x8861
;static const uint  GL_COORD_REPLACE                 = 0x8862
;static const uint  GL_MAX_TEXTURE_COORDS            = 0x8871
//

////#ifndef GL_VERSION_2_1
;static const uint  GL_PIXEL_PACK_BUFFER             = 0x88EB
;static const uint  GL_PIXEL_UNPACK_BUFFER           = 0x88EC
;static const uint  GL_PIXEL_PACK_BUFFER_BINDING     = 0x88ED
;static const uint  GL_PIXEL_UNPACK_BUFFER_BINDING   = 0x88EF
;static const uint  GL_FLOAT_MAT2x3                  = 0x8B65
;static const uint  GL_FLOAT_MAT2x4                  = 0x8B66
;static const uint  GL_FLOAT_MAT3x2                  = 0x8B67
;static const uint  GL_FLOAT_MAT3x4                  = 0x8B68
;static const uint  GL_FLOAT_MAT4x2                  = 0x8B69
;static const uint  GL_FLOAT_MAT4x3                  = 0x8B6A
;static const uint  GL_SRGB                          = 0x8C40
;static const uint  GL_SRGB8                         = 0x8C41
;static const uint  GL_SRGB_ALPHA                    = 0x8C42
;static const uint  GL_SRGB8_ALPHA8                  = 0x8C43
;static const uint  GL_COMPRESSED_SRGB               = 0x8C48
;static const uint  GL_COMPRESSED_SRGB_ALPHA         = 0x8C49
;static const uint  GL_CURRENT_RASTER_SECONDARY_COLOR= 0x845F
;static const uint  GL_SLUMINANCE_ALPHA              = 0x8C44
;static const uint  GL_SLUMINANCE8_ALPHA8            = 0x8C45
;static const uint  GL_SLUMINANCE                    = 0x8C46
;static const uint  GL_SLUMINANCE8                   = 0x8C47
;static const uint  GL_COMPRESSED_SLUMINANCE         = 0x8C4A
;static const uint  GL_COMPRESSED_SLUMINANCE_ALPHA   = 0x8C4B
//

////#ifndef GL_VERSION_3_0
;static const uint  GL_COMPARE_REF_TO_TEXTURE        = 0x884E
;static const uint  GL_CLIP_DISTANCE0                = 0x3000
;static const uint  GL_CLIP_DISTANCE1                = 0x3001
;static const uint  GL_CLIP_DISTANCE2                = 0x3002
;static const uint  GL_CLIP_DISTANCE3                = 0x3003
;static const uint  GL_CLIP_DISTANCE4                = 0x3004
;static const uint  GL_CLIP_DISTANCE5                = 0x3005
;static const uint  GL_CLIP_DISTANCE6                = 0x3006
;static const uint  GL_CLIP_DISTANCE7                = 0x3007
;static const uint  GL_MAX_CLIP_DISTANCES            = 0x0D32
;static const uint  GL_MAJOR_VERSION                 = 0x821B
;static const uint  GL_MINOR_VERSION                 = 0x821C
;static const uint  GL_NUM_EXTENSIONS                = 0x821D
;static const uint  GL_CONTEXT_FLAGS                 = 0x821E
;static const uint  GL_COMPRESSED_RED                = 0x8225
;static const uint  GL_COMPRESSED_RG                 = 0x8226
;static const uint  GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT= 0x00000001
;static const uint  GL_RGBA32F                       = 0x8814
;static const uint  GL_RGB32F                        = 0x8815
;static const uint  GL_RGBA16F                       = 0x881A
;static const uint  GL_RGB16F                        = 0x881B
;static const uint  GL_VERTEX_ATTRIB_ARRAY_INTEGER   = 0x88FD
;static const uint  GL_MAX_ARRAY_TEXTURE_LAYERS      = 0x88FF
;static const uint  GL_MIN_PROGRAM_TEXEL_OFFSET      = 0x8904
;static const uint  GL_MAX_PROGRAM_TEXEL_OFFSET      = 0x8905
;static const uint  GL_CLAMP_READ_COLOR              = 0x891C
;static const uint  GL_FIXED_ONLY                    = 0x891D
;static const uint  GL_MAX_VARYING_COMPONENTS        = 0x8B4B
;static const uint  GL_TEXTURE_1D_ARRAY              = 0x8C18
;static const uint  GL_PROXY_TEXTURE_1D_ARRAY        = 0x8C19
;static const uint  GL_TEXTURE_2D_ARRAY              = 0x8C1A
;static const uint  GL_PROXY_TEXTURE_2D_ARRAY        = 0x8C1B
;static const uint  GL_TEXTURE_BINDING_1D_ARRAY      = 0x8C1C
;static const uint  GL_TEXTURE_BINDING_2D_ARRAY      = 0x8C1D
;static const uint  GL_R11F_G11F_B10F                = 0x8C3A
;static const uint  GL_UNSIGNED_INT_10F_11F_11F_REV  = 0x8C3B
;static const uint  GL_RGB9_E5                       = 0x8C3D
;static const uint  GL_UNSIGNED_INT_5_9_9_9_REV      = 0x8C3E
;static const uint  GL_TEXTURE_SHARED_SIZE           = 0x8C3F
;static const uint  GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH= 0x8C76
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_MODE= 0x8C7F
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS= 0x8C80
;static const uint  GL_TRANSFORM_FEEDBACK_VARYINGS   = 0x8C83
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_START= 0x8C84
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_SIZE= 0x8C85
;static const uint  GL_PRIMITIVES_GENERATED          = 0x8C87
;static const uint  GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN= 0x8C88
;static const uint  GL_RASTERIZER_DISCARD            = 0x8C89
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS= 0x8C8A
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS= 0x8C8B
;static const uint  GL_INTERLEAVED_ATTRIBS           = 0x8C8C
;static const uint  GL_SEPARATE_ATTRIBS              = 0x8C8D
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER     = 0x8C8E
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_BINDING= 0x8C8F
;static const uint  GL_RGBA32UI                      = 0x8D70
;static const uint  GL_RGB32UI                       = 0x8D71
;static const uint  GL_RGBA16UI                      = 0x8D76
;static const uint  GL_RGB16UI                       = 0x8D77
;static const uint  GL_RGBA8UI                       = 0x8D7C
;static const uint  GL_RGB8UI                        = 0x8D7D
;static const uint  GL_RGBA32I                       = 0x8D82
;static const uint  GL_RGB32I                        = 0x8D83
;static const uint  GL_RGBA16I                       = 0x8D88
;static const uint  GL_RGB16I                        = 0x8D89
;static const uint  GL_RGBA8I                        = 0x8D8E
;static const uint  GL_RGB8I                         = 0x8D8F
;static const uint  GL_RED_INTEGER                   = 0x8D94
;static const uint  GL_GREEN_INTEGER                 = 0x8D95
;static const uint  GL_BLUE_INTEGER                  = 0x8D96
;static const uint  GL_RGB_INTEGER                   = 0x8D98
;static const uint  GL_RGBA_INTEGER                  = 0x8D99
;static const uint  GL_BGR_INTEGER                   = 0x8D9A
;static const uint  GL_BGRA_INTEGER                  = 0x8D9B
;static const uint  GL_SAMPLER_1D_ARRAY              = 0x8DC0
;static const uint  GL_SAMPLER_2D_ARRAY              = 0x8DC1
;static const uint  GL_SAMPLER_1D_ARRAY_SHADOW       = 0x8DC3
;static const uint  GL_SAMPLER_2D_ARRAY_SHADOW       = 0x8DC4
;static const uint  GL_SAMPLER_CUBE_SHADOW           = 0x8DC5
;static const uint  GL_UNSIGNED_INT_VEC2             = 0x8DC6
;static const uint  GL_UNSIGNED_INT_VEC3             = 0x8DC7
;static const uint  GL_UNSIGNED_INT_VEC4             = 0x8DC8
;static const uint  GL_INT_SAMPLER_1D                = 0x8DC9
;static const uint  GL_INT_SAMPLER_2D                = 0x8DCA
;static const uint  GL_INT_SAMPLER_3D                = 0x8DCB
;static const uint  GL_INT_SAMPLER_CUBE              = 0x8DCC
;static const uint  GL_INT_SAMPLER_1D_ARRAY          = 0x8DCE
;static const uint  GL_INT_SAMPLER_2D_ARRAY          = 0x8DCF
;static const uint  GL_UNSIGNED_INT_SAMPLER_1D       = 0x8DD1
;static const uint  GL_UNSIGNED_INT_SAMPLER_2D       = 0x8DD2
;static const uint  GL_UNSIGNED_INT_SAMPLER_3D       = 0x8DD3
;static const uint  GL_UNSIGNED_INT_SAMPLER_CUBE     = 0x8DD4
;static const uint  GL_UNSIGNED_INT_SAMPLER_1D_ARRAY = 0x8DD6
;static const uint  GL_UNSIGNED_INT_SAMPLER_2D_ARRAY = 0x8DD7
;static const uint  GL_QUERY_WAIT                    = 0x8E13
;static const uint  GL_QUERY_NO_WAIT                 = 0x8E14
;static const uint  GL_QUERY_BY_REGION_WAIT          = 0x8E15
;static const uint  GL_QUERY_BY_REGION_NO_WAIT       = 0x8E16
;static const uint  GL_BUFFER_ACCESS_FLAGS           = 0x911F
;static const uint  GL_BUFFER_MAP_LENGTH             = 0x9120
;static const uint  GL_BUFFER_MAP_OFFSET             = 0x9121
/* Reuse tokens from ARB_depth_buffer_float */
/* reuse GL_DEPTH_COMPONENT32F */
/* reuse GL_DEPTH32F_STENCIL8 */
/* reuse GL_FLOAT_32_UNSIGNED_INT_24_8_REV */
/* Reuse tokens from ARB_framebuffer_object */
/* reuse GL_INVALID_FRAMEBUFFER_OPERATION */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE */
/* reuse GL_FRAMEBUFFER_DEFAULT */
/* reuse GL_FRAMEBUFFER_UNDEFINED */
/* reuse GL_DEPTH_STENCIL_ATTACHMENT */
/* reuse GL_INDEX */
/* reuse GL_MAX_RENDERBUFFER_SIZE */
/* reuse GL_DEPTH_STENCIL */
/* reuse GL_UNSIGNED_INT_24_8 */
/* reuse GL_DEPTH24_STENCIL8 */
/* reuse GL_TEXTURE_STENCIL_SIZE */
/* reuse GL_TEXTURE_RED_TYPE */
/* reuse GL_TEXTURE_GREEN_TYPE */
/* reuse GL_TEXTURE_BLUE_TYPE */
/* reuse GL_TEXTURE_ALPHA_TYPE */
/* reuse GL_TEXTURE_DEPTH_TYPE */
/* reuse GL_UNSIGNED_NORMALIZED */
/* reuse GL_FRAMEBUFFER_BINDING */
/* reuse GL_DRAW_FRAMEBUFFER_BINDING */
/* reuse GL_RENDERBUFFER_BINDING */
/* reuse GL_READ_FRAMEBUFFER */
/* reuse GL_DRAW_FRAMEBUFFER */
/* reuse GL_READ_FRAMEBUFFER_BINDING */
/* reuse GL_RENDERBUFFER_SAMPLES */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER */
/* reuse GL_FRAMEBUFFER_COMPLETE */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER */
/* reuse GL_FRAMEBUFFER_UNSUPPORTED */
/* reuse GL_MAX_COLOR_ATTACHMENTS */
/* reuse GL_COLOR_ATTACHMENT0 */
/* reuse GL_COLOR_ATTACHMENT1 */
/* reuse GL_COLOR_ATTACHMENT2 */
/* reuse GL_COLOR_ATTACHMENT3 */
/* reuse GL_COLOR_ATTACHMENT4 */
/* reuse GL_COLOR_ATTACHMENT5 */
/* reuse GL_COLOR_ATTACHMENT6 */
/* reuse GL_COLOR_ATTACHMENT7 */
/* reuse GL_COLOR_ATTACHMENT8 */
/* reuse GL_COLOR_ATTACHMENT9 */
/* reuse GL_COLOR_ATTACHMENT10 */
/* reuse GL_COLOR_ATTACHMENT11 */
/* reuse GL_COLOR_ATTACHMENT12 */
/* reuse GL_COLOR_ATTACHMENT13 */
/* reuse GL_COLOR_ATTACHMENT14 */
/* reuse GL_COLOR_ATTACHMENT15 */
/* reuse GL_DEPTH_ATTACHMENT */
/* reuse GL_STENCIL_ATTACHMENT */
/* reuse GL_FRAMEBUFFER */
/* reuse GL_RENDERBUFFER */
/* reuse GL_RENDERBUFFER_WIDTH */
/* reuse GL_RENDERBUFFER_HEIGHT */
/* reuse GL_RENDERBUFFER_INTERNAL_FORMAT */
/* reuse GL_STENCIL_INDEX1 */
/* reuse GL_STENCIL_INDEX4 */
/* reuse GL_STENCIL_INDEX8 */
/* reuse GL_STENCIL_INDEX16 */
/* reuse GL_RENDERBUFFER_RED_SIZE */
/* reuse GL_RENDERBUFFER_GREEN_SIZE */
/* reuse GL_RENDERBUFFER_BLUE_SIZE */
/* reuse GL_RENDERBUFFER_ALPHA_SIZE */
/* reuse GL_RENDERBUFFER_DEPTH_SIZE */
/* reuse GL_RENDERBUFFER_STENCIL_SIZE */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE */
/* reuse GL_MAX_SAMPLES */
/* Reuse tokens from ARB_framebuffer_sRGB */
/* reuse GL_FRAMEBUFFER_SRGB */
/* Reuse tokens from ARB_half_float_vertex */
/* reuse GL_HALF_FLOAT */
/* Reuse tokens from ARB_map_buffer_range */
/* reuse GL_MAP_READ_BIT */
/* reuse GL_MAP_WRITE_BIT */
/* reuse GL_MAP_INVALIDATE_RANGE_BIT */
/* reuse GL_MAP_INVALIDATE_BUFFER_BIT */
/* reuse GL_MAP_FLUSH_EXPLICIT_BIT */
/* reuse GL_MAP_UNSYNCHRONIZED_BIT */
/* Reuse tokens from ARB_texture_compression_rgtc */
/* reuse GL_COMPRESSED_RED_RGTC1 */
/* reuse GL_COMPRESSED_SIGNED_RED_RGTC1 */
/* reuse GL_COMPRESSED_RG_RGTC2 */
/* reuse GL_COMPRESSED_SIGNED_RG_RGTC2 */
/* Reuse tokens from ARB_texture_rg */
/* reuse GL_RG */
/* reuse GL_RG_INTEGER */
/* reuse GL_R8 */
/* reuse GL_R16 */
/* reuse GL_RG8 */
/* reuse GL_RG16 */
/* reuse GL_R16F */
/* reuse GL_R32F */
/* reuse GL_RG16F */
/* reuse GL_RG32F */
/* reuse GL_R8I */
/* reuse GL_R8UI */
/* reuse GL_R16I */
/* reuse GL_R16UI */
/* reuse GL_R32I */
/* reuse GL_R32UI */
/* reuse GL_RG8I */
/* reuse GL_RG8UI */
/* reuse GL_RG16I */
/* reuse GL_RG16UI */
/* reuse GL_RG32I */
/* reuse GL_RG32UI */
/* Reuse tokens from ARB_vertex_array_object */
/* reuse GL_VERTEX_ARRAY_BINDING */
;static const uint  GL_CLAMP_VERTEX_COLOR            = 0x891A
;static const uint  GL_CLAMP_FRAGMENT_COLOR          = 0x891B
;static const uint  GL_ALPHA_INTEGER                 = 0x8D97
/* Reuse tokens from ARB_framebuffer_object */
/* reuse GL_TEXTURE_LUMINANCE_TYPE */
/* reuse GL_TEXTURE_INTENSITY_TYPE */
//

////#ifndef GL_VERSION_3_1
;static const uint  GL_SAMPLER_2D_RECT               = 0x8B63
;static const uint  GL_SAMPLER_2D_RECT_SHADOW        = 0x8B64
;static const uint  GL_SAMPLER_BUFFER                = 0x8DC2
;static const uint  GL_INT_SAMPLER_2D_RECT           = 0x8DCD
;static const uint  GL_INT_SAMPLER_BUFFER            = 0x8DD0
;static const uint  GL_UNSIGNED_INT_SAMPLER_2D_RECT  = 0x8DD5
;static const uint  GL_UNSIGNED_INT_SAMPLER_BUFFER   = 0x8DD8
;static const uint  GL_TEXTURE_BUFFER                = 0x8C2A
;static const uint  GL_MAX_TEXTURE_BUFFER_SIZE       = 0x8C2B
;static const uint  GL_TEXTURE_BINDING_BUFFER        = 0x8C2C
;static const uint  GL_TEXTURE_BUFFER_DATA_STORE_BINDING= 0x8C2D
;static const uint  GL_TEXTURE_RECTANGLE             = 0x84F5
;static const uint  GL_TEXTURE_BINDING_RECTANGLE     = 0x84F6
;static const uint  GL_PROXY_TEXTURE_RECTANGLE       = 0x84F7
;static const uint  GL_MAX_RECTANGLE_TEXTURE_SIZE    = 0x84F8
;static const uint  GL_RED_SNORM                     = 0x8F90
;static const uint  GL_RG_SNORM                      = 0x8F91
;static const uint  GL_RGB_SNORM                     = 0x8F92
;static const uint  GL_RGBA_SNORM                    = 0x8F93
;static const uint  GL_R8_SNORM                      = 0x8F94
;static const uint  GL_RG8_SNORM                     = 0x8F95
;static const uint  GL_RGB8_SNORM                    = 0x8F96
;static const uint  GL_RGBA8_SNORM                   = 0x8F97
;static const uint  GL_R16_SNORM                     = 0x8F98
;static const uint  GL_RG16_SNORM                    = 0x8F99
;static const uint  GL_RGB16_SNORM                   = 0x8F9A
;static const uint  GL_RGBA16_SNORM                  = 0x8F9B
;static const uint  GL_SIGNED_NORMALIZED             = 0x8F9C
;static const uint  GL_PRIMITIVE_RESTART             = 0x8F9D
;static const uint  GL_PRIMITIVE_RESTART_INDEX       = 0x8F9E
/* Reuse tokens from ARB_copy_buffer */
/* reuse GL_COPY_READ_BUFFER */
/* reuse GL_COPY_WRITE_BUFFER */
/* Reuse tokens from ARB_draw_instanced (none) */
/* Reuse tokens from ARB_uniform_buffer_object */
/* reuse GL_UNIFORM_BUFFER */
/* reuse GL_UNIFORM_BUFFER_BINDING */
/* reuse GL_UNIFORM_BUFFER_START */
/* reuse GL_UNIFORM_BUFFER_SIZE */
/* reuse GL_MAX_VERTEX_UNIFORM_BLOCKS */
/* reuse GL_MAX_FRAGMENT_UNIFORM_BLOCKS */
/* reuse GL_MAX_COMBINED_UNIFORM_BLOCKS */
/* reuse GL_MAX_UNIFORM_BUFFER_BINDINGS */
/* reuse GL_MAX_UNIFORM_BLOCK_SIZE */
/* reuse GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS */
/* reuse GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS */
/* reuse GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT */
/* reuse GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH */
/* reuse GL_ACTIVE_UNIFORM_BLOCKS */
/* reuse GL_UNIFORM_TYPE */
/* reuse GL_UNIFORM_SIZE */
/* reuse GL_UNIFORM_NAME_LENGTH */
/* reuse GL_UNIFORM_BLOCK_INDEX */
/* reuse GL_UNIFORM_OFFSET */
/* reuse GL_UNIFORM_ARRAY_STRIDE */
/* reuse GL_UNIFORM_MATRIX_STRIDE */
/* reuse GL_UNIFORM_IS_ROW_MAJOR */
/* reuse GL_UNIFORM_BLOCK_BINDING */
/* reuse GL_UNIFORM_BLOCK_DATA_SIZE */
/* reuse GL_UNIFORM_BLOCK_NAME_LENGTH */
/* reuse GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS */
/* reuse GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER */
/* reuse GL_INVALID_INDEX */
//

////#ifndef GL_VERSION_3_2
;static const uint  GL_CONTEXT_CORE_PROFILE_BIT      = 0x00000001
;static const uint  GL_CONTEXT_COMPATIBILITY_PROFILE_BIT= 0x00000002
;static const uint  GL_LINES_ADJACENCY               = 0x000A
;static const uint  GL_LINE_STRIP_ADJACENCY          = 0x000B
;static const uint  GL_TRIANGLES_ADJACENCY           = 0x000C
;static const uint  GL_TRIANGLE_STRIP_ADJACENCY      = 0x000D
;static const uint  GL_PROGRAM_POINT_SIZE            = 0x8642
;static const uint  GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS= 0x8C29
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_LAYERED= 0x8DA7
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS= 0x8DA8
;static const uint  GL_GEOMETRY_SHADER               = 0x8DD9
;static const uint  GL_GEOMETRY_VERTICES_OUT         = 0x8916
;static const uint  GL_GEOMETRY_INPUT_TYPE           = 0x8917
;static const uint  GL_GEOMETRY_OUTPUT_TYPE          = 0x8918
;static const uint  GL_MAX_GEOMETRY_UNIFORM_COMPONENTS= 0x8DDF
;static const uint  GL_MAX_GEOMETRY_OUTPUT_VERTICES  = 0x8DE0
;static const uint  GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS= 0x8DE1
;static const uint  GL_MAX_VERTEX_OUTPUT_COMPONENTS  = 0x9122
;static const uint  GL_MAX_GEOMETRY_INPUT_COMPONENTS = 0x9123
;static const uint  GL_MAX_GEOMETRY_OUTPUT_COMPONENTS= 0x9124
;static const uint  GL_MAX_FRAGMENT_INPUT_COMPONENTS = 0x9125
;static const uint  GL_CONTEXT_PROFILE_MASK          = 0x9126
/* reuse GL_MAX_VARYING_COMPONENTS */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER */
/* Reuse tokens from ARB_depth_clamp */
/* reuse GL_DEPTH_CLAMP */
/* Reuse tokens from ARB_draw_elements_base_vertex (none) */
/* Reuse tokens from ARB_fragment_coord_conventions (none) */
/* Reuse tokens from ARB_provoking_vertex */
/* reuse GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION */
/* reuse GL_FIRST_VERTEX_CONVENTION */
/* reuse GL_LAST_VERTEX_CONVENTION */
/* reuse GL_PROVOKING_VERTEX */
/* Reuse tokens from ARB_seamless_cube_map */
/* reuse GL_TEXTURE_CUBE_MAP_SEAMLESS */
/* Reuse tokens from ARB_sync */
/* reuse GL_MAX_SERVER_WAIT_TIMEOUT */
/* reuse GL_OBJECT_TYPE */
/* reuse GL_SYNC_CONDITION */
/* reuse GL_SYNC_STATUS */
/* reuse GL_SYNC_FLAGS */
/* reuse GL_SYNC_FENCE */
/* reuse GL_SYNC_GPU_COMMANDS_COMPLETE */
/* reuse GL_UNSIGNALED */
/* reuse GL_SIGNALED */
/* reuse GL_ALREADY_SIGNALED */
/* reuse GL_TIMEOUT_EXPIRED */
/* reuse GL_CONDITION_SATISFIED */
/* reuse GL_WAIT_FAILED */
/* reuse GL_TIMEOUT_IGNORED */
/* reuse GL_SYNC_FLUSH_COMMANDS_BIT */
/* reuse GL_TIMEOUT_IGNORED */
/* Reuse tokens from ARB_texture_multisample */
/* reuse GL_SAMPLE_POSITION */
/* reuse GL_SAMPLE_MASK */
/* reuse GL_SAMPLE_MASK_VALUE */
/* reuse GL_MAX_SAMPLE_MASK_WORDS */
/* reuse GL_TEXTURE_2D_MULTISAMPLE */
/* reuse GL_PROXY_TEXTURE_2D_MULTISAMPLE */
/* reuse GL_TEXTURE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_TEXTURE_BINDING_2D_MULTISAMPLE */
/* reuse GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY */
/* reuse GL_TEXTURE_SAMPLES */
/* reuse GL_TEXTURE_FIXED_SAMPLE_LOCATIONS */
/* reuse GL_SAMPLER_2D_MULTISAMPLE */
/* reuse GL_INT_SAMPLER_2D_MULTISAMPLE */
/* reuse GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE */
/* reuse GL_SAMPLER_2D_MULTISAMPLE_ARRAY */
/* reuse GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY */
/* reuse GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY */
/* reuse GL_MAX_COLOR_TEXTURE_SAMPLES */
/* reuse GL_MAX_DEPTH_TEXTURE_SAMPLES */
/* reuse GL_MAX_INTEGER_SAMPLES */
/* Don't need to reuse tokens from ARB_vertex_array_bgra since they're already in 1.2 core */
//

//#ifndef GL_VERSION_3_3
;static const uint  GL_VERTEX_ATTRIB_ARRAY_DIVISOR   = 0x88FE
/* Reuse tokens from ARB_blend_func_extended */
/* reuse GL_SRC1_COLOR */
/* reuse GL_ONE_MINUS_SRC1_COLOR */
/* reuse GL_ONE_MINUS_SRC1_ALPHA */
/* reuse GL_MAX_DUAL_SOURCE_DRAW_BUFFERS */
/* Reuse tokens from ARB_explicit_attrib_location (none) */
/* Reuse tokens from ARB_occlusion_query2 */
/* reuse GL_ANY_SAMPLES_PASSED */
/* Reuse tokens from ARB_sampler_objects */
/* reuse GL_SAMPLER_BINDING */
/* Reuse tokens from ARB_shader_bit_encoding (none) */
/* Reuse tokens from ARB_texture_rgb10_a2ui */
/* reuse GL_RGB10_A2UI */
/* Reuse tokens from ARB_texture_swizzle */
/* reuse GL_TEXTURE_SWIZZLE_R */
/* reuse GL_TEXTURE_SWIZZLE_G */
/* reuse GL_TEXTURE_SWIZZLE_B */
/* reuse GL_TEXTURE_SWIZZLE_A */
/* reuse GL_TEXTURE_SWIZZLE_RGBA */
/* Reuse tokens from ARB_timer_query */
/* reuse GL_TIME_ELAPSED */
/* reuse GL_TIMESTAMP */
/* Reuse tokens from ARB_vertex_type_2_10_10_10_rev */
/* reuse GL_INT_2_10_10_10_REV */


////#ifndef GL_VERSION_4_0
;static const uint  GL_SAMPLE_SHADING                = 0x8C36
;static const uint  GL_MIN_SAMPLE_SHADING_VALUE      = 0x8C37
;static const uint  GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET= 0x8E5E
;static const uint  GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET= 0x8E5F
;static const uint  GL_TEXTURE_CUBE_MAP_ARRAY        = 0x9009
;static const uint  GL_TEXTURE_BINDING_CUBE_MAP_ARRAY= 0x900A
;static const uint  GL_PROXY_TEXTURE_CUBE_MAP_ARRAY  = 0x900B
;static const uint  GL_SAMPLER_CUBE_MAP_ARRAY        = 0x900C
;static const uint  GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW = 0x900D
;static const uint  GL_INT_SAMPLER_CUBE_MAP_ARRAY    = 0x900E
;static const uint  GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY= 0x900F
/* Reuse tokens from ARB_texture_query_lod (none) */
/* Reuse tokens from ARB_draw_buffers_blend (none) */
/* Reuse tokens from ARB_draw_indirect */
/* reuse GL_DRAW_INDIRECT_BUFFER */
/* reuse GL_DRAW_INDIRECT_BUFFER_BINDING */
/* Reuse tokens from ARB_gpu_shader5 */
/* reuse GL_GEOMETRY_SHADER_INVOCATIONS */
/* reuse GL_MAX_GEOMETRY_SHADER_INVOCATIONS */
/* reuse GL_MIN_FRAGMENT_INTERPOLATION_OFFSET */
/* reuse GL_MAX_FRAGMENT_INTERPOLATION_OFFSET */
/* reuse GL_FRAGMENT_INTERPOLATION_OFFSET_BITS */
/* Reuse tokens from ARB_gpu_shader_fp64 */
/* reuse GL_DOUBLE_VEC2 */
/* reuse GL_DOUBLE_VEC3 */
/* reuse GL_DOUBLE_VEC4 */
/* reuse GL_DOUBLE_MAT2 */
/* reuse GL_DOUBLE_MAT3 */
/* reuse GL_DOUBLE_MAT4 */
/* reuse GL_DOUBLE_MAT2x3 */
/* reuse GL_DOUBLE_MAT2x4 */
/* reuse GL_DOUBLE_MAT3x2 */
/* reuse GL_DOUBLE_MAT3x4 */
/* reuse GL_DOUBLE_MAT4x2 */
/* reuse GL_DOUBLE_MAT4x3 */
/* Reuse tokens from ARB_shader_subroutine */
/* reuse GL_ACTIVE_SUBROUTINES */
/* reuse GL_ACTIVE_SUBROUTINE_UNIFORMS */
/* reuse GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS */
/* reuse GL_ACTIVE_SUBROUTINE_MAX_LENGTH */
/* reuse GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH */
/* reuse GL_MAX_SUBROUTINES */
/* reuse GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS */
/* reuse GL_NUM_COMPATIBLE_SUBROUTINES */
/* reuse GL_COMPATIBLE_SUBROUTINES */
/* Reuse tokens from ARB_tessellation_shader */
/* reuse GL_PATCHES */
/* reuse GL_PATCH_VERTICES */
/* reuse GL_PATCH_DEFAULT_INNER_LEVEL */
/* reuse GL_PATCH_DEFAULT_OUTER_LEVEL */
/* reuse GL_TESS_CONTROL_OUTPUT_VERTICES */
/* reuse GL_TESS_GEN_MODE */
/* reuse GL_TESS_GEN_SPACING */
/* reuse GL_TESS_GEN_VERTEX_ORDER */
/* reuse GL_TESS_GEN_POINT_MODE */
/* reuse GL_ISOLINES */
/* reuse GL_FRACTIONAL_ODD */
/* reuse GL_FRACTIONAL_EVEN */
/* reuse GL_MAX_PATCH_VERTICES */
/* reuse GL_MAX_TESS_GEN_LEVEL */
/* reuse GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS */
/* reuse GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS */
/* reuse GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS */
/* reuse GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS */
/* reuse GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS */
/* reuse GL_MAX_TESS_PATCH_COMPONENTS */
/* reuse GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS */
/* reuse GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS */
/* reuse GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS */
/* reuse GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS */
/* reuse GL_MAX_TESS_CONTROL_INPUT_COMPONENTS */
/* reuse GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS */
/* reuse GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS */
/* reuse GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER */
/* reuse GL_TESS_EVALUATION_SHADER */
/* reuse GL_TESS_CONTROL_SHADER */
/* Reuse tokens from ARB_texture_buffer_object_rgb32 (none) */
/* Reuse tokens from ARB_transform_feedback2 */
/* reuse GL_TRANSFORM_FEEDBACK */
/* reuse GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED */
/* reuse GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE */
/* reuse GL_TRANSFORM_FEEDBACK_BINDING */
/* Reuse tokens from ARB_transform_feedback3 */
/* reuse GL_MAX_TRANSFORM_FEEDBACK_BUFFERS */
/* reuse GL_MAX_VERTEX_STREAMS */


////#ifndef GL_VERSION_4_1
/* Reuse tokens from ARB_ES2_compatibility */
/* reuse GL_FIXED */
/* reuse GL_IMPLEMENTATION_COLOR_READ_TYPE */
/* reuse GL_IMPLEMENTATION_COLOR_READ_FORMAT */
/* reuse GL_LOW_FLOAT */
/* reuse GL_MEDIUM_FLOAT */
/* reuse GL_HIGH_FLOAT */
/* reuse GL_LOW_INT */
/* reuse GL_MEDIUM_INT */
/* reuse GL_HIGH_INT */
/* reuse GL_SHADER_COMPILER */
/* reuse GL_SHADER_BINARY_FORMATS */
/* reuse GL_NUM_SHADER_BINARY_FORMATS */
/* reuse GL_MAX_VERTEX_UNIFORM_VECTORS */
/* reuse GL_MAX_VARYING_VECTORS */
/* reuse GL_MAX_FRAGMENT_UNIFORM_VECTORS */
/* reuse GL_RGB565 */
/* Reuse tokens from ARB_get_program_binary */
/* reuse GL_PROGRAM_BINARY_RETRIEVABLE_HINT */
/* reuse GL_PROGRAM_BINARY_LENGTH */
/* reuse GL_NUM_PROGRAM_BINARY_FORMATS */
/* reuse GL_PROGRAM_BINARY_FORMATS */
/* Reuse tokens from ARB_separate_shader_objects */
/* reuse GL_VERTEX_SHADER_BIT */
/* reuse GL_FRAGMENT_SHADER_BIT */
/* reuse GL_GEOMETRY_SHADER_BIT */
/* reuse GL_TESS_CONTROL_SHADER_BIT */
/* reuse GL_TESS_EVALUATION_SHADER_BIT */
/* reuse GL_ALL_SHADER_BITS */
/* reuse GL_PROGRAM_SEPARABLE */
/* reuse GL_ACTIVE_PROGRAM */
/* reuse GL_PROGRAM_PIPELINE_BINDING */
/* Reuse tokens from ARB_shader_precision (none) */
/* Reuse tokens from ARB_vertex_attrib_64bit - all are in GL 3.0 and 4.0 already */
/* Reuse tokens from ARB_viewport_array - some are in GL 1.1 and ARB_provoking_vertex already */
/* reuse GL_MAX_VIEWPORTS */
/* reuse GL_VIEWPORT_SUBPIXEL_BITS */
/* reuse GL_VIEWPORT_BOUNDS_RANGE */
/* reuse GL_LAYER_PROVOKING_VERTEX */
/* reuse GL_VIEWPORT_INDEX_PROVOKING_VERTEX */
/* reuse GL_UNDEFINED_VERTEX */


////#ifndef GL_VERSION_4_2
/* Reuse tokens from ARB_base_instance (none) */
/* Reuse tokens from ARB_shading_language_420pack (none) */
/* Reuse tokens from ARB_transform_feedback_instanced (none) */
/* Reuse tokens from ARB_compressed_texture_pixel_storage */
/* reuse GL_UNPACK_COMPRESSED_BLOCK_WIDTH */
/* reuse GL_UNPACK_COMPRESSED_BLOCK_HEIGHT */
/* reuse GL_UNPACK_COMPRESSED_BLOCK_DEPTH */
/* reuse GL_UNPACK_COMPRESSED_BLOCK_SIZE */
/* reuse GL_PACK_COMPRESSED_BLOCK_WIDTH */
/* reuse GL_PACK_COMPRESSED_BLOCK_HEIGHT */
/* reuse GL_PACK_COMPRESSED_BLOCK_DEPTH */
/* reuse GL_PACK_COMPRESSED_BLOCK_SIZE */
/* Reuse tokens from ARB_conservative_depth (none) */
/* Reuse tokens from ARB_internalformat_query */
/* reuse GL_NUM_SAMPLE_COUNTS */
/* Reuse tokens from ARB_map_buffer_alignment */
/* reuse GL_MIN_MAP_BUFFER_ALIGNMENT */
/* Reuse tokens from ARB_shader_atomic_counters */
/* reuse GL_ATOMIC_COUNTER_BUFFER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_BINDING */
/* reuse GL_ATOMIC_COUNTER_BUFFER_START */
/* reuse GL_ATOMIC_COUNTER_BUFFER_SIZE */
/* reuse GL_ATOMIC_COUNTER_BUFFER_DATA_SIZE */
/* reuse GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS */
/* reuse GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER */
/* reuse GL_MAX_VERTEX_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_COMBINED_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_VERTEX_ATOMIC_COUNTERS */
/* reuse GL_MAX_TESS_CONTROL_ATOMIC_COUNTERS */
/* reuse GL_MAX_TESS_EVALUATION_ATOMIC_COUNTERS */
/* reuse GL_MAX_GEOMETRY_ATOMIC_COUNTERS */
/* reuse GL_MAX_FRAGMENT_ATOMIC_COUNTERS */
/* reuse GL_MAX_COMBINED_ATOMIC_COUNTERS */
/* reuse GL_MAX_ATOMIC_COUNTER_BUFFER_SIZE */
/* reuse GL_MAX_ATOMIC_COUNTER_BUFFER_BINDINGS */
/* reuse GL_ACTIVE_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX */
/* reuse GL_UNSIGNED_INT_ATOMIC_COUNTER */
/* Reuse tokens from ARB_shader_image_load_store */
/* reuse GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT */
/* reuse GL_ELEMENT_ARRAY_BARRIER_BIT */
/* reuse GL_UNIFORM_BARRIER_BIT */
/* reuse GL_TEXTURE_FETCH_BARRIER_BIT */
/* reuse GL_SHADER_IMAGE_ACCESS_BARRIER_BIT */
/* reuse GL_COMMAND_BARRIER_BIT */
/* reuse GL_PIXEL_BUFFER_BARRIER_BIT */
/* reuse GL_TEXTURE_UPDATE_BARRIER_BIT */
/* reuse GL_BUFFER_UPDATE_BARRIER_BIT */
/* reuse GL_FRAMEBUFFER_BARRIER_BIT */
/* reuse GL_TRANSFORM_FEEDBACK_BARRIER_BIT */
/* reuse GL_ATOMIC_COUNTER_BARRIER_BIT */
/* reuse GL_ALL_BARRIER_BITS */
/* reuse GL_MAX_IMAGE_UNITS */
/* reuse GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS */
/* reuse GL_IMAGE_BINDING_NAME */
/* reuse GL_IMAGE_BINDING_LEVEL */
/* reuse GL_IMAGE_BINDING_LAYERED */
/* reuse GL_IMAGE_BINDING_LAYER */
/* reuse GL_IMAGE_BINDING_ACCESS */
/* reuse GL_IMAGE_1D */
/* reuse GL_IMAGE_2D */
/* reuse GL_IMAGE_3D */
/* reuse GL_IMAGE_2D_RECT */
/* reuse GL_IMAGE_CUBE */
/* reuse GL_IMAGE_BUFFER */
/* reuse GL_IMAGE_1D_ARRAY */
/* reuse GL_IMAGE_2D_ARRAY */
/* reuse GL_IMAGE_CUBE_MAP_ARRAY */
/* reuse GL_IMAGE_2D_MULTISAMPLE */
/* reuse GL_IMAGE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_INT_IMAGE_1D */
/* reuse GL_INT_IMAGE_2D */
/* reuse GL_INT_IMAGE_3D */
/* reuse GL_INT_IMAGE_2D_RECT */
/* reuse GL_INT_IMAGE_CUBE */
/* reuse GL_INT_IMAGE_BUFFER */
/* reuse GL_INT_IMAGE_1D_ARRAY */
/* reuse GL_INT_IMAGE_2D_ARRAY */
/* reuse GL_INT_IMAGE_CUBE_MAP_ARRAY */
/* reuse GL_INT_IMAGE_2D_MULTISAMPLE */
/* reuse GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_UNSIGNED_INT_IMAGE_1D */
/* reuse GL_UNSIGNED_INT_IMAGE_2D */
/* reuse GL_UNSIGNED_INT_IMAGE_3D */
/* reuse GL_UNSIGNED_INT_IMAGE_2D_RECT */
/* reuse GL_UNSIGNED_INT_IMAGE_CUBE */
/* reuse GL_UNSIGNED_INT_IMAGE_BUFFER */
/* reuse GL_UNSIGNED_INT_IMAGE_1D_ARRAY */
/* reuse GL_UNSIGNED_INT_IMAGE_2D_ARRAY */
/* reuse GL_UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY */
/* reuse GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE */
/* reuse GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_MAX_IMAGE_SAMPLES */
/* reuse GL_IMAGE_BINDING_FORMAT */
/* reuse GL_IMAGE_FORMAT_COMPATIBILITY_TYPE */
/* reuse GL_IMAGE_FORMAT_COMPATIBILITY_BY_SIZE */
/* reuse GL_IMAGE_FORMAT_COMPATIBILITY_BY_CLASS */
/* reuse GL_MAX_VERTEX_IMAGE_UNIFORMS */
/* reuse GL_MAX_TESS_CONTROL_IMAGE_UNIFORMS */
/* reuse GL_MAX_TESS_EVALUATION_IMAGE_UNIFORMS */
/* reuse GL_MAX_GEOMETRY_IMAGE_UNIFORMS */
/* reuse GL_MAX_FRAGMENT_IMAGE_UNIFORMS */
/* reuse GL_MAX_COMBINED_IMAGE_UNIFORMS */
/* Reuse tokens from ARB_shading_language_packing (none) */
/* Reuse tokens from ARB_texture_storage */
/* reuse GL_TEXTURE_IMMUTABLE_FORMAT */


////#ifndef GL_VERSION_4_3
;static const uint  GL_NUM_SHADING_LANGUAGE_VERSIONS = 0x82E9
;static const uint  GL_VERTEX_ATTRIB_ARRAY_LONG      = 0x874E
/* Reuse tokens from ARB_arrays_of_arrays (none, GLSL only) */
/* Reuse tokens from ARB_fragment_layer_viewport (none, GLSL only) */
/* Reuse tokens from ARB_shader_image_size (none, GLSL only) */
/* Reuse tokens from ARB_ES3_compatibility */
/* reuse GL_COMPRESSED_RGB8_ETC2 */
/* reuse GL_COMPRESSED_SRGB8_ETC2 */
/* reuse GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2 */
/* reuse GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2 */
/* reuse GL_COMPRESSED_RGBA8_ETC2_EAC */
/* reuse GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC */
/* reuse GL_COMPRESSED_R11_EAC */
/* reuse GL_COMPRESSED_SIGNED_R11_EAC */
/* reuse GL_COMPRESSED_RG11_EAC */
/* reuse GL_COMPRESSED_SIGNED_RG11_EAC */
/* reuse GL_PRIMITIVE_RESTART_FIXED_INDEX */
/* reuse GL_ANY_SAMPLES_PASSED_CONSERVATIVE */
/* reuse GL_MAX_ELEMENT_INDEX */
/* Reuse tokens from ARB_clear_buffer_object (none) */
/* Reuse tokens from ARB_compute_shader */
/* reuse GL_COMPUTE_SHADER */
/* reuse GL_MAX_COMPUTE_UNIFORM_BLOCKS */
/* reuse GL_MAX_COMPUTE_TEXTURE_IMAGE_UNITS */
/* reuse GL_MAX_COMPUTE_IMAGE_UNIFORMS */
/* reuse GL_MAX_COMPUTE_SHARED_MEMORY_SIZE */
/* reuse GL_MAX_COMPUTE_UNIFORM_COMPONENTS */
/* reuse GL_MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS */
/* reuse GL_MAX_COMPUTE_ATOMIC_COUNTERS */
/* reuse GL_MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS */
/* reuse GL_MAX_COMPUTE_LOCAL_INVOCATIONS */
/* reuse GL_MAX_COMPUTE_WORK_GROUP_COUNT */
/* reuse GL_MAX_COMPUTE_WORK_GROUP_SIZE */
/* reuse GL_COMPUTE_LOCAL_WORK_SIZE */
/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER */
/* reuse GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER */
/* reuse GL_DISPATCH_INDIRECT_BUFFER */
/* reuse GL_DISPATCH_INDIRECT_BUFFER_BINDING */
/* Reuse tokens from ARB_copy_image (none) */
/* Reuse tokens from KHR_debug */
/* reuse GL_DEBUG_OUTPUT_SYNCHRONOUS */
/* reuse GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH */
/* reuse GL_DEBUG_CALLBACK_FUNCTION */
/* reuse GL_DEBUG_CALLBACK_USER_PARAM */
/* reuse GL_DEBUG_SOURCE_API */
/* reuse GL_DEBUG_SOURCE_WINDOW_SYSTEM */
/* reuse GL_DEBUG_SOURCE_SHADER_COMPILER */
/* reuse GL_DEBUG_SOURCE_THIRD_PARTY */
/* reuse GL_DEBUG_SOURCE_APPLICATION */
/* reuse GL_DEBUG_SOURCE_OTHER */
/* reuse GL_DEBUG_TYPE_ERROR */
/* reuse GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR */
/* reuse GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR */
/* reuse GL_DEBUG_TYPE_PORTABILITY */
/* reuse GL_DEBUG_TYPE_PERFORMANCE */
/* reuse GL_DEBUG_TYPE_OTHER */
/* reuse GL_MAX_DEBUG_MESSAGE_LENGTH */
/* reuse GL_MAX_DEBUG_LOGGED_MESSAGES */
/* reuse GL_DEBUG_LOGGED_MESSAGES */
/* reuse GL_DEBUG_SEVERITY_HIGH */
/* reuse GL_DEBUG_SEVERITY_MEDIUM */
/* reuse GL_DEBUG_SEVERITY_LOW */
/* reuse GL_DEBUG_TYPE_MARKER */
/* reuse GL_DEBUG_TYPE_PUSH_GROUP */
/* reuse GL_DEBUG_TYPE_POP_GROUP */
/* reuse GL_DEBUG_SEVERITY_NOTIFICATION */
/* reuse GL_MAX_DEBUG_GROUP_STACK_DEPTH */
/* reuse GL_DEBUG_GROUP_STACK_DEPTH */
/* reuse GL_BUFFER */
/* reuse GL_SHADER */
/* reuse GL_PROGRAM */
/* reuse GL_QUERY */
/* reuse GL_PROGRAM_PIPELINE */
/* reuse GL_SAMPLER */
/* reuse GL_DISPLAY_LIST */
/* reuse GL_MAX_LABEL_LENGTH */
/* reuse GL_DEBUG_OUTPUT */
/* reuse GL_CONTEXT_FLAG_DEBUG_BIT */
/* reuse GL_STACK_UNDERFLOW */
/* reuse GL_STACK_OVERFLOW */
/* Reuse tokens from ARB_explicit_uniform_location */
/* reuse GL_MAX_UNIFORM_LOCATIONS */
/* Reuse tokens from ARB_framebuffer_no_attachments */
/* reuse GL_FRAMEBUFFER_DEFAULT_WIDTH */
/* reuse GL_FRAMEBUFFER_DEFAULT_HEIGHT */
/* reuse GL_FRAMEBUFFER_DEFAULT_LAYERS */
/* reuse GL_FRAMEBUFFER_DEFAULT_SAMPLES */
/* reuse GL_FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS */
/* reuse GL_MAX_FRAMEBUFFER_WIDTH */
/* reuse GL_MAX_FRAMEBUFFER_HEIGHT */
/* reuse GL_MAX_FRAMEBUFFER_LAYERS */
/* reuse GL_MAX_FRAMEBUFFER_SAMPLES */
/* Reuse tokens from ARB_internalformat_query2 */
/* reuse GL_INTERNALFORMAT_SUPPORTED */
/* reuse GL_INTERNALFORMAT_PREFERRED */
/* reuse GL_INTERNALFORMAT_RED_SIZE */
/* reuse GL_INTERNALFORMAT_GREEN_SIZE */
/* reuse GL_INTERNALFORMAT_BLUE_SIZE */
/* reuse GL_INTERNALFORMAT_ALPHA_SIZE */
/* reuse GL_INTERNALFORMAT_DEPTH_SIZE */
/* reuse GL_INTERNALFORMAT_STENCIL_SIZE */
/* reuse GL_INTERNALFORMAT_SHARED_SIZE */
/* reuse GL_INTERNALFORMAT_RED_TYPE */
/* reuse GL_INTERNALFORMAT_GREEN_TYPE */
/* reuse GL_INTERNALFORMAT_BLUE_TYPE */
/* reuse GL_INTERNALFORMAT_ALPHA_TYPE */
/* reuse GL_INTERNALFORMAT_DEPTH_TYPE */
/* reuse GL_INTERNALFORMAT_STENCIL_TYPE */
/* reuse GL_MAX_WIDTH */
/* reuse GL_MAX_HEIGHT */
/* reuse GL_MAX_DEPTH */
/* reuse GL_MAX_LAYERS */
/* reuse GL_MAX_COMBINED_DIMENSIONS */
/* reuse GL_COLOR_COMPONENTS */
/* reuse GL_DEPTH_COMPONENTS */
/* reuse GL_STENCIL_COMPONENTS */
/* reuse GL_COLOR_RENDERABLE */
/* reuse GL_DEPTH_RENDERABLE */
/* reuse GL_STENCIL_RENDERABLE */
/* reuse GL_FRAMEBUFFER_RENDERABLE */
/* reuse GL_FRAMEBUFFER_RENDERABLE_LAYERED */
/* reuse GL_FRAMEBUFFER_BLEND */
/* reuse GL_READ_PIXELS */
/* reuse GL_READ_PIXELS_FORMAT */
/* reuse GL_READ_PIXELS_TYPE */
/* reuse GL_TEXTURE_IMAGE_FORMAT */
/* reuse GL_TEXTURE_IMAGE_TYPE */
/* reuse GL_GET_TEXTURE_IMAGE_FORMAT */
/* reuse GL_GET_TEXTURE_IMAGE_TYPE */
/* reuse GL_MIPMAP */
/* reuse GL_MANUAL_GENERATE_MIPMAP */
/* reuse GL_AUTO_GENERATE_MIPMAP */
/* reuse GL_COLOR_ENCODING */
/* reuse GL_SRGB_READ */
/* reuse GL_SRGB_WRITE */
/* reuse GL_FILTER */
/* reuse GL_VERTEX_TEXTURE */
/* reuse GL_TESS_CONTROL_TEXTURE */
/* reuse GL_TESS_EVALUATION_TEXTURE */
/* reuse GL_GEOMETRY_TEXTURE */
/* reuse GL_FRAGMENT_TEXTURE */
/* reuse GL_COMPUTE_TEXTURE */
/* reuse GL_TEXTURE_SHADOW */
/* reuse GL_TEXTURE_GATHER */
/* reuse GL_TEXTURE_GATHER_SHADOW */
/* reuse GL_SHADER_IMAGE_LOAD */
/* reuse GL_SHADER_IMAGE_STORE */
/* reuse GL_SHADER_IMAGE_ATOMIC */
/* reuse GL_IMAGE_TEXEL_SIZE */
/* reuse GL_IMAGE_COMPATIBILITY_CLASS */
/* reuse GL_IMAGE_PIXEL_FORMAT */
/* reuse GL_IMAGE_PIXEL_TYPE */
/* reuse GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST */
/* reuse GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST */
/* reuse GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE */
/* reuse GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE */
/* reuse GL_TEXTURE_COMPRESSED_BLOCK_WIDTH */
/* reuse GL_TEXTURE_COMPRESSED_BLOCK_HEIGHT */
/* reuse GL_TEXTURE_COMPRESSED_BLOCK_SIZE */
/* reuse GL_CLEAR_BUFFER */
/* reuse GL_TEXTURE_VIEW */
/* reuse GL_VIEW_COMPATIBILITY_CLASS */
/* reuse GL_FULL_SUPPORT */
/* reuse GL_CAVEAT_SUPPORT */
/* reuse GL_IMAGE_CLASS_4_X_32 */
/* reuse GL_IMAGE_CLASS_2_X_32 */
/* reuse GL_IMAGE_CLASS_1_X_32 */
/* reuse GL_IMAGE_CLASS_4_X_16 */
/* reuse GL_IMAGE_CLASS_2_X_16 */
/* reuse GL_IMAGE_CLASS_1_X_16 */
/* reuse GL_IMAGE_CLASS_4_X_8 */
/* reuse GL_IMAGE_CLASS_2_X_8 */
/* reuse GL_IMAGE_CLASS_1_X_8 */
/* reuse GL_IMAGE_CLASS_11_11_10 */
/* reuse GL_IMAGE_CLASS_10_10_10_2 */
/* reuse GL_VIEW_CLASS_128_BITS */
/* reuse GL_VIEW_CLASS_96_BITS */
/* reuse GL_VIEW_CLASS_64_BITS */
/* reuse GL_VIEW_CLASS_48_BITS */
/* reuse GL_VIEW_CLASS_32_BITS */
/* reuse GL_VIEW_CLASS_24_BITS */
/* reuse GL_VIEW_CLASS_16_BITS */
/* reuse GL_VIEW_CLASS_8_BITS */
/* reuse GL_VIEW_CLASS_S3TC_DXT1_RGB */
/* reuse GL_VIEW_CLASS_S3TC_DXT1_RGBA */
/* reuse GL_VIEW_CLASS_S3TC_DXT3_RGBA */
/* reuse GL_VIEW_CLASS_S3TC_DXT5_RGBA */
/* reuse GL_VIEW_CLASS_RGTC1_RED */
/* reuse GL_VIEW_CLASS_RGTC2_RG */
/* reuse GL_VIEW_CLASS_BPTC_UNORM */
/* reuse GL_VIEW_CLASS_BPTC_FLOAT */
/* Reuse tokens from ARB_invalidate_subdata (none) */
/* Reuse tokens from ARB_multi_draw_indirect (none) */
/* Reuse tokens from ARB_program_interface_query */
/* reuse GL_UNIFORM */
/* reuse GL_UNIFORM_BLOCK */
/* reuse GL_PROGRAM_INPUT */
/* reuse GL_PROGRAM_OUTPUT */
/* reuse GL_BUFFER_VARIABLE */
/* reuse GL_SHADER_STORAGE_BLOCK */
/* reuse GL_VERTEX_SUBROUTINE */
/* reuse GL_TESS_CONTROL_SUBROUTINE */
/* reuse GL_TESS_EVALUATION_SUBROUTINE */
/* reuse GL_GEOMETRY_SUBROUTINE */
/* reuse GL_FRAGMENT_SUBROUTINE */
/* reuse GL_COMPUTE_SUBROUTINE */
/* reuse GL_VERTEX_SUBROUTINE_UNIFORM */
/* reuse GL_TESS_CONTROL_SUBROUTINE_UNIFORM */
/* reuse GL_TESS_EVALUATION_SUBROUTINE_UNIFORM */
/* reuse GL_GEOMETRY_SUBROUTINE_UNIFORM */
/* reuse GL_FRAGMENT_SUBROUTINE_UNIFORM */
/* reuse GL_COMPUTE_SUBROUTINE_UNIFORM */
/* reuse GL_TRANSFORM_FEEDBACK_VARYING */
/* reuse GL_ACTIVE_RESOURCES */
/* reuse GL_MAX_NAME_LENGTH */
/* reuse GL_MAX_NUM_ACTIVE_VARIABLES */
/* reuse GL_MAX_NUM_COMPATIBLE_SUBROUTINES */
/* reuse GL_NAME_LENGTH */
/* reuse GL_TYPE */
/* reuse GL_ARRAY_SIZE */
/* reuse GL_OFFSET */
/* reuse GL_BLOCK_INDEX */
/* reuse GL_ARRAY_STRIDE */
/* reuse GL_MATRIX_STRIDE */
/* reuse GL_IS_ROW_MAJOR */
/* reuse GL_ATOMIC_COUNTER_BUFFER_INDEX */
/* reuse GL_BUFFER_BINDING */
/* reuse GL_BUFFER_DATA_SIZE */
/* reuse GL_NUM_ACTIVE_VARIABLES */
/* reuse GL_ACTIVE_VARIABLES */
/* reuse GL_REFERENCED_BY_VERTEX_SHADER */
/* reuse GL_REFERENCED_BY_TESS_CONTROL_SHADER */
/* reuse GL_REFERENCED_BY_TESS_EVALUATION_SHADER */
/* reuse GL_REFERENCED_BY_GEOMETRY_SHADER */
/* reuse GL_REFERENCED_BY_FRAGMENT_SHADER */
/* reuse GL_REFERENCED_BY_COMPUTE_SHADER */
/* reuse GL_TOP_LEVEL_ARRAY_SIZE */
/* reuse GL_TOP_LEVEL_ARRAY_STRIDE */
/* reuse GL_LOCATION */
/* reuse GL_LOCATION_INDEX */
/* reuse GL_IS_PER_PATCH */
/* Reuse tokens from ARB_robust_buffer_access_behavior (none) */
/* Reuse tokens from ARB_shader_storage_buffer_object */
/* reuse GL_SHADER_STORAGE_BUFFER */
/* reuse GL_SHADER_STORAGE_BUFFER_BINDING */
/* reuse GL_SHADER_STORAGE_BUFFER_START */
/* reuse GL_SHADER_STORAGE_BUFFER_SIZE */
/* reuse GL_MAX_VERTEX_SHADER_STORAGE_BLOCKS */
/* reuse GL_MAX_GEOMETRY_SHADER_STORAGE_BLOCKS */
/* reuse GL_MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS */
/* reuse GL_MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS */
/* reuse GL_MAX_FRAGMENT_SHADER_STORAGE_BLOCKS */
/* reuse GL_MAX_COMPUTE_SHADER_STORAGE_BLOCKS */
/* reuse GL_MAX_COMBINED_SHADER_STORAGE_BLOCKS */
/* reuse GL_MAX_SHADER_STORAGE_BUFFER_BINDINGS */
/* reuse GL_MAX_SHADER_STORAGE_BLOCK_SIZE */
/* reuse GL_SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT */
/* reuse GL_SHADER_STORAGE_BARRIER_BIT */
/* reuse GL_MAX_COMBINED_SHADER_OUTPUT_RESOURCES */
/* Reuse tokens from ARB_stencil_texturing */
/* reuse GL_DEPTH_STENCIL_TEXTURE_MODE */
/* Reuse tokens from ARB_texture_buffer_range */
/* reuse GL_TEXTURE_BUFFER_OFFSET */
/* reuse GL_TEXTURE_BUFFER_SIZE */
/* reuse GL_TEXTURE_BUFFER_OFFSET_ALIGNMENT */
/* Reuse tokens from ARB_texture_query_levels (none) */
/* Reuse tokens from ARB_texture_storage_multisample (none) */
/* Reuse tokens from ARB_texture_view */
/* reuse GL_TEXTURE_VIEW_MIN_LEVEL */
/* reuse GL_TEXTURE_VIEW_NUM_LEVELS */
/* reuse GL_TEXTURE_VIEW_MIN_LAYER */
/* reuse GL_TEXTURE_VIEW_NUM_LAYERS */
/* reuse GL_TEXTURE_IMMUTABLE_LEVELS */
/* Reuse tokens from ARB_vertex_attrib_binding */
/* reuse GL_VERTEX_ATTRIB_BINDING */
/* reuse GL_VERTEX_ATTRIB_RELATIVE_OFFSET */
/* reuse GL_VERTEX_BINDING_DIVISOR */
/* reuse GL_VERTEX_BINDING_OFFSET */
/* reuse GL_VERTEX_BINDING_STRIDE */
/* reuse GL_MAX_VERTEX_ATTRIB_RELATIVE_OFFSET */
/* reuse GL_MAX_VERTEX_ATTRIB_BINDINGS */


////#ifndef GL_ARB_multitexture
;static const uint  GL_TEXTURE0_ARB                  = 0x84C0
;static const uint  GL_TEXTURE1_ARB                  = 0x84C1
;static const uint  GL_TEXTURE2_ARB                  = 0x84C2
;static const uint  GL_TEXTURE3_ARB                  = 0x84C3
;static const uint  GL_TEXTURE4_ARB                  = 0x84C4
;static const uint  GL_TEXTURE5_ARB                  = 0x84C5
;static const uint  GL_TEXTURE6_ARB                  = 0x84C6
;static const uint  GL_TEXTURE7_ARB                  = 0x84C7
;static const uint  GL_TEXTURE8_ARB                  = 0x84C8
;static const uint  GL_TEXTURE9_ARB                  = 0x84C9
;static const uint  GL_TEXTURE10_ARB                 = 0x84CA
;static const uint  GL_TEXTURE11_ARB                 = 0x84CB
;static const uint  GL_TEXTURE12_ARB                 = 0x84CC
;static const uint  GL_TEXTURE13_ARB                 = 0x84CD
;static const uint  GL_TEXTURE14_ARB                 = 0x84CE
;static const uint  GL_TEXTURE15_ARB                 = 0x84CF
;static const uint  GL_TEXTURE16_ARB                 = 0x84D0
;static const uint  GL_TEXTURE17_ARB                 = 0x84D1
;static const uint  GL_TEXTURE18_ARB                 = 0x84D2
;static const uint  GL_TEXTURE19_ARB                 = 0x84D3
;static const uint  GL_TEXTURE20_ARB                 = 0x84D4
;static const uint  GL_TEXTURE21_ARB                 = 0x84D5
;static const uint  GL_TEXTURE22_ARB                 = 0x84D6
;static const uint  GL_TEXTURE23_ARB                 = 0x84D7
;static const uint  GL_TEXTURE24_ARB                 = 0x84D8
;static const uint  GL_TEXTURE25_ARB                 = 0x84D9
;static const uint  GL_TEXTURE26_ARB                 = 0x84DA
;static const uint  GL_TEXTURE27_ARB                 = 0x84DB
;static const uint  GL_TEXTURE28_ARB                 = 0x84DC
;static const uint  GL_TEXTURE29_ARB                 = 0x84DD
;static const uint  GL_TEXTURE30_ARB                 = 0x84DE
;static const uint  GL_TEXTURE31_ARB                 = 0x84DF
;static const uint  GL_ACTIVE_TEXTURE_ARB            = 0x84E0
;static const uint  GL_CLIENT_ACTIVE_TEXTURE_ARB     = 0x84E1
;static const uint  GL_MAX_TEXTURE_UNITS_ARB         = 0x84E2


////#ifndef GL_ARB_transpose_matrix
;static const uint  GL_TRANSPOSE_MODELVIEW_MATRIX_ARB= 0x84E3
;static const uint  GL_TRANSPOSE_PROJECTION_MATRIX_ARB= 0x84E4
;static const uint  GL_TRANSPOSE_TEXTURE_MATRIX_ARB  = 0x84E5
;static const uint  GL_TRANSPOSE_COLOR_MATRIX_ARB    = 0x84E6


////#ifndef GL_ARB_multisample
;static const uint  GL_MULTISAMPLE_ARB               = 0x809D
;static const uint  GL_SAMPLE_ALPHA_TO_COVERAGE_ARB  = 0x809E
;static const uint  GL_SAMPLE_ALPHA_TO_ONE_ARB       = 0x809F
;static const uint  GL_SAMPLE_COVERAGE_ARB           = 0x80A0
;static const uint  GL_SAMPLE_BUFFERS_ARB            = 0x80A8
;static const uint  GL_SAMPLES_ARB                   = 0x80A9
;static const uint  GL_SAMPLE_COVERAGE_VALUE_ARB     = 0x80AA
;static const uint  GL_SAMPLE_COVERAGE_INVERT_ARB    = 0x80AB
;static const uint  GL_MULTISAMPLE_BIT_ARB           = 0x20000000


////#ifndef GL_ARB_texture_env_add


////#ifndef GL_ARB_texture_cube_map
;static const uint  GL_NORMAL_MAP_ARB                = 0x8511
;static const uint  GL_REFLECTION_MAP_ARB            = 0x8512
;static const uint  GL_TEXTURE_CUBE_MAP_ARB          = 0x8513
;static const uint  GL_TEXTURE_BINDING_CUBE_MAP_ARB  = 0x8514
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_X_ARB= 0x8515
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_X_ARB= 0x8516
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_Y_ARB= 0x8517
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_ARB= 0x8518
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_Z_ARB= 0x8519
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_ARB= 0x851A
;static const uint  GL_PROXY_TEXTURE_CUBE_MAP_ARB    = 0x851B
;static const uint  GL_MAX_CUBE_MAP_TEXTURE_SIZE_ARB = 0x851C


////#ifndef GL_ARB_texture_compression
;static const uint  GL_COMPRESSED_ALPHA_ARB          = 0x84E9
;static const uint  GL_COMPRESSED_LUMINANCE_ARB      = 0x84EA
;static const uint  GL_COMPRESSED_LUMINANCE_ALPHA_ARB= 0x84EB
;static const uint  GL_COMPRESSED_INTENSITY_ARB      = 0x84EC
;static const uint  GL_COMPRESSED_RGB_ARB            = 0x84ED
;static const uint  GL_COMPRESSED_RGBA_ARB           = 0x84EE
;static const uint  GL_TEXTURE_COMPRESSION_HINT_ARB  = 0x84EF
;static const uint  GL_TEXTURE_COMPRESSED_IMAGE_SIZE_ARB= 0x86A0
;static const uint  GL_TEXTURE_COMPRESSED_ARB        = 0x86A1
;static const uint  GL_NUM_COMPRESSED_TEXTURE_FORMATS_ARB= 0x86A2
;static const uint  GL_COMPRESSED_TEXTURE_FORMATS_ARB= 0x86A3


////#ifndef GL_ARB_texture_border_clamp
;static const uint  GL_CLAMP_TO_BORDER_ARB           = 0x812D


////#ifndef GL_ARB_point_parameters
;static const uint  GL_POINT_SIZE_MIN_ARB            = 0x8126
;static const uint  GL_POINT_SIZE_MAX_ARB            = 0x8127
;static const uint  GL_POINT_FADE_THRESHOLD_SIZE_ARB = 0x8128
;static const uint  GL_POINT_DISTANCE_ATTENUATION_ARB= 0x8129


////#ifndef GL_ARB_vertex_blend
;static const uint  GL_MAX_VERTEX_UNITS_ARB          = 0x86A4
;static const uint  GL_ACTIVE_VERTEX_UNITS_ARB       = 0x86A5
;static const uint  GL_WEIGHT_SUM_UNITY_ARB          = 0x86A6
;static const uint  GL_VERTEX_BLEND_ARB              = 0x86A7
;static const uint  GL_CURRENT_WEIGHT_ARB            = 0x86A8
;static const uint  GL_WEIGHT_ARRAY_TYPE_ARB         = 0x86A9
;static const uint  GL_WEIGHT_ARRAY_STRIDE_ARB       = 0x86AA
;static const uint  GL_WEIGHT_ARRAY_SIZE_ARB         = 0x86AB
;static const uint  GL_WEIGHT_ARRAY_POINTER_ARB      = 0x86AC
;static const uint  GL_WEIGHT_ARRAY_ARB              = 0x86AD
;static const uint  GL_MODELVIEW0_ARB                = 0x1700
;static const uint  GL_MODELVIEW1_ARB                = 0x850A
;static const uint  GL_MODELVIEW2_ARB                = 0x8722
;static const uint  GL_MODELVIEW3_ARB                = 0x8723
;static const uint  GL_MODELVIEW4_ARB                = 0x8724
;static const uint  GL_MODELVIEW5_ARB                = 0x8725
;static const uint  GL_MODELVIEW6_ARB                = 0x8726
;static const uint  GL_MODELVIEW7_ARB                = 0x8727
;static const uint  GL_MODELVIEW8_ARB                = 0x8728
;static const uint  GL_MODELVIEW9_ARB                = 0x8729
;static const uint  GL_MODELVIEW10_ARB               = 0x872A
;static const uint  GL_MODELVIEW11_ARB               = 0x872B
;static const uint  GL_MODELVIEW12_ARB               = 0x872C
;static const uint  GL_MODELVIEW13_ARB               = 0x872D
;static const uint  GL_MODELVIEW14_ARB               = 0x872E
;static const uint  GL_MODELVIEW15_ARB               = 0x872F
;static const uint  GL_MODELVIEW16_ARB               = 0x8730
;static const uint  GL_MODELVIEW17_ARB               = 0x8731
;static const uint  GL_MODELVIEW18_ARB               = 0x8732
;static const uint  GL_MODELVIEW19_ARB               = 0x8733
;static const uint  GL_MODELVIEW20_ARB               = 0x8734
;static const uint  GL_MODELVIEW21_ARB               = 0x8735
;static const uint  GL_MODELVIEW22_ARB               = 0x8736
;static const uint  GL_MODELVIEW23_ARB               = 0x8737
;static const uint  GL_MODELVIEW24_ARB               = 0x8738
;static const uint  GL_MODELVIEW25_ARB               = 0x8739
;static const uint  GL_MODELVIEW26_ARB               = 0x873A
;static const uint  GL_MODELVIEW27_ARB               = 0x873B
;static const uint  GL_MODELVIEW28_ARB               = 0x873C
;static const uint  GL_MODELVIEW29_ARB               = 0x873D
;static const uint  GL_MODELVIEW30_ARB               = 0x873E
;static const uint  GL_MODELVIEW31_ARB               = 0x873F


////#ifndef GL_ARB_matrix_palette
;static const uint  GL_MATRIX_PALETTE_ARB            = 0x8840
;static const uint  GL_MAX_MATRIX_PALETTE_STACK_DEPTH_ARB= 0x8841
;static const uint  GL_MAX_PALETTE_MATRICES_ARB      = 0x8842
;static const uint  GL_CURRENT_PALETTE_MATRIX_ARB    = 0x8843
;static const uint  GL_MATRIX_INDEX_ARRAY_ARB        = 0x8844
;static const uint  GL_CURRENT_MATRIX_INDEX_ARB      = 0x8845
;static const uint  GL_MATRIX_INDEX_ARRAY_SIZE_ARB   = 0x8846
;static const uint  GL_MATRIX_INDEX_ARRAY_TYPE_ARB   = 0x8847
;static const uint  GL_MATRIX_INDEX_ARRAY_STRIDE_ARB = 0x8848
;static const uint  GL_MATRIX_INDEX_ARRAY_POINTER_ARB= 0x8849


////#ifndef GL_ARB_texture_env_combine
;static const uint  GL_COMBINE_ARB                   = 0x8570
;static const uint  GL_COMBINE_RGB_ARB               = 0x8571
;static const uint  GL_COMBINE_ALPHA_ARB             = 0x8572
;static const uint  GL_SOURCE0_RGB_ARB               = 0x8580
;static const uint  GL_SOURCE1_RGB_ARB               = 0x8581
;static const uint  GL_SOURCE2_RGB_ARB               = 0x8582
;static const uint  GL_SOURCE0_ALPHA_ARB             = 0x8588
;static const uint  GL_SOURCE1_ALPHA_ARB             = 0x8589
;static const uint  GL_SOURCE2_ALPHA_ARB             = 0x858A
;static const uint  GL_OPERAND0_RGB_ARB              = 0x8590
;static const uint  GL_OPERAND1_RGB_ARB              = 0x8591
;static const uint  GL_OPERAND2_RGB_ARB              = 0x8592
;static const uint  GL_OPERAND0_ALPHA_ARB            = 0x8598
;static const uint  GL_OPERAND1_ALPHA_ARB            = 0x8599
;static const uint  GL_OPERAND2_ALPHA_ARB            = 0x859A
;static const uint  GL_RGB_SCALE_ARB                 = 0x8573
;static const uint  GL_ADD_SIGNED_ARB                = 0x8574
;static const uint  GL_INTERPOLATE_ARB               = 0x8575
;static const uint  GL_SUBTRACT_ARB                  = 0x84E7
;static const uint  GL_CONSTANT_ARB                  = 0x8576
;static const uint  GL_PRIMARY_COLOR_ARB             = 0x8577
;static const uint  GL_PREVIOUS_ARB                  = 0x8578


////#ifndef GL_ARB_texture_env_crossbar


////#ifndef GL_ARB_texture_env_dot3
;static const uint  GL_DOT3_RGB_ARB                  = 0x86AE
;static const uint  GL_DOT3_RGBA_ARB                 = 0x86AF


////#ifndef GL_ARB_texture_mirrored_repeat
;static const uint  GL_MIRRORED_REPEAT_ARB           = 0x8370


////#ifndef GL_ARB_depth_texture
;static const uint  GL_DEPTH_COMPONENT16_ARB         = 0x81A5
;static const uint  GL_DEPTH_COMPONENT24_ARB         = 0x81A6
;static const uint  GL_DEPTH_COMPONENT32_ARB         = 0x81A7
;static const uint  GL_TEXTURE_DEPTH_SIZE_ARB        = 0x884A
;static const uint  GL_DEPTH_TEXTURE_MODE_ARB        = 0x884B


////#ifndef GL_ARB_shadow
;static const uint  GL_TEXTURE_COMPARE_MODE_ARB      = 0x884C
;static const uint  GL_TEXTURE_COMPARE_FUNC_ARB      = 0x884D
;static const uint  GL_COMPARE_R_TO_TEXTURE_ARB      = 0x884E


////#ifndef GL_ARB_shadow_ambient
;static const uint  GL_TEXTURE_COMPARE_FAIL_VALUE_ARB= 0x80BF


////#ifndef GL_ARB_window_pos


////#ifndef GL_ARB_vertex_program
;static const uint  GL_COLOR_SUM_ARB                 = 0x8458
;static const uint  GL_VERTEX_PROGRAM_ARB            = 0x8620
;static const uint  GL_VERTEX_ATTRIB_ARRAY_ENABLED_ARB= 0x8622
;static const uint  GL_VERTEX_ATTRIB_ARRAY_SIZE_ARB  = 0x8623
;static const uint  GL_VERTEX_ATTRIB_ARRAY_STRIDE_ARB= 0x8624
;static const uint  GL_VERTEX_ATTRIB_ARRAY_TYPE_ARB  = 0x8625
;static const uint  GL_CURRENT_VERTEX_ATTRIB_ARB     = 0x8626
;static const uint  GL_PROGRAM_LENGTH_ARB            = 0x8627
;static const uint  GL_PROGRAM_STRING_ARB            = 0x8628
;static const uint  GL_MAX_PROGRAM_MATRIX_STACK_DEPTH_ARB= 0x862E
;static const uint  GL_MAX_PROGRAM_MATRICES_ARB      = 0x862F
;static const uint  GL_CURRENT_MATRIX_STACK_DEPTH_ARB= 0x8640
;static const uint  GL_CURRENT_MATRIX_ARB            = 0x8641
;static const uint  GL_VERTEX_PROGRAM_POINT_SIZE_ARB = 0x8642
;static const uint  GL_VERTEX_PROGRAM_TWO_SIDE_ARB   = 0x8643
;static const uint  GL_VERTEX_ATTRIB_ARRAY_POINTER_ARB= 0x8645
;static const uint  GL_PROGRAM_ERROR_POSITION_ARB    = 0x864B
;static const uint  GL_PROGRAM_BINDING_ARB           = 0x8677
;static const uint  GL_MAX_VERTEX_ATTRIBS_ARB        = 0x8869
;static const uint  GL_VERTEX_ATTRIB_ARRAY_NORMALIZED_ARB= 0x886A
;static const uint  GL_PROGRAM_ERROR_STRING_ARB      = 0x8874
;static const uint  GL_PROGRAM_FORMAT_ASCII_ARB      = 0x8875
;static const uint  GL_PROGRAM_FORMAT_ARB            = 0x8876
;static const uint  GL_PROGRAM_INSTRUCTIONS_ARB      = 0x88A0
;static const uint  GL_MAX_PROGRAM_INSTRUCTIONS_ARB  = 0x88A1
;static const uint  GL_PROGRAM_NATIVE_INSTRUCTIONS_ARB= 0x88A2
;static const uint  GL_MAX_PROGRAM_NATIVE_INSTRUCTIONS_ARB= 0x88A3
;static const uint  GL_PROGRAM_TEMPORARIES_ARB       = 0x88A4
;static const uint  GL_MAX_PROGRAM_TEMPORARIES_ARB   = 0x88A5
;static const uint  GL_PROGRAM_NATIVE_TEMPORARIES_ARB= 0x88A6
;static const uint  GL_MAX_PROGRAM_NATIVE_TEMPORARIES_ARB= 0x88A7
;static const uint  GL_PROGRAM_PARAMETERS_ARB        = 0x88A8
;static const uint  GL_MAX_PROGRAM_PARAMETERS_ARB    = 0x88A9
;static const uint  GL_PROGRAM_NATIVE_PARAMETERS_ARB = 0x88AA
;static const uint  GL_MAX_PROGRAM_NATIVE_PARAMETERS_ARB= 0x88AB
;static const uint  GL_PROGRAM_ATTRIBS_ARB           = 0x88AC
;static const uint  GL_MAX_PROGRAM_ATTRIBS_ARB       = 0x88AD
;static const uint  GL_PROGRAM_NATIVE_ATTRIBS_ARB    = 0x88AE
;static const uint  GL_MAX_PROGRAM_NATIVE_ATTRIBS_ARB= 0x88AF
;static const uint  GL_PROGRAM_ADDRESS_REGISTERS_ARB = 0x88B0
;static const uint  GL_MAX_PROGRAM_ADDRESS_REGISTERS_ARB= 0x88B1
;static const uint  GL_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB= 0x88B2
;static const uint  GL_MAX_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB= 0x88B3
;static const uint  GL_MAX_PROGRAM_LOCAL_PARAMETERS_ARB= 0x88B4
;static const uint  GL_MAX_PROGRAM_ENV_PARAMETERS_ARB= 0x88B5
;static const uint  GL_PROGRAM_UNDER_NATIVE_LIMITS_ARB= 0x88B6
;static const uint  GL_TRANSPOSE_CURRENT_MATRIX_ARB  = 0x88B7
;static const uint  GL_MATRIX0_ARB                   = 0x88C0
;static const uint  GL_MATRIX1_ARB                   = 0x88C1
;static const uint  GL_MATRIX2_ARB                   = 0x88C2
;static const uint  GL_MATRIX3_ARB                   = 0x88C3
;static const uint  GL_MATRIX4_ARB                   = 0x88C4
;static const uint  GL_MATRIX5_ARB                   = 0x88C5
;static const uint  GL_MATRIX6_ARB                   = 0x88C6
;static const uint  GL_MATRIX7_ARB                   = 0x88C7
;static const uint  GL_MATRIX8_ARB                   = 0x88C8
;static const uint  GL_MATRIX9_ARB                   = 0x88C9
;static const uint  GL_MATRIX10_ARB                  = 0x88CA
;static const uint  GL_MATRIX11_ARB                  = 0x88CB
;static const uint  GL_MATRIX12_ARB                  = 0x88CC
;static const uint  GL_MATRIX13_ARB                  = 0x88CD
;static const uint  GL_MATRIX14_ARB                  = 0x88CE
;static const uint  GL_MATRIX15_ARB                  = 0x88CF
;static const uint  GL_MATRIX16_ARB                  = 0x88D0
;static const uint  GL_MATRIX17_ARB                  = 0x88D1
;static const uint  GL_MATRIX18_ARB                  = 0x88D2
;static const uint  GL_MATRIX19_ARB                  = 0x88D3
;static const uint  GL_MATRIX20_ARB                  = 0x88D4
;static const uint  GL_MATRIX21_ARB                  = 0x88D5
;static const uint  GL_MATRIX22_ARB                  = 0x88D6
;static const uint  GL_MATRIX23_ARB                  = 0x88D7
;static const uint  GL_MATRIX24_ARB                  = 0x88D8
;static const uint  GL_MATRIX25_ARB                  = 0x88D9
;static const uint  GL_MATRIX26_ARB                  = 0x88DA
;static const uint  GL_MATRIX27_ARB                  = 0x88DB
;static const uint  GL_MATRIX28_ARB                  = 0x88DC
;static const uint  GL_MATRIX29_ARB                  = 0x88DD
;static const uint  GL_MATRIX30_ARB                  = 0x88DE
;static const uint  GL_MATRIX31_ARB                  = 0x88DF


////#ifndef GL_ARB_fragment_program
;static const uint  GL_FRAGMENT_PROGRAM_ARB          = 0x8804
;static const uint  GL_PROGRAM_ALU_INSTRUCTIONS_ARB  = 0x8805
;static const uint  GL_PROGRAM_TEX_INSTRUCTIONS_ARB  = 0x8806
;static const uint  GL_PROGRAM_TEX_INDIRECTIONS_ARB  = 0x8807
;static const uint  GL_PROGRAM_NATIVE_ALU_INSTRUCTIONS_ARB= 0x8808
;static const uint  GL_PROGRAM_NATIVE_TEX_INSTRUCTIONS_ARB= 0x8809
;static const uint  GL_PROGRAM_NATIVE_TEX_INDIRECTIONS_ARB= 0x880A
;static const uint  GL_MAX_PROGRAM_ALU_INSTRUCTIONS_ARB= 0x880B
;static const uint  GL_MAX_PROGRAM_TEX_INSTRUCTIONS_ARB= 0x880C
;static const uint  GL_MAX_PROGRAM_TEX_INDIRECTIONS_ARB= 0x880D
;static const uint  GL_MAX_PROGRAM_NATIVE_ALU_INSTRUCTIONS_ARB= 0x880E
;static const uint  GL_MAX_PROGRAM_NATIVE_TEX_INSTRUCTIONS_ARB= 0x880F
;static const uint  GL_MAX_PROGRAM_NATIVE_TEX_INDIRECTIONS_ARB= 0x8810
;static const uint  GL_MAX_TEXTURE_COORDS_ARB        = 0x8871
;static const uint  GL_MAX_TEXTURE_IMAGE_UNITS_ARB   = 0x8872


////#ifndef GL_ARB_vertex_buffer_object
;static const uint  GL_BUFFER_SIZE_ARB               = 0x8764
;static const uint  GL_BUFFER_USAGE_ARB              = 0x8765
;static const uint  GL_ARRAY_BUFFER_ARB              = 0x8892
;static const uint  GL_ELEMENT_ARRAY_BUFFER_ARB      = 0x8893
;static const uint  GL_ARRAY_BUFFER_BINDING_ARB      = 0x8894
;static const uint  GL_ELEMENT_ARRAY_BUFFER_BINDING_ARB= 0x8895
;static const uint  GL_VERTEX_ARRAY_BUFFER_BINDING_ARB= 0x8896
;static const uint  GL_NORMAL_ARRAY_BUFFER_BINDING_ARB= 0x8897
;static const uint  GL_COLOR_ARRAY_BUFFER_BINDING_ARB= 0x8898
;static const uint  GL_INDEX_ARRAY_BUFFER_BINDING_ARB= 0x8899
;static const uint  GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING_ARB= 0x889A
;static const uint  GL_EDGE_FLAG_ARRAY_BUFFER_BINDING_ARB= 0x889B
;static const uint  GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING_ARB= 0x889C
;static const uint  GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING_ARB= 0x889D
;static const uint  GL_WEIGHT_ARRAY_BUFFER_BINDING_ARB= 0x889E
;static const uint  GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING_ARB= 0x889F
;static const uint  GL_READ_ONLY_ARB                 = 0x88B8
;static const uint  GL_WRITE_ONLY_ARB                = 0x88B9
;static const uint  GL_READ_WRITE_ARB                = 0x88BA
;static const uint  GL_BUFFER_ACCESS_ARB             = 0x88BB
;static const uint  GL_BUFFER_MAPPED_ARB             = 0x88BC
;static const uint  GL_BUFFER_MAP_POINTER_ARB        = 0x88BD
;static const uint  GL_STREAM_DRAW_ARB               = 0x88E0
;static const uint  GL_STREAM_READ_ARB               = 0x88E1
;static const uint  GL_STREAM_COPY_ARB               = 0x88E2
;static const uint  GL_STATIC_DRAW_ARB               = 0x88E4
;static const uint  GL_STATIC_READ_ARB               = 0x88E5
;static const uint  GL_STATIC_COPY_ARB               = 0x88E6
;static const uint  GL_DYNAMIC_DRAW_ARB              = 0x88E8
;static const uint  GL_DYNAMIC_READ_ARB              = 0x88E9
;static const uint  GL_DYNAMIC_COPY_ARB              = 0x88EA


////#ifndef GL_ARB_occlusion_query
;static const uint  GL_QUERY_COUNTER_BITS_ARB        = 0x8864
;static const uint  GL_CURRENT_QUERY_ARB             = 0x8865
;static const uint  GL_QUERY_RESULT_ARB              = 0x8866
;static const uint  GL_QUERY_RESULT_AVAILABLE_ARB    = 0x8867
;static const uint  GL_SAMPLES_PASSED_ARB            = 0x8914


////#ifndef GL_ARB_shader_objects
;static const uint  GL_PROGRAM_OBJECT_ARB            = 0x8B40
;static const uint  GL_SHADER_OBJECT_ARB             = 0x8B48
;static const uint  GL_OBJECT_TYPE_ARB               = 0x8B4E
;static const uint  GL_OBJECT_SUBTYPE_ARB            = 0x8B4F
;static const uint  GL_FLOAT_VEC2_ARB                = 0x8B50
;static const uint  GL_FLOAT_VEC3_ARB                = 0x8B51
;static const uint  GL_FLOAT_VEC4_ARB                = 0x8B52
;static const uint  GL_INT_VEC2_ARB                  = 0x8B53
;static const uint  GL_INT_VEC3_ARB                  = 0x8B54
;static const uint  GL_INT_VEC4_ARB                  = 0x8B55
;static const uint  GL_BOOL_ARB                      = 0x8B56
;static const uint  GL_BOOL_VEC2_ARB                 = 0x8B57
;static const uint  GL_BOOL_VEC3_ARB                 = 0x8B58
;static const uint  GL_BOOL_VEC4_ARB                 = 0x8B59
;static const uint  GL_FLOAT_MAT2_ARB                = 0x8B5A
;static const uint  GL_FLOAT_MAT3_ARB                = 0x8B5B
;static const uint  GL_FLOAT_MAT4_ARB                = 0x8B5C
;static const uint  GL_SAMPLER_1D_ARB                = 0x8B5D
;static const uint  GL_SAMPLER_2D_ARB                = 0x8B5E
;static const uint  GL_SAMPLER_3D_ARB                = 0x8B5F
;static const uint  GL_SAMPLER_CUBE_ARB              = 0x8B60
;static const uint  GL_SAMPLER_1D_SHADOW_ARB         = 0x8B61
;static const uint  GL_SAMPLER_2D_SHADOW_ARB         = 0x8B62
;static const uint  GL_SAMPLER_2D_RECT_ARB           = 0x8B63
;static const uint  GL_SAMPLER_2D_RECT_SHADOW_ARB    = 0x8B64
;static const uint  GL_OBJECT_DELETE_STATUS_ARB      = 0x8B80
;static const uint  GL_OBJECT_COMPILE_STATUS_ARB     = 0x8B81
;static const uint  GL_OBJECT_LINK_STATUS_ARB        = 0x8B82
;static const uint  GL_OBJECT_VALIDATE_STATUS_ARB    = 0x8B83
;static const uint  GL_OBJECT_INFO_LOG_LENGTH_ARB    = 0x8B84
;static const uint  GL_OBJECT_ATTACHED_OBJECTS_ARB   = 0x8B85
;static const uint  GL_OBJECT_ACTIVE_UNIFORMS_ARB    = 0x8B86
;static const uint  GL_OBJECT_ACTIVE_UNIFORM_MAX_LENGTH_ARB= 0x8B87
;static const uint  GL_OBJECT_SHADER_SOURCE_LENGTH_ARB= 0x8B88


////#ifndef GL_ARB_vertex_shader
;static const uint  GL_VERTEX_SHADER_ARB             = 0x8B31
;static const uint  GL_MAX_VERTEX_UNIFORM_COMPONENTS_ARB= 0x8B4A
;static const uint  GL_MAX_VARYING_FLOATS_ARB        = 0x8B4B
;static const uint  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS_ARB= 0x8B4C
;static const uint  GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS_ARB= 0x8B4D
;static const uint  GL_OBJECT_ACTIVE_ATTRIBUTES_ARB  = 0x8B89
;static const uint  GL_OBJECT_ACTIVE_ATTRIBUTE_MAX_LENGTH_ARB= 0x8B8A


////#ifndef GL_ARB_fragment_shader
;static const uint  GL_FRAGMENT_SHADER_ARB           = 0x8B30
;static const uint  GL_MAX_FRAGMENT_UNIFORM_COMPONENTS_ARB= 0x8B49
;static const uint  GL_FRAGMENT_SHADER_DERIVATIVE_HINT_ARB= 0x8B8B


////#ifndef GL_ARB_shading_language_100
;static const uint  GL_SHADING_LANGUAGE_VERSION_ARB  = 0x8B8C


////#ifndef GL_ARB_texture_non_power_of_two


////#ifndef GL_ARB_point_sprite
;static const uint  GL_POINT_SPRITE_ARB              = 0x8861
;static const uint  GL_COORD_REPLACE_ARB             = 0x8862


////#ifndef GL_ARB_fragment_program_shadow


////#ifndef GL_ARB_draw_buffers
;static const uint  GL_MAX_DRAW_BUFFERS_ARB          = 0x8824
;static const uint  GL_DRAW_BUFFER0_ARB              = 0x8825
;static const uint  GL_DRAW_BUFFER1_ARB              = 0x8826
;static const uint  GL_DRAW_BUFFER2_ARB              = 0x8827
;static const uint  GL_DRAW_BUFFER3_ARB              = 0x8828
;static const uint  GL_DRAW_BUFFER4_ARB              = 0x8829
;static const uint  GL_DRAW_BUFFER5_ARB              = 0x882A
;static const uint  GL_DRAW_BUFFER6_ARB              = 0x882B
;static const uint  GL_DRAW_BUFFER7_ARB              = 0x882C
;static const uint  GL_DRAW_BUFFER8_ARB              = 0x882D
;static const uint  GL_DRAW_BUFFER9_ARB              = 0x882E
;static const uint  GL_DRAW_BUFFER10_ARB             = 0x882F
;static const uint  GL_DRAW_BUFFER11_ARB             = 0x8830
;static const uint  GL_DRAW_BUFFER12_ARB             = 0x8831
;static const uint  GL_DRAW_BUFFER13_ARB             = 0x8832
;static const uint  GL_DRAW_BUFFER14_ARB             = 0x8833
;static const uint  GL_DRAW_BUFFER15_ARB             = 0x8834


////#ifndef GL_ARB_texture_rectangle
;static const uint  GL_TEXTURE_RECTANGLE_ARB         = 0x84F5
;static const uint  GL_TEXTURE_BINDING_RECTANGLE_ARB = 0x84F6
;static const uint  GL_PROXY_TEXTURE_RECTANGLE_ARB   = 0x84F7
;static const uint  GL_MAX_RECTANGLE_TEXTURE_SIZE_ARB= 0x84F8


////#ifndef GL_ARB_color_buffer_float
;static const uint  GL_RGBA_FLOAT_MODE_ARB           = 0x8820
;static const uint  GL_CLAMP_VERTEX_COLOR_ARB        = 0x891A
;static const uint  GL_CLAMP_FRAGMENT_COLOR_ARB      = 0x891B
;static const uint  GL_CLAMP_READ_COLOR_ARB          = 0x891C
;static const uint  GL_FIXED_ONLY_ARB                = 0x891D


////#ifndef GL_ARB_half_float_pixel
;static const uint  GL_HALF_FLOAT_ARB                = 0x140B


////#ifndef GL_ARB_texture_float
;static const uint  GL_TEXTURE_RED_TYPE_ARB          = 0x8C10
;static const uint  GL_TEXTURE_GREEN_TYPE_ARB        = 0x8C11
;static const uint  GL_TEXTURE_BLUE_TYPE_ARB         = 0x8C12
;static const uint  GL_TEXTURE_ALPHA_TYPE_ARB        = 0x8C13
;static const uint  GL_TEXTURE_LUMINANCE_TYPE_ARB    = 0x8C14
;static const uint  GL_TEXTURE_INTENSITY_TYPE_ARB    = 0x8C15
;static const uint  GL_TEXTURE_DEPTH_TYPE_ARB        = 0x8C16
;static const uint  GL_UNSIGNED_NORMALIZED_ARB       = 0x8C17
;static const uint  GL_RGBA32F_ARB                   = 0x8814
;static const uint  GL_RGB32F_ARB                    = 0x8815
;static const uint  GL_ALPHA32F_ARB                  = 0x8816
;static const uint  GL_INTENSITY32F_ARB              = 0x8817
;static const uint  GL_LUMINANCE32F_ARB              = 0x8818
;static const uint  GL_LUMINANCE_ALPHA32F_ARB        = 0x8819
;static const uint  GL_RGBA16F_ARB                   = 0x881A
;static const uint  GL_RGB16F_ARB                    = 0x881B
;static const uint  GL_ALPHA16F_ARB                  = 0x881C
;static const uint  GL_INTENSITY16F_ARB              = 0x881D
;static const uint  GL_LUMINANCE16F_ARB              = 0x881E
;static const uint  GL_LUMINANCE_ALPHA16F_ARB        = 0x881F


////#ifndef GL_ARB_pixel_buffer_object
;static const uint  GL_PIXEL_PACK_BUFFER_ARB         = 0x88EB
;static const uint  GL_PIXEL_UNPACK_BUFFER_ARB       = 0x88EC
;static const uint  GL_PIXEL_PACK_BUFFER_BINDING_ARB = 0x88ED
;static const uint  GL_PIXEL_UNPACK_BUFFER_BINDING_ARB= 0x88EF


////#ifndef GL_ARB_depth_buffer_float
;static const uint  GL_DEPTH_COMPONENT32F            = 0x8CAC
;static const uint  GL_DEPTH32F_STENCIL8             = 0x8CAD
;static const uint  GL_FLOAT_32_UNSIGNED_INT_24_8_REV= 0x8DAD


////#ifndef GL_ARB_draw_instanced


////#ifndef GL_ARB_framebuffer_object
;static const uint  GL_INVALID_FRAMEBUFFER_OPERATION = 0x0506
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING= 0x8210
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE= 0x8211
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE= 0x8212
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE= 0x8213
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE= 0x8214
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE= 0x8215
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE= 0x8216
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE= 0x8217
;static const uint  GL_FRAMEBUFFER_DEFAULT           = 0x8218
;static const uint  GL_FRAMEBUFFER_UNDEFINED         = 0x8219
;static const uint  GL_DEPTH_STENCIL_ATTACHMENT      = 0x821A
;static const uint  GL_MAX_RENDERBUFFER_SIZE         = 0x84E8
;static const uint  GL_DEPTH_STENCIL                 = 0x84F9
;static const uint  GL_UNSIGNED_INT_24_8             = 0x84FA
;static const uint  GL_DEPTH24_STENCIL8              = 0x88F0
;static const uint  GL_TEXTURE_STENCIL_SIZE          = 0x88F1
;static const uint  GL_TEXTURE_RED_TYPE              = 0x8C10
;static const uint  GL_TEXTURE_GREEN_TYPE            = 0x8C11
;static const uint  GL_TEXTURE_BLUE_TYPE             = 0x8C12
;static const uint  GL_TEXTURE_ALPHA_TYPE            = 0x8C13
;static const uint  GL_TEXTURE_DEPTH_TYPE            = 0x8C16
;static const uint  GL_UNSIGNED_NORMALIZED           = 0x8C17
;static const uint  GL_FRAMEBUFFER_BINDING           = 0x8CA6
;static const uint  GL_DRAW_FRAMEBUFFER_BINDING      = 0x8CA6
;static const uint  GL_RENDERBUFFER_BINDING          = 0x8CA7
;static const uint  GL_READ_FRAMEBUFFER              = 0x8CA8
;static const uint  GL_DRAW_FRAMEBUFFER              = 0x8CA9
;static const uint  GL_READ_FRAMEBUFFER_BINDING      = 0x8CAA
;static const uint  GL_RENDERBUFFER_SAMPLES          = 0x8CAB
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE= 0x8CD0
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME= 0x8CD1
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL= 0x8CD2
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE= 0x8CD3
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER= 0x8CD4
;static const uint  GL_FRAMEBUFFER_COMPLETE          = 0x8CD5
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT= 0x8CD6
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT= 0x8CD7
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER= 0x8CDB
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER= 0x8CDC
;static const uint  GL_FRAMEBUFFER_UNSUPPORTED       = 0x8CDD
;static const uint  GL_MAX_COLOR_ATTACHMENTS         = 0x8CDF
;static const uint  GL_COLOR_ATTACHMENT0             = 0x8CE0
;static const uint  GL_COLOR_ATTACHMENT1             = 0x8CE1
;static const uint  GL_COLOR_ATTACHMENT2             = 0x8CE2
;static const uint  GL_COLOR_ATTACHMENT3             = 0x8CE3
;static const uint  GL_COLOR_ATTACHMENT4             = 0x8CE4
;static const uint  GL_COLOR_ATTACHMENT5             = 0x8CE5
;static const uint  GL_COLOR_ATTACHMENT6             = 0x8CE6
;static const uint  GL_COLOR_ATTACHMENT7             = 0x8CE7
;static const uint  GL_COLOR_ATTACHMENT8             = 0x8CE8
;static const uint  GL_COLOR_ATTACHMENT9             = 0x8CE9
;static const uint  GL_COLOR_ATTACHMENT10            = 0x8CEA
;static const uint  GL_COLOR_ATTACHMENT11            = 0x8CEB
;static const uint  GL_COLOR_ATTACHMENT12            = 0x8CEC
;static const uint  GL_COLOR_ATTACHMENT13            = 0x8CED
;static const uint  GL_COLOR_ATTACHMENT14            = 0x8CEE
;static const uint  GL_COLOR_ATTACHMENT15            = 0x8CEF
;static const uint  GL_DEPTH_ATTACHMENT              = 0x8D00
;static const uint  GL_STENCIL_ATTACHMENT            = 0x8D20
;static const uint  GL_FRAMEBUFFER                   = 0x8D40
;static const uint  GL_RENDERBUFFER                  = 0x8D41
;static const uint  GL_RENDERBUFFER_WIDTH            = 0x8D42
;static const uint  GL_RENDERBUFFER_HEIGHT           = 0x8D43
;static const uint  GL_RENDERBUFFER_INTERNAL_FORMAT  = 0x8D44
;static const uint  GL_STENCIL_INDEX1                = 0x8D46
;static const uint  GL_STENCIL_INDEX4                = 0x8D47
;static const uint  GL_STENCIL_INDEX8                = 0x8D48
;static const uint  GL_STENCIL_INDEX16               = 0x8D49
;static const uint  GL_RENDERBUFFER_RED_SIZE         = 0x8D50
;static const uint  GL_RENDERBUFFER_GREEN_SIZE       = 0x8D51
;static const uint  GL_RENDERBUFFER_BLUE_SIZE        = 0x8D52
;static const uint  GL_RENDERBUFFER_ALPHA_SIZE       = 0x8D53
;static const uint  GL_RENDERBUFFER_DEPTH_SIZE       = 0x8D54
;static const uint  GL_RENDERBUFFER_STENCIL_SIZE     = 0x8D55
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE= 0x8D56
;static const uint  GL_MAX_SAMPLES                   = 0x8D57
;static const uint  GL_INDEX                         = 0x8222
;static const uint  GL_TEXTURE_LUMINANCE_TYPE        = 0x8C14
;static const uint  GL_TEXTURE_INTENSITY_TYPE        = 0x8C15


////#ifndef GL_ARB_framebuffer_sRGB
;static const uint  GL_FRAMEBUFFER_SRGB              = 0x8DB9


////#ifndef GL_ARB_geometry_shader4
;static const uint  GL_LINES_ADJACENCY_ARB           = 0x000A
;static const uint  GL_LINE_STRIP_ADJACENCY_ARB      = 0x000B
;static const uint  GL_TRIANGLES_ADJACENCY_ARB       = 0x000C
;static const uint  GL_TRIANGLE_STRIP_ADJACENCY_ARB  = 0x000D
;static const uint  GL_PROGRAM_POINT_SIZE_ARB        = 0x8642
;static const uint  GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_ARB= 0x8C29
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_LAYERED_ARB= 0x8DA7
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_ARB= 0x8DA8
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_ARB= 0x8DA9
;static const uint  GL_GEOMETRY_SHADER_ARB           = 0x8DD9
;static const uint  GL_GEOMETRY_VERTICES_OUT_ARB     = 0x8DDA
;static const uint  GL_GEOMETRY_INPUT_TYPE_ARB       = 0x8DDB
;static const uint  GL_GEOMETRY_OUTPUT_TYPE_ARB      = 0x8DDC
;static const uint  GL_MAX_GEOMETRY_VARYING_COMPONENTS_ARB= 0x8DDD
;static const uint  GL_MAX_VERTEX_VARYING_COMPONENTS_ARB= 0x8DDE
;static const uint  GL_MAX_GEOMETRY_UNIFORM_COMPONENTS_ARB= 0x8DDF
;static const uint  GL_MAX_GEOMETRY_OUTPUT_VERTICES_ARB= 0x8DE0
;static const uint  GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS_ARB= 0x8DE1
/* reuse GL_MAX_VARYING_COMPONENTS */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER */


////#ifndef GL_ARB_half_float_vertex
;static const uint  GL_HALF_FLOAT                    = 0x140B


////#ifndef GL_ARB_instanced_arrays
;static const uint  GL_VERTEX_ATTRIB_ARRAY_DIVISOR_ARB= 0x88FE


////#ifndef GL_ARB_map_buffer_range
;static const uint  GL_MAP_READ_BIT                  = 0x0001
;static const uint  GL_MAP_WRITE_BIT                 = 0x0002
;static const uint  GL_MAP_INVALIDATE_RANGE_BIT      = 0x0004
;static const uint  GL_MAP_INVALIDATE_BUFFER_BIT     = 0x0008
;static const uint  GL_MAP_FLUSH_EXPLICIT_BIT        = 0x0010
;static const uint  GL_MAP_UNSYNCHRONIZED_BIT        = 0x0020


////#ifndef GL_ARB_texture_buffer_object
;static const uint  GL_TEXTURE_BUFFER_ARB            = 0x8C2A
;static const uint  GL_MAX_TEXTURE_BUFFER_SIZE_ARB   = 0x8C2B
;static const uint  GL_TEXTURE_BINDING_BUFFER_ARB    = 0x8C2C
;static const uint  GL_TEXTURE_BUFFER_DATA_STORE_BINDING_ARB= 0x8C2D
;static const uint  GL_TEXTURE_BUFFER_FORMAT_ARB     = 0x8C2E


////#ifndef GL_ARB_texture_compression_rgtc
;static const uint  GL_COMPRESSED_RED_RGTC1          = 0x8DBB
;static const uint  GL_COMPRESSED_SIGNED_RED_RGTC1   = 0x8DBC
;static const uint  GL_COMPRESSED_RG_RGTC2           = 0x8DBD
;static const uint  GL_COMPRESSED_SIGNED_RG_RGTC2    = 0x8DBE


////#ifndef GL_ARB_texture_rg
;static const uint  GL_RG                            = 0x8227
;static const uint  GL_RG_INTEGER                    = 0x8228
;static const uint  GL_R8                            = 0x8229
;static const uint  GL_R16                           = 0x822A
;static const uint  GL_RG8                           = 0x822B
;static const uint  GL_RG16                          = 0x822C
;static const uint  GL_R16F                          = 0x822D
;static const uint  GL_R32F                          = 0x822E
;static const uint  GL_RG16F                         = 0x822F
;static const uint  GL_RG32F                         = 0x8230
;static const uint  GL_R8I                           = 0x8231
;static const uint  GL_R8UI                          = 0x8232
;static const uint  GL_R16I                          = 0x8233
;static const uint  GL_R16UI                         = 0x8234
;static const uint  GL_R32I                          = 0x8235
;static const uint  GL_R32UI                         = 0x8236
;static const uint  GL_RG8I                          = 0x8237
;static const uint  GL_RG8UI                         = 0x8238
;static const uint  GL_RG16I                         = 0x8239
;static const uint  GL_RG16UI                        = 0x823A
;static const uint  GL_RG32I                         = 0x823B
;static const uint  GL_RG32UI                        = 0x823C


////#ifndef GL_ARB_vertex_array_object
;static const uint  GL_VERTEX_ARRAY_BINDING          = 0x85B5


////#ifndef GL_ARB_uniform_buffer_object
;static const uint  GL_UNIFORM_BUFFER                = 0x8A11
;static const uint  GL_UNIFORM_BUFFER_BINDING        = 0x8A28
;static const uint  GL_UNIFORM_BUFFER_START          = 0x8A29
;static const uint  GL_UNIFORM_BUFFER_SIZE           = 0x8A2A
;static const uint  GL_MAX_VERTEX_UNIFORM_BLOCKS     = 0x8A2B
;static const uint  GL_MAX_GEOMETRY_UNIFORM_BLOCKS   = 0x8A2C
;static const uint  GL_MAX_FRAGMENT_UNIFORM_BLOCKS   = 0x8A2D
;static const uint  GL_MAX_COMBINED_UNIFORM_BLOCKS   = 0x8A2E
;static const uint  GL_MAX_UNIFORM_BUFFER_BINDINGS   = 0x8A2F
;static const uint  GL_MAX_UNIFORM_BLOCK_SIZE        = 0x8A30
;static const uint  GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS= 0x8A31
;static const uint  GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS= 0x8A32
;static const uint  GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS= 0x8A33
;static const uint  GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT= 0x8A34
;static const uint  GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH= 0x8A35
;static const uint  GL_ACTIVE_UNIFORM_BLOCKS         = 0x8A36
;static const uint  GL_UNIFORM_TYPE                  = 0x8A37
;static const uint  GL_UNIFORM_SIZE                  = 0x8A38
;static const uint  GL_UNIFORM_NAME_LENGTH           = 0x8A39
;static const uint  GL_UNIFORM_BLOCK_INDEX           = 0x8A3A
;static const uint  GL_UNIFORM_OFFSET                = 0x8A3B
;static const uint  GL_UNIFORM_ARRAY_STRIDE          = 0x8A3C
;static const uint  GL_UNIFORM_MATRIX_STRIDE         = 0x8A3D
;static const uint  GL_UNIFORM_IS_ROW_MAJOR          = 0x8A3E
;static const uint  GL_UNIFORM_BLOCK_BINDING         = 0x8A3F
;static const uint  GL_UNIFORM_BLOCK_DATA_SIZE       = 0x8A40
;static const uint  GL_UNIFORM_BLOCK_NAME_LENGTH     = 0x8A41
;static const uint  GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS = 0x8A42
;static const uint  GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES= 0x8A43
;static const uint  GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER= 0x8A44
;static const uint  GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER= 0x8A45
;static const uint  GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER= 0x8A46
;static const uint  GL_INVALID_INDEX                 = 0xFFFFFFFFu


////#ifndef GL_ARB_compatibility
/* ARB_compatibility just defines tokens from core 3.0 */


////#ifndef GL_ARB_copy_buffer
;static const uint  GL_COPY_READ_BUFFER_BINDING      = 0x8F36
;static const uint  GL_COPY_READ_BUFFER              = 0x8F36
;static const uint  GL_COPY_WRITE_BUFFER_BINDING     = 0x8F37
;static const uint  GL_COPY_WRITE_BUFFER             = 0x8F37


////#ifndef GL_ARB_shader_texture_lod


////#ifndef GL_ARB_depth_clamp
;static const uint  GL_DEPTH_CLAMP                   = 0x864F


////#ifndef GL_ARB_draw_elements_base_vertex


////#ifndef GL_ARB_fragment_coord_conventions


////#ifndef GL_ARB_provoking_vertex
;static const uint  GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION= 0x8E4C
;static const uint  GL_FIRST_VERTEX_CONVENTION       = 0x8E4D
;static const uint  GL_LAST_VERTEX_CONVENTION        = 0x8E4E
;static const uint  GL_PROVOKING_VERTEX              = 0x8E4F


////#ifndef GL_ARB_seamless_cube_map
;static const uint  GL_TEXTURE_CUBE_MAP_SEAMLESS     = 0x884F


////#ifndef GL_ARB_sync
;static const uint  GL_MAX_SERVER_WAIT_TIMEOUT       = 0x9111
;static const uint  GL_OBJECT_TYPE                   = 0x9112
;static const uint  GL_SYNC_CONDITION                = 0x9113
;static const uint  GL_SYNC_STATUS                   = 0x9114
;static const uint  GL_SYNC_FLAGS                    = 0x9115
;static const uint  GL_SYNC_FENCE                    = 0x9116
;static const uint  GL_SYNC_GPU_COMMANDS_COMPLETE    = 0x9117
;static const uint  GL_UNSIGNALED                    = 0x9118
;static const uint  GL_SIGNALED                      = 0x9119
;static const uint  GL_ALREADY_SIGNALED              = 0x911A
;static const uint  GL_TIMEOUT_EXPIRED               = 0x911B
;static const uint  GL_CONDITION_SATISFIED           = 0x911C
;static const uint  GL_WAIT_FAILED                   = 0x911D
;static const uint  GL_SYNC_FLUSH_COMMANDS_BIT       = 0x00000001
;static const uint  GL_TIMEOUT_IGNORED               = -1;


////#ifndef GL_ARB_texture_multisample
;static const uint  GL_SAMPLE_POSITION               = 0x8E50
;static const uint  GL_SAMPLE_MASK                   = 0x8E51
;static const uint  GL_SAMPLE_MASK_VALUE             = 0x8E52
;static const uint  GL_MAX_SAMPLE_MASK_WORDS         = 0x8E59
;static const uint  GL_TEXTURE_2D_MULTISAMPLE        = 0x9100
;static const uint  GL_PROXY_TEXTURE_2D_MULTISAMPLE  = 0x9101
;static const uint  GL_TEXTURE_2D_MULTISAMPLE_ARRAY  = 0x9102
;static const uint  GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY= 0x9103
;static const uint  GL_TEXTURE_BINDING_2D_MULTISAMPLE= 0x9104
;static const uint  GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY= 0x9105
;static const uint  GL_TEXTURE_SAMPLES               = 0x9106
;static const uint  GL_TEXTURE_FIXED_SAMPLE_LOCATIONS= 0x9107
;static const uint  GL_SAMPLER_2D_MULTISAMPLE        = 0x9108
;static const uint  GL_INT_SAMPLER_2D_MULTISAMPLE    = 0x9109
;static const uint  GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE= 0x910A
;static const uint  GL_SAMPLER_2D_MULTISAMPLE_ARRAY  = 0x910B
;static const uint  GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY= 0x910C
;static const uint  GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY= 0x910D
;static const uint  GL_MAX_COLOR_TEXTURE_SAMPLES     = 0x910E
;static const uint  GL_MAX_DEPTH_TEXTURE_SAMPLES     = 0x910F
;static const uint  GL_MAX_INTEGER_SAMPLES           = 0x9110


////#ifndef GL_ARB_vertex_array_bgra
/* reuse GL_BGRA */


////#ifndef GL_ARB_draw_buffers_blend


////#ifndef GL_ARB_sample_shading
;static const uint  GL_SAMPLE_SHADING_ARB            = 0x8C36
;static const uint  GL_MIN_SAMPLE_SHADING_VALUE_ARB  = 0x8C37


////#ifndef GL_ARB_texture_cube_map_array
;static const uint  GL_TEXTURE_CUBE_MAP_ARRAY_ARB    = 0x9009
;static const uint  GL_TEXTURE_BINDING_CUBE_MAP_ARRAY_ARB= 0x900A
;static const uint  GL_PROXY_TEXTURE_CUBE_MAP_ARRAY_ARB= 0x900B
;static const uint  GL_SAMPLER_CUBE_MAP_ARRAY_ARB    = 0x900C
;static const uint  GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW_ARB= 0x900D
;static const uint  GL_INT_SAMPLER_CUBE_MAP_ARRAY_ARB= 0x900E
;static const uint  GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY_ARB= 0x900F


////#ifndef GL_ARB_texture_gather
;static const uint  GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET_ARB= 0x8E5E
;static const uint  GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET_ARB= 0x8E5F
;static const uint  GL_MAX_PROGRAM_TEXTURE_GATHER_COMPONENTS_ARB= 0x8F9F


////#ifndef GL_ARB_texture_query_lod


////#ifndef GL_ARB_shading_language_include
;static const uint  GL_SHADER_INCLUDE_ARB            = 0x8DAE
;static const uint  GL_NAMED_STRING_LENGTH_ARB       = 0x8DE9
;static const uint  GL_NAMED_STRING_TYPE_ARB         = 0x8DEA


////#ifndef GL_ARB_texture_compression_bptc
;static const uint  GL_COMPRESSED_RGBA_BPTC_UNORM_ARB= 0x8E8C
;static const uint  GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM_ARB= 0x8E8D
;static const uint  GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT_ARB= 0x8E8E
;static const uint  GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_ARB= 0x8E8F


////#ifndef GL_ARB_blend_func_extended
;static const uint  GL_SRC1_COLOR                    = 0x88F9
/* reuse GL_SRC1_ALPHA */
;static const uint  GL_ONE_MINUS_SRC1_COLOR          = 0x88FA
;static const uint  GL_ONE_MINUS_SRC1_ALPHA          = 0x88FB
;static const uint  GL_MAX_DUAL_SOURCE_DRAW_BUFFERS  = 0x88FC


////#ifndef GL_ARB_explicit_attrib_location


////#ifndef GL_ARB_occlusion_query2
;static const uint  GL_ANY_SAMPLES_PASSED            = 0x8C2F


////#ifndef GL_ARB_sampler_objects
;static const uint  GL_SAMPLER_BINDING               = 0x8919


////#ifndef GL_ARB_shader_bit_encoding


////#ifndef GL_ARB_texture_rgb10_a2ui
;static const uint  GL_RGB10_A2UI                    = 0x906F


////#ifndef GL_ARB_texture_swizzle
;static const uint  GL_TEXTURE_SWIZZLE_R             = 0x8E42
;static const uint  GL_TEXTURE_SWIZZLE_G             = 0x8E43
;static const uint  GL_TEXTURE_SWIZZLE_B             = 0x8E44
;static const uint  GL_TEXTURE_SWIZZLE_A             = 0x8E45
;static const uint  GL_TEXTURE_SWIZZLE_RGBA          = 0x8E46


////#ifndef GL_ARB_timer_query
;static const uint  GL_TIME_ELAPSED                  = 0x88BF
;static const uint  GL_TIMESTAMP                     = 0x8E28


////#ifndef GL_ARB_vertex_type_2_10_10_10_rev
/* reuse GL_UNSIGNED_INT_2_10_10_10_REV */
;static const uint  GL_INT_2_10_10_10_REV            = 0x8D9F


////#ifndef GL_ARB_draw_indirect
;static const uint  GL_DRAW_INDIRECT_BUFFER          = 0x8F3F
;static const uint  GL_DRAW_INDIRECT_BUFFER_BINDING  = 0x8F43


////#ifndef GL_ARB_gpu_shader5
;static const uint  GL_GEOMETRY_SHADER_INVOCATIONS   = 0x887F
;static const uint  GL_MAX_GEOMETRY_SHADER_INVOCATIONS= 0x8E5A
;static const uint  GL_MIN_FRAGMENT_INTERPOLATION_OFFSET= 0x8E5B
;static const uint  GL_MAX_FRAGMENT_INTERPOLATION_OFFSET= 0x8E5C
;static const uint  GL_FRAGMENT_INTERPOLATION_OFFSET_BITS= 0x8E5D
/* reuse GL_MAX_VERTEX_STREAMS */


////#ifndef GL_ARB_gpu_shader_fp64
/* reuse GL_DOUBLE */
;static const uint  GL_DOUBLE_VEC2                   = 0x8FFC
;static const uint  GL_DOUBLE_VEC3                   = 0x8FFD
;static const uint  GL_DOUBLE_VEC4                   = 0x8FFE
;static const uint  GL_DOUBLE_MAT2                   = 0x8F46
;static const uint  GL_DOUBLE_MAT3                   = 0x8F47
;static const uint  GL_DOUBLE_MAT4                   = 0x8F48
;static const uint  GL_DOUBLE_MAT2x3                 = 0x8F49
;static const uint  GL_DOUBLE_MAT2x4                 = 0x8F4A
;static const uint  GL_DOUBLE_MAT3x2                 = 0x8F4B
;static const uint  GL_DOUBLE_MAT3x4                 = 0x8F4C
;static const uint  GL_DOUBLE_MAT4x2                 = 0x8F4D
;static const uint  GL_DOUBLE_MAT4x3                 = 0x8F4E


////#ifndef GL_ARB_shader_subroutine
;static const uint  GL_ACTIVE_SUBROUTINES            = 0x8DE5
;static const uint  GL_ACTIVE_SUBROUTINE_UNIFORMS    = 0x8DE6
;static const uint  GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS= 0x8E47
;static const uint  GL_ACTIVE_SUBROUTINE_MAX_LENGTH  = 0x8E48
;static const uint  GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH= 0x8E49
;static const uint  GL_MAX_SUBROUTINES               = 0x8DE7
;static const uint  GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS= 0x8DE8
;static const uint  GL_NUM_COMPATIBLE_SUBROUTINES    = 0x8E4A
;static const uint  GL_COMPATIBLE_SUBROUTINES        = 0x8E4B
/* reuse GL_UNIFORM_SIZE */
/* reuse GL_UNIFORM_NAME_LENGTH */


////#ifndef GL_ARB_tessellation_shader
;static const uint  GL_PATCHES                       = 0x000E
;static const uint  GL_PATCH_VERTICES                = 0x8E72
;static const uint  GL_PATCH_DEFAULT_INNER_LEVEL     = 0x8E73
;static const uint  GL_PATCH_DEFAULT_OUTER_LEVEL     = 0x8E74
;static const uint  GL_TESS_CONTROL_OUTPUT_VERTICES  = 0x8E75
;static const uint  GL_TESS_GEN_MODE                 = 0x8E76
;static const uint  GL_TESS_GEN_SPACING              = 0x8E77
;static const uint  GL_TESS_GEN_VERTEX_ORDER         = 0x8E78
;static const uint  GL_TESS_GEN_POINT_MODE           = 0x8E79
/* reuse GL_TRIANGLES */
/* reuse GL_QUADS */
;static const uint  GL_ISOLINES                      = 0x8E7A
/* reuse GL_EQUAL */
;static const uint  GL_FRACTIONAL_ODD                = 0x8E7B
;static const uint  GL_FRACTIONAL_EVEN               = 0x8E7C
/* reuse GL_CCW */
/* reuse GL_CW */
;static const uint  GL_MAX_PATCH_VERTICES            = 0x8E7D
;static const uint  GL_MAX_TESS_GEN_LEVEL            = 0x8E7E
;static const uint  GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS= 0x8E7F
;static const uint  GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS= 0x8E80
;static const uint  GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS= 0x8E81
;static const uint  GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS= 0x8E82
;static const uint  GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS= 0x8E83
;static const uint  GL_MAX_TESS_PATCH_COMPONENTS     = 0x8E84
;static const uint  GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS= 0x8E85
;static const uint  GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS= 0x8E86
;static const uint  GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS= 0x8E89
;static const uint  GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS= 0x8E8A
;static const uint  GL_MAX_TESS_CONTROL_INPUT_COMPONENTS= 0x886C
;static const uint  GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS= 0x886D
;static const uint  GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS= 0x8E1E
;static const uint  GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS= 0x8E1F
;static const uint  GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER= 0x84F0
;static const uint  GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER= 0x84F1
;static const uint  GL_TESS_EVALUATION_SHADER        = 0x8E87
;static const uint  GL_TESS_CONTROL_SHADER           = 0x8E88


////#ifndef GL_ARB_texture_buffer_object_rgb32
/* reuse GL_RGB32F */
/* reuse GL_RGB32UI */
/* reuse GL_RGB32I */


////#ifndef GL_ARB_transform_feedback2
;static const uint  GL_TRANSFORM_FEEDBACK            = 0x8E22
;static const uint  GL_TRANSFORM_FEEDBACK_PAUSED     = 0x8E23
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED= 0x8E23
;static const uint  GL_TRANSFORM_FEEDBACK_ACTIVE     = 0x8E24
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE= 0x8E24
;static const uint  GL_TRANSFORM_FEEDBACK_BINDING    = 0x8E25


////#ifndef GL_ARB_transform_feedback3
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_BUFFERS= 0x8E70
;static const uint  GL_MAX_VERTEX_STREAMS            = 0x8E71


////#ifndef GL_ARB_ES2_compatibility
;static const uint  GL_FIXED                         = 0x140C
;static const uint  GL_IMPLEMENTATION_COLOR_READ_TYPE= 0x8B9A
;static const uint  GL_IMPLEMENTATION_COLOR_READ_FORMAT= 0x8B9B
;static const uint  GL_LOW_FLOAT                     = 0x8DF0
;static const uint  GL_MEDIUM_FLOAT                  = 0x8DF1
;static const uint  GL_HIGH_FLOAT                    = 0x8DF2
;static const uint  GL_LOW_INT                       = 0x8DF3
;static const uint  GL_MEDIUM_INT                    = 0x8DF4
;static const uint  GL_HIGH_INT                      = 0x8DF5
;static const uint  GL_SHADER_COMPILER               = 0x8DFA
;static const uint  GL_SHADER_BINARY_FORMATS         = 0x8DF8
;static const uint  GL_NUM_SHADER_BINARY_FORMATS     = 0x8DF9
;static const uint  GL_MAX_VERTEX_UNIFORM_VECTORS    = 0x8DFB
;static const uint  GL_MAX_VARYING_VECTORS           = 0x8DFC
;static const uint  GL_MAX_FRAGMENT_UNIFORM_VECTORS  = 0x8DFD
;static const uint  GL_RGB565                        = 0x8D62


////#ifndef GL_ARB_get_program_binary
;static const uint  GL_PROGRAM_BINARY_RETRIEVABLE_HINT= 0x8257
;static const uint  GL_PROGRAM_BINARY_LENGTH         = 0x8741
;static const uint  GL_NUM_PROGRAM_BINARY_FORMATS    = 0x87FE
;static const uint  GL_PROGRAM_BINARY_FORMATS        = 0x87FF


////#ifndef GL_ARB_separate_shader_objects
;static const uint  GL_VERTEX_SHADER_BIT             = 0x00000001
;static const uint  GL_FRAGMENT_SHADER_BIT           = 0x00000002
;static const uint  GL_GEOMETRY_SHADER_BIT           = 0x00000004
;static const uint  GL_TESS_CONTROL_SHADER_BIT       = 0x00000008
;static const uint  GL_TESS_EVALUATION_SHADER_BIT    = 0x00000010
;static const uint  GL_ALL_SHADER_BITS               = 0xFFFFFFFF
;static const uint  GL_PROGRAM_SEPARABLE             = 0x8258
;static const uint  GL_ACTIVE_PROGRAM                = 0x8259
;static const uint  GL_PROGRAM_PIPELINE_BINDING      = 0x825A


////#ifndef GL_ARB_shader_precision


////#ifndef GL_ARB_vertex_attrib_64bit
/* reuse GL_RGB32I */
/* reuse GL_DOUBLE_VEC2 */
/* reuse GL_DOUBLE_VEC3 */
/* reuse GL_DOUBLE_VEC4 */
/* reuse GL_DOUBLE_MAT2 */
/* reuse GL_DOUBLE_MAT3 */
/* reuse GL_DOUBLE_MAT4 */
/* reuse GL_DOUBLE_MAT2x3 */
/* reuse GL_DOUBLE_MAT2x4 */
/* reuse GL_DOUBLE_MAT3x2 */
/* reuse GL_DOUBLE_MAT3x4 */
/* reuse GL_DOUBLE_MAT4x2 */
/* reuse GL_DOUBLE_MAT4x3 */


////#ifndef GL_ARB_viewport_array
/* reuse GL_SCISSOR_BOX */
/* reuse GL_VIEWPORT */
/* reuse GL_DEPTH_RANGE */
/* reuse GL_SCISSOR_TEST */
;static const uint  GL_MAX_VIEWPORTS                 = 0x825B
;static const uint  GL_VIEWPORT_SUBPIXEL_BITS        = 0x825C
;static const uint  GL_VIEWPORT_BOUNDS_RANGE         = 0x825D
;static const uint  GL_LAYER_PROVOKING_VERTEX        = 0x825E
;static const uint  GL_VIEWPORT_INDEX_PROVOKING_VERTEX= 0x825F
;static const uint  GL_UNDEFINED_VERTEX              = 0x8260
/* reuse GL_FIRST_VERTEX_CONVENTION */
/* reuse GL_LAST_VERTEX_CONVENTION */
/* reuse GL_PROVOKING_VERTEX */


////#ifndef GL_ARB_cl_event
;static const uint  GL_SYNC_CL_EVENT_ARB             = 0x8240
;static const uint  GL_SYNC_CL_EVENT_COMPLETE_ARB    = 0x8241


////#ifndef GL_ARB_debug_output
;static const uint  GL_DEBUG_OUTPUT_SYNCHRONOUS_ARB  = 0x8242
;static const uint  GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH_ARB= 0x8243
;static const uint  GL_DEBUG_CALLBACK_FUNCTION_ARB   = 0x8244
;static const uint  GL_DEBUG_CALLBACK_USER_PARAM_ARB = 0x8245
;static const uint  GL_DEBUG_SOURCE_API_ARB          = 0x8246
;static const uint  GL_DEBUG_SOURCE_WINDOW_SYSTEM_ARB= 0x8247
;static const uint  GL_DEBUG_SOURCE_SHADER_COMPILER_ARB= 0x8248
;static const uint  GL_DEBUG_SOURCE_THIRD_PARTY_ARB  = 0x8249
;static const uint  GL_DEBUG_SOURCE_APPLICATION_ARB  = 0x824A
;static const uint  GL_DEBUG_SOURCE_OTHER_ARB        = 0x824B
;static const uint  GL_DEBUG_TYPE_ERROR_ARB          = 0x824C
;static const uint  GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR_ARB= 0x824D
;static const uint  GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR_ARB= 0x824E
;static const uint  GL_DEBUG_TYPE_PORTABILITY_ARB    = 0x824F
;static const uint  GL_DEBUG_TYPE_PERFORMANCE_ARB    = 0x8250
;static const uint  GL_DEBUG_TYPE_OTHER_ARB          = 0x8251
;static const uint  GL_MAX_DEBUG_MESSAGE_LENGTH_ARB  = 0x9143
;static const uint  GL_MAX_DEBUG_LOGGED_MESSAGES_ARB = 0x9144
;static const uint  GL_DEBUG_LOGGED_MESSAGES_ARB     = 0x9145
;static const uint  GL_DEBUG_SEVERITY_HIGH_ARB       = 0x9146
;static const uint  GL_DEBUG_SEVERITY_MEDIUM_ARB     = 0x9147
;static const uint  GL_DEBUG_SEVERITY_LOW_ARB        = 0x9148


////#ifndef GL_ARB_robustness
/* reuse GL_NO_ERROR */
;static const uint  GL_CONTEXT_FLAG_ROBUST_ACCESS_BIT_ARB= 0x00000004
;static const uint  GL_LOSE_CONTEXT_ON_RESET_ARB     = 0x8252
;static const uint  GL_GUILTY_CONTEXT_RESET_ARB      = 0x8253
;static const uint  GL_INNOCENT_CONTEXT_RESET_ARB    = 0x8254
;static const uint  GL_UNKNOWN_CONTEXT_RESET_ARB     = 0x8255
;static const uint  GL_RESET_NOTIFICATION_STRATEGY_ARB= 0x8256
;static const uint  GL_NO_RESET_NOTIFICATION_ARB     = 0x8261


////#ifndef GL_ARB_shader_stencil_export


////#ifndef GL_ARB_base_instance


////#ifndef GL_ARB_shading_language_420pack


////#ifndef GL_ARB_transform_feedback_instanced


////#ifndef GL_ARB_compressed_texture_pixel_storage
;static const uint  GL_UNPACK_COMPRESSED_BLOCK_WIDTH = 0x9127
;static const uint  GL_UNPACK_COMPRESSED_BLOCK_HEIGHT= 0x9128
;static const uint  GL_UNPACK_COMPRESSED_BLOCK_DEPTH = 0x9129
;static const uint  GL_UNPACK_COMPRESSED_BLOCK_SIZE  = 0x912A
;static const uint  GL_PACK_COMPRESSED_BLOCK_WIDTH   = 0x912B
;static const uint  GL_PACK_COMPRESSED_BLOCK_HEIGHT  = 0x912C
;static const uint  GL_PACK_COMPRESSED_BLOCK_DEPTH   = 0x912D
;static const uint  GL_PACK_COMPRESSED_BLOCK_SIZE    = 0x912E


////#ifndef GL_ARB_conservative_depth


////#ifndef GL_ARB_internalformat_query
;static const uint  GL_NUM_SAMPLE_COUNTS             = 0x9380


////#ifndef GL_ARB_map_buffer_alignment
;static const uint  GL_MIN_MAP_BUFFER_ALIGNMENT      = 0x90BC


////#ifndef GL_ARB_shader_atomic_counters
;static const uint  GL_ATOMIC_COUNTER_BUFFER         = 0x92C0
;static const uint  GL_ATOMIC_COUNTER_BUFFER_BINDING = 0x92C1
;static const uint  GL_ATOMIC_COUNTER_BUFFER_START   = 0x92C2
;static const uint  GL_ATOMIC_COUNTER_BUFFER_SIZE    = 0x92C3
;static const uint  GL_ATOMIC_COUNTER_BUFFER_DATA_SIZE= 0x92C4
;static const uint  GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS= 0x92C5
;static const uint  GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES= 0x92C6
;static const uint  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER= 0x92C7
;static const uint  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER= 0x92C8
;static const uint  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER= 0x92C9
;static const uint  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER= 0x92CA
;static const uint  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER= 0x92CB
;static const uint  GL_MAX_VERTEX_ATOMIC_COUNTER_BUFFERS= 0x92CC
;static const uint  GL_MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS= 0x92CD
;static const uint  GL_MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS= 0x92CE
;static const uint  GL_MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS= 0x92CF
;static const uint  GL_MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS= 0x92D0
;static const uint  GL_MAX_COMBINED_ATOMIC_COUNTER_BUFFERS= 0x92D1
;static const uint  GL_MAX_VERTEX_ATOMIC_COUNTERS    = 0x92D2
;static const uint  GL_MAX_TESS_CONTROL_ATOMIC_COUNTERS= 0x92D3
;static const uint  GL_MAX_TESS_EVALUATION_ATOMIC_COUNTERS= 0x92D4
;static const uint  GL_MAX_GEOMETRY_ATOMIC_COUNTERS  = 0x92D5
;static const uint  GL_MAX_FRAGMENT_ATOMIC_COUNTERS  = 0x92D6
;static const uint  GL_MAX_COMBINED_ATOMIC_COUNTERS  = 0x92D7
;static const uint  GL_MAX_ATOMIC_COUNTER_BUFFER_SIZE= 0x92D8
;static const uint  GL_MAX_ATOMIC_COUNTER_BUFFER_BINDINGS= 0x92DC
;static const uint  GL_ACTIVE_ATOMIC_COUNTER_BUFFERS = 0x92D9
;static const uint  GL_UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX= 0x92DA
;static const uint  GL_UNSIGNED_INT_ATOMIC_COUNTER   = 0x92DB


////#ifndef GL_ARB_shader_image_load_store
;static const uint  GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT= 0x00000001
;static const uint  GL_ELEMENT_ARRAY_BARRIER_BIT     = 0x00000002
;static const uint  GL_UNIFORM_BARRIER_BIT           = 0x00000004
;static const uint  GL_TEXTURE_FETCH_BARRIER_BIT     = 0x00000008
;static const uint  GL_SHADER_IMAGE_ACCESS_BARRIER_BIT= 0x00000020
;static const uint  GL_COMMAND_BARRIER_BIT           = 0x00000040
;static const uint  GL_PIXEL_BUFFER_BARRIER_BIT      = 0x00000080
;static const uint  GL_TEXTURE_UPDATE_BARRIER_BIT    = 0x00000100
;static const uint  GL_BUFFER_UPDATE_BARRIER_BIT     = 0x00000200
;static const uint  GL_FRAMEBUFFER_BARRIER_BIT       = 0x00000400
;static const uint  GL_TRANSFORM_FEEDBACK_BARRIER_BIT= 0x00000800
;static const uint  GL_ATOMIC_COUNTER_BARRIER_BIT    = 0x00001000
;static const uint  GL_ALL_BARRIER_BITS              = 0xFFFFFFFF
;static const uint  GL_MAX_IMAGE_UNITS               = 0x8F38
;static const uint  GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS= 0x8F39
;static const uint  GL_IMAGE_BINDING_NAME            = 0x8F3A
;static const uint  GL_IMAGE_BINDING_LEVEL           = 0x8F3B
;static const uint  GL_IMAGE_BINDING_LAYERED         = 0x8F3C
;static const uint  GL_IMAGE_BINDING_LAYER           = 0x8F3D
;static const uint  GL_IMAGE_BINDING_ACCESS          = 0x8F3E
;static const uint  GL_IMAGE_1D                      = 0x904C
;static const uint  GL_IMAGE_2D                      = 0x904D
;static const uint  GL_IMAGE_3D                      = 0x904E
;static const uint  GL_IMAGE_2D_RECT                 = 0x904F
;static const uint  GL_IMAGE_CUBE                    = 0x9050
;static const uint  GL_IMAGE_BUFFER                  = 0x9051
;static const uint  GL_IMAGE_1D_ARRAY                = 0x9052
;static const uint  GL_IMAGE_2D_ARRAY                = 0x9053
;static const uint  GL_IMAGE_CUBE_MAP_ARRAY          = 0x9054
;static const uint  GL_IMAGE_2D_MULTISAMPLE          = 0x9055
;static const uint  GL_IMAGE_2D_MULTISAMPLE_ARRAY    = 0x9056
;static const uint  GL_INT_IMAGE_1D                  = 0x9057
;static const uint  GL_INT_IMAGE_2D                  = 0x9058
;static const uint  GL_INT_IMAGE_3D                  = 0x9059
;static const uint  GL_INT_IMAGE_2D_RECT             = 0x905A
;static const uint  GL_INT_IMAGE_CUBE                = 0x905B
;static const uint  GL_INT_IMAGE_BUFFER              = 0x905C
;static const uint  GL_INT_IMAGE_1D_ARRAY            = 0x905D
;static const uint  GL_INT_IMAGE_2D_ARRAY            = 0x905E
;static const uint  GL_INT_IMAGE_CUBE_MAP_ARRAY      = 0x905F
;static const uint  GL_INT_IMAGE_2D_MULTISAMPLE      = 0x9060
;static const uint  GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY= 0x9061
;static const uint  GL_UNSIGNED_INT_IMAGE_1D         = 0x9062
;static const uint  GL_UNSIGNED_INT_IMAGE_2D         = 0x9063
;static const uint  GL_UNSIGNED_INT_IMAGE_3D         = 0x9064
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_RECT    = 0x9065
;static const uint  GL_UNSIGNED_INT_IMAGE_CUBE       = 0x9066
;static const uint  GL_UNSIGNED_INT_IMAGE_BUFFER     = 0x9067
;static const uint  GL_UNSIGNED_INT_IMAGE_1D_ARRAY   = 0x9068
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_ARRAY   = 0x9069
;static const uint  GL_UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY= 0x906A
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE= 0x906B
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY= 0x906C
;static const uint  GL_MAX_IMAGE_SAMPLES             = 0x906D
;static const uint  GL_IMAGE_BINDING_FORMAT          = 0x906E
;static const uint  GL_IMAGE_FORMAT_COMPATIBILITY_TYPE= 0x90C7
;static const uint  GL_IMAGE_FORMAT_COMPATIBILITY_BY_SIZE= 0x90C8
;static const uint  GL_IMAGE_FORMAT_COMPATIBILITY_BY_CLASS= 0x90C9
;static const uint  GL_MAX_VERTEX_IMAGE_UNIFORMS     = 0x90CA
;static const uint  GL_MAX_TESS_CONTROL_IMAGE_UNIFORMS= 0x90CB
;static const uint  GL_MAX_TESS_EVALUATION_IMAGE_UNIFORMS= 0x90CC
;static const uint  GL_MAX_GEOMETRY_IMAGE_UNIFORMS   = 0x90CD
;static const uint  GL_MAX_FRAGMENT_IMAGE_UNIFORMS   = 0x90CE
;static const uint  GL_MAX_COMBINED_IMAGE_UNIFORMS   = 0x90CF


////#ifndef GL_ARB_shading_language_packing


////#ifndef GL_ARB_texture_storage
;static const uint  GL_TEXTURE_IMMUTABLE_FORMAT      = 0x912F


////#ifndef GL_KHR_texture_compression_astc_ldr
;static const uint  GL_COMPRESSED_RGBA_ASTC_4x4_KHR  = 0x93B0
;static const uint  GL_COMPRESSED_RGBA_ASTC_5x4_KHR  = 0x93B1
;static const uint  GL_COMPRESSED_RGBA_ASTC_5x5_KHR  = 0x93B2
;static const uint  GL_COMPRESSED_RGBA_ASTC_6x5_KHR  = 0x93B3
;static const uint  GL_COMPRESSED_RGBA_ASTC_6x6_KHR  = 0x93B4
;static const uint  GL_COMPRESSED_RGBA_ASTC_8x5_KHR  = 0x93B5
;static const uint  GL_COMPRESSED_RGBA_ASTC_8x6_KHR  = 0x93B6
;static const uint  GL_COMPRESSED_RGBA_ASTC_8x8_KHR  = 0x93B7
;static const uint  GL_COMPRESSED_RGBA_ASTC_10x5_KHR = 0x93B8
;static const uint  GL_COMPRESSED_RGBA_ASTC_10x6_KHR = 0x93B9
;static const uint  GL_COMPRESSED_RGBA_ASTC_10x8_KHR = 0x93BA
;static const uint  GL_COMPRESSED_RGBA_ASTC_10x10_KHR= 0x93BB
;static const uint  GL_COMPRESSED_RGBA_ASTC_12x10_KHR= 0x93BC
;static const uint  GL_COMPRESSED_RGBA_ASTC_12x12_KHR= 0x93BD
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR= 0x93D0
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR= 0x93D1
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR= 0x93D2
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR= 0x93D3
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR= 0x93D4
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR= 0x93D5
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR= 0x93D6
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR= 0x93D7
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR= 0x93D8
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR= 0x93D9
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR= 0x93DA
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR= 0x93DB
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR= 0x93DC
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR= 0x93DD


////#ifndef GL_KHR_debug
;static const uint  GL_DEBUG_OUTPUT_SYNCHRONOUS      = 0x8242
;static const uint  GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH= 0x8243
;static const uint  GL_DEBUG_CALLBACK_FUNCTION       = 0x8244
;static const uint  GL_DEBUG_CALLBACK_USER_PARAM     = 0x8245
;static const uint  GL_DEBUG_SOURCE_API              = 0x8246
;static const uint  GL_DEBUG_SOURCE_WINDOW_SYSTEM    = 0x8247
;static const uint  GL_DEBUG_SOURCE_SHADER_COMPILER  = 0x8248
;static const uint  GL_DEBUG_SOURCE_THIRD_PARTY      = 0x8249
;static const uint  GL_DEBUG_SOURCE_APPLICATION      = 0x824A
;static const uint  GL_DEBUG_SOURCE_OTHER            = 0x824B
;static const uint  GL_DEBUG_TYPE_ERROR              = 0x824C
;static const uint  GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR= 0x824D
;static const uint  GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR = 0x824E
;static const uint  GL_DEBUG_TYPE_PORTABILITY        = 0x824F
;static const uint  GL_DEBUG_TYPE_PERFORMANCE        = 0x8250
;static const uint  GL_DEBUG_TYPE_OTHER              = 0x8251
;static const uint  GL_DEBUG_TYPE_MARKER             = 0x8268
;static const uint  GL_DEBUG_TYPE_PUSH_GROUP         = 0x8269
;static const uint  GL_DEBUG_TYPE_POP_GROUP          = 0x826A
;static const uint  GL_DEBUG_SEVERITY_NOTIFICATION   = 0x826B
;static const uint  GL_MAX_DEBUG_GROUP_STACK_DEPTH   = 0x826C
;static const uint  GL_DEBUG_GROUP_STACK_DEPTH       = 0x826D
;static const uint  GL_BUFFER                        = 0x82E0
;static const uint  GL_SHADER                        = 0x82E1
;static const uint  GL_PROGRAM                       = 0x82E2
;static const uint  GL_QUERY                         = 0x82E3
;static const uint  GL_PROGRAM_PIPELINE              = 0x82E4
;static const uint  GL_SAMPLER                       = 0x82E6
;static const uint  GL_DISPLAY_LIST                  = 0x82E7
/* DISPLAY_LIST used in compatibility profile only */
;static const uint  GL_MAX_LABEL_LENGTH              = 0x82E8
;static const uint  GL_MAX_DEBUG_MESSAGE_LENGTH      = 0x9143
;static const uint  GL_MAX_DEBUG_LOGGED_MESSAGES     = 0x9144
;static const uint  GL_DEBUG_LOGGED_MESSAGES         = 0x9145
;static const uint  GL_DEBUG_SEVERITY_HIGH           = 0x9146
;static const uint  GL_DEBUG_SEVERITY_MEDIUM         = 0x9147
;static const uint  GL_DEBUG_SEVERITY_LOW            = 0x9148
;static const uint  GL_DEBUG_OUTPUT                  = 0x92E0
;static const uint  GL_CONTEXT_FLAG_DEBUG_BIT        = 0x00000002
/* reuse GL_STACK_UNDERFLOW */
/* reuse GL_STACK_OVERFLOW */


////#ifndef GL_ARB_arrays_of_arrays


////#ifndef GL_ARB_clear_buffer_object


////#ifndef GL_ARB_compute_shader
;static const uint  GL_COMPUTE_SHADER                = 0x91B9
;static const uint  GL_MAX_COMPUTE_UNIFORM_BLOCKS    = 0x91BB
;static const uint  GL_MAX_COMPUTE_TEXTURE_IMAGE_UNITS= 0x91BC
;static const uint  GL_MAX_COMPUTE_IMAGE_UNIFORMS    = 0x91BD
;static const uint  GL_MAX_COMPUTE_SHARED_MEMORY_SIZE= 0x8262
;static const uint  GL_MAX_COMPUTE_UNIFORM_COMPONENTS= 0x8263
;static const uint  GL_MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS= 0x8264
;static const uint  GL_MAX_COMPUTE_ATOMIC_COUNTERS   = 0x8265
;static const uint  GL_MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS= 0x8266
;static const uint  GL_MAX_COMPUTE_LOCAL_INVOCATIONS = 0x90EB
;static const uint  GL_MAX_COMPUTE_WORK_GROUP_COUNT  = 0x91BE
;static const uint  GL_MAX_COMPUTE_WORK_GROUP_SIZE   = 0x91BF
;static const uint  GL_COMPUTE_LOCAL_WORK_SIZE       = 0x8267
;static const uint  GL_UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER= 0x90EC
;static const uint  GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER= 0x90ED
;static const uint  GL_DISPATCH_INDIRECT_BUFFER      = 0x90EE
;static const uint  GL_DISPATCH_INDIRECT_BUFFER_BINDING= 0x90EF
;static const uint  GL_COMPUTE_SHADER_BIT            = 0x00000020


////#ifndef GL_ARB_copy_image


////#ifndef GL_ARB_texture_view
;static const uint  GL_TEXTURE_VIEW_MIN_LEVEL        = 0x82DB
;static const uint  GL_TEXTURE_VIEW_NUM_LEVELS       = 0x82DC
;static const uint  GL_TEXTURE_VIEW_MIN_LAYER        = 0x82DD
;static const uint  GL_TEXTURE_VIEW_NUM_LAYERS       = 0x82DE
;static const uint  GL_TEXTURE_IMMUTABLE_LEVELS      = 0x82DF


////#ifndef GL_ARB_vertex_attrib_binding
;static const uint  GL_VERTEX_ATTRIB_BINDING         = 0x82D4
;static const uint  GL_VERTEX_ATTRIB_RELATIVE_OFFSET = 0x82D5
;static const uint  GL_VERTEX_BINDING_DIVISOR        = 0x82D6
;static const uint  GL_VERTEX_BINDING_OFFSET         = 0x82D7
;static const uint  GL_VERTEX_BINDING_STRIDE         = 0x82D8
;static const uint  GL_MAX_VERTEX_ATTRIB_RELATIVE_OFFSET= 0x82D9
;static const uint  GL_MAX_VERTEX_ATTRIB_BINDINGS    = 0x82DA


////#ifndef GL_ARB_robustness_isolation


////#ifndef GL_ARB_ES3_compatibility
;static const uint  GL_COMPRESSED_RGB8_ETC2          = 0x9274
;static const uint  GL_COMPRESSED_SRGB8_ETC2         = 0x9275
;static const uint  GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2= 0x9276
;static const uint  GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2= 0x9277
;static const uint  GL_COMPRESSED_RGBA8_ETC2_EAC     = 0x9278
;static const uint  GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC= 0x9279
;static const uint  GL_COMPRESSED_R11_EAC            = 0x9270
;static const uint  GL_COMPRESSED_SIGNED_R11_EAC     = 0x9271
;static const uint  GL_COMPRESSED_RG11_EAC           = 0x9272
;static const uint  GL_COMPRESSED_SIGNED_RG11_EAC    = 0x9273
;static const uint  GL_PRIMITIVE_RESTART_FIXED_INDEX = 0x8D69
;static const uint  GL_ANY_SAMPLES_PASSED_CONSERVATIVE= 0x8D6A
;static const uint  GL_MAX_ELEMENT_INDEX             = 0x8D6B


////#ifndef GL_ARB_explicit_uniform_location
;static const uint  GL_MAX_UNIFORM_LOCATIONS         = 0x826E


////#ifndef GL_ARB_fragment_layer_viewport


////#ifndef GL_ARB_framebuffer_no_attachments
;static const uint  GL_FRAMEBUFFER_DEFAULT_WIDTH     = 0x9310
;static const uint  GL_FRAMEBUFFER_DEFAULT_HEIGHT    = 0x9311
;static const uint  GL_FRAMEBUFFER_DEFAULT_LAYERS    = 0x9312
;static const uint  GL_FRAMEBUFFER_DEFAULT_SAMPLES   = 0x9313
;static const uint  GL_FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS= 0x9314
;static const uint  GL_MAX_FRAMEBUFFER_WIDTH         = 0x9315
;static const uint  GL_MAX_FRAMEBUFFER_HEIGHT        = 0x9316
;static const uint  GL_MAX_FRAMEBUFFER_LAYERS        = 0x9317
;static const uint  GL_MAX_FRAMEBUFFER_SAMPLES       = 0x9318


////#ifndef GL_ARB_internalformat_query2
/* reuse GL_IMAGE_FORMAT_COMPATIBILITY_TYPE */
/* reuse GL_NUM_SAMPLE_COUNTS */
/* reuse GL_RENDERBUFFER */
/* reuse GL_SAMPLES */
/* reuse GL_TEXTURE_1D */
/* reuse GL_TEXTURE_1D_ARRAY */
/* reuse GL_TEXTURE_2D */
/* reuse GL_TEXTURE_2D_ARRAY */
/* reuse GL_TEXTURE_3D */
/* reuse GL_TEXTURE_CUBE_MAP */
/* reuse GL_TEXTURE_CUBE_MAP_ARRAY */
/* reuse GL_TEXTURE_RECTANGLE */
/* reuse GL_TEXTURE_BUFFER */
/* reuse GL_TEXTURE_2D_MULTISAMPLE */
/* reuse GL_TEXTURE_2D_MULTISAMPLE_ARRAY */
/* reuse GL_TEXTURE_COMPRESSED */
;static const uint  GL_INTERNALFORMAT_SUPPORTED      = 0x826F
;static const uint  GL_INTERNALFORMAT_PREFERRED      = 0x8270
;static const uint  GL_INTERNALFORMAT_RED_SIZE       = 0x8271
;static const uint  GL_INTERNALFORMAT_GREEN_SIZE     = 0x8272
;static const uint  GL_INTERNALFORMAT_BLUE_SIZE      = 0x8273
;static const uint  GL_INTERNALFORMAT_ALPHA_SIZE     = 0x8274
;static const uint  GL_INTERNALFORMAT_DEPTH_SIZE     = 0x8275
;static const uint  GL_INTERNALFORMAT_STENCIL_SIZE   = 0x8276
;static const uint  GL_INTERNALFORMAT_SHARED_SIZE    = 0x8277
;static const uint  GL_INTERNALFORMAT_RED_TYPE       = 0x8278
;static const uint  GL_INTERNALFORMAT_GREEN_TYPE     = 0x8279
;static const uint  GL_INTERNALFORMAT_BLUE_TYPE      = 0x827A
;static const uint  GL_INTERNALFORMAT_ALPHA_TYPE     = 0x827B
;static const uint  GL_INTERNALFORMAT_DEPTH_TYPE     = 0x827C
;static const uint  GL_INTERNALFORMAT_STENCIL_TYPE   = 0x827D
;static const uint  GL_MAX_WIDTH                     = 0x827E
;static const uint  GL_MAX_HEIGHT                    = 0x827F
;static const uint  GL_MAX_DEPTH                     = 0x8280
;static const uint  GL_MAX_LAYERS                    = 0x8281
;static const uint  GL_MAX_COMBINED_DIMENSIONS       = 0x8282
;static const uint  GL_COLOR_COMPONENTS              = 0x8283
;static const uint  GL_DEPTH_COMPONENTS              = 0x8284
;static const uint  GL_STENCIL_COMPONENTS            = 0x8285
;static const uint  GL_COLOR_RENDERABLE              = 0x8286
;static const uint  GL_DEPTH_RENDERABLE              = 0x8287
;static const uint  GL_STENCIL_RENDERABLE            = 0x8288
;static const uint  GL_FRAMEBUFFER_RENDERABLE        = 0x8289
;static const uint  GL_FRAMEBUFFER_RENDERABLE_LAYERED= 0x828A
;static const uint  GL_FRAMEBUFFER_BLEND             = 0x828B
;static const uint  GL_READ_PIXELS                   = 0x828C
;static const uint  GL_READ_PIXELS_FORMAT            = 0x828D
;static const uint  GL_READ_PIXELS_TYPE              = 0x828E
;static const uint  GL_TEXTURE_IMAGE_FORMAT          = 0x828F
;static const uint  GL_TEXTURE_IMAGE_TYPE            = 0x8290
;static const uint  GL_GET_TEXTURE_IMAGE_FORMAT      = 0x8291
;static const uint  GL_GET_TEXTURE_IMAGE_TYPE        = 0x8292
;static const uint  GL_MIPMAP                        = 0x8293
;static const uint  GL_MANUAL_GENERATE_MIPMAP        = 0x8294
;static const uint  GL_AUTO_GENERATE_MIPMAP          = 0x8295
;static const uint  GL_COLOR_ENCODING                = 0x8296
;static const uint  GL_SRGB_READ                     = 0x8297
;static const uint  GL_SRGB_WRITE                    = 0x8298
;static const uint  GL_SRGB_DECODE_ARB               = 0x8299
;static const uint  GL_FILTER                        = 0x829A
;static const uint  GL_VERTEX_TEXTURE                = 0x829B
;static const uint  GL_TESS_CONTROL_TEXTURE          = 0x829C
;static const uint  GL_TESS_EVALUATION_TEXTURE       = 0x829D
;static const uint  GL_GEOMETRY_TEXTURE              = 0x829E
;static const uint  GL_FRAGMENT_TEXTURE              = 0x829F
;static const uint  GL_COMPUTE_TEXTURE               = 0x82A0
;static const uint  GL_TEXTURE_SHADOW                = 0x82A1
;static const uint  GL_TEXTURE_GATHER                = 0x82A2
;static const uint  GL_TEXTURE_GATHER_SHADOW         = 0x82A3
;static const uint  GL_SHADER_IMAGE_LOAD             = 0x82A4
;static const uint  GL_SHADER_IMAGE_STORE            = 0x82A5
;static const uint  GL_SHADER_IMAGE_ATOMIC           = 0x82A6
;static const uint  GL_IMAGE_TEXEL_SIZE              = 0x82A7
;static const uint  GL_IMAGE_COMPATIBILITY_CLASS     = 0x82A8
;static const uint  GL_IMAGE_PIXEL_FORMAT            = 0x82A9
;static const uint  GL_IMAGE_PIXEL_TYPE              = 0x82AA
;static const uint  GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST= 0x82AC
;static const uint  GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST= 0x82AD
;static const uint  GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE= 0x82AE
;static const uint  GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE= 0x82AF
;static const uint  GL_TEXTURE_COMPRESSED_BLOCK_WIDTH= 0x82B1
;static const uint  GL_TEXTURE_COMPRESSED_BLOCK_HEIGHT= 0x82B2
;static const uint  GL_TEXTURE_COMPRESSED_BLOCK_SIZE = 0x82B3
;static const uint  GL_CLEAR_BUFFER                  = 0x82B4
;static const uint  GL_TEXTURE_VIEW                  = 0x82B5
;static const uint  GL_VIEW_COMPATIBILITY_CLASS      = 0x82B6
;static const uint  GL_FULL_SUPPORT                  = 0x82B7
;static const uint  GL_CAVEAT_SUPPORT                = 0x82B8
;static const uint  GL_IMAGE_CLASS_4_X_32            = 0x82B9
;static const uint  GL_IMAGE_CLASS_2_X_32            = 0x82BA
;static const uint  GL_IMAGE_CLASS_1_X_32            = 0x82BB
;static const uint  GL_IMAGE_CLASS_4_X_16            = 0x82BC
;static const uint  GL_IMAGE_CLASS_2_X_16            = 0x82BD
;static const uint  GL_IMAGE_CLASS_1_X_16            = 0x82BE
;static const uint  GL_IMAGE_CLASS_4_X_8             = 0x82BF
;static const uint  GL_IMAGE_CLASS_2_X_8             = 0x82C0
;static const uint  GL_IMAGE_CLASS_1_X_8             = 0x82C1
;static const uint  GL_IMAGE_CLASS_11_11_10          = 0x82C2
;static const uint  GL_IMAGE_CLASS_10_10_10_2        = 0x82C3
;static const uint  GL_VIEW_CLASS_128_BITS           = 0x82C4
;static const uint  GL_VIEW_CLASS_96_BITS            = 0x82C5
;static const uint  GL_VIEW_CLASS_64_BITS            = 0x82C6
;static const uint  GL_VIEW_CLASS_48_BITS            = 0x82C7
;static const uint  GL_VIEW_CLASS_32_BITS            = 0x82C8
;static const uint  GL_VIEW_CLASS_24_BITS            = 0x82C9
;static const uint  GL_VIEW_CLASS_16_BITS            = 0x82CA
;static const uint  GL_VIEW_CLASS_8_BITS             = 0x82CB
;static const uint  GL_VIEW_CLASS_S3TC_DXT1_RGB      = 0x82CC
;static const uint  GL_VIEW_CLASS_S3TC_DXT1_RGBA     = 0x82CD
;static const uint  GL_VIEW_CLASS_S3TC_DXT3_RGBA     = 0x82CE
;static const uint  GL_VIEW_CLASS_S3TC_DXT5_RGBA     = 0x82CF
;static const uint  GL_VIEW_CLASS_RGTC1_RED          = 0x82D0
;static const uint  GL_VIEW_CLASS_RGTC2_RG           = 0x82D1
;static const uint  GL_VIEW_CLASS_BPTC_UNORM         = 0x82D2
;static const uint  GL_VIEW_CLASS_BPTC_FLOAT         = 0x82D3


////#ifndef GL_ARB_invalidate_subdata


////#ifndef GL_ARB_multi_draw_indirect


////#ifndef GL_ARB_program_interface_query
;static const uint  GL_UNIFORM                       = 0x92E1
;static const uint  GL_UNIFORM_BLOCK                 = 0x92E2
;static const uint  GL_PROGRAM_INPUT                 = 0x92E3
;static const uint  GL_PROGRAM_OUTPUT                = 0x92E4
;static const uint  GL_BUFFER_VARIABLE               = 0x92E5
;static const uint  GL_SHADER_STORAGE_BLOCK          = 0x92E6
/* reuse GL_ATOMIC_COUNTER_BUFFER */
;static const uint  GL_VERTEX_SUBROUTINE             = 0x92E8
;static const uint  GL_TESS_CONTROL_SUBROUTINE       = 0x92E9
;static const uint  GL_TESS_EVALUATION_SUBROUTINE    = 0x92EA
;static const uint  GL_GEOMETRY_SUBROUTINE           = 0x92EB
;static const uint  GL_FRAGMENT_SUBROUTINE           = 0x92EC
;static const uint  GL_COMPUTE_SUBROUTINE            = 0x92ED
;static const uint  GL_VERTEX_SUBROUTINE_UNIFORM     = 0x92EE
;static const uint  GL_TESS_CONTROL_SUBROUTINE_UNIFORM= 0x92EF
;static const uint  GL_TESS_EVALUATION_SUBROUTINE_UNIFORM= 0x92F0
;static const uint  GL_GEOMETRY_SUBROUTINE_UNIFORM   = 0x92F1
;static const uint  GL_FRAGMENT_SUBROUTINE_UNIFORM   = 0x92F2
;static const uint  GL_COMPUTE_SUBROUTINE_UNIFORM    = 0x92F3
;static const uint  GL_TRANSFORM_FEEDBACK_VARYING    = 0x92F4
;static const uint  GL_ACTIVE_RESOURCES              = 0x92F5
;static const uint  GL_MAX_NAME_LENGTH               = 0x92F6
;static const uint  GL_MAX_NUM_ACTIVE_VARIABLES      = 0x92F7
;static const uint  GL_MAX_NUM_COMPATIBLE_SUBROUTINES= 0x92F8
;static const uint  GL_NAME_LENGTH                   = 0x92F9
;static const uint  GL_TYPE                          = 0x92FA
;static const uint  GL_ARRAY_SIZE                    = 0x92FB
;static const uint  GL_OFFSET                        = 0x92FC
;static const uint  GL_BLOCK_INDEX                   = 0x92FD
;static const uint  GL_ARRAY_STRIDE                  = 0x92FE
;static const uint  GL_MATRIX_STRIDE                 = 0x92FF
;static const uint  GL_IS_ROW_MAJOR                  = 0x9300
;static const uint  GL_ATOMIC_COUNTER_BUFFER_INDEX   = 0x9301
;static const uint  GL_BUFFER_BINDING                = 0x9302
;static const uint  GL_BUFFER_DATA_SIZE              = 0x9303
;static const uint  GL_NUM_ACTIVE_VARIABLES          = 0x9304
;static const uint  GL_ACTIVE_VARIABLES              = 0x9305
;static const uint  GL_REFERENCED_BY_VERTEX_SHADER   = 0x9306
;static const uint  GL_REFERENCED_BY_TESS_CONTROL_SHADER= 0x9307
;static const uint  GL_REFERENCED_BY_TESS_EVALUATION_SHADER= 0x9308
;static const uint  GL_REFERENCED_BY_GEOMETRY_SHADER = 0x9309
;static const uint  GL_REFERENCED_BY_FRAGMENT_SHADER = 0x930A
;static const uint  GL_REFERENCED_BY_COMPUTE_SHADER  = 0x930B
;static const uint  GL_TOP_LEVEL_ARRAY_SIZE          = 0x930C
;static const uint  GL_TOP_LEVEL_ARRAY_STRIDE        = 0x930D
;static const uint  GL_LOCATION                      = 0x930E
;static const uint  GL_LOCATION_INDEX                = 0x930F
;static const uint  GL_IS_PER_PATCH                  = 0x92E7
/* reuse GL_NUM_COMPATIBLE_SUBROUTINES */
/* reuse GL_COMPATIBLE_SUBROUTINES */


////#ifndef GL_ARB_robust_buffer_access_behavior


////#ifndef GL_ARB_shader_image_size


////#ifndef GL_ARB_shader_storage_buffer_object
;static const uint  GL_SHADER_STORAGE_BUFFER         = 0x90D2
;static const uint  GL_SHADER_STORAGE_BUFFER_BINDING = 0x90D3
;static const uint  GL_SHADER_STORAGE_BUFFER_START   = 0x90D4
;static const uint  GL_SHADER_STORAGE_BUFFER_SIZE    = 0x90D5
;static const uint  GL_MAX_VERTEX_SHADER_STORAGE_BLOCKS= 0x90D6
;static const uint  GL_MAX_GEOMETRY_SHADER_STORAGE_BLOCKS= 0x90D7
;static const uint  GL_MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS= 0x90D8
;static const uint  GL_MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS= 0x90D9
;static const uint  GL_MAX_FRAGMENT_SHADER_STORAGE_BLOCKS= 0x90DA
;static const uint  GL_MAX_COMPUTE_SHADER_STORAGE_BLOCKS= 0x90DB
;static const uint  GL_MAX_COMBINED_SHADER_STORAGE_BLOCKS= 0x90DC
;static const uint  GL_MAX_SHADER_STORAGE_BUFFER_BINDINGS= 0x90DD
;static const uint  GL_MAX_SHADER_STORAGE_BLOCK_SIZE = 0x90DE
;static const uint  GL_SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT= 0x90DF
;static const uint  GL_SHADER_STORAGE_BARRIER_BIT    = 0x00002000
;static const uint  GL_MAX_COMBINED_SHADER_OUTPUT_RESOURCES= 0x8F39
/* reuse GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS */


////#ifndef GL_ARB_stencil_texturing
;static const uint  GL_DEPTH_STENCIL_TEXTURE_MODE    = 0x90EA


////#ifndef GL_ARB_texture_buffer_range
;static const uint  GL_TEXTURE_BUFFER_OFFSET         = 0x919D
;static const uint  GL_TEXTURE_BUFFER_SIZE           = 0x919E
;static const uint  GL_TEXTURE_BUFFER_OFFSET_ALIGNMENT= 0x919F


////#ifndef GL_ARB_texture_query_levels


////#ifndef GL_ARB_texture_storage_multisample


////#ifndef GL_EXT_abgr
;static const uint  GL_ABGR_EXT                      = 0x8000


////#ifndef GL_EXT_blend_color
;static const uint  GL_CONSTANT_COLOR_EXT            = 0x8001
;static const uint  GL_ONE_MINUS_CONSTANT_COLOR_EXT  = 0x8002
;static const uint  GL_CONSTANT_ALPHA_EXT            = 0x8003
;static const uint  GL_ONE_MINUS_CONSTANT_ALPHA_EXT  = 0x8004
;static const uint  GL_BLEND_COLOR_EXT               = 0x8005


////#ifndef GL_EXT_polygon_offset
;static const uint  GL_POLYGON_OFFSET_EXT            = 0x8037
;static const uint  GL_POLYGON_OFFSET_FACTOR_EXT     = 0x8038
;static const uint  GL_POLYGON_OFFSET_BIAS_EXT       = 0x8039


////#ifndef GL_EXT_texture
;static const uint  GL_ALPHA4_EXT                    = 0x803B
;static const uint  GL_ALPHA8_EXT                    = 0x803C
;static const uint  GL_ALPHA12_EXT                   = 0x803D
;static const uint  GL_ALPHA16_EXT                   = 0x803E
;static const uint  GL_LUMINANCE4_EXT                = 0x803F
;static const uint  GL_LUMINANCE8_EXT                = 0x8040
;static const uint  GL_LUMINANCE12_EXT               = 0x8041
;static const uint  GL_LUMINANCE16_EXT               = 0x8042
;static const uint  GL_LUMINANCE4_ALPHA4_EXT         = 0x8043
;static const uint  GL_LUMINANCE6_ALPHA2_EXT         = 0x8044
;static const uint  GL_LUMINANCE8_ALPHA8_EXT         = 0x8045
;static const uint  GL_LUMINANCE12_ALPHA4_EXT        = 0x8046
;static const uint  GL_LUMINANCE12_ALPHA12_EXT       = 0x8047
;static const uint  GL_LUMINANCE16_ALPHA16_EXT       = 0x8048
;static const uint  GL_INTENSITY_EXT                 = 0x8049
;static const uint  GL_INTENSITY4_EXT                = 0x804A
;static const uint  GL_INTENSITY8_EXT                = 0x804B
;static const uint  GL_INTENSITY12_EXT               = 0x804C
;static const uint  GL_INTENSITY16_EXT               = 0x804D
;static const uint  GL_RGB2_EXT                      = 0x804E
;static const uint  GL_RGB4_EXT                      = 0x804F
;static const uint  GL_RGB5_EXT                      = 0x8050
;static const uint  GL_RGB8_EXT                      = 0x8051
;static const uint  GL_RGB10_EXT                     = 0x8052
;static const uint  GL_RGB12_EXT                     = 0x8053
;static const uint  GL_RGB16_EXT                     = 0x8054
;static const uint  GL_RGBA2_EXT                     = 0x8055
;static const uint  GL_RGBA4_EXT                     = 0x8056
;static const uint  GL_RGB5_A1_EXT                   = 0x8057
;static const uint  GL_RGBA8_EXT                     = 0x8058
;static const uint  GL_RGB10_A2_EXT                  = 0x8059
;static const uint  GL_RGBA12_EXT                    = 0x805A
;static const uint  GL_RGBA16_EXT                    = 0x805B
;static const uint  GL_TEXTURE_RED_SIZE_EXT          = 0x805C
;static const uint  GL_TEXTURE_GREEN_SIZE_EXT        = 0x805D
;static const uint  GL_TEXTURE_BLUE_SIZE_EXT         = 0x805E
;static const uint  GL_TEXTURE_ALPHA_SIZE_EXT        = 0x805F
;static const uint  GL_TEXTURE_LUMINANCE_SIZE_EXT    = 0x8060
;static const uint  GL_TEXTURE_INTENSITY_SIZE_EXT    = 0x8061
;static const uint  GL_REPLACE_EXT                   = 0x8062
;static const uint  GL_PROXY_TEXTURE_1D_EXT          = 0x8063
;static const uint  GL_PROXY_TEXTURE_2D_EXT          = 0x8064
;static const uint  GL_TEXTURE_TOO_LARGE_EXT         = 0x8065


////#ifndef GL_EXT_texture3D
;static const uint  GL_PACK_SKIP_IMAGES_EXT          = 0x806B
;static const uint  GL_PACK_IMAGE_HEIGHT_EXT         = 0x806C
;static const uint  GL_UNPACK_SKIP_IMAGES_EXT        = 0x806D
;static const uint  GL_UNPACK_IMAGE_HEIGHT_EXT       = 0x806E
;static const uint  GL_TEXTURE_3D_EXT                = 0x806F
;static const uint  GL_PROXY_TEXTURE_3D_EXT          = 0x8070
;static const uint  GL_TEXTURE_DEPTH_EXT             = 0x8071
;static const uint  GL_TEXTURE_WRAP_R_EXT            = 0x8072
;static const uint  GL_MAX_3D_TEXTURE_SIZE_EXT       = 0x8073


////#ifndef GL_SGIS_texture_filter4
;static const uint  GL_FILTER4_SGIS                  = 0x8146
;static const uint  GL_TEXTURE_FILTER4_SIZE_SGIS     = 0x8147


////#ifndef GL_EXT_subtexture


////#ifndef GL_EXT_copy_texture


////#ifndef GL_EXT_histogram
;static const uint  GL_HISTOGRAM_EXT                 = 0x8024
;static const uint  GL_PROXY_HISTOGRAM_EXT           = 0x8025
;static const uint  GL_HISTOGRAM_WIDTH_EXT           = 0x8026
;static const uint  GL_HISTOGRAM_FORMAT_EXT          = 0x8027
;static const uint  GL_HISTOGRAM_RED_SIZE_EXT        = 0x8028
;static const uint  GL_HISTOGRAM_GREEN_SIZE_EXT      = 0x8029
;static const uint  GL_HISTOGRAM_BLUE_SIZE_EXT       = 0x802A
;static const uint  GL_HISTOGRAM_ALPHA_SIZE_EXT      = 0x802B
;static const uint  GL_HISTOGRAM_LUMINANCE_SIZE_EXT  = 0x802C
;static const uint  GL_HISTOGRAM_SINK_EXT            = 0x802D
;static const uint  GL_MINMAX_EXT                    = 0x802E
;static const uint  GL_MINMAX_FORMAT_EXT             = 0x802F
;static const uint  GL_MINMAX_SINK_EXT               = 0x8030
;static const uint  GL_TABLE_TOO_LARGE_EXT           = 0x8031


////#ifndef GL_EXT_convolution
;static const uint  GL_CONVOLUTION_1D_EXT            = 0x8010
;static const uint  GL_CONVOLUTION_2D_EXT            = 0x8011
;static const uint  GL_SEPARABLE_2D_EXT              = 0x8012
;static const uint  GL_CONVOLUTION_BORDER_MODE_EXT   = 0x8013
;static const uint  GL_CONVOLUTION_FILTER_SCALE_EXT  = 0x8014
;static const uint  GL_CONVOLUTION_FILTER_BIAS_EXT   = 0x8015
;static const uint  GL_REDUCE_EXT                    = 0x8016
;static const uint  GL_CONVOLUTION_FORMAT_EXT        = 0x8017
;static const uint  GL_CONVOLUTION_WIDTH_EXT         = 0x8018
;static const uint  GL_CONVOLUTION_HEIGHT_EXT        = 0x8019
;static const uint  GL_MAX_CONVOLUTION_WIDTH_EXT     = 0x801A
;static const uint  GL_MAX_CONVOLUTION_HEIGHT_EXT    = 0x801B
;static const uint  GL_POST_CONVOLUTION_RED_SCALE_EXT= 0x801C
;static const uint  GL_POST_CONVOLUTION_GREEN_SCALE_EXT= 0x801D
;static const uint  GL_POST_CONVOLUTION_BLUE_SCALE_EXT= 0x801E
;static const uint  GL_POST_CONVOLUTION_ALPHA_SCALE_EXT= 0x801F
;static const uint  GL_POST_CONVOLUTION_RED_BIAS_EXT = 0x8020
;static const uint  GL_POST_CONVOLUTION_GREEN_BIAS_EXT= 0x8021
;static const uint  GL_POST_CONVOLUTION_BLUE_BIAS_EXT= 0x8022
;static const uint  GL_POST_CONVOLUTION_ALPHA_BIAS_EXT= 0x8023


////#ifndef GL_SGI_color_matrix
;static const uint  GL_COLOR_MATRIX_SGI              = 0x80B1
;static const uint  GL_COLOR_MATRIX_STACK_DEPTH_SGI  = 0x80B2
;static const uint  GL_MAX_COLOR_MATRIX_STACK_DEPTH_SGI= 0x80B3
;static const uint  GL_POST_COLOR_MATRIX_RED_SCALE_SGI= 0x80B4
;static const uint  GL_POST_COLOR_MATRIX_GREEN_SCALE_SGI= 0x80B5
;static const uint  GL_POST_COLOR_MATRIX_BLUE_SCALE_SGI= 0x80B6
;static const uint  GL_POST_COLOR_MATRIX_ALPHA_SCALE_SGI= 0x80B7
;static const uint  GL_POST_COLOR_MATRIX_RED_BIAS_SGI= 0x80B8
;static const uint  GL_POST_COLOR_MATRIX_GREEN_BIAS_SGI= 0x80B9
;static const uint  GL_POST_COLOR_MATRIX_BLUE_BIAS_SGI= 0x80BA
;static const uint  GL_POST_COLOR_MATRIX_ALPHA_BIAS_SGI= 0x80BB


////#ifndef GL_SGI_color_table
;static const uint  GL_COLOR_TABLE_SGI               = 0x80D0
;static const uint  GL_POST_CONVOLUTION_COLOR_TABLE_SGI= 0x80D1
;static const uint  GL_POST_COLOR_MATRIX_COLOR_TABLE_SGI= 0x80D2
;static const uint  GL_PROXY_COLOR_TABLE_SGI         = 0x80D3
;static const uint  GL_PROXY_POST_CONVOLUTION_COLOR_TABLE_SGI= 0x80D4
;static const uint  GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE_SGI= 0x80D5
;static const uint  GL_COLOR_TABLE_SCALE_SGI         = 0x80D6
;static const uint  GL_COLOR_TABLE_BIAS_SGI          = 0x80D7
;static const uint  GL_COLOR_TABLE_FORMAT_SGI        = 0x80D8
;static const uint  GL_COLOR_TABLE_WIDTH_SGI         = 0x80D9
;static const uint  GL_COLOR_TABLE_RED_SIZE_SGI      = 0x80DA
;static const uint  GL_COLOR_TABLE_GREEN_SIZE_SGI    = 0x80DB
;static const uint  GL_COLOR_TABLE_BLUE_SIZE_SGI     = 0x80DC
;static const uint  GL_COLOR_TABLE_ALPHA_SIZE_SGI    = 0x80DD
;static const uint  GL_COLOR_TABLE_LUMINANCE_SIZE_SGI= 0x80DE
;static const uint  GL_COLOR_TABLE_INTENSITY_SIZE_SGI= 0x80DF


////#ifndef GL_SGIS_pixel_texture
;static const uint  GL_PIXEL_TEXTURE_SGIS            = 0x8353
;static const uint  GL_PIXEL_FRAGMENT_RGB_SOURCE_SGIS= 0x8354
;static const uint  GL_PIXEL_FRAGMENT_ALPHA_SOURCE_SGIS= 0x8355
;static const uint  GL_PIXEL_GROUP_COLOR_SGIS        = 0x8356


////#ifndef GL_SGIX_pixel_texture
;static const uint  GL_PIXEL_TEX_GEN_SGIX            = 0x8139
;static const uint  GL_PIXEL_TEX_GEN_MODE_SGIX       = 0x832B


////#ifndef GL_SGIS_texture4D
;static const uint  GL_PACK_SKIP_VOLUMES_SGIS        = 0x8130
;static const uint  GL_PACK_IMAGE_DEPTH_SGIS         = 0x8131
;static const uint  GL_UNPACK_SKIP_VOLUMES_SGIS      = 0x8132
;static const uint  GL_UNPACK_IMAGE_DEPTH_SGIS       = 0x8133
;static const uint  GL_TEXTURE_4D_SGIS               = 0x8134
;static const uint  GL_PROXY_TEXTURE_4D_SGIS         = 0x8135
;static const uint  GL_TEXTURE_4DSIZE_SGIS           = 0x8136
;static const uint  GL_TEXTURE_WRAP_Q_SGIS           = 0x8137
;static const uint  GL_MAX_4D_TEXTURE_SIZE_SGIS      = 0x8138
;static const uint  GL_TEXTURE_4D_BINDING_SGIS       = 0x814F


////#ifndef GL_SGI_texture_color_table
;static const uint  GL_TEXTURE_COLOR_TABLE_SGI       = 0x80BC
;static const uint  GL_PROXY_TEXTURE_COLOR_TABLE_SGI = 0x80BD


////#ifndef GL_EXT_cmyka
;static const uint  GL_CMYK_EXT                      = 0x800C
;static const uint  GL_CMYKA_EXT                     = 0x800D
;static const uint  GL_PACK_CMYK_HINT_EXT            = 0x800E
;static const uint  GL_UNPACK_CMYK_HINT_EXT          = 0x800F


////#ifndef GL_EXT_texture_object
;static const uint  GL_TEXTURE_PRIORITY_EXT          = 0x8066
;static const uint  GL_TEXTURE_RESIDENT_EXT          = 0x8067
;static const uint  GL_TEXTURE_1D_BINDING_EXT        = 0x8068
;static const uint  GL_TEXTURE_2D_BINDING_EXT        = 0x8069
;static const uint  GL_TEXTURE_3D_BINDING_EXT        = 0x806A


////#ifndef GL_SGIS_detail_texture
;static const uint  GL_DETAIL_TEXTURE_2D_SGIS        = 0x8095
;static const uint  GL_DETAIL_TEXTURE_2D_BINDING_SGIS= 0x8096
;static const uint  GL_LINEAR_DETAIL_SGIS            = 0x8097
;static const uint  GL_LINEAR_DETAIL_ALPHA_SGIS      = 0x8098
;static const uint  GL_LINEAR_DETAIL_COLOR_SGIS      = 0x8099
;static const uint  GL_DETAIL_TEXTURE_LEVEL_SGIS     = 0x809A
;static const uint  GL_DETAIL_TEXTURE_MODE_SGIS      = 0x809B
;static const uint  GL_DETAIL_TEXTURE_FUNC_POINTS_SGIS= 0x809C


////#ifndef GL_SGIS_sharpen_texture
;static const uint  GL_LINEAR_SHARPEN_SGIS           = 0x80AD
;static const uint  GL_LINEAR_SHARPEN_ALPHA_SGIS     = 0x80AE
;static const uint  GL_LINEAR_SHARPEN_COLOR_SGIS     = 0x80AF
;static const uint  GL_SHARPEN_TEXTURE_FUNC_POINTS_SGIS= 0x80B0


////#ifndef GL_EXT_packed_pixels
;static const uint  GL_UNSIGNED_BYTE_3_3_2_EXT       = 0x8032
;static const uint  GL_UNSIGNED_SHORT_4_4_4_4_EXT    = 0x8033
;static const uint  GL_UNSIGNED_SHORT_5_5_5_1_EXT    = 0x8034
;static const uint  GL_UNSIGNED_INT_8_8_8_8_EXT      = 0x8035
;static const uint  GL_UNSIGNED_INT_10_10_10_2_EXT   = 0x8036


////#ifndef GL_SGIS_texture_lod
;static const uint  GL_TEXTURE_MIN_LOD_SGIS          = 0x813A
;static const uint  GL_TEXTURE_MAX_LOD_SGIS          = 0x813B
;static const uint  GL_TEXTURE_BASE_LEVEL_SGIS       = 0x813C
;static const uint  GL_TEXTURE_MAX_LEVEL_SGIS        = 0x813D


////#ifndef GL_SGIS_multisample
;static const uint  GL_MULTISAMPLE_SGIS              = 0x809D
;static const uint  GL_SAMPLE_ALPHA_TO_MASK_SGIS     = 0x809E
;static const uint  GL_SAMPLE_ALPHA_TO_ONE_SGIS      = 0x809F
;static const uint  GL_SAMPLE_MASK_SGIS              = 0x80A0
;static const uint  GL_1PASS_SGIS                    = 0x80A1
;static const uint  GL_2PASS_0_SGIS                  = 0x80A2
;static const uint  GL_2PASS_1_SGIS                  = 0x80A3
;static const uint  GL_4PASS_0_SGIS                  = 0x80A4
;static const uint  GL_4PASS_1_SGIS                  = 0x80A5
;static const uint  GL_4PASS_2_SGIS                  = 0x80A6
;static const uint  GL_4PASS_3_SGIS                  = 0x80A7
;static const uint  GL_SAMPLE_BUFFERS_SGIS           = 0x80A8
;static const uint  GL_SAMPLES_SGIS                  = 0x80A9
;static const uint  GL_SAMPLE_MASK_VALUE_SGIS        = 0x80AA
;static const uint  GL_SAMPLE_MASK_INVERT_SGIS       = 0x80AB
;static const uint  GL_SAMPLE_PATTERN_SGIS           = 0x80AC


//#ifndef GL_EXT_rescale_normal
;static const uint  GL_RESCALE_NORMAL_EXT            = 0x803A


//#ifndef GL_EXT_vertex_array
;static const uint  GL_VERTEX_ARRAY_EXT              = 0x8074
;static const uint  GL_NORMAL_ARRAY_EXT              = 0x8075
;static const uint  GL_COLOR_ARRAY_EXT               = 0x8076
;static const uint  GL_INDEX_ARRAY_EXT               = 0x8077
;static const uint  GL_TEXTURE_COORD_ARRAY_EXT       = 0x8078
;static const uint  GL_EDGE_FLAG_ARRAY_EXT           = 0x8079
;static const uint  GL_VERTEX_ARRAY_SIZE_EXT         = 0x807A
;static const uint  GL_VERTEX_ARRAY_TYPE_EXT         = 0x807B
;static const uint  GL_VERTEX_ARRAY_STRIDE_EXT       = 0x807C
;static const uint  GL_VERTEX_ARRAY_COUNT_EXT        = 0x807D
;static const uint  GL_NORMAL_ARRAY_TYPE_EXT         = 0x807E
;static const uint  GL_NORMAL_ARRAY_STRIDE_EXT       = 0x807F
;static const uint  GL_NORMAL_ARRAY_COUNT_EXT        = 0x8080
;static const uint  GL_COLOR_ARRAY_SIZE_EXT          = 0x8081
;static const uint  GL_COLOR_ARRAY_TYPE_EXT          = 0x8082
;static const uint  GL_COLOR_ARRAY_STRIDE_EXT        = 0x8083
;static const uint  GL_COLOR_ARRAY_COUNT_EXT         = 0x8084
;static const uint  GL_INDEX_ARRAY_TYPE_EXT          = 0x8085
;static const uint  GL_INDEX_ARRAY_STRIDE_EXT        = 0x8086
;static const uint  GL_INDEX_ARRAY_COUNT_EXT         = 0x8087
;static const uint  GL_TEXTURE_COORD_ARRAY_SIZE_EXT  = 0x8088
;static const uint  GL_TEXTURE_COORD_ARRAY_TYPE_EXT  = 0x8089
;static const uint  GL_TEXTURE_COORD_ARRAY_STRIDE_EXT= 0x808A
;static const uint  GL_TEXTURE_COORD_ARRAY_COUNT_EXT = 0x808B
;static const uint  GL_EDGE_FLAG_ARRAY_STRIDE_EXT    = 0x808C
;static const uint  GL_EDGE_FLAG_ARRAY_COUNT_EXT     = 0x808D
;static const uint  GL_VERTEX_ARRAY_POINTER_EXT      = 0x808E
;static const uint  GL_NORMAL_ARRAY_POINTER_EXT      = 0x808F
;static const uint  GL_COLOR_ARRAY_POINTER_EXT       = 0x8090
;static const uint  GL_INDEX_ARRAY_POINTER_EXT       = 0x8091
;static const uint  GL_TEXTURE_COORD_ARRAY_POINTER_EXT= 0x8092
;static const uint  GL_EDGE_FLAG_ARRAY_POINTER_EXT   = 0x8093


//#ifndef GL_EXT_misc_attribute


//#ifndef GL_SGIS_generate_mipmap
;static const uint  GL_GENERATE_MIPMAP_SGIS          = 0x8191
;static const uint  GL_GENERATE_MIPMAP_HINT_SGIS     = 0x8192


//#ifndef GL_SGIX_clipmap
;static const uint  GL_LINEAR_CLIPMAP_LINEAR_SGIX    = 0x8170
;static const uint  GL_TEXTURE_CLIPMAP_CENTER_SGIX   = 0x8171
;static const uint  GL_TEXTURE_CLIPMAP_FRAME_SGIX    = 0x8172
;static const uint  GL_TEXTURE_CLIPMAP_OFFSET_SGIX   = 0x8173
;static const uint  GL_TEXTURE_CLIPMAP_VIRTUAL_DEPTH_SGIX= 0x8174
;static const uint  GL_TEXTURE_CLIPMAP_LOD_OFFSET_SGIX= 0x8175
;static const uint  GL_TEXTURE_CLIPMAP_DEPTH_SGIX    = 0x8176
;static const uint  GL_MAX_CLIPMAP_DEPTH_SGIX        = 0x8177
;static const uint  GL_MAX_CLIPMAP_VIRTUAL_DEPTH_SGIX= 0x8178
;static const uint  GL_NEAREST_CLIPMAP_NEAREST_SGIX  = 0x844D
;static const uint  GL_NEAREST_CLIPMAP_LINEAR_SGIX   = 0x844E
;static const uint  GL_LINEAR_CLIPMAP_NEAREST_SGIX   = 0x844F


//#ifndef GL_SGIX_shadow
;static const uint  GL_TEXTURE_COMPARE_SGIX          = 0x819A
;static const uint  GL_TEXTURE_COMPARE_OPERATOR_SGIX = 0x819B
;static const uint  GL_TEXTURE_LEQUAL_R_SGIX         = 0x819C
;static const uint  GL_TEXTURE_GEQUAL_R_SGIX         = 0x819D


//#ifndef GL_SGIS_texture_edge_clamp
;static const uint  GL_CLAMP_TO_EDGE_SGIS            = 0x812F


//#ifndef GL_SGIS_texture_border_clamp
;static const uint  GL_CLAMP_TO_BORDER_SGIS          = 0x812D


//#ifndef GL_EXT_blend_minmax
;static const uint  GL_FUNC_ADD_EXT                  = 0x8006
;static const uint  GL_MIN_EXT                       = 0x8007
;static const uint  GL_MAX_EXT                       = 0x8008
;static const uint  GL_BLEND_EQUATION_EXT            = 0x8009


//#ifndef GL_EXT_blend_subtract
;static const uint  GL_FUNC_SUBTRACT_EXT             = 0x800A
;static const uint  GL_FUNC_REVERSE_SUBTRACT_EXT     = 0x800B


//#ifndef GL_EXT_blend_logic_op


//#ifndef GL_SGIX_interlace
;static const uint  GL_INTERLACE_SGIX                = 0x8094


//#ifndef GL_SGIX_pixel_tiles
;static const uint  GL_PIXEL_TILE_BEST_ALIGNMENT_SGIX= 0x813E
;static const uint  GL_PIXEL_TILE_CACHE_INCREMENT_SGIX= 0x813F
;static const uint  GL_PIXEL_TILE_WIDTH_SGIX         = 0x8140
;static const uint  GL_PIXEL_TILE_HEIGHT_SGIX        = 0x8141
;static const uint  GL_PIXEL_TILE_GRID_WIDTH_SGIX    = 0x8142
;static const uint  GL_PIXEL_TILE_GRID_HEIGHT_SGIX   = 0x8143
;static const uint  GL_PIXEL_TILE_GRID_DEPTH_SGIX    = 0x8144
;static const uint  GL_PIXEL_TILE_CACHE_SIZE_SGIX    = 0x8145


//#ifndef GL_SGIS_texture_select
;static const uint  GL_DUAL_ALPHA4_SGIS              = 0x8110
;static const uint  GL_DUAL_ALPHA8_SGIS              = 0x8111
;static const uint  GL_DUAL_ALPHA12_SGIS             = 0x8112
;static const uint  GL_DUAL_ALPHA16_SGIS             = 0x8113
;static const uint  GL_DUAL_LUMINANCE4_SGIS          = 0x8114
;static const uint  GL_DUAL_LUMINANCE8_SGIS          = 0x8115
;static const uint  GL_DUAL_LUMINANCE12_SGIS         = 0x8116
;static const uint  GL_DUAL_LUMINANCE16_SGIS         = 0x8117
;static const uint  GL_DUAL_INTENSITY4_SGIS          = 0x8118
;static const uint  GL_DUAL_INTENSITY8_SGIS          = 0x8119
;static const uint  GL_DUAL_INTENSITY12_SGIS         = 0x811A
;static const uint  GL_DUAL_INTENSITY16_SGIS         = 0x811B
;static const uint  GL_DUAL_LUMINANCE_ALPHA4_SGIS    = 0x811C
;static const uint  GL_DUAL_LUMINANCE_ALPHA8_SGIS    = 0x811D
;static const uint  GL_QUAD_ALPHA4_SGIS              = 0x811E
;static const uint  GL_QUAD_ALPHA8_SGIS              = 0x811F
;static const uint  GL_QUAD_LUMINANCE4_SGIS          = 0x8120
;static const uint  GL_QUAD_LUMINANCE8_SGIS          = 0x8121
;static const uint  GL_QUAD_INTENSITY4_SGIS          = 0x8122
;static const uint  GL_QUAD_INTENSITY8_SGIS          = 0x8123
;static const uint  GL_DUAL_TEXTURE_SELECT_SGIS      = 0x8124
;static const uint  GL_QUAD_TEXTURE_SELECT_SGIS      = 0x8125


//#ifndef GL_SGIX_sprite
;static const uint  GL_SPRITE_SGIX                   = 0x8148
;static const uint  GL_SPRITE_MODE_SGIX              = 0x8149
;static const uint  GL_SPRITE_AXIS_SGIX              = 0x814A
;static const uint  GL_SPRITE_TRANSLATION_SGIX       = 0x814B
;static const uint  GL_SPRITE_AXIAL_SGIX             = 0x814C
;static const uint  GL_SPRITE_OBJECT_ALIGNED_SGIX    = 0x814D
;static const uint  GL_SPRITE_EYE_ALIGNED_SGIX       = 0x814E


//#ifndef GL_SGIX_texture_multi_buffer
;static const uint  GL_TEXTURE_MULTI_BUFFER_HINT_SGIX= 0x812E


//#ifndef GL_EXT_point_parameters
;static const uint  GL_POINT_SIZE_MIN_EXT            = 0x8126
;static const uint  GL_POINT_SIZE_MAX_EXT            = 0x8127
;static const uint  GL_POINT_FADE_THRESHOLD_SIZE_EXT = 0x8128
;static const uint  GL_DISTANCE_ATTENUATION_EXT      = 0x8129


//#ifndef GL_SGIS_point_parameters
;static const uint  GL_POINT_SIZE_MIN_SGIS           = 0x8126
;static const uint  GL_POINT_SIZE_MAX_SGIS           = 0x8127
;static const uint  GL_POINT_FADE_THRESHOLD_SIZE_SGIS= 0x8128
;static const uint  GL_DISTANCE_ATTENUATION_SGIS     = 0x8129


//#ifndef GL_SGIX_instruments
;static const uint  GL_INSTRUMENT_BUFFER_POINTER_SGIX= 0x8180
;static const uint  GL_INSTRUMENT_MEASUREMENTS_SGIX  = 0x8181


//#ifndef GL_SGIX_texture_scale_bias
;static const uint  GL_POST_TEXTURE_FILTER_BIAS_SGIX = 0x8179
;static const uint  GL_POST_TEXTURE_FILTER_SCALE_SGIX= 0x817A
;static const uint  GL_POST_TEXTURE_FILTER_BIAS_RANGE_SGIX= 0x817B
;static const uint  GL_POST_TEXTURE_FILTER_SCALE_RANGE_SGIX= 0x817C


//#ifndef GL_SGIX_framezoom
;static const uint  GL_FRAMEZOOM_SGIX                = 0x818B
;static const uint  GL_FRAMEZOOM_FACTOR_SGIX         = 0x818C
;static const uint  GL_MAX_FRAMEZOOM_FACTOR_SGIX     = 0x818D


//#ifndef GL_SGIX_tag_sample_buffer


//#ifndef GL_SGIX_polynomial_ffd
;static const uint  GL_TEXTURE_DEFORMATION_BIT_SGIX  = 0x00000001
;static const uint  GL_GEOMETRY_DEFORMATION_BIT_SGIX = 0x00000002
;static const uint  GL_GEOMETRY_DEFORMATION_SGIX     = 0x8194
;static const uint  GL_TEXTURE_DEFORMATION_SGIX      = 0x8195
;static const uint  GL_DEFORMATIONS_MASK_SGIX        = 0x8196
;static const uint  GL_MAX_DEFORMATION_ORDER_SGIX    = 0x8197


//#ifndef GL_SGIX_reference_plane
;static const uint  GL_REFERENCE_PLANE_SGIX          = 0x817D
;static const uint  GL_REFERENCE_PLANE_EQUATION_SGIX = 0x817E


//#ifndef GL_SGIX_flush_raster


//#ifndef GL_SGIX_depth_texture
;static const uint  GL_DEPTH_COMPONENT16_SGIX        = 0x81A5
;static const uint  GL_DEPTH_COMPONENT24_SGIX        = 0x81A6
;static const uint  GL_DEPTH_COMPONENT32_SGIX        = 0x81A7


//#ifndef GL_SGIS_fog_function
;static const uint  GL_FOG_FUNC_SGIS                 = 0x812A
;static const uint  GL_FOG_FUNC_POINTS_SGIS          = 0x812B
;static const uint  GL_MAX_FOG_FUNC_POINTS_SGIS      = 0x812C


//#ifndef GL_SGIX_fog_offset
;static const uint  GL_FOG_OFFSET_SGIX               = 0x8198
;static const uint  GL_FOG_OFFSET_VALUE_SGIX         = 0x8199


//#ifndef GL_HP_image_transform
;static const uint  GL_IMAGE_SCALE_X_HP              = 0x8155
;static const uint  GL_IMAGE_SCALE_Y_HP              = 0x8156
;static const uint  GL_IMAGE_TRANSLATE_X_HP          = 0x8157
;static const uint  GL_IMAGE_TRANSLATE_Y_HP          = 0x8158
;static const uint  GL_IMAGE_ROTATE_ANGLE_HP         = 0x8159
;static const uint  GL_IMAGE_ROTATE_ORIGIN_X_HP      = 0x815A
;static const uint  GL_IMAGE_ROTATE_ORIGIN_Y_HP      = 0x815B
;static const uint  GL_IMAGE_MAG_FILTER_HP           = 0x815C
;static const uint  GL_IMAGE_MIN_FILTER_HP           = 0x815D
;static const uint  GL_IMAGE_CUBIC_WEIGHT_HP         = 0x815E
;static const uint  GL_CUBIC_HP                      = 0x815F
;static const uint  GL_AVERAGE_HP                    = 0x8160
;static const uint  GL_IMAGE_TRANSFORM_2D_HP         = 0x8161
;static const uint  GL_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP= 0x8162
;static const uint  GL_PROXY_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP= 0x8163


//#ifndef GL_HP_convolution_border_modes
;static const uint  GL_IGNORE_BORDER_HP              = 0x8150
;static const uint  GL_CONSTANT_BORDER_HP            = 0x8151
;static const uint  GL_REPLICATE_BORDER_HP           = 0x8153
;static const uint  GL_CONVOLUTION_BORDER_COLOR_HP   = 0x8154


//#ifndef GL_INGR_palette_buffer


//#ifndef GL_SGIX_texture_add_env
;static const uint  GL_TEXTURE_ENV_BIAS_SGIX         = 0x80BE


//#ifndef GL_EXT_color_subtable


//#ifndef GL_PGI_vertex_hints
;static const uint  GL_VERTEX_DATA_HINT_PGI          = 0x1A22A
;static const uint  GL_VERTEX_CONSISTENT_HINT_PGI    = 0x1A22B
;static const uint  GL_MATERIAL_SIDE_HINT_PGI        = 0x1A22C
;static const uint  GL_MAX_VERTEX_HINT_PGI           = 0x1A22D
;static const uint  GL_VERTEX23_BIT_PGI              = 0x00000004
;static const uint  GL_VERTEX4_BIT_PGI               = 0x00000008
;static const uint  GL_COLOR3_BIT_PGI                = 0x00010000
;static const uint  GL_COLOR4_BIT_PGI                = 0x00020000
;static const uint  GL_EDGEFLAG_BIT_PGI              = 0x00040000
;static const uint  GL_INDEX_BIT_PGI                 = 0x00080000
;static const uint  GL_MAT_AMBIENT_BIT_PGI           = 0x00100000
;static const uint  GL_MAT_AMBIENT_AND_DIFFUSE_BIT_PGI= 0x00200000
;static const uint  GL_MAT_DIFFUSE_BIT_PGI           = 0x00400000
;static const uint  GL_MAT_EMISSION_BIT_PGI          = 0x00800000
;static const uint  GL_MAT_COLOR_INDEXES_BIT_PGI     = 0x01000000
;static const uint  GL_MAT_SHININESS_BIT_PGI         = 0x02000000
;static const uint  GL_MAT_SPECULAR_BIT_PGI          = 0x04000000
;static const uint  GL_NORMAL_BIT_PGI                = 0x08000000
;static const uint  GL_TEXCOORD1_BIT_PGI             = 0x10000000
;static const uint  GL_TEXCOORD2_BIT_PGI             = 0x20000000
;static const uint  GL_TEXCOORD3_BIT_PGI             = 0x40000000
;static const uint  GL_TEXCOORD4_BIT_PGI             = 0x80000000


//#ifndef GL_PGI_misc_hints
;static const uint  GL_PREFER_DOUBLEBUFFER_HINT_PGI  = 0x1A1F8
;static const uint  GL_CONSERVE_MEMORY_HINT_PGI      = 0x1A1FD
;static const uint  GL_RECLAIM_MEMORY_HINT_PGI       = 0x1A1FE
;static const uint  GL_NATIVE_GRAPHICS_HANDLE_PGI    = 0x1A202
;static const uint  GL_NATIVE_GRAPHICS_BEGIN_HINT_PGI= 0x1A203
;static const uint  GL_NATIVE_GRAPHICS_END_HINT_PGI  = 0x1A204
;static const uint  GL_ALWAYS_FAST_HINT_PGI          = 0x1A20C
;static const uint  GL_ALWAYS_SOFT_HINT_PGI          = 0x1A20D
;static const uint  GL_ALLOW_DRAW_OBJ_HINT_PGI       = 0x1A20E
;static const uint  GL_ALLOW_DRAW_WIN_HINT_PGI       = 0x1A20F
;static const uint  GL_ALLOW_DRAW_FRG_HINT_PGI       = 0x1A210
;static const uint  GL_ALLOW_DRAW_MEM_HINT_PGI       = 0x1A211
;static const uint  GL_STRICT_DEPTHFUNC_HINT_PGI     = 0x1A216
;static const uint  GL_STRICT_LIGHTING_HINT_PGI      = 0x1A217
;static const uint  GL_STRICT_SCISSOR_HINT_PGI       = 0x1A218
;static const uint  GL_FULL_STIPPLE_HINT_PGI         = 0x1A219
;static const uint  GL_CLIP_NEAR_HINT_PGI            = 0x1A220
;static const uint  GL_CLIP_FAR_HINT_PGI             = 0x1A221
;static const uint  GL_WIDE_LINE_HINT_PGI            = 0x1A222
;static const uint  GL_BACK_NORMALS_HINT_PGI         = 0x1A223


//#ifndef GL_EXT_paletted_texture
;static const uint  GL_COLOR_INDEX1_EXT              = 0x80E2
;static const uint  GL_COLOR_INDEX2_EXT              = 0x80E3
;static const uint  GL_COLOR_INDEX4_EXT              = 0x80E4
;static const uint  GL_COLOR_INDEX8_EXT              = 0x80E5
;static const uint  GL_COLOR_INDEX12_EXT             = 0x80E6
;static const uint  GL_COLOR_INDEX16_EXT             = 0x80E7
;static const uint  GL_TEXTURE_INDEX_SIZE_EXT        = 0x80ED


//#ifndef GL_EXT_clip_volume_hint
;static const uint  GL_CLIP_VOLUME_CLIPPING_HINT_EXT = 0x80F0


//#ifndef GL_SGIX_list_priority
;static const uint  GL_LIST_PRIORITY_SGIX            = 0x8182


//#ifndef GL_SGIX_ir_instrument1
;static const uint  GL_IR_INSTRUMENT1_SGIX           = 0x817F


//#ifndef GL_SGIX_calligraphic_fragment
;static const uint  GL_CALLIGRAPHIC_FRAGMENT_SGIX    = 0x8183


//#ifndef GL_SGIX_texture_lod_bias
;static const uint  GL_TEXTURE_LOD_BIAS_S_SGIX       = 0x818E
;static const uint  GL_TEXTURE_LOD_BIAS_T_SGIX       = 0x818F
;static const uint  GL_TEXTURE_LOD_BIAS_R_SGIX       = 0x8190


//#ifndef GL_SGIX_shadow_ambient
;static const uint  GL_SHADOW_AMBIENT_SGIX           = 0x80BF


//#ifndef GL_EXT_index_texture


//#ifndef GL_EXT_index_material
;static const uint  GL_INDEX_MATERIAL_EXT            = 0x81B8
;static const uint  GL_INDEX_MATERIAL_PARAMETER_EXT  = 0x81B9
;static const uint  GL_INDEX_MATERIAL_FACE_EXT       = 0x81BA


//#ifndef GL_EXT_index_func
;static const uint  GL_INDEX_TEST_EXT                = 0x81B5
;static const uint  GL_INDEX_TEST_FUNC_EXT           = 0x81B6
;static const uint  GL_INDEX_TEST_REF_EXT            = 0x81B7


//#ifndef GL_EXT_index_array_formats
;static const uint  GL_IUI_V2F_EXT                   = 0x81AD
;static const uint  GL_IUI_V3F_EXT                   = 0x81AE
;static const uint  GL_IUI_N3F_V2F_EXT               = 0x81AF
;static const uint  GL_IUI_N3F_V3F_EXT               = 0x81B0
;static const uint  GL_T2F_IUI_V2F_EXT               = 0x81B1
;static const uint  GL_T2F_IUI_V3F_EXT               = 0x81B2
;static const uint  GL_T2F_IUI_N3F_V2F_EXT           = 0x81B3
;static const uint  GL_T2F_IUI_N3F_V3F_EXT           = 0x81B4


//#ifndef GL_EXT_compiled_vertex_array
;static const uint  GL_ARRAY_ELEMENT_LOCK_FIRST_EXT  = 0x81A8
;static const uint  GL_ARRAY_ELEMENT_LOCK_COUNT_EXT  = 0x81A9


//#ifndef GL_EXT_cull_vertex
;static const uint  GL_CULL_VERTEX_EXT               = 0x81AA
;static const uint  GL_CULL_VERTEX_EYE_POSITION_EXT  = 0x81AB
;static const uint  GL_CULL_VERTEX_OBJECT_POSITION_EXT= 0x81AC


//#ifndef GL_SGIX_ycrcb
;static const uint  GL_YCRCB_422_SGIX                = 0x81BB
;static const uint  GL_YCRCB_444_SGIX                = 0x81BC


//#ifndef GL_SGIX_fragment_lighting
;static const uint  GL_FRAGMENT_LIGHTING_SGIX        = 0x8400
;static const uint  GL_FRAGMENT_COLOR_MATERIAL_SGIX  = 0x8401
;static const uint  GL_FRAGMENT_COLOR_MATERIAL_FACE_SGIX= 0x8402
;static const uint  GL_FRAGMENT_COLOR_MATERIAL_PARAMETER_SGIX= 0x8403
;static const uint  GL_MAX_FRAGMENT_LIGHTS_SGIX      = 0x8404
;static const uint  GL_MAX_ACTIVE_LIGHTS_SGIX        = 0x8405
;static const uint  GL_CURRENT_RASTER_NORMAL_SGIX    = 0x8406
;static const uint  GL_LIGHT_ENV_MODE_SGIX           = 0x8407
;static const uint  GL_FRAGMENT_LIGHT_MODEL_LOCAL_VIEWER_SGIX= 0x8408
;static const uint  GL_FRAGMENT_LIGHT_MODEL_TWO_SIDE_SGIX= 0x8409
;static const uint  GL_FRAGMENT_LIGHT_MODEL_AMBIENT_SGIX= 0x840A
;static const uint  GL_FRAGMENT_LIGHT_MODEL_NORMAL_INTERPOLATION_SGIX= 0x840B
;static const uint  GL_FRAGMENT_LIGHT0_SGIX          = 0x840C
;static const uint  GL_FRAGMENT_LIGHT1_SGIX          = 0x840D
;static const uint  GL_FRAGMENT_LIGHT2_SGIX          = 0x840E
;static const uint  GL_FRAGMENT_LIGHT3_SGIX          = 0x840F
;static const uint  GL_FRAGMENT_LIGHT4_SGIX          = 0x8410
;static const uint  GL_FRAGMENT_LIGHT5_SGIX          = 0x8411
;static const uint  GL_FRAGMENT_LIGHT6_SGIX          = 0x8412
;static const uint  GL_FRAGMENT_LIGHT7_SGIX          = 0x8413


//#ifndef GL_IBM_rasterpos_clip
;static const uint  GL_RASTER_POSITION_UNCLIPPED_IBM = 0x19262


//#ifndef GL_HP_texture_lighting
;static const uint  GL_TEXTURE_LIGHTING_MODE_HP      = 0x8167
;static const uint  GL_TEXTURE_POST_SPECULAR_HP      = 0x8168
;static const uint  GL_TEXTURE_PRE_SPECULAR_HP       = 0x8169


//#ifndef GL_EXT_draw_range_elements
;static const uint  GL_MAX_ELEMENTS_VERTICES_EXT     = 0x80E8
;static const uint  GL_MAX_ELEMENTS_INDICES_EXT      = 0x80E9


//#ifndef GL_WIN_phong_shading
;static const uint  GL_PHONG_WIN                     = 0x80EA
;static const uint  GL_PHONG_HINT_WIN                = 0x80EB


//#ifndef GL_WIN_specular_fog
;static const uint  GL_FOG_SPECULAR_TEXTURE_WIN      = 0x80EC


//#ifndef GL_EXT_light_texture
;static const uint  GL_FRAGMENT_MATERIAL_EXT         = 0x8349
;static const uint  GL_FRAGMENT_NORMAL_EXT           = 0x834A
;static const uint  GL_FRAGMENT_COLOR_EXT            = 0x834C
;static const uint  GL_ATTENUATION_EXT               = 0x834D
;static const uint  GL_SHADOW_ATTENUATION_EXT        = 0x834E
;static const uint  GL_TEXTURE_APPLICATION_MODE_EXT  = 0x834F
;static const uint  GL_TEXTURE_LIGHT_EXT             = 0x8350
;static const uint  GL_TEXTURE_MATERIAL_FACE_EXT     = 0x8351
;static const uint  GL_TEXTURE_MATERIAL_PARAMETER_EXT= 0x8352
/* reuse GL_FRAGMENT_DEPTH_EXT */


//#ifndef GL_SGIX_blend_alpha_minmax
;static const uint  GL_ALPHA_MIN_SGIX                = 0x8320
;static const uint  GL_ALPHA_MAX_SGIX                = 0x8321


//#ifndef GL_EXT_bgra
;static const uint  GL_BGR_EXT                       = 0x80E0
;static const uint  GL_BGRA_EXT                      = 0x80E1


//#ifndef GL_SGIX_async
;static const uint  GL_ASYNC_MARKER_SGIX             = 0x8329


//#ifndef GL_SGIX_async_pixel
;static const uint  GL_ASYNC_TEX_IMAGE_SGIX          = 0x835C
;static const uint  GL_ASYNC_DRAW_PIXELS_SGIX        = 0x835D
;static const uint  GL_ASYNC_READ_PIXELS_SGIX        = 0x835E
;static const uint  GL_MAX_ASYNC_TEX_IMAGE_SGIX      = 0x835F
;static const uint  GL_MAX_ASYNC_DRAW_PIXELS_SGIX    = 0x8360
;static const uint  GL_MAX_ASYNC_READ_PIXELS_SGIX    = 0x8361


//#ifndef GL_SGIX_async_histogram
;static const uint  GL_ASYNC_HISTOGRAM_SGIX          = 0x832C
;static const uint  GL_MAX_ASYNC_HISTOGRAM_SGIX      = 0x832D


//#ifndef GL_INTEL_texture_scissor


//#ifndef GL_INTEL_parallel_arrays
;static const uint  GL_PARALLEL_ARRAYS_INTEL         = 0x83F4
;static const uint  GL_VERTEX_ARRAY_PARALLEL_POINTERS_INTEL= 0x83F5
;static const uint  GL_NORMAL_ARRAY_PARALLEL_POINTERS_INTEL= 0x83F6
;static const uint  GL_COLOR_ARRAY_PARALLEL_POINTERS_INTEL= 0x83F7
;static const uint  GL_TEXTURE_COORD_ARRAY_PARALLEL_POINTERS_INTEL= 0x83F8


//#ifndef GL_HP_occlusion_test
;static const uint  GL_OCCLUSION_TEST_HP             = 0x8165
;static const uint  GL_OCCLUSION_TEST_RESULT_HP      = 0x8166


//#ifndef GL_EXT_pixel_transform
;static const uint  GL_PIXEL_TRANSFORM_2D_EXT        = 0x8330
;static const uint  GL_PIXEL_MAG_FILTER_EXT          = 0x8331
;static const uint  GL_PIXEL_MIN_FILTER_EXT          = 0x8332
;static const uint  GL_PIXEL_CUBIC_WEIGHT_EXT        = 0x8333
;static const uint  GL_CUBIC_EXT                     = 0x8334
;static const uint  GL_AVERAGE_EXT                   = 0x8335
;static const uint  GL_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT= 0x8336
;static const uint  GL_MAX_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT= 0x8337
;static const uint  GL_PIXEL_TRANSFORM_2D_MATRIX_EXT = 0x8338


//#ifndef GL_EXT_pixel_transform_color_table


//#ifndef GL_EXT_shared_texture_palette
;static const uint  GL_SHARED_TEXTURE_PALETTE_EXT    = 0x81FB


//#ifndef GL_EXT_separate_specular_color
;static const uint  GL_LIGHT_MODEL_COLOR_CONTROL_EXT = 0x81F8
;static const uint  GL_SINGLE_COLOR_EXT              = 0x81F9
;static const uint  GL_SEPARATE_SPECULAR_COLOR_EXT   = 0x81FA


//#ifndef GL_EXT_secondary_color
;static const uint  GL_COLOR_SUM_EXT                 = 0x8458
;static const uint  GL_CURRENT_SECONDARY_COLOR_EXT   = 0x8459
;static const uint  GL_SECONDARY_COLOR_ARRAY_SIZE_EXT= 0x845A
;static const uint  GL_SECONDARY_COLOR_ARRAY_TYPE_EXT= 0x845B
;static const uint  GL_SECONDARY_COLOR_ARRAY_STRIDE_EXT= 0x845C
;static const uint  GL_SECONDARY_COLOR_ARRAY_POINTER_EXT= 0x845D
;static const uint  GL_SECONDARY_COLOR_ARRAY_EXT     = 0x845E


//#ifndef GL_EXT_texture_perturb_normal
;static const uint  GL_PERTURB_EXT                   = 0x85AE
;static const uint  GL_TEXTURE_NORMAL_EXT            = 0x85AF


//#ifndef GL_EXT_multi_draw_arrays


//#ifndef GL_EXT_fog_coord
;static const uint  GL_FOG_COORDINATE_SOURCE_EXT     = 0x8450
;static const uint  GL_FOG_COORDINATE_EXT            = 0x8451
;static const uint  GL_FRAGMENT_DEPTH_EXT            = 0x8452
;static const uint  GL_CURRENT_FOG_COORDINATE_EXT    = 0x8453
;static const uint  GL_FOG_COORDINATE_ARRAY_TYPE_EXT = 0x8454
;static const uint  GL_FOG_COORDINATE_ARRAY_STRIDE_EXT= 0x8455
;static const uint  GL_FOG_COORDINATE_ARRAY_POINTER_EXT= 0x8456
;static const uint  GL_FOG_COORDINATE_ARRAY_EXT      = 0x8457


//#ifndef GL_REND_screen_coordinates
;static const uint  GL_SCREEN_COORDINATES_REND       = 0x8490
;static const uint  GL_INVERTED_SCREEN_W_REND        = 0x8491


//#ifndef GL_EXT_coordinate_frame
;static const uint  GL_TANGENT_ARRAY_EXT             = 0x8439
;static const uint  GL_BINORMAL_ARRAY_EXT            = 0x843A
;static const uint  GL_CURRENT_TANGENT_EXT           = 0x843B
;static const uint  GL_CURRENT_BINORMAL_EXT          = 0x843C
;static const uint  GL_TANGENT_ARRAY_TYPE_EXT        = 0x843E
;static const uint  GL_TANGENT_ARRAY_STRIDE_EXT      = 0x843F
;static const uint  GL_BINORMAL_ARRAY_TYPE_EXT       = 0x8440
;static const uint  GL_BINORMAL_ARRAY_STRIDE_EXT     = 0x8441
;static const uint  GL_TANGENT_ARRAY_POINTER_EXT     = 0x8442
;static const uint  GL_BINORMAL_ARRAY_POINTER_EXT    = 0x8443
;static const uint  GL_MAP1_TANGENT_EXT              = 0x8444
;static const uint  GL_MAP2_TANGENT_EXT              = 0x8445
;static const uint  GL_MAP1_BINORMAL_EXT             = 0x8446
;static const uint  GL_MAP2_BINORMAL_EXT             = 0x8447


//#ifndef GL_EXT_texture_env_combine
;static const uint  GL_COMBINE_EXT                   = 0x8570
;static const uint  GL_COMBINE_RGB_EXT               = 0x8571
;static const uint  GL_COMBINE_ALPHA_EXT             = 0x8572
;static const uint  GL_RGB_SCALE_EXT                 = 0x8573
;static const uint  GL_ADD_SIGNED_EXT                = 0x8574
;static const uint  GL_INTERPOLATE_EXT               = 0x8575
;static const uint  GL_CONSTANT_EXT                  = 0x8576
;static const uint  GL_PRIMARY_COLOR_EXT             = 0x8577
;static const uint  GL_PREVIOUS_EXT                  = 0x8578
;static const uint  GL_SOURCE0_RGB_EXT               = 0x8580
;static const uint  GL_SOURCE1_RGB_EXT               = 0x8581
;static const uint  GL_SOURCE2_RGB_EXT               = 0x8582
;static const uint  GL_SOURCE0_ALPHA_EXT             = 0x8588
;static const uint  GL_SOURCE1_ALPHA_EXT             = 0x8589
;static const uint  GL_SOURCE2_ALPHA_EXT             = 0x858A
;static const uint  GL_OPERAND0_RGB_EXT              = 0x8590
;static const uint  GL_OPERAND1_RGB_EXT              = 0x8591
;static const uint  GL_OPERAND2_RGB_EXT              = 0x8592
;static const uint  GL_OPERAND0_ALPHA_EXT            = 0x8598
;static const uint  GL_OPERAND1_ALPHA_EXT            = 0x8599
;static const uint  GL_OPERAND2_ALPHA_EXT            = 0x859A


//#ifndef GL_APPLE_specular_vector
;static const uint  GL_LIGHT_MODEL_SPECULAR_VECTOR_APPLE= 0x85B0


//#ifndef GL_APPLE_transform_hint
;static const uint  GL_TRANSFORM_HINT_APPLE          = 0x85B1


//#ifndef GL_SUNX_constant_data
;static const uint  GL_UNPACK_CONSTANT_DATA_SUNX     = 0x81D5
;static const uint  GL_TEXTURE_CONSTANT_DATA_SUNX    = 0x81D6


//#ifndef GL_SUN_global_alpha
;static const uint  GL_GLOBAL_ALPHA_SUN              = 0x81D9
;static const uint  GL_GLOBAL_ALPHA_FACTOR_SUN       = 0x81DA


//#ifndef GL_SUN_triangle_list
;static const uint  GL_RESTART_SUN                   = 0x0001
;static const uint  GL_REPLACE_MIDDLE_SUN            = 0x0002
;static const uint  GL_REPLACE_OLDEST_SUN            = 0x0003
;static const uint  GL_TRIANGLE_LIST_SUN             = 0x81D7
;static const uint  GL_REPLACEMENT_CODE_SUN          = 0x81D8
;static const uint  GL_REPLACEMENT_CODE_ARRAY_SUN    = 0x85C0
;static const uint  GL_REPLACEMENT_CODE_ARRAY_TYPE_SUN= 0x85C1
;static const uint  GL_REPLACEMENT_CODE_ARRAY_STRIDE_SUN= 0x85C2
;static const uint  GL_REPLACEMENT_CODE_ARRAY_POINTER_SUN= 0x85C3
;static const uint  GL_R1UI_V3F_SUN                  = 0x85C4
;static const uint  GL_R1UI_C4UB_V3F_SUN             = 0x85C5
;static const uint  GL_R1UI_C3F_V3F_SUN              = 0x85C6
;static const uint  GL_R1UI_N3F_V3F_SUN              = 0x85C7
;static const uint  GL_R1UI_C4F_N3F_V3F_SUN          = 0x85C8
;static const uint  GL_R1UI_T2F_V3F_SUN              = 0x85C9
;static const uint  GL_R1UI_T2F_N3F_V3F_SUN          = 0x85CA
;static const uint  GL_R1UI_T2F_C4F_N3F_V3F_SUN      = 0x85CB


//#ifndef GL_SUN_vertex


//#ifndef GL_EXT_blend_func_separate
;static const uint  GL_BLEND_DST_RGB_EXT             = 0x80C8
;static const uint  GL_BLEND_SRC_RGB_EXT             = 0x80C9
;static const uint  GL_BLEND_DST_ALPHA_EXT           = 0x80CA
;static const uint  GL_BLEND_SRC_ALPHA_EXT           = 0x80CB


//#ifndef GL_INGR_color_clamp
;static const uint  GL_RED_MIN_CLAMP_INGR            = 0x8560
;static const uint  GL_GREEN_MIN_CLAMP_INGR          = 0x8561
;static const uint  GL_BLUE_MIN_CLAMP_INGR           = 0x8562
;static const uint  GL_ALPHA_MIN_CLAMP_INGR          = 0x8563
;static const uint  GL_RED_MAX_CLAMP_INGR            = 0x8564
;static const uint  GL_GREEN_MAX_CLAMP_INGR          = 0x8565
;static const uint  GL_BLUE_MAX_CLAMP_INGR           = 0x8566
;static const uint  GL_ALPHA_MAX_CLAMP_INGR          = 0x8567


//#ifndef GL_INGR_interlace_read
;static const uint  GL_INTERLACE_READ_INGR           = 0x8568


//#ifndef GL_EXT_stencil_wrap
;static const uint  GL_INCR_WRAP_EXT                 = 0x8507
;static const uint  GL_DECR_WRAP_EXT                 = 0x8508


//#ifndef GL_EXT_422_pixels
;static const uint  GL_422_EXT                       = 0x80CC
;static const uint  GL_422_REV_EXT                   = 0x80CD
;static const uint  GL_422_AVERAGE_EXT               = 0x80CE
;static const uint  GL_422_REV_AVERAGE_EXT           = 0x80CF


//#ifndef GL_NV_texgen_reflection
;static const uint  GL_NORMAL_MAP_NV                 = 0x8511
;static const uint  GL_REFLECTION_MAP_NV             = 0x8512


//#ifndef GL_EXT_texture_cube_map
;static const uint  GL_NORMAL_MAP_EXT                = 0x8511
;static const uint  GL_REFLECTION_MAP_EXT            = 0x8512
;static const uint  GL_TEXTURE_CUBE_MAP_EXT          = 0x8513
;static const uint  GL_TEXTURE_BINDING_CUBE_MAP_EXT  = 0x8514
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_X_EXT= 0x8515
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_X_EXT= 0x8516
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_Y_EXT= 0x8517
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_EXT= 0x8518
;static const uint  GL_TEXTURE_CUBE_MAP_POSITIVE_Z_EXT= 0x8519
;static const uint  GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_EXT= 0x851A
;static const uint  GL_PROXY_TEXTURE_CUBE_MAP_EXT    = 0x851B
;static const uint  GL_MAX_CUBE_MAP_TEXTURE_SIZE_EXT = 0x851C


//#ifndef GL_SUN_convolution_border_modes
;static const uint  GL_WRAP_BORDER_SUN               = 0x81D4


//#ifndef GL_EXT_texture_env_add


//#ifndef GL_EXT_texture_lod_bias
;static const uint  GL_MAX_TEXTURE_LOD_BIAS_EXT      = 0x84FD
;static const uint  GL_TEXTURE_FILTER_CONTROL_EXT    = 0x8500
;static const uint  GL_TEXTURE_LOD_BIAS_EXT          = 0x8501


//#ifndef GL_EXT_texture_filter_anisotropic
;static const uint  GL_TEXTURE_MAX_ANISOTROPY_EXT    = 0x84FE
;static const uint  GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT= 0x84FF


//#ifndef GL_EXT_vertex_weighting
;static const uint  GL_MODELVIEW0_STACK_DEPTH_EXT    = 0x0BA3
;static const uint  GL_MODELVIEW1_STACK_DEPTH_EXT    = 0x8502
;static const uint  GL_MODELVIEW0_MATRIX_EXT         = 0x0BA6
;static const uint  GL_MODELVIEW1_MATRIX_EXT         = 0x8506
;static const uint  GL_VERTEX_WEIGHTING_EXT          = 0x8509
;static const uint  GL_MODELVIEW0_EXT                = 0x1700
;static const uint  GL_MODELVIEW1_EXT                = 0x850A
;static const uint  GL_CURRENT_VERTEX_WEIGHT_EXT     = 0x850B
;static const uint  GL_VERTEX_WEIGHT_ARRAY_EXT       = 0x850C
;static const uint  GL_VERTEX_WEIGHT_ARRAY_SIZE_EXT  = 0x850D
;static const uint  GL_VERTEX_WEIGHT_ARRAY_TYPE_EXT  = 0x850E
;static const uint  GL_VERTEX_WEIGHT_ARRAY_STRIDE_EXT= 0x850F
;static const uint  GL_VERTEX_WEIGHT_ARRAY_POINTER_EXT= 0x8510


//#ifndef GL_NV_light_max_exponent
;static const uint  GL_MAX_SHININESS_NV              = 0x8504
;static const uint  GL_MAX_SPOT_EXPONENT_NV          = 0x8505


//#ifndef GL_NV_vertex_array_range
;static const uint  GL_VERTEX_ARRAY_RANGE_NV         = 0x851D
;static const uint  GL_VERTEX_ARRAY_RANGE_LENGTH_NV  = 0x851E
;static const uint  GL_VERTEX_ARRAY_RANGE_VALID_NV   = 0x851F
;static const uint  GL_MAX_VERTEX_ARRAY_RANGE_ELEMENT_NV= 0x8520
;static const uint  GL_VERTEX_ARRAY_RANGE_POINTER_NV = 0x8521


//#ifndef GL_NV_register_combiners
;static const uint  GL_REGISTER_COMBINERS_NV         = 0x8522
;static const uint  GL_VARIABLE_A_NV                 = 0x8523
;static const uint  GL_VARIABLE_B_NV                 = 0x8524
;static const uint  GL_VARIABLE_C_NV                 = 0x8525
;static const uint  GL_VARIABLE_D_NV                 = 0x8526
;static const uint  GL_VARIABLE_E_NV                 = 0x8527
;static const uint  GL_VARIABLE_F_NV                 = 0x8528
;static const uint  GL_VARIABLE_G_NV                 = 0x8529
;static const uint  GL_CONSTANT_COLOR0_NV            = 0x852A
;static const uint  GL_CONSTANT_COLOR1_NV            = 0x852B
;static const uint  GL_PRIMARY_COLOR_NV              = 0x852C
;static const uint  GL_SECONDARY_COLOR_NV            = 0x852D
;static const uint  GL_SPARE0_NV                     = 0x852E
;static const uint  GL_SPARE1_NV                     = 0x852F
;static const uint  GL_DISCARD_NV                    = 0x8530
;static const uint  GL_E_TIMES_F_NV                  = 0x8531
;static const uint  GL_SPARE0_PLUS_SECONDARY_COLOR_NV= 0x8532
;static const uint  GL_UNSIGNED_IDENTITY_NV          = 0x8536
;static const uint  GL_UNSIGNED_INVERT_NV            = 0x8537
;static const uint  GL_EXPAND_NORMAL_NV              = 0x8538
;static const uint  GL_EXPAND_NEGATE_NV              = 0x8539
;static const uint  GL_HALF_BIAS_NORMAL_NV           = 0x853A
;static const uint  GL_HALF_BIAS_NEGATE_NV           = 0x853B
;static const uint  GL_SIGNED_IDENTITY_NV            = 0x853C
;static const uint  GL_SIGNED_NEGATE_NV              = 0x853D
;static const uint  GL_SCALE_BY_TWO_NV               = 0x853E
;static const uint  GL_SCALE_BY_FOUR_NV              = 0x853F
;static const uint  GL_SCALE_BY_ONE_HALF_NV          = 0x8540
;static const uint  GL_BIAS_BY_NEGATIVE_ONE_HALF_NV  = 0x8541
;static const uint  GL_COMBINER_INPUT_NV             = 0x8542
;static const uint  GL_COMBINER_MAPPING_NV           = 0x8543
;static const uint  GL_COMBINER_COMPONENT_USAGE_NV   = 0x8544
;static const uint  GL_COMBINER_AB_DOT_PRODUCT_NV    = 0x8545
;static const uint  GL_COMBINER_CD_DOT_PRODUCT_NV    = 0x8546
;static const uint  GL_COMBINER_MUX_SUM_NV           = 0x8547
;static const uint  GL_COMBINER_SCALE_NV             = 0x8548
;static const uint  GL_COMBINER_BIAS_NV              = 0x8549
;static const uint  GL_COMBINER_AB_OUTPUT_NV         = 0x854A
;static const uint  GL_COMBINER_CD_OUTPUT_NV         = 0x854B
;static const uint  GL_COMBINER_SUM_OUTPUT_NV        = 0x854C
;static const uint  GL_MAX_GENERAL_COMBINERS_NV      = 0x854D
;static const uint  GL_NUM_GENERAL_COMBINERS_NV      = 0x854E
;static const uint  GL_COLOR_SUM_CLAMP_NV            = 0x854F
;static const uint  GL_COMBINER0_NV                  = 0x8550
;static const uint  GL_COMBINER1_NV                  = 0x8551
;static const uint  GL_COMBINER2_NV                  = 0x8552
;static const uint  GL_COMBINER3_NV                  = 0x8553
;static const uint  GL_COMBINER4_NV                  = 0x8554
;static const uint  GL_COMBINER5_NV                  = 0x8555
;static const uint  GL_COMBINER6_NV                  = 0x8556
;static const uint  GL_COMBINER7_NV                  = 0x8557
/* reuse GL_TEXTURE0_ARB */
/* reuse GL_TEXTURE1_ARB */
/* reuse GL_ZERO */
/* reuse GL_NONE */
/* reuse GL_FOG */


//#ifndef GL_NV_fog_distance
;static const uint  GL_FOG_DISTANCE_MODE_NV          = 0x855A
;static const uint  GL_EYE_RADIAL_NV                 = 0x855B
;static const uint  GL_EYE_PLANE_ABSOLUTE_NV         = 0x855C
/* reuse GL_EYE_PLANE */


//#ifndef GL_NV_texgen_emboss
;static const uint  GL_EMBOSS_LIGHT_NV               = 0x855D
;static const uint  GL_EMBOSS_CONSTANT_NV            = 0x855E
;static const uint  GL_EMBOSS_MAP_NV                 = 0x855F


//#ifndef GL_NV_blend_square


//#ifndef GL_NV_texture_env_combine4
;static const uint  GL_COMBINE4_NV                   = 0x8503
;static const uint  GL_SOURCE3_RGB_NV                = 0x8583
;static const uint  GL_SOURCE3_ALPHA_NV              = 0x858B
;static const uint  GL_OPERAND3_RGB_NV               = 0x8593
;static const uint  GL_OPERAND3_ALPHA_NV             = 0x859B


//#ifndef GL_MESA_resize_buffers


//#ifndef GL_MESA_window_pos


//#ifndef GL_EXT_texture_compression_s3tc
;static const uint  GL_COMPRESSED_RGB_S3TC_DXT1_EXT  = 0x83F0
;static const uint  GL_COMPRESSED_RGBA_S3TC_DXT1_EXT = 0x83F1
;static const uint  GL_COMPRESSED_RGBA_S3TC_DXT3_EXT = 0x83F2
;static const uint  GL_COMPRESSED_RGBA_S3TC_DXT5_EXT = 0x83F3


//#ifndef GL_IBM_cull_vertex
;static const uint  GL_CULL_VERTEX_IBM               = 103050


//#ifndef GL_IBM_multimode_draw_arrays


//#ifndef GL_IBM_vertex_array_lists
;static const uint  GL_VERTEX_ARRAY_LIST_IBM         = 103070
;static const uint  GL_NORMAL_ARRAY_LIST_IBM         = 103071
;static const uint  GL_COLOR_ARRAY_LIST_IBM          = 103072
;static const uint  GL_INDEX_ARRAY_LIST_IBM          = 103073
;static const uint  GL_TEXTURE_COORD_ARRAY_LIST_IBM  = 103074
;static const uint  GL_EDGE_FLAG_ARRAY_LIST_IBM      = 103075
;static const uint  GL_FOG_COORDINATE_ARRAY_LIST_IBM = 103076
;static const uint  GL_SECONDARY_COLOR_ARRAY_LIST_IBM= 103077
;static const uint  GL_VERTEX_ARRAY_LIST_STRIDE_IBM  = 103080
;static const uint  GL_NORMAL_ARRAY_LIST_STRIDE_IBM  = 103081
;static const uint  GL_COLOR_ARRAY_LIST_STRIDE_IBM   = 103082
;static const uint  GL_INDEX_ARRAY_LIST_STRIDE_IBM   = 103083
;static const uint  GL_TEXTURE_COORD_ARRAY_LIST_STRIDE_IBM =103084
;static const uint  GL_EDGE_FLAG_ARRAY_LIST_STRIDE_IBM =103085
;static const uint  GL_FOG_COORDINATE_ARRAY_LIST_STRIDE_IBM =103086
;static const uint  GL_SECONDARY_COLOR_ARRAY_LIST_STRIDE_IBM =103087


//#ifndef GL_SGIX_subsample
;static const uint  GL_PACK_SUBSAMPLE_RATE_SGIX      = 0x85A0
;static const uint  GL_UNPACK_SUBSAMPLE_RATE_SGIX    = 0x85A1
;static const uint  GL_PIXEL_SUBSAMPLE_4444_SGIX     = 0x85A2
;static const uint  GL_PIXEL_SUBSAMPLE_2424_SGIX     = 0x85A3
;static const uint  GL_PIXEL_SUBSAMPLE_4242_SGIX     = 0x85A4


//#ifndef GL_SGIX_ycrcb_subsample


//#ifndef GL_SGIX_ycrcba
;static const uint  GL_YCRCB_SGIX                    = 0x8318
;static const uint  GL_YCRCBA_SGIX                   = 0x8319


//#ifndef GL_3DFX_texture_compression_FXT1
;static const uint  GL_COMPRESSED_RGB_FXT1_3DFX      = 0x86B0
;static const uint  GL_COMPRESSED_RGBA_FXT1_3DFX     = 0x86B1


//#ifndef GL_3DFX_multisample
;static const uint  GL_MULTISAMPLE_3DFX              = 0x86B2
;static const uint  GL_SAMPLE_BUFFERS_3DFX           = 0x86B3
;static const uint  GL_SAMPLES_3DFX                  = 0x86B4
;static const uint  GL_MULTISAMPLE_BIT_3DFX          = 0x20000000


//#ifndef GL_3DFX_tbuffer


//#ifndef GL_EXT_multisample
;static const uint  GL_MULTISAMPLE_EXT               = 0x809D
;static const uint  GL_SAMPLE_ALPHA_TO_MASK_EXT      = 0x809E
;static const uint  GL_SAMPLE_ALPHA_TO_ONE_EXT       = 0x809F
;static const uint  GL_SAMPLE_MASK_EXT               = 0x80A0
;static const uint  GL_1PASS_EXT                     = 0x80A1
;static const uint  GL_2PASS_0_EXT                   = 0x80A2
;static const uint  GL_2PASS_1_EXT                   = 0x80A3
;static const uint  GL_4PASS_0_EXT                   = 0x80A4
;static const uint  GL_4PASS_1_EXT                   = 0x80A5
;static const uint  GL_4PASS_2_EXT                   = 0x80A6
;static const uint  GL_4PASS_3_EXT                   = 0x80A7
;static const uint  GL_SAMPLE_BUFFERS_EXT            = 0x80A8
;static const uint  GL_SAMPLES_EXT                   = 0x80A9
;static const uint  GL_SAMPLE_MASK_VALUE_EXT         = 0x80AA
;static const uint  GL_SAMPLE_MASK_INVERT_EXT        = 0x80AB
;static const uint  GL_SAMPLE_PATTERN_EXT            = 0x80AC
;static const uint  GL_MULTISAMPLE_BIT_EXT           = 0x20000000


//#ifndef GL_SGIX_vertex_preclip
;static const uint  GL_VERTEX_PRECLIP_SGIX           = 0x83EE
;static const uint  GL_VERTEX_PRECLIP_HINT_SGIX      = 0x83EF


//#ifndef GL_SGIX_convolution_accuracy
;static const uint  GL_CONVOLUTION_HINT_SGIX         = 0x8316


//#ifndef GL_SGIX_resample
;static const uint  GL_PACK_RESAMPLE_SGIX            = 0x842C
;static const uint  GL_UNPACK_RESAMPLE_SGIX          = 0x842D
;static const uint  GL_RESAMPLE_REPLICATE_SGIX       = 0x842E
;static const uint  GL_RESAMPLE_ZERO_FILL_SGIX       = 0x842F
;static const uint  GL_RESAMPLE_DECIMATE_SGIX        = 0x8430


//#ifndef GL_SGIS_point_line_texgen
;static const uint  GL_EYE_DISTANCE_TO_POINT_SGIS    = 0x81F0
;static const uint  GL_OBJECT_DISTANCE_TO_POINT_SGIS = 0x81F1
;static const uint  GL_EYE_DISTANCE_TO_LINE_SGIS     = 0x81F2
;static const uint  GL_OBJECT_DISTANCE_TO_LINE_SGIS  = 0x81F3
;static const uint  GL_EYE_POINT_SGIS                = 0x81F4
;static const uint  GL_OBJECT_POINT_SGIS             = 0x81F5
;static const uint  GL_EYE_LINE_SGIS                 = 0x81F6
;static const uint  GL_OBJECT_LINE_SGIS              = 0x81F7


//#ifndef GL_SGIS_texture_color_mask
;static const uint  GL_TEXTURE_COLOR_WRITEMASK_SGIS  = 0x81EF


//#ifndef GL_EXT_texture_env_dot3
;static const uint  GL_DOT3_RGB_EXT                  = 0x8740
;static const uint  GL_DOT3_RGBA_EXT                 = 0x8741


//#ifndef GL_ATI_texture_mirror_once
;static const uint  GL_MIRROR_CLAMP_ATI              = 0x8742
;static const uint  GL_MIRROR_CLAMP_TO_EDGE_ATI      = 0x8743


//#ifndef GL_NV_fence
;static const uint  GL_ALL_COMPLETED_NV              = 0x84F2
;static const uint  GL_FENCE_STATUS_NV               = 0x84F3
;static const uint  GL_FENCE_CONDITION_NV            = 0x84F4


//#ifndef GL_IBM_static_data
;static const uint  GL_ALL_STATIC_DATA_IBM           = 103060
;static const uint  GL_STATIC_VERTEX_ARRAY_IBM       = 103061


//#ifndef GL_IBM_texture_mirrored_repeat
;static const uint  GL_MIRRORED_REPEAT_IBM           = 0x8370


//#ifndef GL_NV_evaluators
;static const uint  GL_EVAL_2D_NV                    = 0x86C0
;static const uint  GL_EVAL_TRIANGULAR_2D_NV         = 0x86C1
;static const uint  GL_MAP_TESSELLATION_NV           = 0x86C2
;static const uint  GL_MAP_ATTRIB_U_ORDER_NV         = 0x86C3
;static const uint  GL_MAP_ATTRIB_V_ORDER_NV         = 0x86C4
;static const uint  GL_EVAL_FRACTIONAL_TESSELLATION_NV= 0x86C5
;static const uint  GL_EVAL_VERTEX_ATTRIB0_NV        = 0x86C6
;static const uint  GL_EVAL_VERTEX_ATTRIB1_NV        = 0x86C7
;static const uint  GL_EVAL_VERTEX_ATTRIB2_NV        = 0x86C8
;static const uint  GL_EVAL_VERTEX_ATTRIB3_NV        = 0x86C9
;static const uint  GL_EVAL_VERTEX_ATTRIB4_NV        = 0x86CA
;static const uint  GL_EVAL_VERTEX_ATTRIB5_NV        = 0x86CB
;static const uint  GL_EVAL_VERTEX_ATTRIB6_NV        = 0x86CC
;static const uint  GL_EVAL_VERTEX_ATTRIB7_NV        = 0x86CD
;static const uint  GL_EVAL_VERTEX_ATTRIB8_NV        = 0x86CE
;static const uint  GL_EVAL_VERTEX_ATTRIB9_NV        = 0x86CF
;static const uint  GL_EVAL_VERTEX_ATTRIB10_NV       = 0x86D0
;static const uint  GL_EVAL_VERTEX_ATTRIB11_NV       = 0x86D1
;static const uint  GL_EVAL_VERTEX_ATTRIB12_NV       = 0x86D2
;static const uint  GL_EVAL_VERTEX_ATTRIB13_NV       = 0x86D3
;static const uint  GL_EVAL_VERTEX_ATTRIB14_NV       = 0x86D4
;static const uint  GL_EVAL_VERTEX_ATTRIB15_NV       = 0x86D5
;static const uint  GL_MAX_MAP_TESSELLATION_NV       = 0x86D6
;static const uint  GL_MAX_RATIONAL_EVAL_ORDER_NV    = 0x86D7


//#ifndef GL_NV_packed_depth_stencil
;static const uint  GL_DEPTH_STENCIL_NV              = 0x84F9
;static const uint  GL_UNSIGNED_INT_24_8_NV          = 0x84FA


//#ifndef GL_NV_register_combiners2
;static const uint  GL_PER_STAGE_CONSTANTS_NV        = 0x8535


//#ifndef GL_NV_texture_compression_vtc


//#ifndef GL_NV_texture_rectangle
;static const uint  GL_TEXTURE_RECTANGLE_NV          = 0x84F5
;static const uint  GL_TEXTURE_BINDING_RECTANGLE_NV  = 0x84F6
;static const uint  GL_PROXY_TEXTURE_RECTANGLE_NV    = 0x84F7
;static const uint  GL_MAX_RECTANGLE_TEXTURE_SIZE_NV = 0x84F8


//#ifndef GL_NV_texture_shader
;static const uint  GL_OFFSET_TEXTURE_RECTANGLE_NV   = 0x864C
;static const uint  GL_OFFSET_TEXTURE_RECTANGLE_SCALE_NV= 0x864D
;static const uint  GL_DOT_PRODUCT_TEXTURE_RECTANGLE_NV= 0x864E
;static const uint  GL_RGBA_UNSIGNED_DOT_PRODUCT_MAPPING_NV= 0x86D9
;static const uint  GL_UNSIGNED_INT_S8_S8_8_8_NV     = 0x86DA
;static const uint  GL_UNSIGNED_INT_8_8_S8_S8_REV_NV = 0x86DB
;static const uint  GL_DSDT_MAG_INTENSITY_NV         = 0x86DC
;static const uint  GL_SHADER_CONSISTENT_NV          = 0x86DD
;static const uint  GL_TEXTURE_SHADER_NV             = 0x86DE
;static const uint  GL_SHADER_OPERATION_NV           = 0x86DF
;static const uint  GL_CULL_MODES_NV                 = 0x86E0
;static const uint  GL_OFFSET_TEXTURE_MATRIX_NV      = 0x86E1
;static const uint  GL_OFFSET_TEXTURE_2D_MATRIX_NV   = 0x86E1
;static const uint  GL_OFFSET_TEXTURE_SCALE_NV       = 0x86E2
;static const uint  GL_OFFSET_TEXTURE_2D_SCALE_NV    = 0x86E2
;static const uint  GL_OFFSET_TEXTURE_BIAS_NV        = 0x86E3
;static const uint  GL_OFFSET_TEXTURE_2D_BIAS_NV     = 0x86E3
;static const uint  GL_PREVIOUS_TEXTURE_INPUT_NV     = 0x86E4
;static const uint  GL_CONST_EYE_NV                  = 0x86E5
;static const uint  GL_PASS_THROUGH_NV               = 0x86E6
;static const uint  GL_CULL_FRAGMENT_NV              = 0x86E7
;static const uint  GL_OFFSET_TEXTURE_2D_NV          = 0x86E8
;static const uint  GL_DEPENDENT_AR_TEXTURE_2D_NV    = 0x86E9
;static const uint  GL_DEPENDENT_GB_TEXTURE_2D_NV    = 0x86EA
;static const uint  GL_DOT_PRODUCT_NV                = 0x86EC
;static const uint  GL_DOT_PRODUCT_DEPTH_REPLACE_NV  = 0x86ED
;static const uint  GL_DOT_PRODUCT_TEXTURE_2D_NV     = 0x86EE
;static const uint  GL_DOT_PRODUCT_TEXTURE_CUBE_MAP_NV= 0x86F0
;static const uint  GL_DOT_PRODUCT_DIFFUSE_CUBE_MAP_NV= 0x86F1
;static const uint  GL_DOT_PRODUCT_REFLECT_CUBE_MAP_NV= 0x86F2
;static const uint  GL_DOT_PRODUCT_CONST_EYE_REFLECT_CUBE_MAP_NV= 0x86F3
;static const uint  GL_HILO_NV                       = 0x86F4
;static const uint  GL_DSDT_NV                       = 0x86F5
;static const uint  GL_DSDT_MAG_NV                   = 0x86F6
;static const uint  GL_DSDT_MAG_VIB_NV               = 0x86F7
;static const uint  GL_HILO16_NV                     = 0x86F8
;static const uint  GL_SIGNED_HILO_NV                = 0x86F9
;static const uint  GL_SIGNED_HILO16_NV              = 0x86FA
;static const uint  GL_SIGNED_RGBA_NV                = 0x86FB
;static const uint  GL_SIGNED_RGBA8_NV               = 0x86FC
;static const uint  GL_SIGNED_RGB_NV                 = 0x86FE
;static const uint  GL_SIGNED_RGB8_NV                = 0x86FF
;static const uint  GL_SIGNED_LUMINANCE_NV           = 0x8701
;static const uint  GL_SIGNED_LUMINANCE8_NV          = 0x8702
;static const uint  GL_SIGNED_LUMINANCE_ALPHA_NV     = 0x8703
;static const uint  GL_SIGNED_LUMINANCE8_ALPHA8_NV   = 0x8704
;static const uint  GL_SIGNED_ALPHA_NV               = 0x8705
;static const uint  GL_SIGNED_ALPHA8_NV              = 0x8706
;static const uint  GL_SIGNED_INTENSITY_NV           = 0x8707
;static const uint  GL_SIGNED_INTENSITY8_NV          = 0x8708
;static const uint  GL_DSDT8_NV                      = 0x8709
;static const uint  GL_DSDT8_MAG8_NV                 = 0x870A
;static const uint  GL_DSDT8_MAG8_INTENSITY8_NV      = 0x870B
;static const uint  GL_SIGNED_RGB_UNSIGNED_ALPHA_NV  = 0x870C
;static const uint  GL_SIGNED_RGB8_UNSIGNED_ALPHA8_NV= 0x870D
;static const uint  GL_HI_SCALE_NV                   = 0x870E
;static const uint  GL_LO_SCALE_NV                   = 0x870F
;static const uint  GL_DS_SCALE_NV                   = 0x8710
;static const uint  GL_DT_SCALE_NV                   = 0x8711
;static const uint  GL_MAGNITUDE_SCALE_NV            = 0x8712
;static const uint  GL_VIBRANCE_SCALE_NV             = 0x8713
;static const uint  GL_HI_BIAS_NV                    = 0x8714
;static const uint  GL_LO_BIAS_NV                    = 0x8715
;static const uint  GL_DS_BIAS_NV                    = 0x8716
;static const uint  GL_DT_BIAS_NV                    = 0x8717
;static const uint  GL_MAGNITUDE_BIAS_NV             = 0x8718
;static const uint  GL_VIBRANCE_BIAS_NV              = 0x8719
;static const uint  GL_TEXTURE_BORDER_VALUES_NV      = 0x871A
;static const uint  GL_TEXTURE_HI_SIZE_NV            = 0x871B
;static const uint  GL_TEXTURE_LO_SIZE_NV            = 0x871C
;static const uint  GL_TEXTURE_DS_SIZE_NV            = 0x871D
;static const uint  GL_TEXTURE_DT_SIZE_NV            = 0x871E
;static const uint  GL_TEXTURE_MAG_SIZE_NV           = 0x871F


//#ifndef GL_NV_texture_shader2
;static const uint  GL_DOT_PRODUCT_TEXTURE_3D_NV     = 0x86EF


//#ifndef GL_NV_vertex_array_range2
;static const uint  GL_VERTEX_ARRAY_RANGE_WITHOUT_FLUSH_NV= 0x8533


//#ifndef GL_NV_vertex_program
;static const uint  GL_VERTEX_PROGRAM_NV             = 0x8620
;static const uint  GL_VERTEX_STATE_PROGRAM_NV       = 0x8621
;static const uint  GL_ATTRIB_ARRAY_SIZE_NV          = 0x8623
;static const uint  GL_ATTRIB_ARRAY_STRIDE_NV        = 0x8624
;static const uint  GL_ATTRIB_ARRAY_TYPE_NV          = 0x8625
;static const uint  GL_CURRENT_ATTRIB_NV             = 0x8626
;static const uint  GL_PROGRAM_LENGTH_NV             = 0x8627
;static const uint  GL_PROGRAM_STRING_NV             = 0x8628
;static const uint  GL_MODELVIEW_PROJECTION_NV       = 0x8629
;static const uint  GL_IDENTITY_NV                   = 0x862A
;static const uint  GL_INVERSE_NV                    = 0x862B
;static const uint  GL_TRANSPOSE_NV                  = 0x862C
;static const uint  GL_INVERSE_TRANSPOSE_NV          = 0x862D
;static const uint  GL_MAX_TRACK_MATRIX_STACK_DEPTH_NV= 0x862E
;static const uint  GL_MAX_TRACK_MATRICES_NV         = 0x862F
;static const uint  GL_MATRIX0_NV                    = 0x8630
;static const uint  GL_MATRIX1_NV                    = 0x8631
;static const uint  GL_MATRIX2_NV                    = 0x8632
;static const uint  GL_MATRIX3_NV                    = 0x8633
;static const uint  GL_MATRIX4_NV                    = 0x8634
;static const uint  GL_MATRIX5_NV                    = 0x8635
;static const uint  GL_MATRIX6_NV                    = 0x8636
;static const uint  GL_MATRIX7_NV                    = 0x8637
;static const uint  GL_CURRENT_MATRIX_STACK_DEPTH_NV = 0x8640
;static const uint  GL_CURRENT_MATRIX_NV             = 0x8641
;static const uint  GL_VERTEX_PROGRAM_POINT_SIZE_NV  = 0x8642
;static const uint  GL_VERTEX_PROGRAM_TWO_SIDE_NV    = 0x8643
;static const uint  GL_PROGRAM_PARAMETER_NV          = 0x8644
;static const uint  GL_ATTRIB_ARRAY_POINTER_NV       = 0x8645
;static const uint  GL_PROGRAM_TARGET_NV             = 0x8646
;static const uint  GL_PROGRAM_RESIDENT_NV           = 0x8647
;static const uint  GL_TRACK_MATRIX_NV               = 0x8648
;static const uint  GL_TRACK_MATRIX_TRANSFORM_NV     = 0x8649
;static const uint  GL_VERTEX_PROGRAM_BINDING_NV     = 0x864A
;static const uint  GL_PROGRAM_ERROR_POSITION_NV     = 0x864B
;static const uint  GL_VERTEX_ATTRIB_ARRAY0_NV       = 0x8650
;static const uint  GL_VERTEX_ATTRIB_ARRAY1_NV       = 0x8651
;static const uint  GL_VERTEX_ATTRIB_ARRAY2_NV       = 0x8652
;static const uint  GL_VERTEX_ATTRIB_ARRAY3_NV       = 0x8653
;static const uint  GL_VERTEX_ATTRIB_ARRAY4_NV       = 0x8654
;static const uint  GL_VERTEX_ATTRIB_ARRAY5_NV       = 0x8655
;static const uint  GL_VERTEX_ATTRIB_ARRAY6_NV       = 0x8656
;static const uint  GL_VERTEX_ATTRIB_ARRAY7_NV       = 0x8657
;static const uint  GL_VERTEX_ATTRIB_ARRAY8_NV       = 0x8658
;static const uint  GL_VERTEX_ATTRIB_ARRAY9_NV       = 0x8659
;static const uint  GL_VERTEX_ATTRIB_ARRAY10_NV      = 0x865A
;static const uint  GL_VERTEX_ATTRIB_ARRAY11_NV      = 0x865B
;static const uint  GL_VERTEX_ATTRIB_ARRAY12_NV      = 0x865C
;static const uint  GL_VERTEX_ATTRIB_ARRAY13_NV      = 0x865D
;static const uint  GL_VERTEX_ATTRIB_ARRAY14_NV      = 0x865E
;static const uint  GL_VERTEX_ATTRIB_ARRAY15_NV      = 0x865F
;static const uint  GL_MAP1_VERTEX_ATTRIB0_4_NV      = 0x8660
;static const uint  GL_MAP1_VERTEX_ATTRIB1_4_NV      = 0x8661
;static const uint  GL_MAP1_VERTEX_ATTRIB2_4_NV      = 0x8662
;static const uint  GL_MAP1_VERTEX_ATTRIB3_4_NV      = 0x8663
;static const uint  GL_MAP1_VERTEX_ATTRIB4_4_NV      = 0x8664
;static const uint  GL_MAP1_VERTEX_ATTRIB5_4_NV      = 0x8665
;static const uint  GL_MAP1_VERTEX_ATTRIB6_4_NV      = 0x8666
;static const uint  GL_MAP1_VERTEX_ATTRIB7_4_NV      = 0x8667
;static const uint  GL_MAP1_VERTEX_ATTRIB8_4_NV      = 0x8668
;static const uint  GL_MAP1_VERTEX_ATTRIB9_4_NV      = 0x8669
;static const uint  GL_MAP1_VERTEX_ATTRIB10_4_NV     = 0x866A
;static const uint  GL_MAP1_VERTEX_ATTRIB11_4_NV     = 0x866B
;static const uint  GL_MAP1_VERTEX_ATTRIB12_4_NV     = 0x866C
;static const uint  GL_MAP1_VERTEX_ATTRIB13_4_NV     = 0x866D
;static const uint  GL_MAP1_VERTEX_ATTRIB14_4_NV     = 0x866E
;static const uint  GL_MAP1_VERTEX_ATTRIB15_4_NV     = 0x866F
;static const uint  GL_MAP2_VERTEX_ATTRIB0_4_NV      = 0x8670
;static const uint  GL_MAP2_VERTEX_ATTRIB1_4_NV      = 0x8671
;static const uint  GL_MAP2_VERTEX_ATTRIB2_4_NV      = 0x8672
;static const uint  GL_MAP2_VERTEX_ATTRIB3_4_NV      = 0x8673
;static const uint  GL_MAP2_VERTEX_ATTRIB4_4_NV      = 0x8674
;static const uint  GL_MAP2_VERTEX_ATTRIB5_4_NV      = 0x8675
;static const uint  GL_MAP2_VERTEX_ATTRIB6_4_NV      = 0x8676
;static const uint  GL_MAP2_VERTEX_ATTRIB7_4_NV      = 0x8677
;static const uint  GL_MAP2_VERTEX_ATTRIB8_4_NV      = 0x8678
;static const uint  GL_MAP2_VERTEX_ATTRIB9_4_NV      = 0x8679
;static const uint  GL_MAP2_VERTEX_ATTRIB10_4_NV     = 0x867A
;static const uint  GL_MAP2_VERTEX_ATTRIB11_4_NV     = 0x867B
;static const uint  GL_MAP2_VERTEX_ATTRIB12_4_NV     = 0x867C
;static const uint  GL_MAP2_VERTEX_ATTRIB13_4_NV     = 0x867D
;static const uint  GL_MAP2_VERTEX_ATTRIB14_4_NV     = 0x867E
;static const uint  GL_MAP2_VERTEX_ATTRIB15_4_NV     = 0x867F


//#ifndef GL_SGIX_texture_coordinate_clamp
;static const uint  GL_TEXTURE_MAX_CLAMP_S_SGIX      = 0x8369
;static const uint  GL_TEXTURE_MAX_CLAMP_T_SGIX      = 0x836A
;static const uint  GL_TEXTURE_MAX_CLAMP_R_SGIX      = 0x836B


//#ifndef GL_SGIX_scalebias_hint
;static const uint  GL_SCALEBIAS_HINT_SGIX           = 0x8322


//#ifndef GL_OML_interlace
;static const uint  GL_INTERLACE_OML                 = 0x8980
;static const uint  GL_INTERLACE_READ_OML            = 0x8981


//#ifndef GL_OML_subsample
;static const uint  GL_FORMAT_SUBSAMPLE_24_24_OML    = 0x8982
;static const uint  GL_FORMAT_SUBSAMPLE_244_244_OML  = 0x8983


//#ifndef GL_OML_resample
;static const uint  GL_PACK_RESAMPLE_OML             = 0x8984
;static const uint  GL_UNPACK_RESAMPLE_OML           = 0x8985
;static const uint  GL_RESAMPLE_REPLICATE_OML        = 0x8986
;static const uint  GL_RESAMPLE_ZERO_FILL_OML        = 0x8987
;static const uint  GL_RESAMPLE_AVERAGE_OML          = 0x8988
;static const uint  GL_RESAMPLE_DECIMATE_OML         = 0x8989


//#ifndef GL_NV_copy_depth_to_color
;static const uint  GL_DEPTH_STENCIL_TO_RGBA_NV      = 0x886E
;static const uint  GL_DEPTH_STENCIL_TO_BGRA_NV      = 0x886F


//#ifndef GL_ATI_envmap_bumpmap
;static const uint  GL_BUMP_ROT_MATRIX_ATI           = 0x8775
;static const uint  GL_BUMP_ROT_MATRIX_SIZE_ATI      = 0x8776
;static const uint  GL_BUMP_NUM_TEX_UNITS_ATI        = 0x8777
;static const uint  GL_BUMP_TEX_UNITS_ATI            = 0x8778
;static const uint  GL_DUDV_ATI                      = 0x8779
;static const uint  GL_DU8DV8_ATI                    = 0x877A
;static const uint  GL_BUMP_ENVMAP_ATI               = 0x877B
;static const uint  GL_BUMP_TARGET_ATI               = 0x877C


//#ifndef GL_ATI_fragment_shader
;static const uint  GL_FRAGMENT_SHADER_ATI           = 0x8920
;static const uint  GL_REG_0_ATI                     = 0x8921
;static const uint  GL_REG_1_ATI                     = 0x8922
;static const uint  GL_REG_2_ATI                     = 0x8923
;static const uint  GL_REG_3_ATI                     = 0x8924
;static const uint  GL_REG_4_ATI                     = 0x8925
;static const uint  GL_REG_5_ATI                     = 0x8926
;static const uint  GL_REG_6_ATI                     = 0x8927
;static const uint  GL_REG_7_ATI                     = 0x8928
;static const uint  GL_REG_8_ATI                     = 0x8929
;static const uint  GL_REG_9_ATI                     = 0x892A
;static const uint  GL_REG_10_ATI                    = 0x892B
;static const uint  GL_REG_11_ATI                    = 0x892C
;static const uint  GL_REG_12_ATI                    = 0x892D
;static const uint  GL_REG_13_ATI                    = 0x892E
;static const uint  GL_REG_14_ATI                    = 0x892F
;static const uint  GL_REG_15_ATI                    = 0x8930
;static const uint  GL_REG_16_ATI                    = 0x8931
;static const uint  GL_REG_17_ATI                    = 0x8932
;static const uint  GL_REG_18_ATI                    = 0x8933
;static const uint  GL_REG_19_ATI                    = 0x8934
;static const uint  GL_REG_20_ATI                    = 0x8935
;static const uint  GL_REG_21_ATI                    = 0x8936
;static const uint  GL_REG_22_ATI                    = 0x8937
;static const uint  GL_REG_23_ATI                    = 0x8938
;static const uint  GL_REG_24_ATI                    = 0x8939
;static const uint  GL_REG_25_ATI                    = 0x893A
;static const uint  GL_REG_26_ATI                    = 0x893B
;static const uint  GL_REG_27_ATI                    = 0x893C
;static const uint  GL_REG_28_ATI                    = 0x893D
;static const uint  GL_REG_29_ATI                    = 0x893E
;static const uint  GL_REG_30_ATI                    = 0x893F
;static const uint  GL_REG_31_ATI                    = 0x8940
;static const uint  GL_CON_0_ATI                     = 0x8941
;static const uint  GL_CON_1_ATI                     = 0x8942
;static const uint  GL_CON_2_ATI                     = 0x8943
;static const uint  GL_CON_3_ATI                     = 0x8944
;static const uint  GL_CON_4_ATI                     = 0x8945
;static const uint  GL_CON_5_ATI                     = 0x8946
;static const uint  GL_CON_6_ATI                     = 0x8947
;static const uint  GL_CON_7_ATI                     = 0x8948
;static const uint  GL_CON_8_ATI                     = 0x8949
;static const uint  GL_CON_9_ATI                     = 0x894A
;static const uint  GL_CON_10_ATI                    = 0x894B
;static const uint  GL_CON_11_ATI                    = 0x894C
;static const uint  GL_CON_12_ATI                    = 0x894D
;static const uint  GL_CON_13_ATI                    = 0x894E
;static const uint  GL_CON_14_ATI                    = 0x894F
;static const uint  GL_CON_15_ATI                    = 0x8950
;static const uint  GL_CON_16_ATI                    = 0x8951
;static const uint  GL_CON_17_ATI                    = 0x8952
;static const uint  GL_CON_18_ATI                    = 0x8953
;static const uint  GL_CON_19_ATI                    = 0x8954
;static const uint  GL_CON_20_ATI                    = 0x8955
;static const uint  GL_CON_21_ATI                    = 0x8956
;static const uint  GL_CON_22_ATI                    = 0x8957
;static const uint  GL_CON_23_ATI                    = 0x8958
;static const uint  GL_CON_24_ATI                    = 0x8959
;static const uint  GL_CON_25_ATI                    = 0x895A
;static const uint  GL_CON_26_ATI                    = 0x895B
;static const uint  GL_CON_27_ATI                    = 0x895C
;static const uint  GL_CON_28_ATI                    = 0x895D
;static const uint  GL_CON_29_ATI                    = 0x895E
;static const uint  GL_CON_30_ATI                    = 0x895F
;static const uint  GL_CON_31_ATI                    = 0x8960
;static const uint  GL_MOV_ATI                       = 0x8961
;static const uint  GL_ADD_ATI                       = 0x8963
;static const uint  GL_MUL_ATI                       = 0x8964
;static const uint  GL_SUB_ATI                       = 0x8965
;static const uint  GL_DOT3_ATI                      = 0x8966
;static const uint  GL_DOT4_ATI                      = 0x8967
;static const uint  GL_MAD_ATI                       = 0x8968
;static const uint  GL_LERP_ATI                      = 0x8969
;static const uint  GL_CND_ATI                       = 0x896A
;static const uint  GL_CND0_ATI                      = 0x896B
;static const uint  GL_DOT2_ADD_ATI                  = 0x896C
;static const uint  GL_SECONDARY_INTERPOLATOR_ATI    = 0x896D
;static const uint  GL_NUM_FRAGMENT_REGISTERS_ATI    = 0x896E
;static const uint  GL_NUM_FRAGMENT_CONSTANTS_ATI    = 0x896F
;static const uint  GL_NUM_PASSES_ATI                = 0x8970
;static const uint  GL_NUM_INSTRUCTIONS_PER_PASS_ATI = 0x8971
;static const uint  GL_NUM_INSTRUCTIONS_TOTAL_ATI    = 0x8972
;static const uint  GL_NUM_INPUT_INTERPOLATOR_COMPONENTS_ATI= 0x8973
;static const uint  GL_NUM_LOOPBACK_COMPONENTS_ATI   = 0x8974
;static const uint  GL_COLOR_ALPHA_PAIRING_ATI       = 0x8975
;static const uint  GL_SWIZZLE_STR_ATI               = 0x8976
;static const uint  GL_SWIZZLE_STQ_ATI               = 0x8977
;static const uint  GL_SWIZZLE_STR_DR_ATI            = 0x8978
;static const uint  GL_SWIZZLE_STQ_DQ_ATI            = 0x8979
;static const uint  GL_SWIZZLE_STRQ_ATI              = 0x897A
;static const uint  GL_SWIZZLE_STRQ_DQ_ATI           = 0x897B
;static const uint  GL_RED_BIT_ATI                   = 0x00000001
;static const uint  GL_GREEN_BIT_ATI                 = 0x00000002
;static const uint  GL_BLUE_BIT_ATI                  = 0x00000004
;static const uint  GL_2X_BIT_ATI                    = 0x00000001
;static const uint  GL_4X_BIT_ATI                    = 0x00000002
;static const uint  GL_8X_BIT_ATI                    = 0x00000004
;static const uint  GL_HALF_BIT_ATI                  = 0x00000008
;static const uint  GL_QUARTER_BIT_ATI               = 0x00000010
;static const uint  GL_EIGHTH_BIT_ATI                = 0x00000020
;static const uint  GL_SATURATE_BIT_ATI              = 0x00000040
;static const uint  GL_COMP_BIT_ATI                  = 0x00000002
;static const uint  GL_NEGATE_BIT_ATI                = 0x00000004
;static const uint  GL_BIAS_BIT_ATI                  = 0x00000008


//#ifndef GL_ATI_pn_triangles
;static const uint  GL_PN_TRIANGLES_ATI              = 0x87F0
;static const uint  GL_MAX_PN_TRIANGLES_TESSELATION_LEVEL_ATI= 0x87F1
;static const uint  GL_PN_TRIANGLES_POINT_MODE_ATI   = 0x87F2
;static const uint  GL_PN_TRIANGLES_NORMAL_MODE_ATI  = 0x87F3
;static const uint  GL_PN_TRIANGLES_TESSELATION_LEVEL_ATI= 0x87F4
;static const uint  GL_PN_TRIANGLES_POINT_MODE_LINEAR_ATI= 0x87F5
;static const uint  GL_PN_TRIANGLES_POINT_MODE_CUBIC_ATI= 0x87F6
;static const uint  GL_PN_TRIANGLES_NORMAL_MODE_LINEAR_ATI= 0x87F7
;static const uint  GL_PN_TRIANGLES_NORMAL_MODE_QUADRATIC_ATI= 0x87F8


//#ifndef GL_ATI_vertex_array_object
;static const uint  GL_STATIC_ATI                    = 0x8760
;static const uint  GL_DYNAMIC_ATI                   = 0x8761
;static const uint  GL_PRESERVE_ATI                  = 0x8762
;static const uint  GL_DISCARD_ATI                   = 0x8763
;static const uint  GL_OBJECT_BUFFER_SIZE_ATI        = 0x8764
;static const uint  GL_OBJECT_BUFFER_USAGE_ATI       = 0x8765
;static const uint  GL_ARRAY_OBJECT_BUFFER_ATI       = 0x8766
;static const uint  GL_ARRAY_OBJECT_OFFSET_ATI       = 0x8767


//#ifndef GL_EXT_vertex_shader
;static const uint  GL_VERTEX_SHADER_EXT             = 0x8780
;static const uint  GL_VERTEX_SHADER_BINDING_EXT     = 0x8781
;static const uint  GL_OP_INDEX_EXT                  = 0x8782
;static const uint  GL_OP_NEGATE_EXT                 = 0x8783
;static const uint  GL_OP_DOT3_EXT                   = 0x8784
;static const uint  GL_OP_DOT4_EXT                   = 0x8785
;static const uint  GL_OP_MUL_EXT                    = 0x8786
;static const uint  GL_OP_ADD_EXT                    = 0x8787
;static const uint  GL_OP_MADD_EXT                   = 0x8788
;static const uint  GL_OP_FRAC_EXT                   = 0x8789
;static const uint  GL_OP_MAX_EXT                    = 0x878A
;static const uint  GL_OP_MIN_EXT                    = 0x878B
;static const uint  GL_OP_SET_GE_EXT                 = 0x878C
;static const uint  GL_OP_SET_LT_EXT                 = 0x878D
;static const uint  GL_OP_CLAMP_EXT                  = 0x878E
;static const uint  GL_OP_FLOOR_EXT                  = 0x878F
;static const uint  GL_OP_ROUND_EXT                  = 0x8790
;static const uint  GL_OP_EXP_BASE_2_EXT             = 0x8791
;static const uint  GL_OP_LOG_BASE_2_EXT             = 0x8792
;static const uint  GL_OP_POWER_EXT                  = 0x8793
;static const uint  GL_OP_RECIP_EXT                  = 0x8794
;static const uint  GL_OP_RECIP_SQRT_EXT             = 0x8795
;static const uint  GL_OP_SUB_EXT                    = 0x8796
;static const uint  GL_OP_CROSS_PRODUCT_EXT          = 0x8797
;static const uint  GL_OP_MULTIPLY_MATRIX_EXT        = 0x8798
;static const uint  GL_OP_MOV_EXT                    = 0x8799
;static const uint  GL_OUTPUT_VERTEX_EXT             = 0x879A
;static const uint  GL_OUTPUT_COLOR0_EXT             = 0x879B
;static const uint  GL_OUTPUT_COLOR1_EXT             = 0x879C
;static const uint  GL_OUTPUT_TEXTURE_COORD0_EXT     = 0x879D
;static const uint  GL_OUTPUT_TEXTURE_COORD1_EXT     = 0x879E
;static const uint  GL_OUTPUT_TEXTURE_COORD2_EXT     = 0x879F
;static const uint  GL_OUTPUT_TEXTURE_COORD3_EXT     = 0x87A0
;static const uint  GL_OUTPUT_TEXTURE_COORD4_EXT     = 0x87A1
;static const uint  GL_OUTPUT_TEXTURE_COORD5_EXT     = 0x87A2
;static const uint  GL_OUTPUT_TEXTURE_COORD6_EXT     = 0x87A3
;static const uint  GL_OUTPUT_TEXTURE_COORD7_EXT     = 0x87A4
;static const uint  GL_OUTPUT_TEXTURE_COORD8_EXT     = 0x87A5
;static const uint  GL_OUTPUT_TEXTURE_COORD9_EXT     = 0x87A6
;static const uint  GL_OUTPUT_TEXTURE_COORD10_EXT    = 0x87A7
;static const uint  GL_OUTPUT_TEXTURE_COORD11_EXT    = 0x87A8
;static const uint  GL_OUTPUT_TEXTURE_COORD12_EXT    = 0x87A9
;static const uint  GL_OUTPUT_TEXTURE_COORD13_EXT    = 0x87AA
;static const uint  GL_OUTPUT_TEXTURE_COORD14_EXT    = 0x87AB
;static const uint  GL_OUTPUT_TEXTURE_COORD15_EXT    = 0x87AC
;static const uint  GL_OUTPUT_TEXTURE_COORD16_EXT    = 0x87AD
;static const uint  GL_OUTPUT_TEXTURE_COORD17_EXT    = 0x87AE
;static const uint  GL_OUTPUT_TEXTURE_COORD18_EXT    = 0x87AF
;static const uint  GL_OUTPUT_TEXTURE_COORD19_EXT    = 0x87B0
;static const uint  GL_OUTPUT_TEXTURE_COORD20_EXT    = 0x87B1
;static const uint  GL_OUTPUT_TEXTURE_COORD21_EXT    = 0x87B2
;static const uint  GL_OUTPUT_TEXTURE_COORD22_EXT    = 0x87B3
;static const uint  GL_OUTPUT_TEXTURE_COORD23_EXT    = 0x87B4
;static const uint  GL_OUTPUT_TEXTURE_COORD24_EXT    = 0x87B5
;static const uint  GL_OUTPUT_TEXTURE_COORD25_EXT    = 0x87B6
;static const uint  GL_OUTPUT_TEXTURE_COORD26_EXT    = 0x87B7
;static const uint  GL_OUTPUT_TEXTURE_COORD27_EXT    = 0x87B8
;static const uint  GL_OUTPUT_TEXTURE_COORD28_EXT    = 0x87B9
;static const uint  GL_OUTPUT_TEXTURE_COORD29_EXT    = 0x87BA
;static const uint  GL_OUTPUT_TEXTURE_COORD30_EXT    = 0x87BB
;static const uint  GL_OUTPUT_TEXTURE_COORD31_EXT    = 0x87BC
;static const uint  GL_OUTPUT_FOG_EXT                = 0x87BD
;static const uint  GL_SCALAR_EXT                    = 0x87BE
;static const uint  GL_VECTOR_EXT                    = 0x87BF
;static const uint  GL_MATRIX_EXT                    = 0x87C0
;static const uint  GL_VARIANT_EXT                   = 0x87C1
;static const uint  GL_INVARIANT_EXT                 = 0x87C2
;static const uint  GL_LOCAL_CONSTANT_EXT            = 0x87C3
;static const uint  GL_LOCAL_EXT                     = 0x87C4
;static const uint  GL_MAX_VERTEX_SHADER_INSTRUCTIONS_EXT= 0x87C5
;static const uint  GL_MAX_VERTEX_SHADER_VARIANTS_EXT= 0x87C6
;static const uint  GL_MAX_VERTEX_SHADER_INVARIANTS_EXT= 0x87C7
;static const uint  GL_MAX_VERTEX_SHADER_LOCAL_CONSTANTS_EXT= 0x87C8
;static const uint  GL_MAX_VERTEX_SHADER_LOCALS_EXT  = 0x87C9
;static const uint  GL_MAX_OPTIMIZED_VERTEX_SHADER_INSTRUCTIONS_EXT= 0x87CA
;static const uint  GL_MAX_OPTIMIZED_VERTEX_SHADER_VARIANTS_EXT= 0x87CB
;static const uint  GL_MAX_OPTIMIZED_VERTEX_SHADER_LOCAL_CONSTANTS_EXT= 0x87CC
;static const uint  GL_MAX_OPTIMIZED_VERTEX_SHADER_INVARIANTS_EXT= 0x87CD
;static const uint  GL_MAX_OPTIMIZED_VERTEX_SHADER_LOCALS_EXT= 0x87CE
;static const uint  GL_VERTEX_SHADER_INSTRUCTIONS_EXT= 0x87CF
;static const uint  GL_VERTEX_SHADER_VARIANTS_EXT    = 0x87D0
;static const uint  GL_VERTEX_SHADER_INVARIANTS_EXT  = 0x87D1
;static const uint  GL_VERTEX_SHADER_LOCAL_CONSTANTS_EXT= 0x87D2
;static const uint  GL_VERTEX_SHADER_LOCALS_EXT      = 0x87D3
;static const uint  GL_VERTEX_SHADER_OPTIMIZED_EXT   = 0x87D4
;static const uint  GL_X_EXT                         = 0x87D5
;static const uint  GL_Y_EXT                         = 0x87D6
;static const uint  GL_Z_EXT                         = 0x87D7
;static const uint  GL_W_EXT                         = 0x87D8
;static const uint  GL_NEGATIVE_X_EXT                = 0x87D9
;static const uint  GL_NEGATIVE_Y_EXT                = 0x87DA
;static const uint  GL_NEGATIVE_Z_EXT                = 0x87DB
;static const uint  GL_NEGATIVE_W_EXT                = 0x87DC
;static const uint  GL_ZERO_EXT                      = 0x87DD
;static const uint  GL_ONE_EXT                       = 0x87DE
;static const uint  GL_NEGATIVE_ONE_EXT              = 0x87DF
;static const uint  GL_NORMALIZED_RANGE_EXT          = 0x87E0
;static const uint  GL_FULL_RANGE_EXT                = 0x87E1
;static const uint  GL_CURRENT_VERTEX_EXT            = 0x87E2
;static const uint  GL_MVP_MATRIX_EXT                = 0x87E3
;static const uint  GL_VARIANT_VALUE_EXT             = 0x87E4
;static const uint  GL_VARIANT_DATATYPE_EXT          = 0x87E5
;static const uint  GL_VARIANT_ARRAY_STRIDE_EXT      = 0x87E6
;static const uint  GL_VARIANT_ARRAY_TYPE_EXT        = 0x87E7
;static const uint  GL_VARIANT_ARRAY_EXT             = 0x87E8
;static const uint  GL_VARIANT_ARRAY_POINTER_EXT     = 0x87E9
;static const uint  GL_INVARIANT_VALUE_EXT           = 0x87EA
;static const uint  GL_INVARIANT_DATATYPE_EXT        = 0x87EB
;static const uint  GL_LOCAL_CONSTANT_VALUE_EXT      = 0x87EC
;static const uint  GL_LOCAL_CONSTANT_DATATYPE_EXT   = 0x87ED


//#ifndef GL_ATI_vertex_streams
;static const uint  GL_MAX_VERTEX_STREAMS_ATI        = 0x876B
;static const uint  GL_VERTEX_STREAM0_ATI            = 0x876C
;static const uint  GL_VERTEX_STREAM1_ATI            = 0x876D
;static const uint  GL_VERTEX_STREAM2_ATI            = 0x876E
;static const uint  GL_VERTEX_STREAM3_ATI            = 0x876F
;static const uint  GL_VERTEX_STREAM4_ATI            = 0x8770
;static const uint  GL_VERTEX_STREAM5_ATI            = 0x8771
;static const uint  GL_VERTEX_STREAM6_ATI            = 0x8772
;static const uint  GL_VERTEX_STREAM7_ATI            = 0x8773
;static const uint  GL_VERTEX_SOURCE_ATI             = 0x8774


//#ifndef GL_ATI_element_array
;static const uint  GL_ELEMENT_ARRAY_ATI             = 0x8768
;static const uint  GL_ELEMENT_ARRAY_TYPE_ATI        = 0x8769
;static const uint  GL_ELEMENT_ARRAY_POINTER_ATI     = 0x876A


//#ifndef GL_SUN_mesh_array
;static const uint  GL_QUAD_MESH_SUN                 = 0x8614
;static const uint  GL_TRIANGLE_MESH_SUN             = 0x8615


//#ifndef GL_SUN_slice_accum
;static const uint  GL_SLICE_ACCUM_SUN               = 0x85CC


//#ifndef GL_NV_multisample_filter_hint
;static const uint  GL_MULTISAMPLE_FILTER_HINT_NV    = 0x8534


//#ifndef GL_NV_depth_clamp
;static const uint  GL_DEPTH_CLAMP_NV                = 0x864F


//#ifndef GL_NV_occlusion_query
;static const uint  GL_PIXEL_COUNTER_BITS_NV         = 0x8864
;static const uint  GL_CURRENT_OCCLUSION_QUERY_ID_NV = 0x8865
;static const uint  GL_PIXEL_COUNT_NV                = 0x8866
;static const uint  GL_PIXEL_COUNT_AVAILABLE_NV      = 0x8867


//#ifndef GL_NV_point_sprite
;static const uint  GL_POINT_SPRITE_NV               = 0x8861
;static const uint  GL_COORD_REPLACE_NV              = 0x8862
;static const uint  GL_POINT_SPRITE_R_MODE_NV        = 0x8863


//#ifndef GL_NV_texture_shader3
;static const uint  GL_OFFSET_PROJECTIVE_TEXTURE_2D_NV= 0x8850
;static const uint  GL_OFFSET_PROJECTIVE_TEXTURE_2D_SCALE_NV= 0x8851
;static const uint  GL_OFFSET_PROJECTIVE_TEXTURE_RECTANGLE_NV= 0x8852
;static const uint  GL_OFFSET_PROJECTIVE_TEXTURE_RECTANGLE_SCALE_NV= 0x8853
;static const uint  GL_OFFSET_HILO_TEXTURE_2D_NV     = 0x8854
;static const uint  GL_OFFSET_HILO_TEXTURE_RECTANGLE_NV= 0x8855
;static const uint  GL_OFFSET_HILO_PROJECTIVE_TEXTURE_2D_NV= 0x8856
;static const uint  GL_OFFSET_HILO_PROJECTIVE_TEXTURE_RECTANGLE_NV= 0x8857
;static const uint  GL_DEPENDENT_HILO_TEXTURE_2D_NV  = 0x8858
;static const uint  GL_DEPENDENT_RGB_TEXTURE_3D_NV   = 0x8859
;static const uint  GL_DEPENDENT_RGB_TEXTURE_CUBE_MAP_NV= 0x885A
;static const uint  GL_DOT_PRODUCT_PASS_THROUGH_NV   = 0x885B
;static const uint  GL_DOT_PRODUCT_TEXTURE_1D_NV     = 0x885C
;static const uint  GL_DOT_PRODUCT_AFFINE_DEPTH_REPLACE_NV= 0x885D
;static const uint  GL_HILO8_NV                      = 0x885E
;static const uint  GL_SIGNED_HILO8_NV               = 0x885F
;static const uint  GL_FORCE_BLUE_TO_ONE_NV          = 0x8860


//#ifndef GL_NV_vertex_program1_1


//#ifndef GL_EXT_shadow_funcs


//#ifndef GL_EXT_stencil_two_side
;static const uint  GL_STENCIL_TEST_TWO_SIDE_EXT     = 0x8910
;static const uint  GL_ACTIVE_STENCIL_FACE_EXT       = 0x8911


//#ifndef GL_ATI_text_fragment_shader
;static const uint  GL_TEXT_FRAGMENT_SHADER_ATI      = 0x8200


//#ifndef GL_APPLE_client_storage
;static const uint  GL_UNPACK_CLIENT_STORAGE_APPLE   = 0x85B2


//#ifndef GL_APPLE_element_array
;static const uint  GL_ELEMENT_ARRAY_APPLE           = 0x8A0C
;static const uint  GL_ELEMENT_ARRAY_TYPE_APPLE      = 0x8A0D
;static const uint  GL_ELEMENT_ARRAY_POINTER_APPLE   = 0x8A0E


//#ifndef GL_APPLE_fence
;static const uint  GL_DRAW_PIXELS_APPLE             = 0x8A0A
;static const uint  GL_FENCE_APPLE                   = 0x8A0B


//#ifndef GL_APPLE_vertex_array_object
;static const uint  GL_VERTEX_ARRAY_BINDING_APPLE    = 0x85B5


//#ifndef GL_APPLE_vertex_array_range
;static const uint  GL_VERTEX_ARRAY_RANGE_APPLE      = 0x851D
;static const uint  GL_VERTEX_ARRAY_RANGE_LENGTH_APPLE= 0x851E
;static const uint  GL_VERTEX_ARRAY_STORAGE_HINT_APPLE= 0x851F
;static const uint  GL_VERTEX_ARRAY_RANGE_POINTER_APPLE= 0x8521
;static const uint  GL_STORAGE_CLIENT_APPLE          = 0x85B4
;static const uint  GL_STORAGE_CACHED_APPLE          = 0x85BE
;static const uint  GL_STORAGE_SHARED_APPLE          = 0x85BF


//#ifndef GL_APPLE_ycbcr_422
;static const uint  GL_YCBCR_422_APPLE               = 0x85B9
;static const uint  GL_UNSIGNED_SHORT_8_8_APPLE      = 0x85BA
;static const uint  GL_UNSIGNED_SHORT_8_8_REV_APPLE  = 0x85BB


//#ifndef GL_S3_s3tc
;static const uint  GL_RGB_S3TC                      = 0x83A0
;static const uint  GL_RGB4_S3TC                     = 0x83A1
;static const uint  GL_RGBA_S3TC                     = 0x83A2
;static const uint  GL_RGBA4_S3TC                    = 0x83A3
;static const uint  GL_RGBA_DXT5_S3TC                = 0x83A4
;static const uint  GL_RGBA4_DXT5_S3TC               = 0x83A5


//#ifndef GL_ATI_draw_buffers
;static const uint  GL_MAX_DRAW_BUFFERS_ATI          = 0x8824
;static const uint  GL_DRAW_BUFFER0_ATI              = 0x8825
;static const uint  GL_DRAW_BUFFER1_ATI              = 0x8826
;static const uint  GL_DRAW_BUFFER2_ATI              = 0x8827
;static const uint  GL_DRAW_BUFFER3_ATI              = 0x8828
;static const uint  GL_DRAW_BUFFER4_ATI              = 0x8829
;static const uint  GL_DRAW_BUFFER5_ATI              = 0x882A
;static const uint  GL_DRAW_BUFFER6_ATI              = 0x882B
;static const uint  GL_DRAW_BUFFER7_ATI              = 0x882C
;static const uint  GL_DRAW_BUFFER8_ATI              = 0x882D
;static const uint  GL_DRAW_BUFFER9_ATI              = 0x882E
;static const uint  GL_DRAW_BUFFER10_ATI             = 0x882F
;static const uint  GL_DRAW_BUFFER11_ATI             = 0x8830
;static const uint  GL_DRAW_BUFFER12_ATI             = 0x8831
;static const uint  GL_DRAW_BUFFER13_ATI             = 0x8832
;static const uint  GL_DRAW_BUFFER14_ATI             = 0x8833
;static const uint  GL_DRAW_BUFFER15_ATI             = 0x8834


//#ifndef GL_ATI_pixel_format_float
;static const uint  GL_RGBA_FLOAT_MODE_ATI           = 0x8820
;static const uint  GL_COLOR_CLEAR_UNCLAMPED_VALUE_ATI= 0x8835


//#ifndef GL_ATI_texture_env_combine3
;static const uint  GL_MODULATE_ADD_ATI              = 0x8744
;static const uint  GL_MODULATE_SIGNED_ADD_ATI       = 0x8745
;static const uint  GL_MODULATE_SUBTRACT_ATI         = 0x8746


//#ifndef GL_ATI_texture_float
;static const uint  GL_RGBA_FLOAT32_ATI              = 0x8814
;static const uint  GL_RGB_FLOAT32_ATI               = 0x8815
;static const uint  GL_ALPHA_FLOAT32_ATI             = 0x8816
;static const uint  GL_INTENSITY_FLOAT32_ATI         = 0x8817
;static const uint  GL_LUMINANCE_FLOAT32_ATI         = 0x8818
;static const uint  GL_LUMINANCE_ALPHA_FLOAT32_ATI   = 0x8819
;static const uint  GL_RGBA_FLOAT16_ATI              = 0x881A
;static const uint  GL_RGB_FLOAT16_ATI               = 0x881B
;static const uint  GL_ALPHA_FLOAT16_ATI             = 0x881C
;static const uint  GL_INTENSITY_FLOAT16_ATI         = 0x881D
;static const uint  GL_LUMINANCE_FLOAT16_ATI         = 0x881E
;static const uint  GL_LUMINANCE_ALPHA_FLOAT16_ATI   = 0x881F


//#ifndef GL_NV_float_buffer
;static const uint  GL_FLOAT_R_NV                    = 0x8880
;static const uint  GL_FLOAT_RG_NV                   = 0x8881
;static const uint  GL_FLOAT_RGB_NV                  = 0x8882
;static const uint  GL_FLOAT_RGBA_NV                 = 0x8883
;static const uint  GL_FLOAT_R16_NV                  = 0x8884
;static const uint  GL_FLOAT_R32_NV                  = 0x8885
;static const uint  GL_FLOAT_RG16_NV                 = 0x8886
;static const uint  GL_FLOAT_RG32_NV                 = 0x8887
;static const uint  GL_FLOAT_RGB16_NV                = 0x8888
;static const uint  GL_FLOAT_RGB32_NV                = 0x8889
;static const uint  GL_FLOAT_RGBA16_NV               = 0x888A
;static const uint  GL_FLOAT_RGBA32_NV               = 0x888B
;static const uint  GL_TEXTURE_FLOAT_COMPONENTS_NV   = 0x888C
;static const uint  GL_FLOAT_CLEAR_COLOR_VALUE_NV    = 0x888D
;static const uint  GL_FLOAT_RGBA_MODE_NV            = 0x888E


//#ifndef GL_NV_fragment_program
;static const uint  GL_MAX_FRAGMENT_PROGRAM_LOCAL_PARAMETERS_NV= 0x8868
;static const uint  GL_FRAGMENT_PROGRAM_NV           = 0x8870
;static const uint  GL_MAX_TEXTURE_COORDS_NV         = 0x8871
;static const uint  GL_MAX_TEXTURE_IMAGE_UNITS_NV    = 0x8872
;static const uint  GL_FRAGMENT_PROGRAM_BINDING_NV   = 0x8873
;static const uint  GL_PROGRAM_ERROR_STRING_NV       = 0x8874


//#ifndef GL_NV_half_float
;static const uint  GL_HALF_FLOAT_NV                 = 0x140B


//#ifndef GL_NV_pixel_data_range
;static const uint  GL_WRITE_PIXEL_DATA_RANGE_NV     = 0x8878
;static const uint  GL_READ_PIXEL_DATA_RANGE_NV      = 0x8879
;static const uint  GL_WRITE_PIXEL_DATA_RANGE_LENGTH_NV= 0x887A
;static const uint  GL_READ_PIXEL_DATA_RANGE_LENGTH_NV= 0x887B
;static const uint  GL_WRITE_PIXEL_DATA_RANGE_POINTER_NV= 0x887C
;static const uint  GL_READ_PIXEL_DATA_RANGE_POINTER_NV= 0x887D


//#ifndef GL_NV_primitive_restart
;static const uint  GL_PRIMITIVE_RESTART_NV          = 0x8558
;static const uint  GL_PRIMITIVE_RESTART_INDEX_NV    = 0x8559


//#ifndef GL_NV_texture_expand_normal
;static const uint  GL_TEXTURE_UNSIGNED_REMAP_MODE_NV= 0x888F


//#ifndef GL_NV_vertex_program2


//#ifndef GL_ATI_map_object_buffer


//#ifndef GL_ATI_separate_stencil
;static const uint  GL_STENCIL_BACK_FUNC_ATI         = 0x8800
;static const uint  GL_STENCIL_BACK_FAIL_ATI         = 0x8801
;static const uint  GL_STENCIL_BACK_PASS_DEPTH_FAIL_ATI= 0x8802
;static const uint  GL_STENCIL_BACK_PASS_DEPTH_PASS_ATI= 0x8803


//#ifndef GL_ATI_vertex_attrib_array_object


//#ifndef GL_OES_byte_coordinates


//#ifndef GL_OES_fixed_point
;static const uint  GL_FIXED_OES                     = 0x140C


//#ifndef GL_OES_single_precision


//#ifndef GL_OES_compressed_paletted_texture
;static const uint  GL_PALETTE4_RGB8_OES             = 0x8B90
;static const uint  GL_PALETTE4_RGBA8_OES            = 0x8B91
;static const uint  GL_PALETTE4_R5_G6_B5_OES         = 0x8B92
;static const uint  GL_PALETTE4_RGBA4_OES            = 0x8B93
;static const uint  GL_PALETTE4_RGB5_A1_OES          = 0x8B94
;static const uint  GL_PALETTE8_RGB8_OES             = 0x8B95
;static const uint  GL_PALETTE8_RGBA8_OES            = 0x8B96
;static const uint  GL_PALETTE8_R5_G6_B5_OES         = 0x8B97
;static const uint  GL_PALETTE8_RGBA4_OES            = 0x8B98
;static const uint  GL_PALETTE8_RGB5_A1_OES          = 0x8B99


//#ifndef GL_OES_read_format
;static const uint  GL_IMPLEMENTATION_COLOR_READ_TYPE_OES= 0x8B9A
;static const uint  GL_IMPLEMENTATION_COLOR_READ_FORMAT_OES= 0x8B9B


//#ifndef GL_OES_query_matrix


//#ifndef GL_EXT_depth_bounds_test
;static const uint  GL_DEPTH_BOUNDS_TEST_EXT         = 0x8890
;static const uint  GL_DEPTH_BOUNDS_EXT              = 0x8891


//#ifndef GL_EXT_texture_mirror_clamp
;static const uint  GL_MIRROR_CLAMP_EXT              = 0x8742
;static const uint  GL_MIRROR_CLAMP_TO_EDGE_EXT      = 0x8743
;static const uint  GL_MIRROR_CLAMP_TO_BORDER_EXT    = 0x8912


//#ifndef GL_EXT_blend_equation_separate
;static const uint  GL_BLEND_EQUATION_RGB_EXT        = 0x8009
;static const uint  GL_BLEND_EQUATION_ALPHA_EXT      = 0x883D


//#ifndef GL_MESA_pack_invert
;static const uint  GL_PACK_INVERT_MESA              = 0x8758


//#ifndef GL_MESA_ycbcr_texture
;static const uint  GL_UNSIGNED_SHORT_8_8_MESA       = 0x85BA
;static const uint  GL_UNSIGNED_SHORT_8_8_REV_MESA   = 0x85BB
;static const uint  GL_YCBCR_MESA                    = 0x8757


//#ifndef GL_EXT_pixel_buffer_object
;static const uint  GL_PIXEL_PACK_BUFFER_EXT         = 0x88EB
;static const uint  GL_PIXEL_UNPACK_BUFFER_EXT       = 0x88EC
;static const uint  GL_PIXEL_PACK_BUFFER_BINDING_EXT = 0x88ED
;static const uint  GL_PIXEL_UNPACK_BUFFER_BINDING_EXT= 0x88EF


//#ifndef GL_NV_fragment_program_option


//#ifndef GL_NV_fragment_program2
;static const uint  GL_MAX_PROGRAM_EXEC_INSTRUCTIONS_NV= 0x88F4
;static const uint  GL_MAX_PROGRAM_CALL_DEPTH_NV     = 0x88F5
;static const uint  GL_MAX_PROGRAM_IF_DEPTH_NV       = 0x88F6
;static const uint  GL_MAX_PROGRAM_LOOP_DEPTH_NV     = 0x88F7
;static const uint  GL_MAX_PROGRAM_LOOP_COUNT_NV     = 0x88F8


//#ifndef GL_NV_vertex_program2_option
/* reuse GL_MAX_PROGRAM_EXEC_INSTRUCTIONS_NV */
/* reuse GL_MAX_PROGRAM_CALL_DEPTH_NV */


//#ifndef GL_NV_vertex_program3
/* reuse GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS_ARB */


//#ifndef GL_EXT_framebuffer_object
;static const uint  GL_INVALID_FRAMEBUFFER_OPERATION_EXT= 0x0506
;static const uint  GL_MAX_RENDERBUFFER_SIZE_EXT     = 0x84E8
;static const uint  GL_FRAMEBUFFER_BINDING_EXT       = 0x8CA6
;static const uint  GL_RENDERBUFFER_BINDING_EXT      = 0x8CA7
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE_EXT= 0x8CD0
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT= 0x8CD1
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_EXT= 0x8CD2
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE_EXT= 0x8CD3
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_3D_ZOFFSET_EXT= 0x8CD4
;static const uint  GL_FRAMEBUFFER_COMPLETE_EXT      = 0x8CD5
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT= 0x8CD6
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT= 0x8CD7
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT= 0x8CD9
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT= 0x8CDA
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT= 0x8CDB
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT= 0x8CDC
;static const uint  GL_FRAMEBUFFER_UNSUPPORTED_EXT   = 0x8CDD
;static const uint  GL_MAX_COLOR_ATTACHMENTS_EXT     = 0x8CDF
;static const uint  GL_COLOR_ATTACHMENT0_EXT         = 0x8CE0
;static const uint  GL_COLOR_ATTACHMENT1_EXT         = 0x8CE1
;static const uint  GL_COLOR_ATTACHMENT2_EXT         = 0x8CE2
;static const uint  GL_COLOR_ATTACHMENT3_EXT         = 0x8CE3
;static const uint  GL_COLOR_ATTACHMENT4_EXT         = 0x8CE4
;static const uint  GL_COLOR_ATTACHMENT5_EXT         = 0x8CE5
;static const uint  GL_COLOR_ATTACHMENT6_EXT         = 0x8CE6
;static const uint  GL_COLOR_ATTACHMENT7_EXT         = 0x8CE7
;static const uint  GL_COLOR_ATTACHMENT8_EXT         = 0x8CE8
;static const uint  GL_COLOR_ATTACHMENT9_EXT         = 0x8CE9
;static const uint  GL_COLOR_ATTACHMENT10_EXT        = 0x8CEA
;static const uint  GL_COLOR_ATTACHMENT11_EXT        = 0x8CEB
;static const uint  GL_COLOR_ATTACHMENT12_EXT        = 0x8CEC
;static const uint  GL_COLOR_ATTACHMENT13_EXT        = 0x8CED
;static const uint  GL_COLOR_ATTACHMENT14_EXT        = 0x8CEE
;static const uint  GL_COLOR_ATTACHMENT15_EXT        = 0x8CEF
;static const uint  GL_DEPTH_ATTACHMENT_EXT          = 0x8D00
;static const uint  GL_STENCIL_ATTACHMENT_EXT        = 0x8D20
;static const uint  GL_FRAMEBUFFER_EXT               = 0x8D40
;static const uint  GL_RENDERBUFFER_EXT              = 0x8D41
;static const uint  GL_RENDERBUFFER_WIDTH_EXT        = 0x8D42
;static const uint  GL_RENDERBUFFER_HEIGHT_EXT       = 0x8D43
;static const uint  GL_RENDERBUFFER_INTERNAL_FORMAT_EXT= 0x8D44
;static const uint  GL_STENCIL_INDEX1_EXT            = 0x8D46
;static const uint  GL_STENCIL_INDEX4_EXT            = 0x8D47
;static const uint  GL_STENCIL_INDEX8_EXT            = 0x8D48
;static const uint  GL_STENCIL_INDEX16_EXT           = 0x8D49
;static const uint  GL_RENDERBUFFER_RED_SIZE_EXT     = 0x8D50
;static const uint  GL_RENDERBUFFER_GREEN_SIZE_EXT   = 0x8D51
;static const uint  GL_RENDERBUFFER_BLUE_SIZE_EXT    = 0x8D52
;static const uint  GL_RENDERBUFFER_ALPHA_SIZE_EXT   = 0x8D53
;static const uint  GL_RENDERBUFFER_DEPTH_SIZE_EXT   = 0x8D54
;static const uint  GL_RENDERBUFFER_STENCIL_SIZE_EXT = 0x8D55


//#ifndef GL_GREMEDY_string_marker


//#ifndef GL_EXT_packed_depth_stencil
;static const uint  GL_DEPTH_STENCIL_EXT             = 0x84F9
;static const uint  GL_UNSIGNED_INT_24_8_EXT         = 0x84FA
;static const uint  GL_DEPTH24_STENCIL8_EXT          = 0x88F0
;static const uint  GL_TEXTURE_STENCIL_SIZE_EXT      = 0x88F1


//#ifndef GL_EXT_stencil_clear_tag
;static const uint  GL_STENCIL_TAG_BITS_EXT          = 0x88F2
;static const uint  GL_STENCIL_CLEAR_TAG_VALUE_EXT   = 0x88F3


//#ifndef GL_EXT_texture_sRGB
;static const uint  GL_SRGB_EXT                      = 0x8C40
;static const uint  GL_SRGB8_EXT                     = 0x8C41
;static const uint  GL_SRGB_ALPHA_EXT                = 0x8C42
;static const uint  GL_SRGB8_ALPHA8_EXT              = 0x8C43
;static const uint  GL_SLUMINANCE_ALPHA_EXT          = 0x8C44
;static const uint  GL_SLUMINANCE8_ALPHA8_EXT        = 0x8C45
;static const uint  GL_SLUMINANCE_EXT                = 0x8C46
;static const uint  GL_SLUMINANCE8_EXT               = 0x8C47
;static const uint  GL_COMPRESSED_SRGB_EXT           = 0x8C48
;static const uint  GL_COMPRESSED_SRGB_ALPHA_EXT     = 0x8C49
;static const uint  GL_COMPRESSED_SLUMINANCE_EXT     = 0x8C4A
;static const uint  GL_COMPRESSED_SLUMINANCE_ALPHA_EXT= 0x8C4B
;static const uint  GL_COMPRESSED_SRGB_S3TC_DXT1_EXT = 0x8C4C
;static const uint  GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT1_EXT= 0x8C4D
;static const uint  GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT= 0x8C4E
;static const uint  GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT= 0x8C4F


//#ifndef GL_EXT_framebuffer_blit
;static const uint  GL_READ_FRAMEBUFFER_EXT          = 0x8CA8
;static const uint  GL_DRAW_FRAMEBUFFER_EXT          = 0x8CA9
;static const uint  GL_DRAW_FRAMEBUFFER_BINDING_EXT  = 0x8CA6
;static const uint  GL_READ_FRAMEBUFFER_BINDING_EXT  = 0x8CAA


//#ifndef GL_EXT_framebuffer_multisample
;static const uint  GL_RENDERBUFFER_SAMPLES_EXT      = 0x8CAB
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_EXT= 0x8D56
;static const uint  GL_MAX_SAMPLES_EXT               = 0x8D57


//#ifndef GL_MESAX_texture_stack
;static const uint  GL_TEXTURE_1D_STACK_MESAX        = 0x8759
;static const uint  GL_TEXTURE_2D_STACK_MESAX        = 0x875A
;static const uint  GL_PROXY_TEXTURE_1D_STACK_MESAX  = 0x875B
;static const uint  GL_PROXY_TEXTURE_2D_STACK_MESAX  = 0x875C
;static const uint  GL_TEXTURE_1D_STACK_BINDING_MESAX= 0x875D
;static const uint  GL_TEXTURE_2D_STACK_BINDING_MESAX= 0x875E


//#ifndef GL_EXT_timer_query
;static const uint  GL_TIME_ELAPSED_EXT              = 0x88BF


//#ifndef GL_EXT_gpu_program_parameters


//#ifndef GL_APPLE_flush_buffer_range
;static const uint  GL_BUFFER_SERIALIZED_MODIFY_APPLE= 0x8A12
;static const uint  GL_BUFFER_FLUSHING_UNMAP_APPLE   = 0x8A13


//#ifndef GL_NV_gpu_program4
;static const uint  GL_MIN_PROGRAM_TEXEL_OFFSET_NV   = 0x8904
;static const uint  GL_MAX_PROGRAM_TEXEL_OFFSET_NV   = 0x8905
;static const uint  GL_PROGRAM_ATTRIB_COMPONENTS_NV  = 0x8906
;static const uint  GL_PROGRAM_RESULT_COMPONENTS_NV  = 0x8907
;static const uint  GL_MAX_PROGRAM_ATTRIB_COMPONENTS_NV= 0x8908
;static const uint  GL_MAX_PROGRAM_RESULT_COMPONENTS_NV= 0x8909
;static const uint  GL_MAX_PROGRAM_GENERIC_ATTRIBS_NV= 0x8DA5
;static const uint  GL_MAX_PROGRAM_GENERIC_RESULTS_NV= 0x8DA6


//#ifndef GL_NV_geometry_program4
;static const uint  GL_LINES_ADJACENCY_EXT           = 0x000A
;static const uint  GL_LINE_STRIP_ADJACENCY_EXT      = 0x000B
;static const uint  GL_TRIANGLES_ADJACENCY_EXT       = 0x000C
;static const uint  GL_TRIANGLE_STRIP_ADJACENCY_EXT  = 0x000D
;static const uint  GL_GEOMETRY_PROGRAM_NV           = 0x8C26
;static const uint  GL_MAX_PROGRAM_OUTPUT_VERTICES_NV= 0x8C27
;static const uint  GL_MAX_PROGRAM_TOTAL_OUTPUT_COMPONENTS_NV= 0x8C28
;static const uint  GL_GEOMETRY_VERTICES_OUT_EXT     = 0x8DDA
;static const uint  GL_GEOMETRY_INPUT_TYPE_EXT       = 0x8DDB
;static const uint  GL_GEOMETRY_OUTPUT_TYPE_EXT      = 0x8DDC
;static const uint  GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_EXT= 0x8C29
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_LAYERED_EXT= 0x8DA7
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_EXT= 0x8DA8
;static const uint  GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_EXT= 0x8DA9
;static const uint  GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT= 0x8CD4
;static const uint  GL_PROGRAM_POINT_SIZE_EXT        = 0x8642


//#ifndef GL_EXT_geometry_shader4
;static const uint  GL_GEOMETRY_SHADER_EXT           = 0x8DD9
/* reuse GL_GEOMETRY_VERTICES_OUT_EXT */
/* reuse GL_GEOMETRY_INPUT_TYPE_EXT */
/* reuse GL_GEOMETRY_OUTPUT_TYPE_EXT */
/* reuse GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_EXT */
;static const uint  GL_MAX_GEOMETRY_VARYING_COMPONENTS_EXT= 0x8DDD
;static const uint  GL_MAX_VERTEX_VARYING_COMPONENTS_EXT= 0x8DDE
;static const uint  GL_MAX_VARYING_COMPONENTS_EXT    = 0x8B4B
;static const uint  GL_MAX_GEOMETRY_UNIFORM_COMPONENTS_EXT= 0x8DDF
;static const uint  GL_MAX_GEOMETRY_OUTPUT_VERTICES_EXT= 0x8DE0
;static const uint  GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS_EXT= 0x8DE1
/* reuse GL_LINES_ADJACENCY_EXT */
/* reuse GL_LINE_STRIP_ADJACENCY_EXT */
/* reuse GL_TRIANGLES_ADJACENCY_EXT */
/* reuse GL_TRIANGLE_STRIP_ADJACENCY_EXT */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_EXT */
/* reuse GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_EXT */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_LAYERED_EXT */
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT */
/* reuse GL_PROGRAM_POINT_SIZE_EXT */


//#ifndef GL_NV_vertex_program4
;static const uint  GL_VERTEX_ATTRIB_ARRAY_INTEGER_NV= 0x88FD


//#ifndef GL_EXT_gpu_shader4
;static const uint  GL_SAMPLER_1D_ARRAY_EXT          = 0x8DC0
;static const uint  GL_SAMPLER_2D_ARRAY_EXT          = 0x8DC1
;static const uint  GL_SAMPLER_BUFFER_EXT            = 0x8DC2
;static const uint  GL_SAMPLER_1D_ARRAY_SHADOW_EXT   = 0x8DC3
;static const uint  GL_SAMPLER_2D_ARRAY_SHADOW_EXT   = 0x8DC4
;static const uint  GL_SAMPLER_CUBE_SHADOW_EXT       = 0x8DC5
;static const uint  GL_UNSIGNED_INT_VEC2_EXT         = 0x8DC6
;static const uint  GL_UNSIGNED_INT_VEC3_EXT         = 0x8DC7
;static const uint  GL_UNSIGNED_INT_VEC4_EXT         = 0x8DC8
;static const uint  GL_INT_SAMPLER_1D_EXT            = 0x8DC9
;static const uint  GL_INT_SAMPLER_2D_EXT            = 0x8DCA
;static const uint  GL_INT_SAMPLER_3D_EXT            = 0x8DCB
;static const uint  GL_INT_SAMPLER_CUBE_EXT          = 0x8DCC
;static const uint  GL_INT_SAMPLER_2D_RECT_EXT       = 0x8DCD
;static const uint  GL_INT_SAMPLER_1D_ARRAY_EXT      = 0x8DCE
;static const uint  GL_INT_SAMPLER_2D_ARRAY_EXT      = 0x8DCF
;static const uint  GL_INT_SAMPLER_BUFFER_EXT        = 0x8DD0
;static const uint  GL_UNSIGNED_INT_SAMPLER_1D_EXT   = 0x8DD1
;static const uint  GL_UNSIGNED_INT_SAMPLER_2D_EXT   = 0x8DD2
;static const uint  GL_UNSIGNED_INT_SAMPLER_3D_EXT   = 0x8DD3
;static const uint  GL_UNSIGNED_INT_SAMPLER_CUBE_EXT = 0x8DD4
;static const uint  GL_UNSIGNED_INT_SAMPLER_2D_RECT_EXT= 0x8DD5
;static const uint  GL_UNSIGNED_INT_SAMPLER_1D_ARRAY_EXT= 0x8DD6
;static const uint  GL_UNSIGNED_INT_SAMPLER_2D_ARRAY_EXT= 0x8DD7
;static const uint  GL_UNSIGNED_INT_SAMPLER_BUFFER_EXT= 0x8DD8


//#ifndef GL_EXT_draw_instanced


//#ifndef GL_EXT_packed_float
;static const uint  GL_R11F_G11F_B10F_EXT            = 0x8C3A
;static const uint  GL_UNSIGNED_INT_10F_11F_11F_REV_EXT= 0x8C3B
;static const uint  GL_RGBA_SIGNED_COMPONENTS_EXT    = 0x8C3C


//#ifndef GL_EXT_texture_array
;static const uint  GL_TEXTURE_1D_ARRAY_EXT          = 0x8C18
;static const uint  GL_PROXY_TEXTURE_1D_ARRAY_EXT    = 0x8C19
;static const uint  GL_TEXTURE_2D_ARRAY_EXT          = 0x8C1A
;static const uint  GL_PROXY_TEXTURE_2D_ARRAY_EXT    = 0x8C1B
;static const uint  GL_TEXTURE_BINDING_1D_ARRAY_EXT  = 0x8C1C
;static const uint  GL_TEXTURE_BINDING_2D_ARRAY_EXT  = 0x8C1D
;static const uint  GL_MAX_ARRAY_TEXTURE_LAYERS_EXT  = 0x88FF
;static const uint  GL_COMPARE_REF_DEPTH_TO_TEXTURE_EXT= 0x884E
/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT */


//#ifndef GL_EXT_texture_buffer_object
;static const uint  GL_TEXTURE_BUFFER_EXT            = 0x8C2A
;static const uint  GL_MAX_TEXTURE_BUFFER_SIZE_EXT   = 0x8C2B
;static const uint  GL_TEXTURE_BINDING_BUFFER_EXT    = 0x8C2C
;static const uint  GL_TEXTURE_BUFFER_DATA_STORE_BINDING_EXT= 0x8C2D
;static const uint  GL_TEXTURE_BUFFER_FORMAT_EXT     = 0x8C2E


//#ifndef GL_EXT_texture_compression_latc
;static const uint  GL_COMPRESSED_LUMINANCE_LATC1_EXT= 0x8C70
;static const uint  GL_COMPRESSED_SIGNED_LUMINANCE_LATC1_EXT= 0x8C71
;static const uint  GL_COMPRESSED_LUMINANCE_ALPHA_LATC2_EXT= 0x8C72
;static const uint  GL_COMPRESSED_SIGNED_LUMINANCE_ALPHA_LATC2_EXT= 0x8C73


//#ifndef GL_EXT_texture_compression_rgtc
;static const uint  GL_COMPRESSED_RED_RGTC1_EXT      = 0x8DBB
;static const uint  GL_COMPRESSED_SIGNED_RED_RGTC1_EXT= 0x8DBC
;static const uint  GL_COMPRESSED_RED_GREEN_RGTC2_EXT= 0x8DBD
;static const uint  GL_COMPRESSED_SIGNED_RED_GREEN_RGTC2_EXT= 0x8DBE


//#ifndef GL_EXT_texture_shared_exponent
;static const uint  GL_RGB9_E5_EXT                   = 0x8C3D
;static const uint  GL_UNSIGNED_INT_5_9_9_9_REV_EXT  = 0x8C3E
;static const uint  GL_TEXTURE_SHARED_SIZE_EXT       = 0x8C3F


//#ifndef GL_NV_depth_buffer_float
;static const uint  GL_DEPTH_COMPONENT32F_NV         = 0x8DAB
;static const uint  GL_DEPTH32F_STENCIL8_NV          = 0x8DAC
;static const uint  GL_FLOAT_32_UNSIGNED_INT_24_8_REV_NV= 0x8DAD
;static const uint  GL_DEPTH_BUFFER_FLOAT_MODE_NV    = 0x8DAF


//#ifndef GL_NV_fragment_program4


//#ifndef GL_NV_framebuffer_multisample_coverage
;static const uint  GL_RENDERBUFFER_COVERAGE_SAMPLES_NV= 0x8CAB
;static const uint  GL_RENDERBUFFER_COLOR_SAMPLES_NV = 0x8E10
;static const uint  GL_MAX_MULTISAMPLE_COVERAGE_MODES_NV= 0x8E11
;static const uint  GL_MULTISAMPLE_COVERAGE_MODES_NV = 0x8E12


//#ifndef GL_EXT_framebuffer_sRGB
;static const uint  GL_FRAMEBUFFER_SRGB_EXT          = 0x8DB9
;static const uint  GL_FRAMEBUFFER_SRGB_CAPABLE_EXT  = 0x8DBA


//#ifndef GL_NV_geometry_shader4


//#ifndef GL_NV_parameter_buffer_object
;static const uint  GL_MAX_PROGRAM_PARAMETER_BUFFER_BINDINGS_NV= 0x8DA0
;static const uint  GL_MAX_PROGRAM_PARAMETER_BUFFER_SIZE_NV= 0x8DA1
;static const uint  GL_VERTEX_PROGRAM_PARAMETER_BUFFER_NV= 0x8DA2
;static const uint  GL_GEOMETRY_PROGRAM_PARAMETER_BUFFER_NV= 0x8DA3
;static const uint  GL_FRAGMENT_PROGRAM_PARAMETER_BUFFER_NV= 0x8DA4


//#ifndef GL_EXT_draw_buffers2


//#ifndef GL_NV_transform_feedback
;static const uint  GL_BACK_PRIMARY_COLOR_NV         = 0x8C77
;static const uint  GL_BACK_SECONDARY_COLOR_NV       = 0x8C78
;static const uint  GL_TEXTURE_COORD_NV              = 0x8C79
;static const uint  GL_CLIP_DISTANCE_NV              = 0x8C7A
;static const uint  GL_VERTEX_ID_NV                  = 0x8C7B
;static const uint  GL_PRIMITIVE_ID_NV               = 0x8C7C
;static const uint  GL_GENERIC_ATTRIB_NV             = 0x8C7D
;static const uint  GL_TRANSFORM_FEEDBACK_ATTRIBS_NV = 0x8C7E
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_MODE_NV= 0x8C7F
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS_NV= 0x8C80
;static const uint  GL_ACTIVE_VARYINGS_NV            = 0x8C81
;static const uint  GL_ACTIVE_VARYING_MAX_LENGTH_NV  = 0x8C82
;static const uint  GL_TRANSFORM_FEEDBACK_VARYINGS_NV= 0x8C83
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_START_NV= 0x8C84
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_SIZE_NV= 0x8C85
;static const uint  GL_TRANSFORM_FEEDBACK_RECORD_NV  = 0x8C86
;static const uint  GL_PRIMITIVES_GENERATED_NV       = 0x8C87
;static const uint  GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_NV= 0x8C88
;static const uint  GL_RASTERIZER_DISCARD_NV         = 0x8C89
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS_NV= 0x8C8A
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS_NV= 0x8C8B
;static const uint  GL_INTERLEAVED_ATTRIBS_NV        = 0x8C8C
;static const uint  GL_SEPARATE_ATTRIBS_NV           = 0x8C8D
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_NV  = 0x8C8E
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_BINDING_NV= 0x8C8F
;static const uint  GL_LAYER_NV                      = 0x8DAA
;static const uint  GL_NEXT_BUFFER_NV                = -2
;static const uint  GL_SKIP_COMPONENTS4_NV           = -3
;static const uint  GL_SKIP_COMPONENTS3_NV           = -4
;static const uint  GL_SKIP_COMPONENTS2_NV           = -5
;static const uint  GL_SKIP_COMPONENTS1_NV           = -6


//#ifndef GL_EXT_bindable_uniform
;static const uint  GL_MAX_VERTEX_BINDABLE_UNIFORMS_EXT= 0x8DE2
;static const uint  GL_MAX_FRAGMENT_BINDABLE_UNIFORMS_EXT= 0x8DE3
;static const uint  GL_MAX_GEOMETRY_BINDABLE_UNIFORMS_EXT= 0x8DE4
;static const uint  GL_MAX_BINDABLE_UNIFORM_SIZE_EXT = 0x8DED
;static const uint  GL_UNIFORM_BUFFER_EXT            = 0x8DEE
;static const uint  GL_UNIFORM_BUFFER_BINDING_EXT    = 0x8DEF


//#ifndef GL_EXT_texture_integer
;static const uint  GL_RGBA32UI_EXT                  = 0x8D70
;static const uint  GL_RGB32UI_EXT                   = 0x8D71
;static const uint  GL_ALPHA32UI_EXT                 = 0x8D72
;static const uint  GL_INTENSITY32UI_EXT             = 0x8D73
;static const uint  GL_LUMINANCE32UI_EXT             = 0x8D74
;static const uint  GL_LUMINANCE_ALPHA32UI_EXT       = 0x8D75
;static const uint  GL_RGBA16UI_EXT                  = 0x8D76
;static const uint  GL_RGB16UI_EXT                   = 0x8D77
;static const uint  GL_ALPHA16UI_EXT                 = 0x8D78
;static const uint  GL_INTENSITY16UI_EXT             = 0x8D79
;static const uint  GL_LUMINANCE16UI_EXT             = 0x8D7A
;static const uint  GL_LUMINANCE_ALPHA16UI_EXT       = 0x8D7B
;static const uint  GL_RGBA8UI_EXT                   = 0x8D7C
;static const uint  GL_RGB8UI_EXT                    = 0x8D7D
;static const uint  GL_ALPHA8UI_EXT                  = 0x8D7E
;static const uint  GL_INTENSITY8UI_EXT              = 0x8D7F
;static const uint  GL_LUMINANCE8UI_EXT              = 0x8D80
;static const uint  GL_LUMINANCE_ALPHA8UI_EXT        = 0x8D81
;static const uint  GL_RGBA32I_EXT                   = 0x8D82
;static const uint  GL_RGB32I_EXT                    = 0x8D83
;static const uint  GL_ALPHA32I_EXT                  = 0x8D84
;static const uint  GL_INTENSITY32I_EXT              = 0x8D85
;static const uint  GL_LUMINANCE32I_EXT              = 0x8D86
;static const uint  GL_LUMINANCE_ALPHA32I_EXT        = 0x8D87
;static const uint  GL_RGBA16I_EXT                   = 0x8D88
;static const uint  GL_RGB16I_EXT                    = 0x8D89
;static const uint  GL_ALPHA16I_EXT                  = 0x8D8A
;static const uint  GL_INTENSITY16I_EXT              = 0x8D8B
;static const uint  GL_LUMINANCE16I_EXT              = 0x8D8C
;static const uint  GL_LUMINANCE_ALPHA16I_EXT        = 0x8D8D
;static const uint  GL_RGBA8I_EXT                    = 0x8D8E
;static const uint  GL_RGB8I_EXT                     = 0x8D8F
;static const uint  GL_ALPHA8I_EXT                   = 0x8D90
;static const uint  GL_INTENSITY8I_EXT               = 0x8D91
;static const uint  GL_LUMINANCE8I_EXT               = 0x8D92
;static const uint  GL_LUMINANCE_ALPHA8I_EXT         = 0x8D93
;static const uint  GL_RED_INTEGER_EXT               = 0x8D94
;static const uint  GL_GREEN_INTEGER_EXT             = 0x8D95
;static const uint  GL_BLUE_INTEGER_EXT              = 0x8D96
;static const uint  GL_ALPHA_INTEGER_EXT             = 0x8D97
;static const uint  GL_RGB_INTEGER_EXT               = 0x8D98
;static const uint  GL_RGBA_INTEGER_EXT              = 0x8D99
;static const uint  GL_BGR_INTEGER_EXT               = 0x8D9A
;static const uint  GL_BGRA_INTEGER_EXT              = 0x8D9B
;static const uint  GL_LUMINANCE_INTEGER_EXT         = 0x8D9C
;static const uint  GL_LUMINANCE_ALPHA_INTEGER_EXT   = 0x8D9D
;static const uint  GL_RGBA_INTEGER_MODE_EXT         = 0x8D9E


//#ifndef GL_GREMEDY_frame_terminator


//#ifndef GL_NV_conditional_render
;static const uint  GL_QUERY_WAIT_NV                 = 0x8E13
;static const uint  GL_QUERY_NO_WAIT_NV              = 0x8E14
;static const uint  GL_QUERY_BY_REGION_WAIT_NV       = 0x8E15
;static const uint  GL_QUERY_BY_REGION_NO_WAIT_NV    = 0x8E16


//#ifndef GL_NV_present_video
;static const uint  GL_FRAME_NV                      = 0x8E26
;static const uint  GL_FIELDS_NV                     = 0x8E27
;static const uint  GL_CURRENT_TIME_NV               = 0x8E28
;static const uint  GL_NUM_FILL_STREAMS_NV           = 0x8E29
;static const uint  GL_PRESENT_TIME_NV               = 0x8E2A
;static const uint  GL_PRESENT_DURATION_NV           = 0x8E2B


//#ifndef GL_EXT_transform_feedback
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_EXT = 0x8C8E
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_START_EXT= 0x8C84
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_SIZE_EXT= 0x8C85
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_BINDING_EXT= 0x8C8F
;static const uint  GL_INTERLEAVED_ATTRIBS_EXT       = 0x8C8C
;static const uint  GL_SEPARATE_ATTRIBS_EXT          = 0x8C8D
;static const uint  GL_PRIMITIVES_GENERATED_EXT      = 0x8C87
;static const uint  GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_EXT= 0x8C88
;static const uint  GL_RASTERIZER_DISCARD_EXT        = 0x8C89
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS_EXT= 0x8C8A
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS_EXT= 0x8C8B
;static const uint  GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS_EXT= 0x8C80
;static const uint  GL_TRANSFORM_FEEDBACK_VARYINGS_EXT= 0x8C83
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_MODE_EXT= 0x8C7F
;static const uint  GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH_EXT= 0x8C76


//#ifndef GL_EXT_direct_state_access
;static const uint  GL_PROGRAM_MATRIX_EXT            = 0x8E2D
;static const uint  GL_TRANSPOSE_PROGRAM_MATRIX_EXT  = 0x8E2E
;static const uint  GL_PROGRAM_MATRIX_STACK_DEPTH_EXT= 0x8E2F


//#ifndef GL_EXT_vertex_array_bgra
/* reuse GL_BGRA */


//#ifndef GL_EXT_texture_swizzle
;static const uint  GL_TEXTURE_SWIZZLE_R_EXT         = 0x8E42
;static const uint  GL_TEXTURE_SWIZZLE_G_EXT         = 0x8E43
;static const uint  GL_TEXTURE_SWIZZLE_B_EXT         = 0x8E44
;static const uint  GL_TEXTURE_SWIZZLE_A_EXT         = 0x8E45
;static const uint  GL_TEXTURE_SWIZZLE_RGBA_EXT      = 0x8E46


//#ifndef GL_NV_explicit_multisample
;static const uint  GL_SAMPLE_POSITION_NV            = 0x8E50
;static const uint  GL_SAMPLE_MASK_NV                = 0x8E51
;static const uint  GL_SAMPLE_MASK_VALUE_NV          = 0x8E52
;static const uint  GL_TEXTURE_BINDING_RENDERBUFFER_NV= 0x8E53
;static const uint  GL_TEXTURE_RENDERBUFFER_DATA_STORE_BINDING_NV= 0x8E54
;static const uint  GL_TEXTURE_RENDERBUFFER_NV       = 0x8E55
;static const uint  GL_SAMPLER_RENDERBUFFER_NV       = 0x8E56
;static const uint  GL_INT_SAMPLER_RENDERBUFFER_NV   = 0x8E57
;static const uint  GL_UNSIGNED_INT_SAMPLER_RENDERBUFFER_NV= 0x8E58
;static const uint  GL_MAX_SAMPLE_MASK_WORDS_NV      = 0x8E59


//#ifndef GL_NV_transform_feedback2
;static const uint  GL_TRANSFORM_FEEDBACK_NV         = 0x8E22
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED_NV= 0x8E23
;static const uint  GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE_NV= 0x8E24
;static const uint  GL_TRANSFORM_FEEDBACK_BINDING_NV = 0x8E25


//#ifndef GL_ATI_meminfo
;static const uint  GL_VBO_FREE_MEMORY_ATI           = 0x87FB
;static const uint  GL_TEXTURE_FREE_MEMORY_ATI       = 0x87FC
;static const uint  GL_RENDERBUFFER_FREE_MEMORY_ATI  = 0x87FD


//#ifndef GL_AMD_performance_monitor
;static const uint  GL_COUNTER_TYPE_AMD              = 0x8BC0
;static const uint  GL_COUNTER_RANGE_AMD             = 0x8BC1
;static const uint  GL_UNSIGNED_INT64_AMD            = 0x8BC2
;static const uint  GL_PERCENTAGE_AMD                = 0x8BC3
;static const uint  GL_PERFMON_RESULT_AVAILABLE_AMD  = 0x8BC4
;static const uint  GL_PERFMON_RESULT_SIZE_AMD       = 0x8BC5
;static const uint  GL_PERFMON_RESULT_AMD            = 0x8BC6


//#ifndef GL_AMD_texture_texture4


//#ifndef GL_AMD_vertex_shader_tessellator
;static const uint  GL_SAMPLER_BUFFER_AMD            = 0x9001
;static const uint  GL_INT_SAMPLER_BUFFER_AMD        = 0x9002
;static const uint  GL_UNSIGNED_INT_SAMPLER_BUFFER_AMD= 0x9003
;static const uint  GL_TESSELLATION_MODE_AMD         = 0x9004
;static const uint  GL_TESSELLATION_FACTOR_AMD       = 0x9005
;static const uint  GL_DISCRETE_AMD                  = 0x9006
;static const uint  GL_CONTINUOUS_AMD                = 0x9007


//#ifndef GL_EXT_provoking_vertex
;static const uint  GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION_EXT= 0x8E4C
;static const uint  GL_FIRST_VERTEX_CONVENTION_EXT   = 0x8E4D
;static const uint  GL_LAST_VERTEX_CONVENTION_EXT    = 0x8E4E
;static const uint  GL_PROVOKING_VERTEX_EXT          = 0x8E4F


//#ifndef GL_EXT_texture_snorm
;static const uint  GL_ALPHA_SNORM                   = 0x9010
;static const uint  GL_LUMINANCE_SNORM               = 0x9011
;static const uint  GL_LUMINANCE_ALPHA_SNORM         = 0x9012
;static const uint  GL_INTENSITY_SNORM               = 0x9013
;static const uint  GL_ALPHA8_SNORM                  = 0x9014
;static const uint  GL_LUMINANCE8_SNORM              = 0x9015
;static const uint  GL_LUMINANCE8_ALPHA8_SNORM       = 0x9016
;static const uint  GL_INTENSITY8_SNORM              = 0x9017
;static const uint  GL_ALPHA16_SNORM                 = 0x9018
;static const uint  GL_LUMINANCE16_SNORM             = 0x9019
;static const uint  GL_LUMINANCE16_ALPHA16_SNORM     = 0x901A
;static const uint  GL_INTENSITY16_SNORM             = 0x901B
/* reuse GL_RED_SNORM */
/* reuse GL_RG_SNORM */
/* reuse GL_RGB_SNORM */
/* reuse GL_RGBA_SNORM */
/* reuse GL_R8_SNORM */
/* reuse GL_RG8_SNORM */
/* reuse GL_RGB8_SNORM */
/* reuse GL_RGBA8_SNORM */
/* reuse GL_R16_SNORM */
/* reuse GL_RG16_SNORM */
/* reuse GL_RGB16_SNORM */
/* reuse GL_RGBA16_SNORM */
/* reuse GL_SIGNED_NORMALIZED */


//#ifndef GL_AMD_draw_buffers_blend


//#ifndef GL_APPLE_texture_range
;static const uint  GL_TEXTURE_RANGE_LENGTH_APPLE    = 0x85B7
;static const uint  GL_TEXTURE_RANGE_POINTER_APPLE   = 0x85B8
;static const uint  GL_TEXTURE_STORAGE_HINT_APPLE    = 0x85BC
;static const uint  GL_STORAGE_PRIVATE_APPLE         = 0x85BD
/* reuse GL_STORAGE_CACHED_APPLE */
/* reuse GL_STORAGE_SHARED_APPLE */


//#ifndef GL_APPLE_float_pixels
;static const uint  GL_HALF_APPLE                    = 0x140B
;static const uint  GL_RGBA_FLOAT32_APPLE            = 0x8814
;static const uint  GL_RGB_FLOAT32_APPLE             = 0x8815
;static const uint  GL_ALPHA_FLOAT32_APPLE           = 0x8816
;static const uint  GL_INTENSITY_FLOAT32_APPLE       = 0x8817
;static const uint  GL_LUMINANCE_FLOAT32_APPLE       = 0x8818
;static const uint  GL_LUMINANCE_ALPHA_FLOAT32_APPLE = 0x8819
;static const uint  GL_RGBA_FLOAT16_APPLE            = 0x881A
;static const uint  GL_RGB_FLOAT16_APPLE             = 0x881B
;static const uint  GL_ALPHA_FLOAT16_APPLE           = 0x881C
;static const uint  GL_INTENSITY_FLOAT16_APPLE       = 0x881D
;static const uint  GL_LUMINANCE_FLOAT16_APPLE       = 0x881E
;static const uint  GL_LUMINANCE_ALPHA_FLOAT16_APPLE = 0x881F
;static const uint  GL_COLOR_FLOAT_APPLE             = 0x8A0F


//#ifndef GL_APPLE_vertex_program_evaluators
;static const uint  GL_VERTEX_ATTRIB_MAP1_APPLE      = 0x8A00
;static const uint  GL_VERTEX_ATTRIB_MAP2_APPLE      = 0x8A01
;static const uint  GL_VERTEX_ATTRIB_MAP1_SIZE_APPLE = 0x8A02
;static const uint  GL_VERTEX_ATTRIB_MAP1_COEFF_APPLE= 0x8A03
;static const uint  GL_VERTEX_ATTRIB_MAP1_ORDER_APPLE= 0x8A04
;static const uint  GL_VERTEX_ATTRIB_MAP1_DOMAIN_APPLE= 0x8A05
;static const uint  GL_VERTEX_ATTRIB_MAP2_SIZE_APPLE = 0x8A06
;static const uint  GL_VERTEX_ATTRIB_MAP2_COEFF_APPLE= 0x8A07
;static const uint  GL_VERTEX_ATTRIB_MAP2_ORDER_APPLE= 0x8A08
;static const uint  GL_VERTEX_ATTRIB_MAP2_DOMAIN_APPLE= 0x8A09


//#ifndef GL_APPLE_aux_depth_stencil
;static const uint  GL_AUX_DEPTH_STENCIL_APPLE       = 0x8A14


//#ifndef GL_APPLE_object_purgeable
;static const uint  GL_BUFFER_OBJECT_APPLE           = 0x85B3
;static const uint  GL_RELEASED_APPLE                = 0x8A19
;static const uint  GL_VOLATILE_APPLE                = 0x8A1A
;static const uint  GL_RETAINED_APPLE                = 0x8A1B
;static const uint  GL_UNDEFINED_APPLE               = 0x8A1C
;static const uint  GL_PURGEABLE_APPLE               = 0x8A1D


//#ifndef GL_APPLE_row_bytes
;static const uint  GL_PACK_ROW_BYTES_APPLE          = 0x8A15
;static const uint  GL_UNPACK_ROW_BYTES_APPLE        = 0x8A16


//#ifndef GL_APPLE_rgb_422
;static const uint  GL_RGB_422_APPLE                 = 0x8A1F
/* reuse GL_UNSIGNED_SHORT_8_8_APPLE */
/* reuse GL_UNSIGNED_SHORT_8_8_REV_APPLE */


//#ifndef GL_NV_video_capture
;static const uint  GL_VIDEO_BUFFER_NV               = 0x9020
;static const uint  GL_VIDEO_BUFFER_BINDING_NV       = 0x9021
;static const uint  GL_FIELD_UPPER_NV                = 0x9022
;static const uint  GL_FIELD_LOWER_NV                = 0x9023
;static const uint  GL_NUM_VIDEO_CAPTURE_STREAMS_NV  = 0x9024
;static const uint  GL_NEXT_VIDEO_CAPTURE_BUFFER_STATUS_NV= 0x9025
;static const uint  GL_VIDEO_CAPTURE_TO_422_SUPPORTED_NV= 0x9026
;static const uint  GL_LAST_VIDEO_CAPTURE_STATUS_NV  = 0x9027
;static const uint  GL_VIDEO_BUFFER_PITCH_NV         = 0x9028
;static const uint  GL_VIDEO_COLOR_CONVERSION_MATRIX_NV= 0x9029
;static const uint  GL_VIDEO_COLOR_CONVERSION_MAX_NV = 0x902A
;static const uint  GL_VIDEO_COLOR_CONVERSION_MIN_NV = 0x902B
;static const uint  GL_VIDEO_COLOR_CONVERSION_OFFSET_NV= 0x902C
;static const uint  GL_VIDEO_BUFFER_INTERNAL_FORMAT_NV= 0x902D
;static const uint  GL_PARTIAL_SUCCESS_NV            = 0x902E
;static const uint  GL_SUCCESS_NV                    = 0x902F
;static const uint  GL_FAILURE_NV                    = 0x9030
;static const uint  GL_YCBYCR8_422_NV                = 0x9031
;static const uint  GL_YCBAYCR8A_4224_NV             = 0x9032
;static const uint  GL_Z6Y10Z6CB10Z6Y10Z6CR10_422_NV = 0x9033
;static const uint  GL_Z6Y10Z6CB10Z6A10Z6Y10Z6CR10Z6A10_4224_NV= 0x9034
;static const uint  GL_Z4Y12Z4CB12Z4Y12Z4CR12_422_NV = 0x9035
;static const uint  GL_Z4Y12Z4CB12Z4A12Z4Y12Z4CR12Z4A12_4224_NV= 0x9036
;static const uint  GL_Z4Y12Z4CB12Z4CR12_444_NV      = 0x9037
;static const uint  GL_VIDEO_CAPTURE_FRAME_WIDTH_NV  = 0x9038
;static const uint  GL_VIDEO_CAPTURE_FRAME_HEIGHT_NV = 0x9039
;static const uint  GL_VIDEO_CAPTURE_FIELD_UPPER_HEIGHT_NV= 0x903A
;static const uint  GL_VIDEO_CAPTURE_FIELD_LOWER_HEIGHT_NV= 0x903B
;static const uint  GL_VIDEO_CAPTURE_SURFACE_ORIGIN_NV= 0x903C


//#ifndef GL_NV_copy_image


//#ifndef GL_EXT_separate_shader_objects
;static const uint  GL_ACTIVE_PROGRAM_EXT            = 0x8B8D


//#ifndef GL_NV_parameter_buffer_object2


//#ifndef GL_NV_shader_buffer_load
;static const uint  GL_BUFFER_GPU_ADDRESS_NV         = 0x8F1D
;static const uint  GL_GPU_ADDRESS_NV                = 0x8F34
;static const uint  GL_MAX_SHADER_BUFFER_ADDRESS_NV  = 0x8F35


//#ifndef GL_NV_vertex_buffer_unified_memory
;static const uint  GL_VERTEX_ATTRIB_ARRAY_UNIFIED_NV= 0x8F1E
;static const uint  GL_ELEMENT_ARRAY_UNIFIED_NV      = 0x8F1F
;static const uint  GL_VERTEX_ATTRIB_ARRAY_ADDRESS_NV= 0x8F20
;static const uint  GL_VERTEX_ARRAY_ADDRESS_NV       = 0x8F21
;static const uint  GL_NORMAL_ARRAY_ADDRESS_NV       = 0x8F22
;static const uint  GL_COLOR_ARRAY_ADDRESS_NV        = 0x8F23
;static const uint  GL_INDEX_ARRAY_ADDRESS_NV        = 0x8F24
;static const uint  GL_TEXTURE_COORD_ARRAY_ADDRESS_NV= 0x8F25
;static const uint  GL_EDGE_FLAG_ARRAY_ADDRESS_NV    = 0x8F26
;static const uint  GL_SECONDARY_COLOR_ARRAY_ADDRESS_NV= 0x8F27
;static const uint  GL_FOG_COORD_ARRAY_ADDRESS_NV    = 0x8F28
;static const uint  GL_ELEMENT_ARRAY_ADDRESS_NV      = 0x8F29
;static const uint  GL_VERTEX_ATTRIB_ARRAY_LENGTH_NV = 0x8F2A
;static const uint  GL_VERTEX_ARRAY_LENGTH_NV        = 0x8F2B
;static const uint  GL_NORMAL_ARRAY_LENGTH_NV        = 0x8F2C
;static const uint  GL_COLOR_ARRAY_LENGTH_NV         = 0x8F2D
;static const uint  GL_INDEX_ARRAY_LENGTH_NV         = 0x8F2E
;static const uint  GL_TEXTURE_COORD_ARRAY_LENGTH_NV = 0x8F2F
;static const uint  GL_EDGE_FLAG_ARRAY_LENGTH_NV     = 0x8F30
;static const uint  GL_SECONDARY_COLOR_ARRAY_LENGTH_NV= 0x8F31
;static const uint  GL_FOG_COORD_ARRAY_LENGTH_NV     = 0x8F32
;static const uint  GL_ELEMENT_ARRAY_LENGTH_NV       = 0x8F33
;static const uint  GL_DRAW_INDIRECT_UNIFIED_NV      = 0x8F40
;static const uint  GL_DRAW_INDIRECT_ADDRESS_NV      = 0x8F41
;static const uint  GL_DRAW_INDIRECT_LENGTH_NV       = 0x8F42


//#ifndef GL_NV_texture_barrier


//#ifndef GL_AMD_shader_stencil_export


//#ifndef GL_AMD_seamless_cubemap_per_texture
/* reuse GL_TEXTURE_CUBE_MAP_SEAMLESS */


//#ifndef GL_AMD_conservative_depth


//#ifndef GL_EXT_shader_image_load_store
;static const uint  GL_MAX_IMAGE_UNITS_EXT           = 0x8F38
;static const uint  GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS_EXT= 0x8F39
;static const uint  GL_IMAGE_BINDING_NAME_EXT        = 0x8F3A
;static const uint  GL_IMAGE_BINDING_LEVEL_EXT       = 0x8F3B
;static const uint  GL_IMAGE_BINDING_LAYERED_EXT     = 0x8F3C
;static const uint  GL_IMAGE_BINDING_LAYER_EXT       = 0x8F3D
;static const uint  GL_IMAGE_BINDING_ACCESS_EXT      = 0x8F3E
;static const uint  GL_IMAGE_1D_EXT                  = 0x904C
;static const uint  GL_IMAGE_2D_EXT                  = 0x904D
;static const uint  GL_IMAGE_3D_EXT                  = 0x904E
;static const uint  GL_IMAGE_2D_RECT_EXT             = 0x904F
;static const uint  GL_IMAGE_CUBE_EXT                = 0x9050
;static const uint  GL_IMAGE_BUFFER_EXT              = 0x9051
;static const uint  GL_IMAGE_1D_ARRAY_EXT            = 0x9052
;static const uint  GL_IMAGE_2D_ARRAY_EXT            = 0x9053
;static const uint  GL_IMAGE_CUBE_MAP_ARRAY_EXT      = 0x9054
;static const uint  GL_IMAGE_2D_MULTISAMPLE_EXT      = 0x9055
;static const uint  GL_IMAGE_2D_MULTISAMPLE_ARRAY_EXT= 0x9056
;static const uint  GL_INT_IMAGE_1D_EXT              = 0x9057
;static const uint  GL_INT_IMAGE_2D_EXT              = 0x9058
;static const uint  GL_INT_IMAGE_3D_EXT              = 0x9059
;static const uint  GL_INT_IMAGE_2D_RECT_EXT         = 0x905A
;static const uint  GL_INT_IMAGE_CUBE_EXT            = 0x905B
;static const uint  GL_INT_IMAGE_BUFFER_EXT          = 0x905C
;static const uint  GL_INT_IMAGE_1D_ARRAY_EXT        = 0x905D
;static const uint  GL_INT_IMAGE_2D_ARRAY_EXT        = 0x905E
;static const uint  GL_INT_IMAGE_CUBE_MAP_ARRAY_EXT  = 0x905F
;static const uint  GL_INT_IMAGE_2D_MULTISAMPLE_EXT  = 0x9060
;static const uint  GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY_EXT= 0x9061
;static const uint  GL_UNSIGNED_INT_IMAGE_1D_EXT     = 0x9062
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_EXT     = 0x9063
;static const uint  GL_UNSIGNED_INT_IMAGE_3D_EXT     = 0x9064
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_RECT_EXT= 0x9065
;static const uint  GL_UNSIGNED_INT_IMAGE_CUBE_EXT   = 0x9066
;static const uint  GL_UNSIGNED_INT_IMAGE_BUFFER_EXT = 0x9067
;static const uint  GL_UNSIGNED_INT_IMAGE_1D_ARRAY_EXT= 0x9068
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_ARRAY_EXT= 0x9069
;static const uint  GL_UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY_EXT= 0x906A
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_EXT= 0x906B
;static const uint  GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY_EXT= 0x906C
;static const uint  GL_MAX_IMAGE_SAMPLES_EXT         = 0x906D
;static const uint  GL_IMAGE_BINDING_FORMAT_EXT      = 0x906E
;static const uint  GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT_EXT= 0x00000001
;static const uint  GL_ELEMENT_ARRAY_BARRIER_BIT_EXT = 0x00000002
;static const uint  GL_UNIFORM_BARRIER_BIT_EXT       = 0x00000004
;static const uint  GL_TEXTURE_FETCH_BARRIER_BIT_EXT = 0x00000008
;static const uint  GL_SHADER_IMAGE_ACCESS_BARRIER_BIT_EXT= 0x00000020
;static const uint  GL_COMMAND_BARRIER_BIT_EXT       = 0x00000040
;static const uint  GL_PIXEL_BUFFER_BARRIER_BIT_EXT  = 0x00000080
;static const uint  GL_TEXTURE_UPDATE_BARRIER_BIT_EXT= 0x00000100
;static const uint  GL_BUFFER_UPDATE_BARRIER_BIT_EXT = 0x00000200
;static const uint  GL_FRAMEBUFFER_BARRIER_BIT_EXT   = 0x00000400
;static const uint  GL_TRANSFORM_FEEDBACK_BARRIER_BIT_EXT= 0x00000800
;static const uint  GL_ATOMIC_COUNTER_BARRIER_BIT_EXT= 0x00001000
;static const uint  GL_ALL_BARRIER_BITS_EXT          = 0xFFFFFFFF


//#ifndef GL_EXT_vertex_attrib_64bit
/* reuse GL_DOUBLE */
;static const uint  GL_DOUBLE_VEC2_EXT               = 0x8FFC
;static const uint  GL_DOUBLE_VEC3_EXT               = 0x8FFD
;static const uint  GL_DOUBLE_VEC4_EXT               = 0x8FFE
;static const uint  GL_DOUBLE_MAT2_EXT               = 0x8F46
;static const uint  GL_DOUBLE_MAT3_EXT               = 0x8F47
;static const uint  GL_DOUBLE_MAT4_EXT               = 0x8F48
;static const uint  GL_DOUBLE_MAT2x3_EXT             = 0x8F49
;static const uint  GL_DOUBLE_MAT2x4_EXT             = 0x8F4A
;static const uint  GL_DOUBLE_MAT3x2_EXT             = 0x8F4B
;static const uint  GL_DOUBLE_MAT3x4_EXT             = 0x8F4C
;static const uint  GL_DOUBLE_MAT4x2_EXT             = 0x8F4D
;static const uint  GL_DOUBLE_MAT4x3_EXT             = 0x8F4E


//#ifndef GL_NV_gpu_program5
;static const uint  GL_MAX_GEOMETRY_PROGRAM_INVOCATIONS_NV= 0x8E5A
;static const uint  GL_MIN_FRAGMENT_INTERPOLATION_OFFSET_NV= 0x8E5B
;static const uint  GL_MAX_FRAGMENT_INTERPOLATION_OFFSET_NV= 0x8E5C
;static const uint  GL_FRAGMENT_PROGRAM_INTERPOLATION_OFFSET_BITS_NV= 0x8E5D
;static const uint  GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET_NV= 0x8E5E
;static const uint  GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET_NV= 0x8E5F
;static const uint  GL_MAX_PROGRAM_SUBROUTINE_PARAMETERS_NV= 0x8F44
;static const uint  GL_MAX_PROGRAM_SUBROUTINE_NUM_NV = 0x8F45


//#ifndef GL_NV_gpu_shader5
;static const uint  GL_INT64_NV                      = 0x140E
;static const uint  GL_UNSIGNED_INT64_NV             = 0x140F
;static const uint  GL_INT8_NV                       = 0x8FE0
;static const uint  GL_INT8_VEC2_NV                  = 0x8FE1
;static const uint  GL_INT8_VEC3_NV                  = 0x8FE2
;static const uint  GL_INT8_VEC4_NV                  = 0x8FE3
;static const uint  GL_INT16_NV                      = 0x8FE4
;static const uint  GL_INT16_VEC2_NV                 = 0x8FE5
;static const uint  GL_INT16_VEC3_NV                 = 0x8FE6
;static const uint  GL_INT16_VEC4_NV                 = 0x8FE7
;static const uint  GL_INT64_VEC2_NV                 = 0x8FE9
;static const uint  GL_INT64_VEC3_NV                 = 0x8FEA
;static const uint  GL_INT64_VEC4_NV                 = 0x8FEB
;static const uint  GL_UNSIGNED_INT8_NV              = 0x8FEC
;static const uint  GL_UNSIGNED_INT8_VEC2_NV         = 0x8FED
;static const uint  GL_UNSIGNED_INT8_VEC3_NV         = 0x8FEE
;static const uint  GL_UNSIGNED_INT8_VEC4_NV         = 0x8FEF
;static const uint  GL_UNSIGNED_INT16_NV             = 0x8FF0
;static const uint  GL_UNSIGNED_INT16_VEC2_NV        = 0x8FF1
;static const uint  GL_UNSIGNED_INT16_VEC3_NV        = 0x8FF2
;static const uint  GL_UNSIGNED_INT16_VEC4_NV        = 0x8FF3
;static const uint  GL_UNSIGNED_INT64_VEC2_NV        = 0x8FF5
;static const uint  GL_UNSIGNED_INT64_VEC3_NV        = 0x8FF6
;static const uint  GL_UNSIGNED_INT64_VEC4_NV        = 0x8FF7
;static const uint  GL_FLOAT16_NV                    = 0x8FF8
;static const uint  GL_FLOAT16_VEC2_NV               = 0x8FF9
;static const uint  GL_FLOAT16_VEC3_NV               = 0x8FFA
;static const uint  GL_FLOAT16_VEC4_NV               = 0x8FFB
/* reuse GL_PATCHES */


//#ifndef GL_NV_shader_buffer_store
;static const uint  GL_SHADER_GLOBAL_ACCESS_BARRIER_BIT_NV= 0x00000010
/* reuse GL_READ_WRITE */
/* reuse GL_WRITE_ONLY */


//#ifndef GL_NV_tessellation_program5
;static const uint  GL_MAX_PROGRAM_PATCH_ATTRIBS_NV  = 0x86D8
;static const uint  GL_TESS_CONTROL_PROGRAM_NV       = 0x891E
;static const uint  GL_TESS_EVALUATION_PROGRAM_NV    = 0x891F
;static const uint  GL_TESS_CONTROL_PROGRAM_PARAMETER_BUFFER_NV= 0x8C74
;static const uint  GL_TESS_EVALUATION_PROGRAM_PARAMETER_BUFFER_NV= 0x8C75


//#ifndef GL_NV_vertex_attrib_integer_64bit
/* reuse GL_INT64_NV */
/* reuse GL_UNSIGNED_INT64_NV */


//#ifndef GL_NV_multisample_coverage
;static const uint  GL_COLOR_SAMPLES_NV              = 0x8E20
/* reuse GL_SAMPLES_ARB */


//#ifndef GL_AMD_name_gen_delete
;static const uint  GL_DATA_BUFFER_AMD               = 0x9151
;static const uint  GL_PERFORMANCE_MONITOR_AMD       = 0x9152
;static const uint  GL_QUERY_OBJECT_AMD              = 0x9153
;static const uint  GL_VERTEX_ARRAY_OBJECT_AMD       = 0x9154
;static const uint  GL_SAMPLER_OBJECT_AMD            = 0x9155


//#ifndef GL_AMD_debug_output
;static const uint  GL_MAX_DEBUG_MESSAGE_LENGTH_AMD  = 0x9143
;static const uint  GL_MAX_DEBUG_LOGGED_MESSAGES_AMD = 0x9144
;static const uint  GL_DEBUG_LOGGED_MESSAGES_AMD     = 0x9145
;static const uint  GL_DEBUG_SEVERITY_HIGH_AMD       = 0x9146
;static const uint  GL_DEBUG_SEVERITY_MEDIUM_AMD     = 0x9147
;static const uint  GL_DEBUG_SEVERITY_LOW_AMD        = 0x9148
;static const uint  GL_DEBUG_CATEGORY_API_ERROR_AMD  = 0x9149
;static const uint  GL_DEBUG_CATEGORY_WINDOW_SYSTEM_AMD= 0x914A
;static const uint  GL_DEBUG_CATEGORY_DEPRECATION_AMD= 0x914B
;static const uint  GL_DEBUG_CATEGORY_UNDEFINED_BEHAVIOR_AMD= 0x914C
;static const uint  GL_DEBUG_CATEGORY_PERFORMANCE_AMD= 0x914D
;static const uint  GL_DEBUG_CATEGORY_SHADER_COMPILER_AMD= 0x914E
;static const uint  GL_DEBUG_CATEGORY_APPLICATION_AMD= 0x914F
;static const uint  GL_DEBUG_CATEGORY_OTHER_AMD      = 0x9150


//#ifndef GL_NV_vdpau_interop
;static const uint  GL_SURFACE_STATE_NV              = 0x86EB
;static const uint  GL_SURFACE_REGISTERED_NV         = 0x86FD
;static const uint  GL_SURFACE_MAPPED_NV             = 0x8700
;static const uint  GL_WRITE_DISCARD_NV              = 0x88BE


//#ifndef GL_AMD_transform_feedback3_lines_triangles


//#ifndef GL_AMD_depth_clamp_separate
;static const uint  GL_DEPTH_CLAMP_NEAR_AMD          = 0x901E
;static const uint  GL_DEPTH_CLAMP_FAR_AMD           = 0x901F


//#ifndef GL_EXT_texture_sRGB_decode
;static const uint  GL_TEXTURE_SRGB_DECODE_EXT       = 0x8A48
;static const uint  GL_DECODE_EXT                    = 0x8A49
;static const uint  GL_SKIP_DECODE_EXT               = 0x8A4A


//#ifndef GL_NV_texture_multisample
;static const uint  GL_TEXTURE_COVERAGE_SAMPLES_NV   = 0x9045
;static const uint  GL_TEXTURE_COLOR_SAMPLES_NV      = 0x9046


//#ifndef GL_AMD_blend_minmax_factor
;static const uint  GL_FACTOR_MIN_AMD                = 0x901C
;static const uint  GL_FACTOR_MAX_AMD                = 0x901D


//#ifndef GL_AMD_sample_positions
;static const uint  GL_SUBSAMPLE_DISTANCE_AMD        = 0x883F


//#ifndef GL_EXT_x11_sync_object
;static const uint  GL_SYNC_X11_FENCE_EXT            = 0x90E1


//#ifndef GL_AMD_multi_draw_indirect


//#ifndef GL_EXT_framebuffer_multisample_blit_scaled
;static const uint  GL_SCALED_RESOLVE_FASTEST_EXT    = 0x90BA
;static const uint  GL_SCALED_RESOLVE_NICEST_EXT     = 0x90BB


//#ifndef GL_NV_path_rendering
;static const uint  GL_PATH_FORMAT_SVG_NV            = 0x9070
;static const uint  GL_PATH_FORMAT_PS_NV             = 0x9071
;static const uint  GL_STANDARD_FONT_NAME_NV         = 0x9072
;static const uint  GL_SYSTEM_FONT_NAME_NV           = 0x9073
;static const uint  GL_FILE_NAME_NV                  = 0x9074
;static const uint  GL_PATH_STROKE_WIDTH_NV          = 0x9075
;static const uint  GL_PATH_END_CAPS_NV              = 0x9076
;static const uint  GL_PATH_INITIAL_END_CAP_NV       = 0x9077
;static const uint  GL_PATH_TERMINAL_END_CAP_NV      = 0x9078
;static const uint  GL_PATH_JOIN_STYLE_NV            = 0x9079
;static const uint  GL_PATH_MITER_LIMIT_NV           = 0x907A
;static const uint  GL_PATH_DASH_CAPS_NV             = 0x907B
;static const uint  GL_PATH_INITIAL_DASH_CAP_NV      = 0x907C
;static const uint  GL_PATH_TERMINAL_DASH_CAP_NV     = 0x907D
;static const uint  GL_PATH_DASH_OFFSET_NV           = 0x907E
;static const uint  GL_PATH_CLIENT_LENGTH_NV         = 0x907F
;static const uint  GL_PATH_FILL_MODE_NV             = 0x9080
;static const uint  GL_PATH_FILL_MASK_NV             = 0x9081
;static const uint  GL_PATH_FILL_COVER_MODE_NV       = 0x9082
;static const uint  GL_PATH_STROKE_COVER_MODE_NV     = 0x9083
;static const uint  GL_PATH_STROKE_MASK_NV           = 0x9084
;static const uint  GL_COUNT_UP_NV                   = 0x9088
;static const uint  GL_COUNT_DOWN_NV                 = 0x9089
;static const uint  GL_PATH_OBJECT_BOUNDING_BOX_NV   = 0x908A
;static const uint  GL_CONVEX_HULL_NV                = 0x908B
;static const uint  GL_BOUNDING_BOX_NV               = 0x908D
;static const uint  GL_TRANSLATE_X_NV                = 0x908E
;static const uint  GL_TRANSLATE_Y_NV                = 0x908F
;static const uint  GL_TRANSLATE_2D_NV               = 0x9090
;static const uint  GL_TRANSLATE_3D_NV               = 0x9091
;static const uint  GL_AFFINE_2D_NV                  = 0x9092
;static const uint  GL_AFFINE_3D_NV                  = 0x9094
;static const uint  GL_TRANSPOSE_AFFINE_2D_NV        = 0x9096
;static const uint  GL_TRANSPOSE_AFFINE_3D_NV        = 0x9098
;static const uint  GL_UTF8_NV                       = 0x909A
;static const uint  GL_UTF16_NV                      = 0x909B
;static const uint  GL_BOUNDING_BOX_OF_BOUNDING_BOXES_NV= 0x909C
;static const uint  GL_PATH_COMMAND_COUNT_NV         = 0x909D
;static const uint  GL_PATH_COORD_COUNT_NV           = 0x909E
;static const uint  GL_PATH_DASH_ARRAY_COUNT_NV      = 0x909F
;static const uint  GL_PATH_COMPUTED_LENGTH_NV       = 0x90A0
;static const uint  GL_PATH_FILL_BOUNDING_BOX_NV     = 0x90A1
;static const uint  GL_PATH_STROKE_BOUNDING_BOX_NV   = 0x90A2
;static const uint  GL_SQUARE_NV                     = 0x90A3
;static const uint  GL_ROUND_NV                      = 0x90A4
;static const uint  GL_TRIANGULAR_NV                 = 0x90A5
;static const uint  GL_BEVEL_NV                      = 0x90A6
;static const uint  GL_MITER_REVERT_NV               = 0x90A7
;static const uint  GL_MITER_TRUNCATE_NV             = 0x90A8
;static const uint  GL_SKIP_MISSING_GLYPH_NV         = 0x90A9
;static const uint  GL_USE_MISSING_GLYPH_NV          = 0x90AA
;static const uint  GL_PATH_ERROR_POSITION_NV        = 0x90AB
;static const uint  GL_PATH_FOG_GEN_MODE_NV          = 0x90AC
;static const uint  GL_ACCUM_ADJACENT_PAIRS_NV       = 0x90AD
;static const uint  GL_ADJACENT_PAIRS_NV             = 0x90AE
;static const uint  GL_FIRST_TO_REST_NV              = 0x90AF
;static const uint  GL_PATH_GEN_MODE_NV              = 0x90B0
;static const uint  GL_PATH_GEN_COEFF_NV             = 0x90B1
;static const uint  GL_PATH_GEN_COLOR_FORMAT_NV      = 0x90B2
;static const uint  GL_PATH_GEN_COMPONENTS_NV        = 0x90B3
;static const uint  GL_PATH_STENCIL_FUNC_NV          = 0x90B7
;static const uint  GL_PATH_STENCIL_REF_NV           = 0x90B8
;static const uint  GL_PATH_STENCIL_VALUE_MASK_NV    = 0x90B9
;static const uint  GL_PATH_STENCIL_DEPTH_OFFSET_FACTOR_NV= 0x90BD
;static const uint  GL_PATH_STENCIL_DEPTH_OFFSET_UNITS_NV= 0x90BE
;static const uint  GL_PATH_COVER_DEPTH_FUNC_NV      = 0x90BF
;static const uint  GL_PATH_DASH_OFFSET_RESET_NV     = 0x90B4
;static const uint  GL_MOVE_TO_RESETS_NV             = 0x90B5
;static const uint  GL_MOVE_TO_CONTINUES_NV          = 0x90B6
;static const uint  GL_CLOSE_PATH_NV                 = 0x00
;static const uint  GL_MOVE_TO_NV                    = 0x02
;static const uint  GL_RELATIVE_MOVE_TO_NV           = 0x03
;static const uint  GL_LINE_TO_NV                    = 0x04
;static const uint  GL_RELATIVE_LINE_TO_NV           = 0x05
;static const uint  GL_HORIZONTAL_LINE_TO_NV         = 0x06
;static const uint  GL_RELATIVE_HORIZONTAL_LINE_TO_NV= 0x07
;static const uint  GL_VERTICAL_LINE_TO_NV           = 0x08
;static const uint  GL_RELATIVE_VERTICAL_LINE_TO_NV  = 0x09
;static const uint  GL_QUADRATIC_CURVE_TO_NV         = 0x0A
;static const uint  GL_RELATIVE_QUADRATIC_CURVE_TO_NV= 0x0B
;static const uint  GL_CUBIC_CURVE_TO_NV             = 0x0C
;static const uint  GL_RELATIVE_CUBIC_CURVE_TO_NV    = 0x0D
;static const uint  GL_SMOOTH_QUADRATIC_CURVE_TO_NV  = 0x0E
;static const uint  GL_RELATIVE_SMOOTH_QUADRATIC_CURVE_TO_NV= 0x0F
;static const uint  GL_SMOOTH_CUBIC_CURVE_TO_NV      = 0x10
;static const uint  GL_RELATIVE_SMOOTH_CUBIC_CURVE_TO_NV= 0x11
;static const uint  GL_SMALL_CCW_ARC_TO_NV           = 0x12
;static const uint  GL_RELATIVE_SMALL_CCW_ARC_TO_NV  = 0x13
;static const uint  GL_SMALL_CW_ARC_TO_NV            = 0x14
;static const uint  GL_RELATIVE_SMALL_CW_ARC_TO_NV   = 0x15
;static const uint  GL_LARGE_CCW_ARC_TO_NV           = 0x16
;static const uint  GL_RELATIVE_LARGE_CCW_ARC_TO_NV  = 0x17
;static const uint  GL_LARGE_CW_ARC_TO_NV            = 0x18
;static const uint  GL_RELATIVE_LARGE_CW_ARC_TO_NV   = 0x19
;static const uint  GL_RESTART_PATH_NV               = 0xF0
;static const uint  GL_DUP_FIRST_CUBIC_CURVE_TO_NV   = 0xF2
;static const uint  GL_DUP_LAST_CUBIC_CURVE_TO_NV    = 0xF4
;static const uint  GL_RECT_NV                       = 0xF6
;static const uint  GL_CIRCULAR_CCW_ARC_TO_NV        = 0xF8
;static const uint  GL_CIRCULAR_CW_ARC_TO_NV         = 0xFA
;static const uint  GL_CIRCULAR_TANGENT_ARC_TO_NV    = 0xFC
;static const uint  GL_ARC_TO_NV                     = 0xFE
;static const uint  GL_RELATIVE_ARC_TO_NV            = 0xFF
;static const uint  GL_BOLD_BIT_NV                   = 0x01
;static const uint  GL_ITALIC_BIT_NV                 = 0x02
;static const uint  GL_GLYPH_WIDTH_BIT_NV            = 0x01
;static const uint  GL_GLYPH_HEIGHT_BIT_NV           = 0x02
;static const uint  GL_GLYPH_HORIZONTAL_BEARING_X_BIT_NV= 0x04
;static const uint  GL_GLYPH_HORIZONTAL_BEARING_Y_BIT_NV= 0x08
;static const uint  GL_GLYPH_HORIZONTAL_BEARING_ADVANCE_BIT_NV= 0x10
;static const uint  GL_GLYPH_VERTICAL_BEARING_X_BIT_NV= 0x20
;static const uint  GL_GLYPH_VERTICAL_BEARING_Y_BIT_NV= 0x40
;static const uint  GL_GLYPH_VERTICAL_BEARING_ADVANCE_BIT_NV= 0x80
;static const uint  GL_GLYPH_HAS_KERNING_BIT_NV      = 0x100
;static const uint  GL_FONT_X_MIN_BOUNDS_BIT_NV      = 0x00010000
;static const uint  GL_FONT_Y_MIN_BOUNDS_BIT_NV      = 0x00020000
;static const uint  GL_FONT_X_MAX_BOUNDS_BIT_NV      = 0x00040000
;static const uint  GL_FONT_Y_MAX_BOUNDS_BIT_NV      = 0x00080000
;static const uint  GL_FONT_UNITS_PER_EM_BIT_NV      = 0x00100000
;static const uint  GL_FONT_ASCENDER_BIT_NV          = 0x00200000
;static const uint  GL_FONT_DESCENDER_BIT_NV         = 0x00400000
;static const uint  GL_FONT_HEIGHT_BIT_NV            = 0x00800000
;static const uint  GL_FONT_MAX_ADVANCE_WIDTH_BIT_NV = 0x01000000
;static const uint  GL_FONT_MAX_ADVANCE_HEIGHT_BIT_NV= 0x02000000
;static const uint  GL_FONT_UNDERLINE_POSITION_BIT_NV= 0x04000000
;static const uint  GL_FONT_UNDERLINE_THICKNESS_BIT_NV= 0x08000000
;static const uint  GL_FONT_HAS_KERNING_BIT_NV       = 0x10000000
/* reuse GL_PRIMARY_COLOR */
/* reuse GL_PRIMARY_COLOR_NV */
/* reuse GL_SECONDARY_COLOR_NV */


//#ifndef GL_AMD_pinned_memory
;static const uint  GL_EXTERNAL_VIRTUAL_MEMORY_BUFFER_AMD= 0x9160


//#ifndef GL_AMD_stencil_operation_extended
;static const uint  GL_SET_AMD                       = 0x874A
;static const uint  GL_REPLACE_VALUE_AMD             = 0x874B
;static const uint  GL_STENCIL_OP_VALUE_AMD          = 0x874C
;static const uint  GL_STENCIL_BACK_OP_VALUE_AMD     = 0x874D


//#ifndef GL_AMD_vertex_shader_viewport_index


//#ifndef GL_AMD_vertex_shader_layer


//#ifndef GL_NV_bindless_texture


//#ifndef GL_NV_shader_atomic_float


//#ifndef GL_AMD_query_buffer_object
;static const uint  GL_QUERY_BUFFER_AMD              = 0x9192
;static const uint  GL_QUERY_BUFFER_BINDING_AMD      = 0x9193
;static const uint  GL_QUERY_RESULT_NO_WAIT_AMD      = 0x9194


//#ifndef GL_NV_compute_program5
;static const uint  GL_COMPUTE_PROGRAM_NV            = 0x90FB
;static const uint  GL_COMPUTE_PROGRAM_PARAMETER_BUFFER_NV= 0x90FC


//#ifndef GL_NV_shader_storage_buffer_object


//#ifndef GL_NV_shader_atomic_counters


//#ifndef GL_NV_deep_texture3D
;static const uint  GL_MAX_DEEP_3D_TEXTURE_WIDTH_HEIGHT_NV= 0x90D0
;static const uint  GL_MAX_DEEP_3D_TEXTURE_DEPTH_NV  = 0x90D1


//#ifndef GL_NVX_conditional_render


//#ifndef GL_AMD_sparse_texture
;static const uint  GL_VIRTUAL_PAGE_SIZE_X_AMD       = 0x9195
;static const uint  GL_VIRTUAL_PAGE_SIZE_Y_AMD       = 0x9196
;static const uint  GL_VIRTUAL_PAGE_SIZE_Z_AMD       = 0x9197
;static const uint  GL_MAX_SPARSE_TEXTURE_SIZE_AMD   = 0x9198
;static const uint  GL_MAX_SPARSE_3D_TEXTURE_SIZE_AMD= 0x9199
;static const uint  GL_MAX_SPARSE_ARRAY_TEXTURE_LAYERS= 0x919A
;static const uint  GL_MIN_SPARSE_LEVEL_AMD          = 0x919B
;static const uint  GL_MIN_LOD_WARNING_AMD           = 0x919C
;static const uint  GL_TEXTURE_STORAGE_SPARSE_BIT_AMD= 0x00000001


//#ifndef GL_AMD_shader_trinary_minmax


//#ifndef GL_INTEL_map_texture
;static const uint  GL_TEXTURE_MEMORY_LAYOUT_INTEL   = 0x83FF
;static const uint  GL_LAYOUT_DEFAULT_INTEL          = 0
;static const uint  GL_LAYOUT_LINEAR_INTEL           = 1
;static const uint  GL_LAYOUT_LINEAR_CPU_CACHED_INTEL= 2


//#ifndef GL_NV_draw_texture
;;


// old "handwritten" definitions
/*
   static const uint GL_FRAMEBUFFER_EXT = 0x8D40;

   static const uint GL_COLOR_ATTACHMENT0_EXT = 0x8CE0;

   static const uint GL_DEPTH_COMPONENT24 = 0x81A6;
   static const uint GL_DEPTH_ATTACHMENT_EXT = 0x8D00;
   static const uint GL_RENDERBUFFER_EXT     = 0x8D41;

   static const uint GL_RGBA8_EXT = 0x8058;

   static const uint GL_FRAMEBUFFER_COMPLETE_EXT = 0x8CD5;

   static const uint GL_LINK_STATUS = 0x8B82;
   static const uint GL_INFO_LOG_LENGTH = 0x8B84;

   static const uint GL_COMPILE_STATUS = 0x8B81;

   static const uint GL_FRAGMENT_SHADER = 0x8B30;
   static const uint GL_VERTEX_SHADER   = 0x8B31;

   static const uint GL_VERTEX_ARRAY_BINDING = 0x85B5;
*/


   // Shader
   alias extern(Windows) GLuint function() TYPEGLCREATEPROGRAM;
   alias extern(Windows) void function(GLuint program) TYPEGLUSEPROGRAM;
   alias extern(Windows) void function(GLuint program, GLuint shader) TYPEGLATTACHSHADER;
   alias extern(Windows) void function(GLuint program) TYPEGLLINKPROGRAM;
   alias extern(Windows) void function(GLuint program, GLuint index, immutable(char) *name) TYPEGLBINDATTRIBLOCATION;
   alias extern(Windows) void function(GLuint program, GLuint colorNumber, immutable(char) *name) TYPEGLBINDFRAGDATALOCATION;
   alias extern(Windows) GLint function(GLuint program, immutable (char) *name) TYPEGLGETUNIFORMLOCATION;
   alias extern(Windows) void function(GLuint, GLenum, GLint *) TYPEGLUEIP; // many
   alias extern(Windows) void function(GLuint, GLsizei, GLsizei *, char *) TYPEGLUSISIPCP; // many
   alias extern(Windows) GLuint function(GLenum shaderType) TYPEGLCREATESHADER;
   alias extern(Windows) void function(GLuint shader, GLsizei count, char **string, GLint *length) TYPEGLSHADERSOURCE;
   alias extern(Windows) void function(GLuint) TYPEGLU; // GLuint

   public static TYPEGLCREATEPROGRAM glCreateProgram;
   public static TYPEGLUSEPROGRAM glUseProgram;
   public static TYPEGLATTACHSHADER glAttachShader;
   public static TYPEGLLINKPROGRAM glLinkProgram;
   public static TYPEGLBINDATTRIBLOCATION glBindAttribLocation;
   public static TYPEGLBINDFRAGDATALOCATION glBindFragDataLocation;
   public static TYPEGLGETUNIFORMLOCATION glGetUniformLocation;
   public static TYPEGLUEIP glGetProgramiv;
   public static TYPEGLUEIP glGetShaderiv;
   public static TYPEGLUSISIPCP glGetProgramInfoLog;
   public static TYPEGLUSISIPCP glGetShaderInfoLog;
   public static TYPEGLCREATESHADER glCreateShader;
   public static TYPEGLSHADERSOURCE glShaderSource;
   public static TYPEGLU glCompileShader;
   public static PFNGLDELETEPROGRAMPROC glDeleteProgram;

   alias extern(Windows) void function(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value) TYPEGLUNIFORMMATRIX4FV;

   public static TYPEGLUNIFORMMATRIX4FV glUniformMatrix4fv;

   // Buffer
   alias extern(Windows) void function(GLsizei n, GLuint *arrays) TYPEGLGENVERTEXARRAYS;
   alias extern(Windows) void function(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *pointer) TYPEGLVERTEXATTRIBPOINTER;
   alias extern(Windows) void function(GLsizei n, const GLuint *arrays) TYPEGLDELETEVERTEXARRAYS;
   alias extern(Windows) void function(GLenum target, GLuint buffer) TYPEGLBINDBUFFER;
   alias extern(Windows) void function(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage) TYPEGLBUFFERDATA;
   alias extern(Windows) void function(GLsizei n, GLuint *buffers) TYPEGLGENBUFFERS;
   alias extern(Windows) void function(GLsizei n, const GLuint *buffers) TYPEGLDELETEBUFFERS;

   alias extern(Windows) void function(GLuint program) PFNGLDELETEPROGRAMPROC;

   public static TYPEGLGENVERTEXARRAYS glGenVertexArrays;
   public static TYPEGLU glBindVertexArray;
   public static TYPEGLVERTEXATTRIBPOINTER glVertexAttribPointer;
   public static TYPEGLU glEnableVertexAttribArray;
   public static TYPEGLDELETEVERTEXARRAYS glDeleteVertexArrays;
   public static TYPEGLBINDBUFFER glBindBuffer;
   public static TYPEGLBUFFERDATA glBufferData;
   public static TYPEGLGENBUFFERS glGenBuffers;
   public static TYPEGLDELETEBUFFERS glDeleteBuffers;


	// FBO
	alias extern(Windows) void function(GLenum target, GLuint framebuffer) TYPEGLBINDFRAMEBUFFER;
	alias extern(Windows) void function(GLsizei n, const GLuint *framebuffers) TYPEGLDELETEFRAMEBUFFER;
	alias extern(Windows) void function(GLsizei n, GLuint *framebuffers) TYPEGLGENFRAMEBUFFERS;
	alias extern(Windows) GLenum function(GLenum target) TYPEGLCHECKFRAMEBUFFERSTATUS;
	alias extern(Windows) void function(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level) TYPEGLFRAMEBUFFERTEXTURE2D;
	alias extern(Windows) void function(GLenum target, GLuint renderbuffer) TYPEGLBINDRENDERBUFFER;
	alias extern(Windows) void function (GLenum target, GLenum internalformat, GLsizei width, GLsizei height) TYPEGLRENDERBUFFERSTORAGE;
	alias extern(Windows) void function (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer) TYPEGLFRAMEBUFFERRENDERBUFFER;
	alias extern(Windows) void function (GLsizei n, GLuint *renderbuffers) TYPEGLGENRENDERBUFFERS;

	public static TYPEGLBINDFRAMEBUFFER glBindFramebuffer;
	public static TYPEGLDELETEFRAMEBUFFER glDeleteFramebuffers;
	public static TYPEGLGENFRAMEBUFFERS glGenFramebuffers;
	public static TYPEGLCHECKFRAMEBUFFERSTATUS glCheckFramebufferStatus;
	public static TYPEGLFRAMEBUFFERTEXTURE2D glFramebufferTexture2D;
	public static TYPEGLBINDRENDERBUFFER glBindRenderbuffer;
	public static TYPEGLRENDERBUFFERSTORAGE glRenderbufferStorage;
	public static TYPEGLFRAMEBUFFERRENDERBUFFER glFramebufferRenderbuffer;
	public static TYPEGLGENRENDERBUFFERS glGenRenderbuffers;



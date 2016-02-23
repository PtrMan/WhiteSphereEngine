module opencl.ClGl;

import opencl.Cl;

alias cl_uint     cl_gl_object_type;
alias cl_uint     cl_gl_texture_info;
alias cl_uint     cl_gl_platform_info;
//alias struct __GLsync *cl_GLsync;

/* cl_gl_object_type = 0x2000 - 0x200F enum values are currently taken           */
;const uint CL_GL_OBJECT_BUFFER                     = 0x2000
;const uint CL_GL_OBJECT_TEXTURE2D                  = 0x2001
;const uint CL_GL_OBJECT_TEXTURE3D                  = 0x2002
;const uint CL_GL_OBJECT_RENDERBUFFER               = 0x2003
;const uint CL_GL_OBJECT_TEXTURE2D_ARRAY            = 0x200E
;const uint CL_GL_OBJECT_TEXTURE1D                  = 0x200F
;const uint CL_GL_OBJECT_TEXTURE1D_ARRAY            = 0x2010
;const uint CL_GL_OBJECT_TEXTURE_BUFFER             = 0x2011

/* cl_gl_texture_info           */
;const uint CL_GL_TEXTURE_TARGET                    = 0x2004
;const uint CL_GL_MIPMAP_LEVEL                      = 0x2005
;const uint CL_GL_NUM_SAMPLES                       = 0x2012
;;

extern (System) {
cl_mem
clCreateFromGLBuffer(cl_context     /* context */,
                     cl_mem_flags   /* flags */,
                     cl_GLuint      /* bufobj */,
                     int *          /* errcode_ret */); // CL_API_SUFFIX__VERSION_1_0;

cl_mem
clCreateFromGLTexture(cl_context      /* context */,
                      cl_mem_flags    /* flags */,
                      cl_GLenum       /* target */,
                      cl_GLint        /* miplevel */,
                      cl_GLuint       /* texture */,
                      cl_int *        /* errcode_ret */); // CL_API_SUFFIX__VERSION_1_2;
    
cl_mem
clCreateFromGLRenderbuffer(cl_context   /* context */,
                           cl_mem_flags /* flags */,
                           cl_GLuint    /* renderbuffer */,
                           cl_int *     /* errcode_ret */); // CL_API_SUFFIX__VERSION_1_0;

cl_int
clGetGLObjectInfo(cl_mem                /* memobj */,
                  cl_gl_object_type *   /* gl_object_type */,
                  cl_GLuint *           /* gl_object_name */); // CL_API_SUFFIX__VERSION_1_0;
                  
cl_int
clGetGLTextureInfo(cl_mem               /* memobj */,
                   cl_gl_texture_info   /* param_name */,
                   size_t               /* param_value_size */,
                   void *               /* param_value */,
                   size_t *             /* param_value_size_ret */); // CL_API_SUFFIX__VERSION_1_0;

cl_int
clEnqueueAcquireGLObjects(cl_command_queue      /* command_queue */,
                          cl_uint               /* num_objects */,
                          const cl_mem *        /* mem_objects */,
                          cl_uint               /* num_events_in_wait_list */,
                          const cl_event *      /* event_wait_list */,
                          cl_event *            /* event */); // CL_API_SUFFIX__VERSION_1_0;

cl_int
clEnqueueReleaseGLObjects(cl_command_queue      /* command_queue */,
                          cl_uint               /* num_objects */,
                          const cl_mem *        /* mem_objects */,
                          cl_uint               /* num_events_in_wait_list */,
                          const cl_event *      /* event_wait_list */,
                          cl_event *            /* event */); // CL_API_SUFFIX__VERSION_1_0;


/* Deprecated OpenCL 1.1 APIs */
/*CL_EXT_PREFIX__VERSION_1_1_DEPRECATED*/ cl_mem
clCreateFromGLTexture2D(cl_context      /* context */,
                        cl_mem_flags    /* flags */,
                        cl_GLenum       /* target */,
                        cl_GLint        /* miplevel */,
                        cl_GLuint       /* texture */,
                        cl_int *        /* errcode_ret */); // CL_EXT_SUFFIX__VERSION_1_1_DEPRECATED;
    
/*CL_EXT_PREFIX__VERSION_1_1_DEPRECATED*/ cl_mem
clCreateFromGLTexture3D(cl_context      /* context */,
                        cl_mem_flags    /* flags */,
                        cl_GLenum       /* target */,
                        cl_GLint        /* miplevel */,
                        cl_GLuint       /* texture */,
                        cl_int *        /* errcode_ret */); // CL_EXT_SUFFIX__VERSION_1_1_DEPRECATED;
    }
/* cl_khr_gl_sharing extension  */
    
;const uint cl_khr_gl_sharing = 1
;;
    
alias cl_uint     cl_gl_context_info;
    
/* Additional Error Codes  */
;const uint CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR  = -1000
    
/* cl_gl_context_info  */
;const uint CL_CURRENT_DEVICE_FOR_GL_CONTEXT_KHR    = 0x2006
;const uint CL_DEVICES_FOR_GL_CONTEXT_KHR           = 0x2007
    
/* Additional cl_context_properties  */
;const uint CL_GL_CONTEXT_KHR                       = 0x2008
;const uint CL_EGL_DISPLAY_KHR                      = 0x2009
;const uint CL_GLX_DISPLAY_KHR                      = 0x200A
;const uint CL_WGL_HDC_KHR                          = 0x200B
;const uint CL_CGL_SHAREGROUP_KHR                   = 0x200C
;;

extern (System) {
cl_int
clGetGLContextInfoKHR(const cl_context_properties * /* properties */,
                      cl_gl_context_info            /* param_name */,
                      size_t                        /* param_value_size */,
                      void *                        /* param_value */,
                      size_t *                      /* param_value_size_ret */); // CL_API_SUFFIX__VERSION_1_0;
}

/* TODO
typedef CL_API_ENTRY cl_int  *clGetGLContextInfoKHR_fn)(
    const cl_context_properties * properties,
    cl_gl_context_info            param_name,
    size_t                        param_value_size,
    void *                        param_value,
    size_t *                      param_value_size_ret);
*/
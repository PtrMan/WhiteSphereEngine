
./OpenClWrapper.o:     Dateiformat elf64-x86-64


Disassembly of section .text._D13OpenClWrapper13OpenClWrapper6Kernel6__ctorMFkZC13OpenClWrapper13OpenClWrapper6Kernel:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper6Kernel6__ctorMFkZC13OpenClWrapper13OpenClWrapper6Kernel>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   8:	89 75 f4             	mov    %esi,-0xc(%rbp)
   b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
   f:	8b 75 f4             	mov    -0xc(%rbp),%esi
  12:	89 77 10             	mov    %esi,0x10(%rdi)
  15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  19:	5d                   	pop    %rbp
  1a:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper6Kernel9getHandleMFZk:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper6Kernel9getHandleMFZk>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  13:	00 
  14:	74 19                	je     2f <_D13OpenClWrapper13OpenClWrapper6Kernel9getHandleMFZk+0x2f>
  16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1a:	48 89 c7             	mov    %rax,%rdi
  1d:	e8 00 00 00 00       	callq  22 <_D13OpenClWrapper13OpenClWrapper6Kernel9getHandleMFZk+0x22>
  22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  26:	8b 40 10             	mov    0x10(%rax),%eax
  29:	48 83 c4 10          	add    $0x10,%rsp
  2d:	5d                   	pop    %rbp
  2e:	c3                   	retq   
  2f:	b8 00 00 00 00       	mov    $0x0,%eax
  34:	89 c6                	mov    %eax,%esi
  36:	b8 00 00 00 00       	mov    $0x0,%eax
  3b:	89 c1                	mov    %eax,%ecx
  3d:	b8 09 00 00 00       	mov    $0x9,%eax
  42:	89 c7                	mov    %eax,%edi
  44:	b8 11 00 00 00       	mov    $0x11,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	41 b8 18 00 00 00    	mov    $0x18,%r8d
  51:	e8 00 00 00 00       	callq  56 <_D13OpenClWrapper13OpenClWrapper6Kernel9getHandleMFZk+0x56>

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  13:	00 
  14:	74 2c                	je     42 <_D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv+0x42>
  16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1a:	48 89 c7             	mov    %rax,%rdi
  1d:	e8 00 00 00 00       	callq  22 <_D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv+0x22>
  22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  26:	8b 78 10             	mov    0x10(%rax),%edi
  29:	e8 00 00 00 00       	callq  2e <_D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv+0x2e>
  2e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  32:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%rcx)
  39:	89 45 f4             	mov    %eax,-0xc(%rbp)
  3c:	48 83 c4 10          	add    $0x10,%rsp
  40:	5d                   	pop    %rbp
  41:	c3                   	retq   
  42:	b8 00 00 00 00       	mov    $0x0,%eax
  47:	89 c6                	mov    %eax,%esi
  49:	b8 00 00 00 00       	mov    $0x0,%eax
  4e:	89 c1                	mov    %eax,%ecx
  50:	b8 09 00 00 00       	mov    $0x9,%eax
  55:	89 c7                	mov    %eax,%edi
  57:	b8 11 00 00 00       	mov    $0x11,%eax
  5c:	89 c2                	mov    %eax,%edx
  5e:	41 b8 1c 00 00 00    	mov    $0x1c,%r8d
  64:	e8 00 00 00 00       	callq  69 <_D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv+0x69>

Disassembly of section .text.Th24_D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv:

0000000000000000 <Th24_D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 81 c7 e8 ff ff ff 	add    $0xffffffffffffffe8,%rdi
   b:	e8 00 00 00 00       	callq  10 <Th24_D13OpenClWrapper13OpenClWrapper6Kernel7disposeMFZv+0x10>
  10:	5d                   	pop    %rbp
  11:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper7Program12createKernelMFAyaZC13OpenClWrapper13OpenClWrapper6Kernel:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper7Program12createKernelMFAyaZC13OpenClWrapper13OpenClWrapper6Kernel>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 20          	sub    $0x20,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  10:	48 89 75 e8          	mov    %rsi,-0x18(%rbp)
  14:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  1b:	00 
  1c:	74 16                	je     34 <_D13OpenClWrapper13OpenClWrapper7Program12createKernelMFAyaZC13OpenClWrapper13OpenClWrapper6Kernel+0x34>
  1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  22:	48 89 c7             	mov    %rax,%rdi
  25:	e8 00 00 00 00       	callq  2a <_D13OpenClWrapper13OpenClWrapper7Program12createKernelMFAyaZC13OpenClWrapper13OpenClWrapper6Kernel+0x2a>
  2a:	31 c9                	xor    %ecx,%ecx
  2c:	89 c8                	mov    %ecx,%eax
  2e:	48 83 c4 20          	add    $0x20,%rsp
  32:	5d                   	pop    %rbp
  33:	c3                   	retq   
  34:	b8 00 00 00 00       	mov    $0x0,%eax
  39:	89 c6                	mov    %eax,%esi
  3b:	b8 00 00 00 00       	mov    $0x0,%eax
  40:	89 c1                	mov    %eax,%ecx
  42:	b8 09 00 00 00       	mov    $0x9,%eax
  47:	89 c7                	mov    %eax,%edi
  49:	b8 11 00 00 00       	mov    $0x11,%eax
  4e:	89 c2                	mov    %eax,%edx
  50:	41 b8 27 00 00 00    	mov    $0x27,%r8d
  56:	e8 00 00 00 00       	callq  5b <_D13OpenClWrapper13OpenClWrapper7Program12createKernelMFAyaZC13OpenClWrapper13OpenClWrapper6Kernel+0x5b>

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  13:	00 
  14:	74 2c                	je     42 <_D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv+0x42>
  16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1a:	48 89 c7             	mov    %rax,%rdi
  1d:	e8 00 00 00 00       	callq  22 <_D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv+0x22>
  22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  26:	8b 78 10             	mov    0x10(%rax),%edi
  29:	e8 00 00 00 00       	callq  2e <_D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv+0x2e>
  2e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  32:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%rcx)
  39:	89 45 f4             	mov    %eax,-0xc(%rbp)
  3c:	48 83 c4 10          	add    $0x10,%rsp
  40:	5d                   	pop    %rbp
  41:	c3                   	retq   
  42:	b8 00 00 00 00       	mov    $0x0,%eax
  47:	89 c6                	mov    %eax,%esi
  49:	b8 00 00 00 00       	mov    $0x0,%eax
  4e:	89 c1                	mov    %eax,%ecx
  50:	b8 09 00 00 00       	mov    $0x9,%eax
  55:	89 c7                	mov    %eax,%edi
  57:	b8 11 00 00 00       	mov    $0x11,%eax
  5c:	89 c2                	mov    %eax,%edx
  5e:	41 b8 2b 00 00 00    	mov    $0x2b,%r8d
  64:	e8 00 00 00 00       	callq  69 <_D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv+0x69>

Disassembly of section .text.Th24_D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv:

0000000000000000 <Th24_D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 81 c7 e8 ff ff ff 	add    $0xffffffffffffffe8,%rdi
   b:	e8 00 00 00 00       	callq  10 <Th24_D13OpenClWrapper13OpenClWrapper7Program7disposeMFZv+0x10>
  10:	5d                   	pop    %rbp
  11:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper6Buffer6getPtrMFZPk:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper6Buffer6getPtrMFZPk>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  13:	00 
  14:	74 1c                	je     32 <_D13OpenClWrapper13OpenClWrapper6Buffer6getPtrMFZPk+0x32>
  16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1a:	48 89 c7             	mov    %rax,%rdi
  1d:	e8 00 00 00 00       	callq  22 <_D13OpenClWrapper13OpenClWrapper6Buffer6getPtrMFZPk+0x22>
  22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  26:	48 05 10 00 00 00    	add    $0x10,%rax
  2c:	48 83 c4 10          	add    $0x10,%rsp
  30:	5d                   	pop    %rbp
  31:	c3                   	retq   
  32:	b8 00 00 00 00       	mov    $0x0,%eax
  37:	89 c6                	mov    %eax,%esi
  39:	b8 00 00 00 00       	mov    $0x0,%eax
  3e:	89 c1                	mov    %eax,%ecx
  40:	b8 09 00 00 00       	mov    $0x9,%eax
  45:	89 c7                	mov    %eax,%edi
  47:	b8 11 00 00 00       	mov    $0x11,%eax
  4c:	89 c2                	mov    %eax,%edx
  4e:	41 b8 5e 00 00 00    	mov    $0x5e,%r8d
  54:	e8 00 00 00 00       	callq  59 <_D13OpenClWrapper13OpenClWrapper6Buffer6getPtrMFZPk+0x59>

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper5Image9getHandleMFZk:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper5Image9getHandleMFZk>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  13:	00 
  14:	74 19                	je     2f <_D13OpenClWrapper13OpenClWrapper5Image9getHandleMFZk+0x2f>
  16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1a:	48 89 c7             	mov    %rax,%rdi
  1d:	e8 00 00 00 00       	callq  22 <_D13OpenClWrapper13OpenClWrapper5Image9getHandleMFZk+0x22>
  22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  26:	8b 40 10             	mov    0x10(%rax),%eax
  29:	48 83 c4 10          	add    $0x10,%rsp
  2d:	5d                   	pop    %rbp
  2e:	c3                   	retq   
  2f:	b8 00 00 00 00       	mov    $0x0,%eax
  34:	89 c6                	mov    %eax,%esi
  36:	b8 00 00 00 00       	mov    $0x0,%eax
  3b:	89 c1                	mov    %eax,%ecx
  3d:	b8 09 00 00 00       	mov    $0x9,%eax
  42:	89 c7                	mov    %eax,%edi
  44:	b8 11 00 00 00       	mov    $0x11,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	41 b8 6b 00 00 00    	mov    $0x6b,%r8d
  51:	e8 00 00 00 00       	callq  56 <_D13OpenClWrapper13OpenClWrapper5Image9getHandleMFZk+0x56>

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper6__dtorMFZv:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper6__dtorMFZv>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  10:	48 8b 3f             	mov    (%rdi),%rdi
  13:	48 8b 7f 48          	mov    0x48(%rdi),%rdi
  17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1b:	48 89 7d f0          	mov    %rdi,-0x10(%rbp)
  1f:	48 89 c7             	mov    %rax,%rdi
  22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  26:	ff d0                	callq  *%rax
  28:	48 83 c4 10          	add    $0x10,%rsp
  2c:	5d                   	pop    %rbp
  2d:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper7disposeMFZv:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper7disposeMFZv>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  13:	00 
  14:	74 1b                	je     31 <_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x31>
  16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1a:	48 89 c7             	mov    %rax,%rdi
  1d:	e8 00 00 00 00       	callq  22 <_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x22>
  22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  26:	81 78 10 00 00 00 00 	cmpl   $0x0,0x10(%rax)
  2d:	75 29                	jne    58 <_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x58>
  2f:	eb 41                	jmp    72 <_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x72>
  31:	b8 00 00 00 00       	mov    $0x0,%eax
  36:	89 c6                	mov    %eax,%esi
  38:	b8 00 00 00 00       	mov    $0x0,%eax
  3d:	89 c1                	mov    %eax,%ecx
  3f:	b8 09 00 00 00       	mov    $0x9,%eax
  44:	89 c7                	mov    %eax,%edi
  46:	b8 11 00 00 00       	mov    $0x11,%eax
  4b:	89 c2                	mov    %eax,%edx
  4d:	41 b8 b4 01 00 00    	mov    $0x1b4,%r8d
  53:	e8 00 00 00 00       	callq  58 <_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x58>
  58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  5c:	8b 78 10             	mov    0x10(%rax),%edi
  5f:	e8 00 00 00 00       	callq  64 <_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x64>
  64:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  68:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%rcx)
  6f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  76:	81 78 14 00 00 00 00 	cmpl   $0x0,0x14(%rax)
  7d:	74 1a                	je     99 <_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x99>
  7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  83:	8b 78 14             	mov    0x14(%rax),%edi
  86:	e8 00 00 00 00       	callq  8b <_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x8b>
  8b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8f:	c7 41 14 00 00 00 00 	movl   $0x0,0x14(%rcx)
  96:	89 45 f0             	mov    %eax,-0x10(%rbp)
  99:	48 83 c4 10          	add    $0x10,%rsp
  9d:	5d                   	pop    %rbp
  9e:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 81 ec c0 01 00 00 	sub    $0x1c0,%rsp
   b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  13:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  1a:	00 
  1b:	74 3a                	je     57 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x57>
  1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  21:	48 89 c7             	mov    %rax,%rdi
  24:	e8 00 00 00 00       	callq  29 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x29>
  29:	31 ff                	xor    %edi,%edi
  2b:	31 c9                	xor    %ecx,%ecx
  2d:	89 ce                	mov    %ecx,%esi
  2f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  3a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  41:	e8 00 00 00 00       	callq  46 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x46>
  46:	89 45 ec             	mov    %eax,-0x14(%rbp)
  49:	81 7d ec 00 00 00 00 	cmpl   $0x0,-0x14(%rbp)
  50:	75 2c                	jne    7e <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x7e>
  52:	e9 ca 00 00 00       	jmpq   121 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x121>
  57:	b8 00 00 00 00       	mov    $0x0,%eax
  5c:	89 c6                	mov    %eax,%esi
  5e:	b8 00 00 00 00       	mov    $0x0,%eax
  63:	89 c1                	mov    %eax,%ecx
  65:	b8 09 00 00 00       	mov    $0x9,%eax
  6a:	89 c7                	mov    %eax,%edi
  6c:	b8 11 00 00 00       	mov    $0x11,%eax
  71:	89 c2                	mov    %eax,%edx
  73:	41 b8 76 00 00 00    	mov    $0x76,%r8d
  79:	e8 00 00 00 00       	callq  7e <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x7e>
  7e:	b8 7e 00 00 00       	mov    $0x7e,%eax
  83:	8b 7d ec             	mov    -0x14(%rbp),%edi
  86:	89 85 6c ff ff ff    	mov    %eax,-0x94(%rbp)
  8c:	e8 00 00 00 00       	callq  91 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x91>
  91:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  95:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  99:	48 8b 7d f0          	mov    -0x10(%rbp),%rdi
  9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  a2:	89 c8                	mov    %ecx,%eax
  a4:	b9 01 00 00 00       	mov    $0x1,%ecx
  a9:	89 ce                	mov    %ecx,%esi
  ab:	48 89 bd 60 ff ff ff 	mov    %rdi,-0xa0(%rbp)
  b2:	48 89 c7             	mov    %rax,%rdi
  b5:	e8 00 00 00 00       	callq  ba <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0xba>
  ba:	0f 10 45 d8          	movups -0x28(%rbp),%xmm0
  be:	0f 11 02             	movups %xmm0,(%rdx)
  c1:	48 89 e6             	mov    %rsp,%rsi
  c4:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
  cb:	00 
  cc:	48 c7 06 31 00 00 00 	movq   $0x31,(%rsi)
  d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  d8:	41 b8 11 00 00 00    	mov    $0x11,%r8d
  de:	44 89 c6             	mov    %r8d,%esi
  e1:	41 b8 7e 00 00 00    	mov    $0x7e,%r8d
  e7:	48 8b bd 60 ff ff ff 	mov    -0xa0(%rbp),%rdi
  ee:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  f5:	44 89 c6             	mov    %r8d,%esi
  f8:	4c 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%r9
  ff:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
 106:	4c 89 ca             	mov    %r9,%rdx
 109:	49 89 c0             	mov    %rax,%r8
 10c:	4c 8b 8d 50 ff ff ff 	mov    -0xb0(%rbp),%r9
 113:	e8 00 00 00 00       	callq  118 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x118>
 118:	48 81 c4 c0 01 00 00 	add    $0x1c0,%rsp
 11f:	5d                   	pop    %rbp
 120:	c3                   	retq   
 121:	81 7d e8 00 00 00 00 	cmpl   $0x0,-0x18(%rbp)
 128:	75 53                	jne    17d <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x17d>
 12a:	b8 83 00 00 00       	mov    $0x83,%eax
 12f:	48 8b 7d f0          	mov    -0x10(%rbp),%rdi
 133:	48 89 e1             	mov    %rsp,%rcx
 136:	48 c7 41 08 00 00 00 	movq   $0x0,0x8(%rcx)
 13d:	00 
 13e:	48 c7 01 17 00 00 00 	movq   $0x17,(%rcx)
 145:	ba 00 00 00 00       	mov    $0x0,%edx
 14a:	89 d1                	mov    %edx,%ecx
 14c:	ba 11 00 00 00       	mov    $0x11,%edx
 151:	31 f6                	xor    %esi,%esi
 153:	41 89 f0             	mov    %esi,%r8d
 156:	be 83 00 00 00       	mov    $0x83,%esi
 15b:	4c 89 85 48 ff ff ff 	mov    %r8,-0xb8(%rbp)
 162:	4c 8b 8d 48 ff ff ff 	mov    -0xb8(%rbp),%r9
 169:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%rbp)
 16f:	e8 00 00 00 00       	callq  174 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x174>
 174:	48 81 c4 c0 01 00 00 	add    $0x1c0,%rsp
 17b:	5d                   	pop    %rbp
 17c:	c3                   	retq   
 17d:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
 184:	00 00 00 
 187:	8b 45 e8             	mov    -0x18(%rbp),%eax
 18a:	89 c6                	mov    %eax,%esi
 18c:	e8 00 00 00 00       	callq  191 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x191>
 191:	31 c9                	xor    %ecx,%ecx
 193:	89 ce                	mov    %ecx,%esi
 195:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
 199:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
 19d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
 1a1:	8b 7d e8             	mov    -0x18(%rbp),%edi
 1a4:	48 89 b5 38 ff ff ff 	mov    %rsi,-0xc8(%rbp)
 1ab:	48 89 c6             	mov    %rax,%rsi
 1ae:	48 8b 95 38 ff ff ff 	mov    -0xc8(%rbp),%rdx
 1b5:	e8 00 00 00 00       	callq  1ba <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x1ba>
 1ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
 1bd:	81 7d ec 00 00 00 00 	cmpl   $0x0,-0x14(%rbp)
 1c4:	0f 84 a3 00 00 00    	je     26d <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x26d>
 1ca:	b8 8e 00 00 00       	mov    $0x8e,%eax
 1cf:	8b 7d ec             	mov    -0x14(%rbp),%edi
 1d2:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%rbp)
 1d8:	e8 00 00 00 00       	callq  1dd <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x1dd>
 1dd:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
 1e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 1e5:	48 8b 7d f0          	mov    -0x10(%rbp),%rdi
 1e9:	b9 00 00 00 00       	mov    $0x0,%ecx
 1ee:	89 c8                	mov    %ecx,%eax
 1f0:	b9 01 00 00 00       	mov    $0x1,%ecx
 1f5:	89 ce                	mov    %ecx,%esi
 1f7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
 1fe:	48 89 c7             	mov    %rax,%rdi
 201:	e8 00 00 00 00       	callq  206 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x206>
 206:	0f 10 45 b8          	movups -0x48(%rbp),%xmm0
 20a:	0f 11 02             	movups %xmm0,(%rdx)
 20d:	48 89 e6             	mov    %rsp,%rsi
 210:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
 217:	00 
 218:	48 c7 06 27 00 00 00 	movq   $0x27,(%rsi)
 21f:	b9 00 00 00 00       	mov    $0x0,%ecx
 224:	41 b8 11 00 00 00    	mov    $0x11,%r8d
 22a:	44 89 c6             	mov    %r8d,%esi
 22d:	41 b8 8e 00 00 00    	mov    $0x8e,%r8d
 233:	48 8b bd 28 ff ff ff 	mov    -0xd8(%rbp),%rdi
 23a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
 241:	44 89 c6             	mov    %r8d,%esi
 244:	4c 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%r9
 24b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
 252:	4c 89 ca             	mov    %r9,%rdx
 255:	49 89 c0             	mov    %rax,%r8
 258:	4c 8b 8d 18 ff ff ff 	mov    -0xe8(%rbp),%r9
 25f:	e8 00 00 00 00       	callq  264 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x264>
 264:	48 81 c4 c0 01 00 00 	add    $0x1c0,%rsp
 26b:	5d                   	pop    %rbp
 26c:	c3                   	retq   
 26d:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
 274:	00 00 00 
 277:	b8 07 00 00 00       	mov    $0x7,%eax
 27c:	89 c6                	mov    %eax,%esi
 27e:	e8 00 00 00 00       	callq  283 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x283>
 283:	31 c9                	xor    %ecx,%ecx
 285:	89 ce                	mov    %ecx,%esi
 287:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
 28b:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
 28f:	48 3b 75 a8          	cmp    -0x58(%rbp),%rsi
 293:	72 18                	jb     2ad <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x2ad>
 295:	b8 00 00 00 00       	mov    $0x0,%eax
 29a:	89 c6                	mov    %eax,%esi
 29c:	b8 11 00 00 00       	mov    $0x11,%eax
 2a1:	89 c7                	mov    %eax,%edi
 2a3:	ba ad 00 00 00       	mov    $0xad,%edx
 2a8:	e8 00 00 00 00       	callq  2ad <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x2ad>
 2ad:	b8 01 00 00 00       	mov    $0x1,%eax
 2b2:	89 c1                	mov    %eax,%ecx
 2b4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
 2b8:	c7 02 84 10 00 00    	movl   $0x1084,(%rdx)
 2be:	48 3b 4d a8          	cmp    -0x58(%rbp),%rcx
 2c2:	72 18                	jb     2dc <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x2dc>
 2c4:	b8 00 00 00 00       	mov    $0x0,%eax
 2c9:	89 c6                	mov    %eax,%esi
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	89 c7                	mov    %eax,%edi
 2d2:	ba ae 00 00 00       	mov    $0xae,%edx
 2d7:	e8 00 00 00 00       	callq  2dc <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x2dc>
 2dc:	31 c0                	xor    %eax,%eax
 2de:	89 c1                	mov    %eax,%ecx
 2e0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
 2e4:	48 81 c2 04 00 00 00 	add    $0x4,%rdx
 2eb:	48 3b 4d c8          	cmp    -0x38(%rbp),%rcx
 2ef:	48 89 95 10 ff ff ff 	mov    %rdx,-0xf0(%rbp)
 2f6:	72 18                	jb     310 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x310>
 2f8:	b8 00 00 00 00       	mov    $0x0,%eax
 2fd:	89 c6                	mov    %eax,%esi
 2ff:	b8 11 00 00 00       	mov    $0x11,%eax
 304:	89 c7                	mov    %eax,%edi
 306:	ba ae 00 00 00       	mov    $0xae,%edx
 30b:	e8 00 00 00 00       	callq  310 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x310>
 310:	b8 02 00 00 00       	mov    $0x2,%eax
 315:	89 c1                	mov    %eax,%ecx
 317:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
 31b:	8b 02                	mov    (%rdx),%eax
 31d:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
 324:	89 02                	mov    %eax,(%rdx)
 326:	48 3b 4d a8          	cmp    -0x58(%rbp),%rcx
 32a:	72 18                	jb     344 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x344>
 32c:	b8 00 00 00 00       	mov    $0x0,%eax
 331:	89 c6                	mov    %eax,%esi
 333:	b8 11 00 00 00       	mov    $0x11,%eax
 338:	89 c7                	mov    %eax,%edi
 33a:	ba b3 00 00 00       	mov    $0xb3,%edx
 33f:	e8 00 00 00 00       	callq  344 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x344>
 344:	b8 03 00 00 00       	mov    $0x3,%eax
 349:	89 c1                	mov    %eax,%ecx
 34b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
 34f:	c7 42 08 08 20 00 00 	movl   $0x2008,0x8(%rdx)
 356:	48 3b 4d a8          	cmp    -0x58(%rbp),%rcx
 35a:	72 18                	jb     374 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x374>
 35c:	b8 00 00 00 00       	mov    $0x0,%eax
 361:	89 c6                	mov    %eax,%esi
 363:	b8 11 00 00 00       	mov    $0x11,%eax
 368:	89 c7                	mov    %eax,%edi
 36a:	ba b4 00 00 00       	mov    $0xb4,%edx
 36f:	e8 00 00 00 00       	callq  374 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x374>
 374:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
 378:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
 37f:	e8 00 00 00 00       	callq  384 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x384>
 384:	b9 04 00 00 00       	mov    $0x4,%ecx
 389:	89 ca                	mov    %ecx,%edx
 38b:	89 c1                	mov    %eax,%ecx
 38d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
 394:	89 48 0c             	mov    %ecx,0xc(%rax)
 397:	48 3b 55 a8          	cmp    -0x58(%rbp),%rdx
 39b:	72 18                	jb     3b5 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x3b5>
 39d:	b8 00 00 00 00       	mov    $0x0,%eax
 3a2:	89 c6                	mov    %eax,%esi
 3a4:	b8 11 00 00 00       	mov    $0x11,%eax
 3a9:	89 c7                	mov    %eax,%edi
 3ab:	ba b5 00 00 00       	mov    $0xb5,%edx
 3b0:	e8 00 00 00 00       	callq  3b5 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x3b5>
 3b5:	b8 05 00 00 00       	mov    $0x5,%eax
 3ba:	89 c1                	mov    %eax,%ecx
 3bc:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
 3c0:	c7 42 10 0a 20 00 00 	movl   $0x200a,0x10(%rdx)
 3c7:	48 3b 4d a8          	cmp    -0x58(%rbp),%rcx
 3cb:	72 18                	jb     3e5 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x3e5>
 3cd:	b8 00 00 00 00       	mov    $0x0,%eax
 3d2:	89 c6                	mov    %eax,%esi
 3d4:	b8 11 00 00 00       	mov    $0x11,%eax
 3d9:	89 c7                	mov    %eax,%edi
 3db:	ba b6 00 00 00       	mov    $0xb6,%edx
 3e0:	e8 00 00 00 00       	callq  3e5 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x3e5>
 3e5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
 3e9:	48 89 85 00 ff ff ff 	mov    %rax,-0x100(%rbp)
 3f0:	e8 00 00 00 00       	callq  3f5 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x3f5>
 3f5:	b9 06 00 00 00       	mov    $0x6,%ecx
 3fa:	89 ca                	mov    %ecx,%edx
 3fc:	89 c1                	mov    %eax,%ecx
 3fe:	48 8b 85 00 ff ff ff 	mov    -0x100(%rbp),%rax
 405:	89 48 14             	mov    %ecx,0x14(%rax)
 408:	48 3b 55 a8          	cmp    -0x58(%rbp),%rdx
 40c:	72 18                	jb     426 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x426>
 40e:	b8 00 00 00 00       	mov    $0x0,%eax
 413:	89 c6                	mov    %eax,%esi
 415:	b8 11 00 00 00       	mov    $0x11,%eax
 41a:	89 c7                	mov    %eax,%edi
 41c:	ba b8 00 00 00       	mov    $0xb8,%edx
 421:	e8 00 00 00 00       	callq  426 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x426>
 426:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
 42a:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
 431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 435:	48 8b 7d b0          	mov    -0x50(%rbp),%rdi
 439:	b9 04 00 00 00       	mov    $0x4,%ecx
 43e:	89 ce                	mov    %ecx,%esi
 440:	31 c9                	xor    %ecx,%ecx
 442:	89 ca                	mov    %ecx,%edx
 444:	4c 8d 45 ec          	lea    -0x14(%rbp),%r8
 448:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
 44f:	48 8b 8d f8 fe ff ff 	mov    -0x108(%rbp),%rcx
 456:	48 89 85 f0 fe ff ff 	mov    %rax,-0x110(%rbp)
 45d:	e8 00 00 00 00       	callq  462 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x462>
 462:	48 8b 8d f0 fe ff ff 	mov    -0x110(%rbp),%rcx
 469:	89 41 10             	mov    %eax,0x10(%rcx)
 46c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
 470:	8b 41 10             	mov    0x10(%rcx),%eax
 473:	85 c0                	test   %eax,%eax
 475:	41 0f 95 c1          	setne  %r9b
 479:	44 88 8d ef fe ff ff 	mov    %r9b,-0x111(%rbp)
 480:	0f 85 a5 00 00 00    	jne    52b <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x52b>
 486:	eb 00                	jmp    488 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x488>
 488:	b8 bf 00 00 00       	mov    $0xbf,%eax
 48d:	8b 7d ec             	mov    -0x14(%rbp),%edi
 490:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%rbp)
 496:	e8 00 00 00 00       	callq  49b <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x49b>
 49b:	48 89 45 98          	mov    %rax,-0x68(%rbp)
 49f:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 4a3:	48 8b 7d f0          	mov    -0x10(%rbp),%rdi
 4a7:	b9 00 00 00 00       	mov    $0x0,%ecx
 4ac:	89 c8                	mov    %ecx,%eax
 4ae:	b9 01 00 00 00       	mov    $0x1,%ecx
 4b3:	89 ce                	mov    %ecx,%esi
 4b5:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 4bc:	48 89 c7             	mov    %rax,%rdi
 4bf:	e8 00 00 00 00       	callq  4c4 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x4c4>
 4c4:	0f 10 45 98          	movups -0x68(%rbp),%xmm0
 4c8:	0f 11 02             	movups %xmm0,(%rdx)
 4cb:	48 89 e6             	mov    %rsp,%rsi
 4ce:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
 4d5:	00 
 4d6:	48 c7 06 21 00 00 00 	movq   $0x21,(%rsi)
 4dd:	b9 00 00 00 00       	mov    $0x0,%ecx
 4e2:	41 b8 11 00 00 00    	mov    $0x11,%r8d
 4e8:	44 89 c6             	mov    %r8d,%esi
 4eb:	41 b8 bf 00 00 00    	mov    $0xbf,%r8d
 4f1:	48 8b bd e0 fe ff ff 	mov    -0x120(%rbp),%rdi
 4f8:	48 89 b5 d8 fe ff ff 	mov    %rsi,-0x128(%rbp)
 4ff:	44 89 c6             	mov    %r8d,%esi
 502:	4c 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%r9
 509:	48 89 95 d0 fe ff ff 	mov    %rdx,-0x130(%rbp)
 510:	4c 89 ca             	mov    %r9,%rdx
 513:	49 89 c0             	mov    %rax,%r8
 516:	4c 8b 8d d0 fe ff ff 	mov    -0x130(%rbp),%r9
 51d:	e8 00 00 00 00       	callq  522 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x522>
 522:	48 81 c4 c0 01 00 00 	add    $0x1c0,%rsp
 529:	5d                   	pop    %rbp
 52a:	c3                   	retq   
 52b:	be 81 10 00 00       	mov    $0x1081,%esi
 530:	31 c0                	xor    %eax,%eax
 532:	89 c1                	mov    %eax,%ecx
 534:	4c 8d 45 90          	lea    -0x70(%rbp),%r8
 538:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
 53f:	00 
 540:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
 544:	8b 7a 10             	mov    0x10(%rdx),%edi
 547:	48 89 ca             	mov    %rcx,%rdx
 54a:	e8 00 00 00 00       	callq  54f <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x54f>
 54f:	89 45 ec             	mov    %eax,-0x14(%rbp)
 552:	81 7d ec 00 00 00 00 	cmpl   $0x0,-0x14(%rbp)
 559:	0f 84 a3 00 00 00    	je     602 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x602>
 55f:	b8 c9 00 00 00       	mov    $0xc9,%eax
 564:	8b 7d ec             	mov    -0x14(%rbp),%edi
 567:	89 85 cc fe ff ff    	mov    %eax,-0x134(%rbp)
 56d:	e8 00 00 00 00       	callq  572 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x572>
 572:	48 89 45 80          	mov    %rax,-0x80(%rbp)
 576:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
 57a:	48 8b 7d f0          	mov    -0x10(%rbp),%rdi
 57e:	b9 00 00 00 00       	mov    $0x0,%ecx
 583:	89 c8                	mov    %ecx,%eax
 585:	b9 01 00 00 00       	mov    $0x1,%ecx
 58a:	89 ce                	mov    %ecx,%esi
 58c:	48 89 bd c0 fe ff ff 	mov    %rdi,-0x140(%rbp)
 593:	48 89 c7             	mov    %rax,%rdi
 596:	e8 00 00 00 00       	callq  59b <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x59b>
 59b:	0f 10 45 80          	movups -0x80(%rbp),%xmm0
 59f:	0f 11 02             	movups %xmm0,(%rdx)
 5a2:	48 89 e6             	mov    %rsp,%rsi
 5a5:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
 5ac:	00 
 5ad:	48 c7 06 23 00 00 00 	movq   $0x23,(%rsi)
 5b4:	b9 00 00 00 00       	mov    $0x0,%ecx
 5b9:	41 b8 11 00 00 00    	mov    $0x11,%r8d
 5bf:	44 89 c6             	mov    %r8d,%esi
 5c2:	41 b8 c9 00 00 00    	mov    $0xc9,%r8d
 5c8:	48 8b bd c0 fe ff ff 	mov    -0x140(%rbp),%rdi
 5cf:	48 89 b5 b8 fe ff ff 	mov    %rsi,-0x148(%rbp)
 5d6:	44 89 c6             	mov    %r8d,%esi
 5d9:	4c 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%r9
 5e0:	48 89 95 b0 fe ff ff 	mov    %rdx,-0x150(%rbp)
 5e7:	4c 89 ca             	mov    %r9,%rdx
 5ea:	49 89 c0             	mov    %rax,%r8
 5ed:	4c 8b 8d b0 fe ff ff 	mov    -0x150(%rbp),%r9
 5f4:	e8 00 00 00 00       	callq  5f9 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x5f9>
 5f9:	48 81 c4 c0 01 00 00 	add    $0x1c0,%rsp
 600:	5d                   	pop    %rbp
 601:	c3                   	retq   
 602:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
 609:	00 00 00 
 60c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 610:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
 614:	48 c1 e9 02          	shr    $0x2,%rcx
 618:	48 89 ce             	mov    %rcx,%rsi
 61b:	48 89 85 a8 fe ff ff 	mov    %rax,-0x158(%rbp)
 622:	e8 00 00 00 00       	callq  627 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x627>
 627:	be 81 10 00 00       	mov    $0x1081,%esi
 62c:	45 31 c0             	xor    %r8d,%r8d
 62f:	48 8b 8d a8 fe ff ff 	mov    -0x158(%rbp),%rcx
 636:	48 89 41 18          	mov    %rax,0x18(%rcx)
 63a:	48 89 51 20          	mov    %rdx,0x20(%rcx)
 63e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
 642:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
 646:	48 8b 52 20          	mov    0x20(%rdx),%rdx
 64a:	8b 78 10             	mov    0x10(%rax),%edi
 64d:	48 8b 45 90          	mov    -0x70(%rbp),%rax
 651:	48 89 95 a0 fe ff ff 	mov    %rdx,-0x160(%rbp)
 658:	48 89 c2             	mov    %rax,%rdx
 65b:	48 8b 8d a0 fe ff ff 	mov    -0x160(%rbp),%rcx
 662:	e8 00 00 00 00       	callq  667 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x667>
 667:	89 45 ec             	mov    %eax,-0x14(%rbp)
 66a:	81 7d ec 00 00 00 00 	cmpl   $0x0,-0x14(%rbp)
 671:	0f 84 ac 00 00 00    	je     723 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x723>
 677:	b8 d2 00 00 00       	mov    $0xd2,%eax
 67c:	8b 7d ec             	mov    -0x14(%rbp),%edi
 67f:	89 85 9c fe ff ff    	mov    %eax,-0x164(%rbp)
 685:	e8 00 00 00 00       	callq  68a <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x68a>
 68a:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
 691:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
 698:	48 8b 7d f0          	mov    -0x10(%rbp),%rdi
 69c:	b9 00 00 00 00       	mov    $0x0,%ecx
 6a1:	89 c8                	mov    %ecx,%eax
 6a3:	b9 01 00 00 00       	mov    $0x1,%ecx
 6a8:	89 ce                	mov    %ecx,%esi
 6aa:	48 89 bd 90 fe ff ff 	mov    %rdi,-0x170(%rbp)
 6b1:	48 89 c7             	mov    %rax,%rdi
 6b4:	e8 00 00 00 00       	callq  6b9 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x6b9>
 6b9:	0f 10 85 70 ff ff ff 	movups -0x90(%rbp),%xmm0
 6c0:	0f 11 02             	movups %xmm0,(%rdx)
 6c3:	48 89 e6             	mov    %rsp,%rsi
 6c6:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
 6cd:	00 
 6ce:	48 c7 06 23 00 00 00 	movq   $0x23,(%rsi)
 6d5:	b9 00 00 00 00       	mov    $0x0,%ecx
 6da:	41 b8 11 00 00 00    	mov    $0x11,%r8d
 6e0:	44 89 c6             	mov    %r8d,%esi
 6e3:	41 b8 d2 00 00 00    	mov    $0xd2,%r8d
 6e9:	48 8b bd 90 fe ff ff 	mov    -0x170(%rbp),%rdi
 6f0:	48 89 b5 88 fe ff ff 	mov    %rsi,-0x178(%rbp)
 6f7:	44 89 c6             	mov    %r8d,%esi
 6fa:	4c 8b 8d 88 fe ff ff 	mov    -0x178(%rbp),%r9
 701:	48 89 95 80 fe ff ff 	mov    %rdx,-0x180(%rbp)
 708:	4c 89 ca             	mov    %r9,%rdx
 70b:	49 89 c0             	mov    %rax,%r8
 70e:	4c 8b 8d 80 fe ff ff 	mov    -0x180(%rbp),%r9
 715:	e8 00 00 00 00       	callq  71a <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x71a>
 71a:	48 81 c4 c0 01 00 00 	add    $0x1c0,%rsp
 721:	5d                   	pop    %rbp
 722:	c3                   	retq   
 723:	31 c0                	xor    %eax,%eax
 725:	89 c1                	mov    %eax,%ecx
 727:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
 72b:	48 81 c2 14 00 00 00 	add    $0x14,%rdx
 732:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
 736:	48 81 c6 10 00 00 00 	add    $0x10,%rsi
 73d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 741:	49 89 f8             	mov    %rdi,%r8
 744:	49 81 c0 18 00 00 00 	add    $0x18,%r8
 74b:	48 3b 4f 18          	cmp    0x18(%rdi),%rcx
 74f:	4c 89 85 78 fe ff ff 	mov    %r8,-0x188(%rbp)
 756:	48 89 95 70 fe ff ff 	mov    %rdx,-0x190(%rbp)
 75d:	48 89 b5 68 fe ff ff 	mov    %rsi,-0x198(%rbp)
 764:	72 18                	jb     77e <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x77e>
 766:	b8 00 00 00 00       	mov    $0x0,%eax
 76b:	89 c6                	mov    %eax,%esi
 76d:	b8 11 00 00 00       	mov    $0x11,%eax
 772:	89 c7                	mov    %eax,%edi
 774:	ba da 00 00 00       	mov    $0xda,%edx
 779:	e8 00 00 00 00       	callq  77e <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x77e>
 77e:	48 8b 85 78 fe ff ff 	mov    -0x188(%rbp),%rax
 785:	48 8b 48 08          	mov    0x8(%rax),%rcx
 789:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
 790:	8b 3a                	mov    (%rdx),%edi
 792:	8b 31                	mov    (%rcx),%esi
 794:	41 b8 02 00 00 00    	mov    $0x2,%r8d
 79a:	44 89 c2             	mov    %r8d,%edx
 79d:	45 31 c0             	xor    %r8d,%r8d
 7a0:	44 89 c1             	mov    %r8d,%ecx
 7a3:	e8 00 00 00 00       	callq  7a8 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x7a8>
 7a8:	48 8b 8d 70 fe ff ff 	mov    -0x190(%rbp),%rcx
 7af:	89 01                	mov    %eax,(%rcx)
 7b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
 7b5:	8b 42 14             	mov    0x14(%rdx),%eax
 7b8:	85 c0                	test   %eax,%eax
 7ba:	41 0f 95 c1          	setne  %r9b
 7be:	44 88 8d 67 fe ff ff 	mov    %r9b,-0x199(%rbp)
 7c5:	75 55                	jne    81c <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x81c>
 7c7:	eb 00                	jmp    7c9 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x7c9>
 7c9:	b8 e0 00 00 00       	mov    $0xe0,%eax
 7ce:	48 8b 7d f0          	mov    -0x10(%rbp),%rdi
 7d2:	48 89 e1             	mov    %rsp,%rcx
 7d5:	48 c7 41 08 00 00 00 	movq   $0x0,0x8(%rcx)
 7dc:	00 
 7dd:	48 c7 01 22 00 00 00 	movq   $0x22,(%rcx)
 7e4:	ba 00 00 00 00       	mov    $0x0,%edx
 7e9:	89 d1                	mov    %edx,%ecx
 7eb:	ba 11 00 00 00       	mov    $0x11,%edx
 7f0:	31 f6                	xor    %esi,%esi
 7f2:	41 89 f0             	mov    %esi,%r8d
 7f5:	be e0 00 00 00       	mov    $0xe0,%esi
 7fa:	4c 89 85 58 fe ff ff 	mov    %r8,-0x1a8(%rbp)
 801:	4c 8b 8d 58 fe ff ff 	mov    -0x1a8(%rbp),%r9
 808:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%rbp)
 80e:	e8 00 00 00 00       	callq  813 <_D13OpenClWrapper13OpenClWrapper6aquireMFC10ErrorStack10ErrorStackZv+0x813>
 813:	48 81 c4 c0 01 00 00 	add    $0x1c0,%rsp
 81a:	5d                   	pop    %rbp
 81b:	c3                   	retq   
 81c:	48 81 c4 c0 01 00 00 	add    $0x1c0,%rsp
 823:	5d                   	pop    %rbp
 824:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper12getErrorTextFiZAya:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper12getErrorTextFiZAya>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	89 7d fc             	mov    %edi,-0x4(%rbp)
   7:	89 f8                	mov    %edi,%eax
   9:	83 ef bb             	sub    $0xffffffbb,%edi
   c:	89 45 f8             	mov    %eax,-0x8(%rbp)
   f:	89 7d f4             	mov    %edi,-0xc(%rbp)
  12:	7f 26                	jg     3a <_D13OpenClWrapper13OpenClWrapper12getErrorTextFiZAya+0x3a>
  14:	eb 00                	jmp    16 <_D13OpenClWrapper13OpenClWrapper12getErrorTextFiZAya+0x16>
  16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  19:	05 ed 03 00 00       	add    $0x3ed,%eax
  1e:	89 c1                	mov    %eax,%ecx
  20:	83 e8 05             	sub    $0x5,%eax
  23:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  27:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  2a:	77 30                	ja     5c <_D13OpenClWrapper13OpenClWrapper12getErrorTextFiZAya+0x5c>
  2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  30:	48 8b 0c c5 00 00 00 	mov    0x0(,%rax,8),%rcx
  37:	00 
  38:	ff e1                	jmpq   *%rcx
  3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  3d:	83 c0 44             	add    $0x44,%eax
  40:	89 c1                	mov    %eax,%ecx
  42:	83 e8 44             	sub    $0x44,%eax
  45:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  49:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  4c:	77 0e                	ja     5c <_D13OpenClWrapper13OpenClWrapper12getErrorTextFiZAya+0x5c>
  4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  52:	48 8b 0c c5 00 00 00 	mov    0x0(,%rax,8),%rcx
  59:	00 
  5a:	ff e1                	jmpq   *%rcx
  5c:	e9 8e 03 00 00       	jmpq   3ef <_D13OpenClWrapper13OpenClWrapper12getErrorTextFiZAya+0x3ef>
  61:	b8 00 00 00 00       	mov    $0x0,%eax
  66:	89 c2                	mov    %eax,%edx
  68:	b8 0a 00 00 00       	mov    $0xa,%eax
  6d:	5d                   	pop    %rbp
  6e:	c3                   	retq   
  6f:	b8 00 00 00 00       	mov    $0x0,%eax
  74:	89 c2                	mov    %eax,%edx
  76:	b8 13 00 00 00       	mov    $0x13,%eax
  7b:	5d                   	pop    %rbp
  7c:	c3                   	retq   
  7d:	b8 00 00 00 00       	mov    $0x0,%eax
  82:	89 c2                	mov    %eax,%edx
  84:	b8 17 00 00 00       	mov    $0x17,%eax
  89:	5d                   	pop    %rbp
  8a:	c3                   	retq   
  8b:	b8 00 00 00 00       	mov    $0x0,%eax
  90:	89 c2                	mov    %eax,%edx
  92:	b8 19 00 00 00       	mov    $0x19,%eax
  97:	5d                   	pop    %rbp
  98:	c3                   	retq   
  99:	b8 00 00 00 00       	mov    $0x0,%eax
  9e:	89 c2                	mov    %eax,%edx
  a0:	b8 20 00 00 00       	mov    $0x20,%eax
  a5:	5d                   	pop    %rbp
  a6:	c3                   	retq   
  a7:	b8 00 00 00 00       	mov    $0x0,%eax
  ac:	89 c2                	mov    %eax,%edx
  ae:	b8 13 00 00 00       	mov    $0x13,%eax
  b3:	5d                   	pop    %rbp
  b4:	c3                   	retq   
  b5:	b8 00 00 00 00       	mov    $0x0,%eax
  ba:	89 c2                	mov    %eax,%edx
  bc:	b8 15 00 00 00       	mov    $0x15,%eax
  c1:	5d                   	pop    %rbp
  c2:	c3                   	retq   
  c3:	b8 00 00 00 00       	mov    $0x0,%eax
  c8:	89 c2                	mov    %eax,%edx
  ca:	b8 1f 00 00 00       	mov    $0x1f,%eax
  cf:	5d                   	pop    %rbp
  d0:	c3                   	retq   
  d1:	b8 00 00 00 00       	mov    $0x0,%eax
  d6:	89 c2                	mov    %eax,%edx
  d8:	b8 13 00 00 00       	mov    $0x13,%eax
  dd:	5d                   	pop    %rbp
  de:	c3                   	retq   
  df:	b8 00 00 00 00       	mov    $0x0,%eax
  e4:	89 c2                	mov    %eax,%edx
  e6:	b8 18 00 00 00       	mov    $0x18,%eax
  eb:	5d                   	pop    %rbp
  ec:	c3                   	retq   
  ed:	b8 00 00 00 00       	mov    $0x0,%eax
  f2:	89 c2                	mov    %eax,%edx
  f4:	b8 1d 00 00 00       	mov    $0x1d,%eax
  f9:	5d                   	pop    %rbp
  fa:	c3                   	retq   
  fb:	b8 00 00 00 00       	mov    $0x0,%eax
 100:	89 c2                	mov    %eax,%edx
 102:	b8 18 00 00 00       	mov    $0x18,%eax
 107:	5d                   	pop    %rbp
 108:	c3                   	retq   
 109:	b8 00 00 00 00       	mov    $0x0,%eax
 10e:	89 c2                	mov    %eax,%edx
 110:	b8 0e 00 00 00       	mov    $0xe,%eax
 115:	5d                   	pop    %rbp
 116:	c3                   	retq   
 117:	b8 00 00 00 00       	mov    $0x0,%eax
 11c:	89 c2                	mov    %eax,%edx
 11e:	b8 1f 00 00 00       	mov    $0x1f,%eax
 123:	5d                   	pop    %rbp
 124:	c3                   	retq   
 125:	b8 00 00 00 00       	mov    $0x0,%eax
 12a:	89 c2                	mov    %eax,%edx
 12c:	b8 2c 00 00 00       	mov    $0x2c,%eax
 131:	5d                   	pop    %rbp
 132:	c3                   	retq   
 133:	b8 00 00 00 00       	mov    $0x0,%eax
 138:	89 c2                	mov    %eax,%edx
 13a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 13f:	5d                   	pop    %rbp
 140:	c3                   	retq   
 141:	b8 00 00 00 00       	mov    $0x0,%eax
 146:	89 c2                	mov    %eax,%edx
 148:	b8 17 00 00 00       	mov    $0x17,%eax
 14d:	5d                   	pop    %rbp
 14e:	c3                   	retq   
 14f:	b8 00 00 00 00       	mov    $0x0,%eax
 154:	89 c2                	mov    %eax,%edx
 156:	b8 17 00 00 00       	mov    $0x17,%eax
 15b:	5d                   	pop    %rbp
 15c:	c3                   	retq   
 15d:	b8 00 00 00 00       	mov    $0x0,%eax
 162:	89 c2                	mov    %eax,%edx
 164:	b8 1a 00 00 00       	mov    $0x1a,%eax
 169:	5d                   	pop    %rbp
 16a:	c3                   	retq   
 16b:	b8 00 00 00 00       	mov    $0x0,%eax
 170:	89 c2                	mov    %eax,%edx
 172:	b8 20 00 00 00       	mov    $0x20,%eax
 177:	5d                   	pop    %rbp
 178:	c3                   	retq   
 179:	b8 00 00 00 00       	mov    $0x0,%eax
 17e:	89 c2                	mov    %eax,%edx
 180:	b8 10 00 00 00       	mov    $0x10,%eax
 185:	5d                   	pop    %rbp
 186:	c3                   	retq   
 187:	b8 00 00 00 00       	mov    $0x0,%eax
 18c:	89 c2                	mov    %eax,%edx
 18e:	b8 16 00 00 00       	mov    $0x16,%eax
 193:	5d                   	pop    %rbp
 194:	c3                   	retq   
 195:	b8 00 00 00 00       	mov    $0x0,%eax
 19a:	89 c2                	mov    %eax,%edx
 19c:	b8 13 00 00 00       	mov    $0x13,%eax
 1a1:	5d                   	pop    %rbp
 1a2:	c3                   	retq   
 1a3:	b8 00 00 00 00       	mov    $0x0,%eax
 1a8:	89 c2                	mov    %eax,%edx
 1aa:	b8 11 00 00 00       	mov    $0x11,%eax
 1af:	5d                   	pop    %rbp
 1b0:	c3                   	retq   
 1b1:	b8 00 00 00 00       	mov    $0x0,%eax
 1b6:	89 c2                	mov    %eax,%edx
 1b8:	b8 12 00 00 00       	mov    $0x12,%eax
 1bd:	5d                   	pop    %rbp
 1be:	c3                   	retq   
 1bf:	b8 00 00 00 00       	mov    $0x0,%eax
 1c4:	89 c2                	mov    %eax,%edx
 1c6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 1cb:	5d                   	pop    %rbp
 1cc:	c3                   	retq   
 1cd:	b8 00 00 00 00       	mov    $0x0,%eax
 1d2:	89 c2                	mov    %eax,%edx
 1d4:	b8 18 00 00 00       	mov    $0x18,%eax
 1d9:	5d                   	pop    %rbp
 1da:	c3                   	retq   
 1db:	b8 00 00 00 00       	mov    $0x0,%eax
 1e0:	89 c2                	mov    %eax,%edx
 1e2:	b8 13 00 00 00       	mov    $0x13,%eax
 1e7:	5d                   	pop    %rbp
 1e8:	c3                   	retq   
 1e9:	b8 00 00 00 00       	mov    $0x0,%eax
 1ee:	89 c2                	mov    %eax,%edx
 1f0:	b8 15 00 00 00       	mov    $0x15,%eax
 1f5:	5d                   	pop    %rbp
 1f6:	c3                   	retq   
 1f7:	b8 00 00 00 00       	mov    $0x0,%eax
 1fc:	89 c2                	mov    %eax,%edx
 1fe:	b8 22 00 00 00       	mov    $0x22,%eax
 203:	5d                   	pop    %rbp
 204:	c3                   	retq   
 205:	b8 00 00 00 00       	mov    $0x0,%eax
 20a:	89 c2                	mov    %eax,%edx
 20c:	b8 15 00 00 00       	mov    $0x15,%eax
 211:	5d                   	pop    %rbp
 212:	c3                   	retq   
 213:	b8 00 00 00 00       	mov    $0x0,%eax
 218:	89 c2                	mov    %eax,%edx
 21a:	b8 12 00 00 00       	mov    $0x12,%eax
 21f:	5d                   	pop    %rbp
 220:	c3                   	retq   
 221:	b8 00 00 00 00       	mov    $0x0,%eax
 226:	89 c2                	mov    %eax,%edx
 228:	b8 11 00 00 00       	mov    $0x11,%eax
 22d:	5d                   	pop    %rbp
 22e:	c3                   	retq   
 22f:	b8 00 00 00 00       	mov    $0x0,%eax
 234:	89 c2                	mov    %eax,%edx
 236:	b8 18 00 00 00       	mov    $0x18,%eax
 23b:	5d                   	pop    %rbp
 23c:	c3                   	retq   
 23d:	b8 00 00 00 00       	mov    $0x0,%eax
 242:	89 c2                	mov    %eax,%edx
 244:	b8 12 00 00 00       	mov    $0x12,%eax
 249:	5d                   	pop    %rbp
 24a:	c3                   	retq   
 24b:	b8 00 00 00 00       	mov    $0x0,%eax
 250:	89 c2                	mov    %eax,%edx
 252:	b8 1d 00 00 00       	mov    $0x1d,%eax
 257:	5d                   	pop    %rbp
 258:	c3                   	retq   
 259:	b8 00 00 00 00       	mov    $0x0,%eax
 25e:	89 c2                	mov    %eax,%edx
 260:	b8 16 00 00 00       	mov    $0x16,%eax
 265:	5d                   	pop    %rbp
 266:	c3                   	retq   
 267:	b8 00 00 00 00       	mov    $0x0,%eax
 26c:	89 c2                	mov    %eax,%edx
 26e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 273:	5d                   	pop    %rbp
 274:	c3                   	retq   
 275:	b8 00 00 00 00       	mov    $0x0,%eax
 27a:	89 c2                	mov    %eax,%edx
 27c:	b8 11 00 00 00       	mov    $0x11,%eax
 281:	5d                   	pop    %rbp
 282:	c3                   	retq   
 283:	b8 00 00 00 00       	mov    $0x0,%eax
 288:	89 c2                	mov    %eax,%edx
 28a:	b8 14 00 00 00       	mov    $0x14,%eax
 28f:	5d                   	pop    %rbp
 290:	c3                   	retq   
 291:	b8 00 00 00 00       	mov    $0x0,%eax
 296:	89 c2                	mov    %eax,%edx
 298:	b8 14 00 00 00       	mov    $0x14,%eax
 29d:	5d                   	pop    %rbp
 29e:	c3                   	retq   
 29f:	b8 00 00 00 00       	mov    $0x0,%eax
 2a4:	89 c2                	mov    %eax,%edx
 2a6:	b8 13 00 00 00       	mov    $0x13,%eax
 2ab:	5d                   	pop    %rbp
 2ac:	c3                   	retq   
 2ad:	b8 00 00 00 00       	mov    $0x0,%eax
 2b2:	89 c2                	mov    %eax,%edx
 2b4:	b8 16 00 00 00       	mov    $0x16,%eax
 2b9:	5d                   	pop    %rbp
 2ba:	c3                   	retq   
 2bb:	b8 00 00 00 00       	mov    $0x0,%eax
 2c0:	89 c2                	mov    %eax,%edx
 2c2:	b8 19 00 00 00       	mov    $0x19,%eax
 2c7:	5d                   	pop    %rbp
 2c8:	c3                   	retq   
 2c9:	b8 00 00 00 00       	mov    $0x0,%eax
 2ce:	89 c2                	mov    %eax,%edx
 2d0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2d5:	5d                   	pop    %rbp
 2d6:	c3                   	retq   
 2d7:	b8 00 00 00 00       	mov    $0x0,%eax
 2dc:	89 c2                	mov    %eax,%edx
 2de:	b8 19 00 00 00       	mov    $0x19,%eax
 2e3:	5d                   	pop    %rbp
 2e4:	c3                   	retq   
 2e5:	b8 00 00 00 00       	mov    $0x0,%eax
 2ea:	89 c2                	mov    %eax,%edx
 2ec:	b8 18 00 00 00       	mov    $0x18,%eax
 2f1:	5d                   	pop    %rbp
 2f2:	c3                   	retq   
 2f3:	b8 00 00 00 00       	mov    $0x0,%eax
 2f8:	89 c2                	mov    %eax,%edx
 2fa:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2ff:	5d                   	pop    %rbp
 300:	c3                   	retq   
 301:	b8 00 00 00 00       	mov    $0x0,%eax
 306:	89 c2                	mov    %eax,%edx
 308:	b8 10 00 00 00       	mov    $0x10,%eax
 30d:	5d                   	pop    %rbp
 30e:	c3                   	retq   
 30f:	b8 00 00 00 00       	mov    $0x0,%eax
 314:	89 c2                	mov    %eax,%edx
 316:	b8 14 00 00 00       	mov    $0x14,%eax
 31b:	5d                   	pop    %rbp
 31c:	c3                   	retq   
 31d:	b8 00 00 00 00       	mov    $0x0,%eax
 322:	89 c2                	mov    %eax,%edx
 324:	b8 14 00 00 00       	mov    $0x14,%eax
 329:	5d                   	pop    %rbp
 32a:	c3                   	retq   
 32b:	b8 00 00 00 00       	mov    $0x0,%eax
 330:	89 c2                	mov    %eax,%edx
 332:	b8 16 00 00 00       	mov    $0x16,%eax
 337:	5d                   	pop    %rbp
 338:	c3                   	retq   
 339:	b8 00 00 00 00       	mov    $0x0,%eax
 33e:	89 c2                	mov    %eax,%edx
 340:	b8 14 00 00 00       	mov    $0x14,%eax
 345:	5d                   	pop    %rbp
 346:	c3                   	retq   
 347:	b8 00 00 00 00       	mov    $0x0,%eax
 34c:	89 c2                	mov    %eax,%edx
 34e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 353:	5d                   	pop    %rbp
 354:	c3                   	retq   
 355:	b8 00 00 00 00       	mov    $0x0,%eax
 35a:	89 c2                	mov    %eax,%edx
 35c:	b8 13 00 00 00       	mov    $0x13,%eax
 361:	5d                   	pop    %rbp
 362:	c3                   	retq   
 363:	b8 00 00 00 00       	mov    $0x0,%eax
 368:	89 c2                	mov    %eax,%edx
 36a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 36f:	5d                   	pop    %rbp
 370:	c3                   	retq   
 371:	b8 00 00 00 00       	mov    $0x0,%eax
 376:	89 c2                	mov    %eax,%edx
 378:	b8 1b 00 00 00       	mov    $0x1b,%eax
 37d:	5d                   	pop    %rbp
 37e:	c3                   	retq   
 37f:	b8 00 00 00 00       	mov    $0x0,%eax
 384:	89 c2                	mov    %eax,%edx
 386:	b8 19 00 00 00       	mov    $0x19,%eax
 38b:	5d                   	pop    %rbp
 38c:	c3                   	retq   
 38d:	b8 00 00 00 00       	mov    $0x0,%eax
 392:	89 c2                	mov    %eax,%edx
 394:	b8 21 00 00 00       	mov    $0x21,%eax
 399:	5d                   	pop    %rbp
 39a:	c3                   	retq   
 39b:	b8 00 00 00 00       	mov    $0x0,%eax
 3a0:	89 c2                	mov    %eax,%edx
 3a2:	b8 26 00 00 00       	mov    $0x26,%eax
 3a7:	5d                   	pop    %rbp
 3a8:	c3                   	retq   
 3a9:	b8 00 00 00 00       	mov    $0x0,%eax
 3ae:	89 c2                	mov    %eax,%edx
 3b0:	b8 19 00 00 00       	mov    $0x19,%eax
 3b5:	5d                   	pop    %rbp
 3b6:	c3                   	retq   
 3b7:	b8 00 00 00 00       	mov    $0x0,%eax
 3bc:	89 c2                	mov    %eax,%edx
 3be:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3c3:	5d                   	pop    %rbp
 3c4:	c3                   	retq   
 3c5:	b8 00 00 00 00       	mov    $0x0,%eax
 3ca:	89 c2                	mov    %eax,%edx
 3cc:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3d1:	5d                   	pop    %rbp
 3d2:	c3                   	retq   
 3d3:	b8 00 00 00 00       	mov    $0x0,%eax
 3d8:	89 c2                	mov    %eax,%edx
 3da:	b8 26 00 00 00       	mov    $0x26,%eax
 3df:	5d                   	pop    %rbp
 3e0:	c3                   	retq   
 3e1:	b8 00 00 00 00       	mov    $0x0,%eax
 3e6:	89 c2                	mov    %eax,%edx
 3e8:	b8 22 00 00 00       	mov    $0x22,%eax
 3ed:	5d                   	pop    %rbp
 3ee:	c3                   	retq   
 3ef:	b8 00 00 00 00       	mov    $0x0,%eax
 3f4:	89 c2                	mov    %eax,%edx
 3f6:	b8 14 00 00 00       	mov    $0x14,%eax
 3fb:	5d                   	pop    %rbp
 3fc:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 81 ec d0 01 00 00 	sub    $0x1d0,%rsp
   b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   f:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  13:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  17:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1b:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  22:	00 
  23:	0f 84 95 00 00 00    	je     be <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0xbe>
  29:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  2d:	e8 00 00 00 00       	callq  32 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x32>
  32:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  39:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  3d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  41:	e8 00 00 00 00       	callq  46 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x46>
  46:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  4d:	00 00 00 
  50:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  54:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  58:	e8 00 00 00 00       	callq  5d <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x5d>
  5d:	48 ba 00 00 00 00 00 	movabs $0x0,%rdx
  64:	00 00 00 
  67:	b9 01 00 00 00       	mov    $0x1,%ecx
  6c:	89 ce                	mov    %ecx,%esi
  6e:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  75:	00 00 00 
  78:	49 89 c0             	mov    %rax,%r8
  7b:	48 89 38             	mov    %rdi,(%rax)
  7e:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  85:	00 
  86:	48 8b 3c 25 00 00 00 	mov    0x0,%rdi
  8d:	00 
  8e:	48 89 78 10          	mov    %rdi,0x10(%rax)
  92:	48 8b 3c 25 00 00 00 	mov    0x0,%rdi
  99:	00 
  9a:	48 89 78 18          	mov    %rdi,0x18(%rax)
  9e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  a2:	48 89 d7             	mov    %rdx,%rdi
  a5:	e8 00 00 00 00       	callq  aa <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0xaa>
  aa:	31 c9                	xor    %ecx,%ecx
  ac:	89 ce                	mov    %ecx,%esi
  ae:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  b2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  b6:	48 3b 75 b0          	cmp    -0x50(%rbp),%rsi
  ba:	72 41                	jb     fd <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0xfd>
  bc:	eb 27                	jmp    e5 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0xe5>
  be:	b8 00 00 00 00       	mov    $0x0,%eax
  c3:	89 c6                	mov    %eax,%esi
  c5:	b8 00 00 00 00       	mov    $0x0,%eax
  ca:	89 c1                	mov    %eax,%ecx
  cc:	b8 09 00 00 00       	mov    $0x9,%eax
  d1:	89 c7                	mov    %eax,%edi
  d3:	b8 11 00 00 00       	mov    $0x11,%eax
  d8:	89 c2                	mov    %eax,%edx
  da:	41 b8 e7 00 00 00    	mov    $0xe7,%r8d
  e0:	e8 00 00 00 00       	callq  e5 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0xe5>
  e5:	b8 00 00 00 00       	mov    $0x0,%eax
  ea:	89 c6                	mov    %eax,%esi
  ec:	b8 11 00 00 00       	mov    $0x11,%eax
  f1:	89 c7                	mov    %eax,%edi
  f3:	ba ef 00 00 00       	mov    $0xef,%edx
  f8:	e8 00 00 00 00       	callq  fd <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0xfd>
  fd:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
 101:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 105:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
 109:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
 110:	e8 00 00 00 00       	callq  115 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x115>
 115:	48 8b b5 40 ff ff ff 	mov    -0xc0(%rbp),%rsi
 11c:	48 89 06             	mov    %rax,(%rsi)
 11f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
 123:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
 127:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
 12b:	8b 7e 10             	mov    0x10(%rsi),%edi
 12e:	31 c9                	xor    %ecx,%ecx
 130:	89 ce                	mov    %ecx,%esi
 132:	b9 01 00 00 00       	mov    $0x1,%ecx
 137:	48 89 b5 38 ff ff ff 	mov    %rsi,-0xc8(%rbp)
 13e:	89 ce                	mov    %ecx,%esi
 140:	48 8b 8d 38 ff ff ff 	mov    -0xc8(%rbp),%rcx
 147:	4c 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%r8
 14e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
 155:	e8 00 00 00 00       	callq  15a <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x15a>
 15a:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
 161:	89 41 10             	mov    %eax,0x10(%rcx)
 164:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
 168:	8b 41 10             	mov    0x10(%rcx),%eax
 16b:	85 c0                	test   %eax,%eax
 16d:	41 0f 95 c1          	setne  %r9b
 171:	44 88 8d 2f ff ff ff 	mov    %r9b,-0xd1(%rbp)
 178:	0f 85 99 00 00 00    	jne    217 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x217>
 17e:	eb 00                	jmp    180 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x180>
 180:	b8 f4 00 00 00       	mov    $0xf4,%eax
 185:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
 189:	b9 00 00 00 00       	mov    $0x0,%ecx
 18e:	89 ca                	mov    %ecx,%edx
 190:	b9 01 00 00 00       	mov    $0x1,%ecx
 195:	89 ce                	mov    %ecx,%esi
 197:	48 89 bd 20 ff ff ff 	mov    %rdi,-0xe0(%rbp)
 19e:	48 89 d7             	mov    %rdx,%rdi
 1a1:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%rbp)
 1a7:	e8 00 00 00 00       	callq  1ac <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x1ac>
 1ac:	0f 10 45 e8          	movups -0x18(%rbp),%xmm0
 1b0:	0f 11 02             	movups %xmm0,(%rdx)
 1b3:	48 89 e6             	mov    %rsp,%rsi
 1b6:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
 1bd:	00 
 1be:	48 c7 06 19 00 00 00 	movq   $0x19,(%rsi)
 1c5:	b9 00 00 00 00       	mov    $0x0,%ecx
 1ca:	41 b8 11 00 00 00    	mov    $0x11,%r8d
 1d0:	44 89 c6             	mov    %r8d,%esi
 1d3:	41 b8 f4 00 00 00    	mov    $0xf4,%r8d
 1d9:	48 8b bd 20 ff ff ff 	mov    -0xe0(%rbp),%rdi
 1e0:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
 1e7:	44 89 c6             	mov    %r8d,%esi
 1ea:	4c 8b 8d 10 ff ff ff 	mov    -0xf0(%rbp),%r9
 1f1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
 1f8:	4c 89 ca             	mov    %r9,%rdx
 1fb:	49 89 c0             	mov    %rax,%r8
 1fe:	4c 8b 8d 08 ff ff ff 	mov    -0xf8(%rbp),%r9
 205:	e8 00 00 00 00       	callq  20a <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x20a>
 20a:	31 f6                	xor    %esi,%esi
 20c:	89 f0                	mov    %esi,%eax
 20e:	48 81 c4 d0 01 00 00 	add    $0x1d0,%rsp
 215:	5d                   	pop    %rbp
 216:	c3                   	retq   
 217:	31 f6                	xor    %esi,%esi
 219:	31 c0                	xor    %eax,%eax
 21b:	89 c1                	mov    %eax,%ecx
 21d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
 221:	8b 7a 10             	mov    0x10(%rdx),%edi
 224:	48 89 ca             	mov    %rcx,%rdx
 227:	48 89 8d 00 ff ff ff 	mov    %rcx,-0x100(%rbp)
 22e:	4c 8b 85 00 ff ff ff 	mov    -0x100(%rbp),%r8
 235:	4c 8b 8d 00 ff ff ff 	mov    -0x100(%rbp),%r9
 23c:	e8 00 00 00 00       	callq  241 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x241>
 241:	89 45 dc             	mov    %eax,-0x24(%rbp)
 244:	81 7d dc 00 00 00 00 	cmpl   $0x0,-0x24(%rbp)
 24b:	74 42                	je     28f <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x28f>
 24d:	31 c0                	xor    %eax,%eax
 24f:	89 c1                	mov    %eax,%ecx
 251:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
 258:	00 
 259:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%rbp)
 260:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
 264:	48 81 c2 10 00 00 00 	add    $0x10,%rdx
 26b:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
 26f:	48 89 f7             	mov    %rsi,%rdi
 272:	48 81 c7 18 00 00 00 	add    $0x18,%rdi
 279:	48 3b 4e 18          	cmp    0x18(%rsi),%rcx
 27d:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
 284:	48 89 95 f0 fe ff ff 	mov    %rdx,-0x110(%rbp)
 28b:	72 27                	jb     2b4 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x2b4>
 28d:	eb 0d                	jmp    29c <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x29c>
 28f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
 293:	48 81 c4 d0 01 00 00 	add    $0x1d0,%rsp
 29a:	5d                   	pop    %rbp
 29b:	c3                   	retq   
 29c:	b8 00 00 00 00       	mov    $0x0,%eax
 2a1:	89 c6                	mov    %eax,%esi
 2a3:	b8 11 00 00 00       	mov    $0x11,%eax
 2a8:	89 c7                	mov    %eax,%edi
 2aa:	ba ff 00 00 00       	mov    $0xff,%edx
 2af:	e8 00 00 00 00       	callq  2b4 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x2b4>
 2b4:	ba 83 11 00 00       	mov    $0x1183,%edx
 2b9:	31 c0                	xor    %eax,%eax
 2bb:	89 c1                	mov    %eax,%ecx
 2bd:	4c 8d 4d a8          	lea    -0x58(%rbp),%r9
 2c1:	48 8b b5 f8 fe ff ff 	mov    -0x108(%rbp),%rsi
 2c8:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
 2cc:	4c 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%r8
 2d3:	41 8b 00             	mov    (%r8),%eax
 2d6:	8b 37                	mov    (%rdi),%esi
 2d8:	89 c7                	mov    %eax,%edi
 2da:	48 89 8d e8 fe ff ff 	mov    %rcx,-0x118(%rbp)
 2e1:	4c 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%r8
 2e8:	e8 00 00 00 00       	callq  2ed <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x2ed>
 2ed:	89 45 a4             	mov    %eax,-0x5c(%rbp)
 2f0:	81 7d dc 00 00 00 00 	cmpl   $0x0,-0x24(%rbp)
 2f7:	0f 84 8a 00 00 00    	je     387 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x387>
 2fd:	b8 01 01 00 00       	mov    $0x101,%eax
 302:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
 306:	b9 00 00 00 00       	mov    $0x0,%ecx
 30b:	89 ca                	mov    %ecx,%edx
 30d:	b9 01 00 00 00       	mov    $0x1,%ecx
 312:	89 ce                	mov    %ecx,%esi
 314:	48 89 bd e0 fe ff ff 	mov    %rdi,-0x120(%rbp)
 31b:	48 89 d7             	mov    %rdx,%rdi
 31e:	89 85 dc fe ff ff    	mov    %eax,-0x124(%rbp)
 324:	e8 00 00 00 00       	callq  329 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x329>
 329:	0f 10 45 e8          	movups -0x18(%rbp),%xmm0
 32d:	0f 11 02             	movups %xmm0,(%rdx)
 330:	48 89 e6             	mov    %rsp,%rsi
 333:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
 33a:	00 
 33b:	48 c7 06 18 00 00 00 	movq   $0x18,(%rsi)
 342:	b9 00 00 00 00       	mov    $0x0,%ecx
 347:	41 b8 11 00 00 00    	mov    $0x11,%r8d
 34d:	44 89 c6             	mov    %r8d,%esi
 350:	41 b8 01 01 00 00    	mov    $0x101,%r8d
 356:	48 8b bd e0 fe ff ff 	mov    -0x120(%rbp),%rdi
 35d:	48 89 b5 d0 fe ff ff 	mov    %rsi,-0x130(%rbp)
 364:	44 89 c6             	mov    %r8d,%esi
 367:	4c 8b 8d d0 fe ff ff 	mov    -0x130(%rbp),%r9
 36e:	48 89 95 c8 fe ff ff 	mov    %rdx,-0x138(%rbp)
 375:	4c 89 ca             	mov    %r9,%rdx
 378:	49 89 c0             	mov    %rax,%r8
 37b:	4c 8b 8d c8 fe ff ff 	mov    -0x138(%rbp),%r9
 382:	e8 00 00 00 00       	callq  387 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x387>
 387:	0f 57 c0             	xorps  %xmm0,%xmm0
 38a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
 38e:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
 395:	00 
 396:	48 8d 45 80          	lea    -0x80(%rbp),%rax
 39a:	be 01 00 00 00       	mov    $0x1,%esi
 39f:	48 89 c7             	mov    %rax,%rdi
 3a2:	48 89 85 c0 fe ff ff 	mov    %rax,-0x140(%rbp)
 3a9:	e8 00 00 00 00       	callq  3ae <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x3ae>
 3ae:	c6 85 7f ff ff ff 00 	movb   $0x0,-0x81(%rbp)
 3b5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
 3b9:	48 8d b5 7f ff ff ff 	lea    -0x81(%rbp),%rsi
 3c0:	48 8b bd c0 fe ff ff 	mov    -0x140(%rbp),%rdi
 3c7:	e8 00 00 00 00       	callq  3cc <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x3cc>
 3cc:	8a 8d 7f ff ff ff    	mov    -0x81(%rbp),%cl
 3d2:	f6 c1 01             	test   $0x1,%cl
 3d5:	75 4c                	jne    423 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x423>
 3d7:	eb 00                	jmp    3d9 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x3d9>
 3d9:	b8 09 01 00 00       	mov    $0x109,%eax
 3de:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
 3e2:	48 89 e1             	mov    %rsp,%rcx
 3e5:	48 c7 41 08 00 00 00 	movq   $0x0,0x8(%rcx)
 3ec:	00 
 3ed:	48 c7 01 0e 00 00 00 	movq   $0xe,(%rcx)
 3f4:	ba 00 00 00 00       	mov    $0x0,%edx
 3f9:	89 d1                	mov    %edx,%ecx
 3fb:	ba 11 00 00 00       	mov    $0x11,%edx
 400:	31 f6                	xor    %esi,%esi
 402:	41 89 f0             	mov    %esi,%r8d
 405:	be 09 01 00 00       	mov    $0x109,%esi
 40a:	4c 89 85 b8 fe ff ff 	mov    %r8,-0x148(%rbp)
 411:	4c 8b 8d b8 fe ff ff 	mov    -0x148(%rbp),%r9
 418:	89 85 b4 fe ff ff    	mov    %eax,-0x14c(%rbp)
 41e:	e8 00 00 00 00       	callq  423 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x423>
 423:	31 c0                	xor    %eax,%eax
 425:	89 c1                	mov    %eax,%ecx
 427:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
 42b:	48 81 c2 10 00 00 00 	add    $0x10,%rdx
 432:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
 436:	48 89 f7             	mov    %rsi,%rdi
 439:	48 81 c7 18 00 00 00 	add    $0x18,%rdi
 440:	48 3b 4e 18          	cmp    0x18(%rsi),%rcx
 444:	48 89 bd a8 fe ff ff 	mov    %rdi,-0x158(%rbp)
 44b:	48 89 95 a0 fe ff ff 	mov    %rdx,-0x160(%rbp)
 452:	72 5e                	jb     4b2 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x4b2>
 454:	eb 42                	jmp    498 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x498>
 456:	48 8d 7d 80          	lea    -0x80(%rbp),%rdi
 45a:	e8 00 00 00 00       	callq  45f <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x45f>
 45f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
 465:	89 c1                	mov    %eax,%ecx
 467:	83 e9 01             	sub    $0x1,%ecx
 46a:	89 85 9c fe ff ff    	mov    %eax,-0x164(%rbp)
 470:	89 8d 98 fe ff ff    	mov    %ecx,-0x168(%rbp)
 476:	0f 84 1f 02 00 00    	je     69b <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x69b>
 47c:	eb 00                	jmp    47e <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x47e>
 47e:	8b 85 9c fe ff ff    	mov    -0x164(%rbp),%eax
 484:	83 e8 02             	sub    $0x2,%eax
 487:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%rbp)
 48d:	0f 84 18 02 00 00    	je     6ab <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x6ab>
 493:	e9 b1 01 00 00       	jmpq   649 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x649>
 498:	b8 00 00 00 00       	mov    $0x0,%eax
 49d:	89 c6                	mov    %eax,%esi
 49f:	b8 11 00 00 00       	mov    $0x11,%eax
 4a4:	89 c7                	mov    %eax,%edi
 4a6:	ba 0e 01 00 00       	mov    $0x10e,%edx
 4ab:	e8 00 00 00 00       	callq  4b0 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x4b0>
 4b0:	eb 24                	jmp    4d6 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x4d6>
 4b2:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
 4b9:	48 8b 48 08          	mov    0x8(%rax),%rcx
 4bd:	48 8d 7d 80          	lea    -0x80(%rbp),%rdi
 4c1:	48 89 8d 88 fe ff ff 	mov    %rcx,-0x178(%rbp)
 4c8:	e8 00 00 00 00       	callq  4cd <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x4cd>
 4cd:	48 89 85 80 fe ff ff 	mov    %rax,-0x180(%rbp)
 4d4:	eb 00                	jmp    4d6 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x4d6>
 4d6:	48 8b 85 a0 fe ff ff 	mov    -0x160(%rbp),%rax
 4dd:	8b 38                	mov    (%rax),%edi
 4df:	48 8b 8d 88 fe ff ff 	mov    -0x178(%rbp),%rcx
 4e6:	8b 31                	mov    (%rcx),%esi
 4e8:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
 4ec:	31 d2                	xor    %edx,%edx
 4ee:	41 89 d1             	mov    %edx,%r9d
 4f1:	ba 83 11 00 00       	mov    $0x1183,%edx
 4f6:	4c 8b 85 80 fe ff ff 	mov    -0x180(%rbp),%r8
 4fd:	e8 00 00 00 00       	callq  502 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x502>
 502:	89 85 7c fe ff ff    	mov    %eax,-0x184(%rbp)
 508:	eb 00                	jmp    50a <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x50a>
 50a:	8b 85 7c fe ff ff    	mov    -0x184(%rbp),%eax
 510:	89 45 a4             	mov    %eax,-0x5c(%rbp)
 513:	81 7d dc 00 00 00 00 	cmpl   $0x0,-0x24(%rbp)
 51a:	0f 85 35 01 00 00    	jne    655 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x655>
 520:	e9 61 01 00 00       	jmpq   686 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x686>
 525:	0f 10 45 e8          	movups -0x18(%rbp),%xmm0
 529:	48 8b 85 70 fe ff ff 	mov    -0x190(%rbp),%rax
 530:	0f 11 00             	movups %xmm0,(%rax)
 533:	48 89 e1             	mov    %rsp,%rcx
 536:	48 c7 41 08 00 00 00 	movq   $0x0,0x8(%rcx)
 53d:	00 
 53e:	48 c7 01 18 00 00 00 	movq   $0x18,(%rcx)
 545:	ba 00 00 00 00       	mov    $0x0,%edx
 54a:	89 d1                	mov    %edx,%ecx
 54c:	ba 11 00 00 00       	mov    $0x11,%edx
 551:	be 10 01 00 00       	mov    $0x110,%esi
 556:	48 8b bd 68 fe ff ff 	mov    -0x198(%rbp),%rdi
 55d:	4c 8b 85 60 fe ff ff 	mov    -0x1a0(%rbp),%r8
 564:	49 89 c1             	mov    %rax,%r9
 567:	e8 00 00 00 00       	callq  56c <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x56c>
 56c:	eb 00                	jmp    56e <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x56e>
 56e:	e9 13 01 00 00       	jmpq   686 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x686>
 573:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
 577:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
 57e:	48 8b 85 58 fe ff ff 	mov    -0x1a8(%rbp),%rax
 585:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
 58c:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
 590:	b9 00 00 00 00       	mov    $0x0,%ecx
 595:	89 ca                	mov    %ecx,%edx
 597:	b9 02 00 00 00       	mov    $0x2,%ecx
 59c:	89 ce                	mov    %ecx,%esi
 59e:	48 89 bd 50 fe ff ff 	mov    %rdi,-0x1b0(%rbp)
 5a5:	48 89 d7             	mov    %rdx,%rdi
 5a8:	e8 00 00 00 00       	callq  5ad <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x5ad>
 5ad:	48 89 95 48 fe ff ff 	mov    %rdx,-0x1b8(%rbp)
 5b4:	48 89 85 40 fe ff ff 	mov    %rax,-0x1c0(%rbp)
 5bb:	eb 00                	jmp    5bd <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x5bd>
 5bd:	0f 10 45 e8          	movups -0x18(%rbp),%xmm0
 5c1:	48 8b 85 48 fe ff ff 	mov    -0x1b8(%rbp),%rax
 5c8:	0f 11 00             	movups %xmm0,(%rax)
 5cb:	0f 10 85 58 ff ff ff 	movups -0xa8(%rbp),%xmm0
 5d2:	0f 11 40 10          	movups %xmm0,0x10(%rax)
 5d6:	48 89 e1             	mov    %rsp,%rcx
 5d9:	48 c7 41 08 00 00 00 	movq   $0x0,0x8(%rcx)
 5e0:	00 
 5e1:	48 c7 01 18 00 00 00 	movq   $0x18,(%rcx)
 5e8:	ba 00 00 00 00       	mov    $0x0,%edx
 5ed:	89 d1                	mov    %edx,%ecx
 5ef:	ba 11 00 00 00       	mov    $0x11,%edx
 5f4:	be 15 01 00 00       	mov    $0x115,%esi
 5f9:	48 8b bd 50 fe ff ff 	mov    -0x1b0(%rbp),%rdi
 600:	4c 8b 85 40 fe ff ff 	mov    -0x1c0(%rbp),%r8
 607:	49 89 c1             	mov    %rax,%r9
 60a:	e8 00 00 00 00       	callq  60f <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x60f>
 60f:	eb 00                	jmp    611 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x611>
 611:	48 c7 85 50 ff ff ff 	movq   $0x0,-0xb0(%rbp)
 618:	00 00 00 00 
 61c:	c7 85 4c ff ff ff 01 	movl   $0x1,-0xb4(%rbp)
 623:	00 00 00 
 626:	e9 2b fe ff ff       	jmpq   456 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x456>
 62b:	89 d1                	mov    %edx,%ecx
 62d:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
 634:	89 8d 6c ff ff ff    	mov    %ecx,-0x94(%rbp)
 63a:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
 641:	00 00 00 
 644:	e9 0d fe ff ff       	jmpq   456 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x456>
 649:	48 8b bd 70 ff ff ff 	mov    -0x90(%rbp),%rdi
 650:	e8 00 00 00 00       	callq  655 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x655>
 655:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
 659:	b9 00 00 00 00       	mov    $0x0,%ecx
 65e:	89 cf                	mov    %ecx,%edi
 660:	b9 01 00 00 00       	mov    $0x1,%ecx
 665:	89 ce                	mov    %ecx,%esi
 667:	48 89 85 68 fe ff ff 	mov    %rax,-0x198(%rbp)
 66e:	e8 00 00 00 00       	callq  673 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x673>
 673:	48 89 95 70 fe ff ff 	mov    %rdx,-0x190(%rbp)
 67a:	48 89 85 60 fe ff ff 	mov    %rax,-0x1a0(%rbp)
 681:	e9 9f fe ff ff       	jmpq   525 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x525>
 686:	48 8d 7d 80          	lea    -0x80(%rbp),%rdi
 68a:	e8 00 00 00 00       	callq  68f <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x68f>
 68f:	48 89 85 58 fe ff ff 	mov    %rax,-0x1a8(%rbp)
 696:	e9 d8 fe ff ff       	jmpq   573 <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x573>
 69b:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
 6a2:	48 81 c4 d0 01 00 00 	add    $0x1d0,%rsp
 6a9:	5d                   	pop    %rbp
 6aa:	c3                   	retq   
 6ab:	e9 df fb ff ff       	jmpq   28f <_D13OpenClWrapper13OpenClWrapper14openAndCompileMFAyaC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper7Program+0x28f>

Disassembly of section .text._D3std4file17__T8readTextTAyaZ8readTextFNfxAaZAya:

0000000000000000 <_D3std4file17__T8readTextTAyaZ8readTextFNfxAaZAya>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 20          	sub    $0x20,%rsp
   8:	48 89 7d f0          	mov    %rdi,-0x10(%rbp)
   c:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
  10:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  18:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  1f:	e8 00 00 00 00       	callq  24 <_D3std4file17__T8readTextTAyaZ8readTextFNfxAaZAya+0x24>
  24:	48 89 c7             	mov    %rax,%rdi
  27:	48 89 d6             	mov    %rdx,%rsi
  2a:	e8 00 00 00 00       	callq  2f <_D3std4file17__T8readTextTAyaZ8readTextFNfxAaZAya+0x2f>
  2f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  37:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  3b:	48 89 d6             	mov    %rdx,%rsi
  3e:	e8 00 00 00 00       	callq  43 <_D3std4file17__T8readTextTAyaZ8readTextFNfxAaZAya+0x43>
  43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  4b:	48 83 c4 20          	add    $0x20,%rsp
  4f:	5d                   	pop    %rbp
  50:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper12createBufferMFmmPvZC13OpenClWrapper13OpenClWrapper6Buffer:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper12createBufferMFmmPvZC13OpenClWrapper13OpenClWrapper6Buffer>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 20          	sub    $0x20,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  10:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  18:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  1f:	00 
  20:	74 16                	je     38 <_D13OpenClWrapper13OpenClWrapper12createBufferMFmmPvZC13OpenClWrapper13OpenClWrapper6Buffer+0x38>
  22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  26:	48 89 c7             	mov    %rax,%rdi
  29:	e8 00 00 00 00       	callq  2e <_D13OpenClWrapper13OpenClWrapper12createBufferMFmmPvZC13OpenClWrapper13OpenClWrapper6Buffer+0x2e>
  2e:	31 c9                	xor    %ecx,%ecx
  30:	89 c8                	mov    %ecx,%eax
  32:	48 83 c4 20          	add    $0x20,%rsp
  36:	5d                   	pop    %rbp
  37:	c3                   	retq   
  38:	b8 00 00 00 00       	mov    $0x0,%eax
  3d:	89 c6                	mov    %eax,%esi
  3f:	b8 00 00 00 00       	mov    $0x0,%eax
  44:	89 c1                	mov    %eax,%ecx
  46:	b8 09 00 00 00       	mov    $0x9,%eax
  4b:	89 c7                	mov    %eax,%edi
  4d:	b8 11 00 00 00       	mov    $0x11,%eax
  52:	89 c2                	mov    %eax,%edx
  54:	41 b8 1e 01 00 00    	mov    $0x11e,%r8d
  5a:	e8 00 00 00 00       	callq  5f <_D13OpenClWrapper13OpenClWrapper12createBufferMFmmPvZC13OpenClWrapper13OpenClWrapper6Buffer+0x5f>

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 70          	sub    $0x70,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  10:	89 55 ec             	mov    %edx,-0x14(%rbp)
  13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  17:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  1e:	00 
  1f:	74 4a                	je     6b <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x6b>
  21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  25:	48 89 c7             	mov    %rax,%rdi
  28:	e8 00 00 00 00       	callq  2d <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x2d>
  2d:	ba e1 0d 00 00       	mov    $0xde1,%edx
  32:	31 c9                	xor    %ecx,%ecx
  34:	4c 8d 4d d8          	lea    -0x28(%rbp),%r9
  38:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  3f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  4a:	8b 78 10             	mov    0x10(%rax),%edi
  4d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  51:	44 8b 45 ec          	mov    -0x14(%rbp),%r8d
  55:	e8 00 00 00 00       	callq  5a <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x5a>
  5a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  5d:	81 7d d8 00 00 00 00 	cmpl   $0x0,-0x28(%rbp)
  64:	75 2c                	jne    92 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x92>
  66:	e9 b6 00 00 00       	jmpq   121 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x121>
  6b:	b8 00 00 00 00       	mov    $0x0,%eax
  70:	89 c6                	mov    %eax,%esi
  72:	b8 00 00 00 00       	mov    $0x0,%eax
  77:	89 c1                	mov    %eax,%ecx
  79:	b8 09 00 00 00       	mov    $0x9,%eax
  7e:	89 c7                	mov    %eax,%edi
  80:	b8 11 00 00 00       	mov    $0x11,%eax
  85:	89 c2                	mov    %eax,%edx
  87:	41 b8 2b 01 00 00    	mov    $0x12b,%r8d
  8d:	e8 00 00 00 00       	callq  92 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x92>
  92:	b8 35 01 00 00       	mov    $0x135,%eax
  97:	8b 7d d8             	mov    -0x28(%rbp),%edi
  9a:	89 45 bc             	mov    %eax,-0x44(%rbp)
  9d:	e8 00 00 00 00       	callq  a2 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0xa2>
  a2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  a6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  aa:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  b3:	89 c8                	mov    %ecx,%eax
  b5:	b9 01 00 00 00       	mov    $0x1,%ecx
  ba:	89 ce                	mov    %ecx,%esi
  bc:	48 89 7d b0          	mov    %rdi,-0x50(%rbp)
  c0:	48 89 c7             	mov    %rax,%rdi
  c3:	e8 00 00 00 00       	callq  c8 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0xc8>
  c8:	0f 10 45 c8          	movups -0x38(%rbp),%xmm0
  cc:	0f 11 02             	movups %xmm0,(%rdx)
  cf:	48 89 e6             	mov    %rsp,%rsi
  d2:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
  d9:	00 
  da:	48 c7 06 38 00 00 00 	movq   $0x38,(%rsi)
  e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  e6:	41 b8 11 00 00 00    	mov    $0x11,%r8d
  ec:	44 89 c6             	mov    %r8d,%esi
  ef:	41 b8 35 01 00 00    	mov    $0x135,%r8d
  f5:	48 8b 7d b0          	mov    -0x50(%rbp),%rdi
  f9:	48 89 75 a8          	mov    %rsi,-0x58(%rbp)
  fd:	44 89 c6             	mov    %r8d,%esi
 100:	4c 8b 4d a8          	mov    -0x58(%rbp),%r9
 104:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 108:	4c 89 ca             	mov    %r9,%rdx
 10b:	49 89 c0             	mov    %rax,%r8
 10e:	4c 8b 4d a0          	mov    -0x60(%rbp),%r9
 112:	e8 00 00 00 00       	callq  117 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x117>
 117:	31 f6                	xor    %esi,%esi
 119:	89 f0                	mov    %esi,%eax
 11b:	48 83 c4 70          	add    $0x70,%rsp
 11f:	5d                   	pop    %rbp
 120:	c3                   	retq   
 121:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
 128:	00 00 00 
 12b:	e8 00 00 00 00       	callq  130 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x130>
 130:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
 137:	00 00 00 
 13a:	48 89 c1             	mov    %rax,%rcx
 13d:	48 89 38             	mov    %rdi,(%rax)
 140:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
 147:	00 
 148:	48 8b 3c 25 00 00 00 	mov    0x0,%rdi
 14f:	00 
 150:	48 89 78 10          	mov    %rdi,0x10(%rax)
 154:	48 8b 3c 25 00 00 00 	mov    0x0,%rdi
 15b:	00 
 15c:	48 89 78 18          	mov    %rdi,0x18(%rax)
 160:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 164:	48 89 78 18          	mov    %rdi,0x18(%rax)
 168:	48 89 cf             	mov    %rcx,%rdi
 16b:	e8 00 00 00 00       	callq  170 <_D13OpenClWrapper13OpenClWrapper28createImageFromOpenGLTextureMFmkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x170>
 170:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
 174:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
 178:	8b 55 dc             	mov    -0x24(%rbp),%edx
 17b:	89 50 10             	mov    %edx,0x10(%rax)
 17e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
 182:	48 83 c4 70          	add    $0x70,%rsp
 186:	5d                   	pop    %rbp
 187:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
   b:	48 8b 45 10          	mov    0x10(%rbp),%rax
   f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  17:	44 89 4d ec          	mov    %r9d,-0x14(%rbp)
  1b:	44 89 45 e8          	mov    %r8d,-0x18(%rbp)
  1f:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  22:	89 55 e0             	mov    %edx,-0x20(%rbp)
  25:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  29:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  30:	00 
  31:	0f 84 96 00 00 00    	je     cd <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0xcd>
  37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  3b:	48 89 c7             	mov    %rax,%rdi
  3e:	e8 00 00 00 00       	callq  43 <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x43>
  43:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
  47:	31 c9                	xor    %ecx,%ecx
  49:	41 89 c9             	mov    %ecx,%r9d
  4c:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  50:	31 f6                	xor    %esi,%esi
  52:	b9 08 00 00 00       	mov    $0x8,%ecx
  57:	89 ca                	mov    %ecx,%edx
  59:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  60:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%rbp)
  67:	49 89 c0             	mov    %rax,%r8
  6a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  6e:	4c 89 c7             	mov    %r8,%rdi
  71:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  75:	4c 89 4d 98          	mov    %r9,-0x68(%rbp)
  79:	e8 00 00 00 00       	callq  7e <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x7e>
  7e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  81:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  84:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  87:	89 4d cc             	mov    %ecx,-0x34(%rbp)
  8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8e:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  91:	8b 75 e8             	mov    -0x18(%rbp),%esi
  94:	41 89 f0             	mov    %esi,%r8d
  97:	8b 78 10             	mov    0x10(%rax),%edi
  9a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  9e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  a2:	4c 8b 4d 98          	mov    -0x68(%rbp),%r9
  a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  ad:	00 
  ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  b2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  b7:	e8 00 00 00 00       	callq  bc <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0xbc>
  bc:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  bf:	81 7d d0 00 00 00 00 	cmpl   $0x0,-0x30(%rbp)
  c6:	75 2c                	jne    f4 <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0xf4>
  c8:	e9 b2 00 00 00       	jmpq   17f <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x17f>
  cd:	b8 00 00 00 00       	mov    $0x0,%eax
  d2:	89 c6                	mov    %eax,%esi
  d4:	b8 00 00 00 00       	mov    $0x0,%eax
  d9:	89 c1                	mov    %eax,%ecx
  db:	b8 09 00 00 00       	mov    $0x9,%eax
  e0:	89 c7                	mov    %eax,%edi
  e2:	b8 11 00 00 00       	mov    $0x11,%eax
  e7:	89 c2                	mov    %eax,%edx
  e9:	41 b8 3e 01 00 00    	mov    $0x13e,%r8d
  ef:	e8 00 00 00 00       	callq  f4 <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0xf4>
  f4:	b8 55 01 00 00       	mov    $0x155,%eax
  f9:	8b 7d d4             	mov    -0x2c(%rbp),%edi
  fc:	89 45 94             	mov    %eax,-0x6c(%rbp)
  ff:	e8 00 00 00 00       	callq  104 <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x104>
 104:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
 108:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 10c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
 110:	b9 00 00 00 00       	mov    $0x0,%ecx
 115:	89 c8                	mov    %ecx,%eax
 117:	b9 01 00 00 00       	mov    $0x1,%ecx
 11c:	89 ce                	mov    %ecx,%esi
 11e:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
 122:	48 89 c7             	mov    %rax,%rdi
 125:	e8 00 00 00 00       	callq  12a <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x12a>
 12a:	0f 10 45 b8          	movups -0x48(%rbp),%xmm0
 12e:	0f 11 02             	movups %xmm0,(%rdx)
 131:	48 89 e6             	mov    %rsp,%rsi
 134:	48 c7 46 08 00 00 00 	movq   $0x0,0x8(%rsi)
 13b:	00 
 13c:	48 c7 06 18 00 00 00 	movq   $0x18,(%rsi)
 143:	b9 00 00 00 00       	mov    $0x0,%ecx
 148:	41 b8 11 00 00 00    	mov    $0x11,%r8d
 14e:	44 89 c6             	mov    %r8d,%esi
 151:	41 b8 55 01 00 00    	mov    $0x155,%r8d
 157:	48 8b 7d 88          	mov    -0x78(%rbp),%rdi
 15b:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
 15f:	44 89 c6             	mov    %r8d,%esi
 162:	4c 8b 4d 80          	mov    -0x80(%rbp),%r9
 166:	48 89 95 78 ff ff ff 	mov    %rdx,-0x88(%rbp)
 16d:	4c 89 ca             	mov    %r9,%rdx
 170:	49 89 c0             	mov    %rax,%r8
 173:	4c 8b 8d 78 ff ff ff 	mov    -0x88(%rbp),%r9
 17a:	e8 00 00 00 00       	callq  17f <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x17f>
 17f:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
 186:	00 00 00 
 189:	e8 00 00 00 00       	callq  18e <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x18e>
 18e:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
 195:	00 00 00 
 198:	48 89 c1             	mov    %rax,%rcx
 19b:	48 89 38             	mov    %rdi,(%rax)
 19e:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
 1a5:	00 
 1a6:	48 8b 3c 25 00 00 00 	mov    0x0,%rdi
 1ad:	00 
 1ae:	48 89 78 10          	mov    %rdi,0x10(%rax)
 1b2:	48 8b 3c 25 00 00 00 	mov    0x0,%rdi
 1b9:	00 
 1ba:	48 89 78 18          	mov    %rdi,0x18(%rax)
 1be:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
 1c2:	48 89 78 18          	mov    %rdi,0x18(%rax)
 1c6:	48 89 cf             	mov    %rcx,%rdi
 1c9:	e8 00 00 00 00       	callq  1ce <_D13OpenClWrapper13OpenClWrapper21createImage2dOnDeviceMFmkkkkC10ErrorStack10ErrorStackZC13OpenClWrapper13OpenClWrapper5Image+0x1ce>
 1ce:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
 1d2:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
 1d6:	8b 55 d4             	mov    -0x2c(%rbp),%edx
 1d9:	89 50 10             	mov    %edx,0x10(%rax)
 1dc:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
 1e0:	48 81 c4 a0 00 00 00 	add    $0xa0,%rsp
 1e7:	5d                   	pop    %rbp
 1e8:	c3                   	retq   

Disassembly of section .text._D13OpenClWrapper13OpenClWrapper14testcode_getCQMFZk:

0000000000000000 <_D13OpenClWrapper13OpenClWrapper14testcode_getCQMFZk>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 10          	sub    $0x10,%rsp
   8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   c:	48 81 7d f8 00 00 00 	cmpq   $0x0,-0x8(%rbp)
  13:	00 
  14:	74 19                	je     2f <_D13OpenClWrapper13OpenClWrapper14testcode_getCQMFZk+0x2f>
  16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1a:	48 89 c7             	mov    %rax,%rdi
  1d:	e8 00 00 00 00       	callq  22 <_D13OpenClWrapper13OpenClWrapper14testcode_getCQMFZk+0x22>
  22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  26:	8b 40 14             	mov    0x14(%rax),%eax
  29:	48 83 c4 10          	add    $0x10,%rsp
  2d:	5d                   	pop    %rbp
  2e:	c3                   	retq   
  2f:	b8 00 00 00 00       	mov    $0x0,%eax
  34:	89 c6                	mov    %eax,%esi
  36:	b8 00 00 00 00       	mov    $0x0,%eax
  3b:	89 c1                	mov    %eax,%ecx
  3d:	b8 09 00 00 00       	mov    $0x9,%eax
  42:	89 c7                	mov    %eax,%edi
  44:	b8 11 00 00 00       	mov    $0x11,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	41 b8 62 01 00 00    	mov    $0x162,%r8d
  51:	e8 00 00 00 00       	callq  56 <_D13OpenClWrapper13OpenClWrapper14testcode_getCQMFZk+0x56>

Disassembly of section .text.Th40_D13OpenClWrapper13OpenClWrapper7disposeMFZv:

0000000000000000 <Th40_D13OpenClWrapper13OpenClWrapper7disposeMFZv>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 81 c7 d8 ff ff ff 	add    $0xffffffffffffffd8,%rdi
   b:	e8 00 00 00 00       	callq  10 <Th40_D13OpenClWrapper13OpenClWrapper7disposeMFZv+0x10>
  10:	5d                   	pop    %rbp
  11:	c3                   	retq   

Disassembly of section .text._D3std4file17__T8readTextTAyaZ8readTextFNfxAaZ11trustedCastFNaNbNiNeAvZAya:

0000000000000000 <_D3std4file17__T8readTextTAyaZ8readTextFNfxAaZ11trustedCastFNaNbNiNeAvZAya>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 89 7d f0          	mov    %rdi,-0x10(%rbp)
   8:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
   c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  14:	5d                   	pop    %rbp
  15:	c3                   	retq   

Disassembly of section .text.ldc.dso_ctor.13OpenClWrapper:

0000000000000000 <ldc.dso_ctor.13OpenClWrapper>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	80 3c 25 00 00 00 00 	cmpb   $0x0,0x0
   b:	00 
   c:	75 55                	jne    63 <ldc.dso_ctor.13OpenClWrapper+0x63>
   e:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
  15:	00 00 00 
  18:	48 b9 00 00 00 00 00 	movabs $0x0,%rcx
  1f:	00 00 00 
  22:	48 ba 00 00 00 00 00 	movabs $0x0,%rdx
  29:	00 00 00 
  2c:	48 be 00 00 00 00 00 	movabs $0x0,%rsi
  33:	00 00 00 
  36:	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 3d <ldc.dso_ctor.13OpenClWrapper+0x3d>
  3d:	48 89 e7             	mov    %rsp,%rdi
  40:	48 83 c7 d0          	add    $0xffffffffffffffd0,%rdi
  44:	48 89 fc             	mov    %rdi,%rsp
  47:	48 c7 07 01 00 00 00 	movq   $0x1,(%rdi)
  4e:	48 89 77 08          	mov    %rsi,0x8(%rdi)
  52:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  56:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
  5a:	48 89 47 20          	mov    %rax,0x20(%rdi)
  5e:	e8 00 00 00 00       	callq  63 <ldc.dso_ctor.13OpenClWrapper+0x63>
  63:	48 89 ec             	mov    %rbp,%rsp
  66:	5d                   	pop    %rbp
  67:	c3                   	retq   

Disassembly of section .text.ldc.dso_dtor.13OpenClWrapper:

0000000000000000 <ldc.dso_dtor.13OpenClWrapper>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	80 3c 25 00 00 00 00 	cmpb   $0x0,0x0
   b:	00 
   c:	74 55                	je     63 <ldc.dso_dtor.13OpenClWrapper+0x63>
   e:	48 b8 00 00 00 00 00 	movabs $0x0,%rax
  15:	00 00 00 
  18:	48 b9 00 00 00 00 00 	movabs $0x0,%rcx
  1f:	00 00 00 
  22:	48 ba 00 00 00 00 00 	movabs $0x0,%rdx
  29:	00 00 00 
  2c:	48 be 00 00 00 00 00 	movabs $0x0,%rsi
  33:	00 00 00 
  36:	c6 05 00 00 00 00 00 	movb   $0x0,0x0(%rip)        # 3d <ldc.dso_dtor.13OpenClWrapper+0x3d>
  3d:	48 89 e7             	mov    %rsp,%rdi
  40:	48 83 c7 d0          	add    $0xffffffffffffffd0,%rdi
  44:	48 89 fc             	mov    %rdi,%rsp
  47:	48 c7 07 01 00 00 00 	movq   $0x1,(%rdi)
  4e:	48 89 77 08          	mov    %rsi,0x8(%rdi)
  52:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  56:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
  5a:	48 89 47 20          	mov    %rax,0x20(%rdi)
  5e:	e8 00 00 00 00       	callq  63 <ldc.dso_dtor.13OpenClWrapper+0x63>
  63:	48 89 ec             	mov    %rbp,%rsp
  66:	5d                   	pop    %rbp
  67:	c3                   	retq   

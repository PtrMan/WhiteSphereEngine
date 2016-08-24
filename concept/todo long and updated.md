the format is
e entrydata d donedate  priority

Graphics - Vulkan
---


- e 22.08.2016 d - LOW : implement textures
- e 22.08.2016 d - LOW :  use vkCmdBlitImage for copy for the right conversion


- e 22.08.2016 d - LOW :  variable scissor for resolution change (fullscreen/window)



- e 22.08.2016 d - LOW :  instantiated rendering

- e 22.08.2016 d - LOW :  depth buffer

- e 22.08.2016 d - LOW :  deffered rendering
- e 22.08.2016 d - LOW :  HDR (mipmap down in renderpass for fast calculation of total illumination)



- e 22.08.2016 d - LOW : in memory allocator / allocator usage
                         check device limits for memory limit of memory by memory type and possibly resize the first allocation size to this size

- e 22.08.2016 d - LOW : queue allocation:
                         in the initialisation of the vulkan : check/watch out for max # of queues

- e 22.08.2016 d - LOW : fullscreen rendering


AI / physics (just together because we have the todo points together for now)
---

- e 22.08.2016 d - : refactor basic AI from the AI fuzzy logic test to some reusable AI
- e 22.08.2016 d - : refactor raycasting code from AI fuzzy logic test into physics engine

- e 24.08.2016 d - : behavior tree : add more basic nodes, for for example switching and checking a condition

GUI
---

- e 22.08.2016 d - : get basic GUI going with vulkan, refactor 
- e 22.08.2016 d - : get the glyph texture renderer going

refactoring
---

- e 22.08.2016 d - : refactor code so its based in a directory called "whiteSphereEngine"
- e 22.08.2016 d - : include nuclear physics simulation code

core
---

- e 22.08.2016 d - : include task schedueling code from old engine code (if its there)
- e 22.08.2016 d - LOW : using task schedueling code for multithreading

atronomical
---

- e 22.08.2016 d - : translate c++ code for astronomical simulation to D and integrate
- e 22.08.2016 d - : pull in other C++ code from spacesimcore and translate to D
- e 22.08.2016 d - : use Motion.d in this codebase to calculate celestial position and velocity
                     (half done, position is calculated with it already, but not velocity)

interaction
---

- e 23.08.2016 d - : begin basic crafting system for weapons and thruster engine
                     one "effect modifier" is the implosion modifier, which is useful for building nuclear weapons

                     components: generic material (can be made out of any metal at any mixture rate)
                                                  (can be made with any microstructure damages, for example sand has extremly high microstructure damages)
                                                  (is made out of basic 3d shapes, boxes, quaders, cylinders, cylinders with hole, etc)
                                 neutron deflector
                                 explosives
                                 <special: implosion (for nuclear weapons)>
                                 <special: barrelconstraint (for classical guns and that like)
                                 <special: ignitor (for rocket engine)

- e 24.08.2016 d - : basic resource producer/consumer/routing system

- e 24.08.2016 d - : (related to crafting system) integrate into the physical interaction system heat transfer, and state of matter




DONE
---

graphics
----

- e 22.08.2016 d 22.08.2016? : implement GraphicsVulkanAbstractGraphicsEngineAdapter and refactor Graphics vulkan for it

ai
---

- e 22.08.2016 d 23.08.2016 : pull in behaviour tree and refactor to new codebase
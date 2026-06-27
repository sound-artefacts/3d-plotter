3d plotter is a SuperCollider sound and graphics engine for perspective based, (vanishing points, axonometric, fisheye options), audioreactive tensors.
It plots vector point cloud animations based on distribution arrays and other array data types, supports color per point, lining, shapes, animation control, sequencing and grouping.

Array types include: Spherical distributions with spherical harmonics, toriads, relevant wraps and localization point group nestings, and other mods like bessel ripples and depth information. 
Points/vertices based on solid and polytope, geodesic geometries. 
Arrays based on image information data like image or video are utilized for mesh creation. 
Image sources can be single image (in case of single image rbg values can be used forcoordinate pints as well apart from mesh on points, in any case point cloud should be a static periodic distribution, as it is sonified, while mesh arrays can be aperiodically animated) or video frames, structurally utilized for sonification, motion capture analogs, or chaotic data sources, in order to set presence of mesh lines according to array information, as boolean (no line on mesh, line) or stroke and fill degrees, based on image px information. Mesh arrays can also be defined via stochastic randomness, number and geometric sequencies, and relevant animatory routines.

Plotted point clouds can be individually colored, used to make 3d objects via lines and other SC Pen functions. Animated via routines in communication with sound engine builds, and grouped in sequence or on matrix to form complex animations, interfaces and renderings. Collision between animations can create intricate graphic environments as well as vivid and musically colorfull sonifications, synthetic drones and timbres and sonic events.

////////(on notes folder Quaternion.scd file compliement to SC in place of defalut Mathlib file, allows argument control of Quaternions through external Ugens, in case this object is intented to be utilized, as for multiple animations management, gimbal lock etc.)//////

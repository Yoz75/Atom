module atom.settings;
import atom.aliases;

///Percentage of velocity lost each frame
fpoint Friction = 0.00005;
/// Maximal distance of particles interaction
fpoint InteractParticlesDistance = float.infinity;
/// Minimal distance between particles before interaction reverse
fpoint MinimalParticlesDistance = 0.1;
/// Particles radius
fpoint ParticleRadius = 15;
/// Base interaction strength multiplier
enum fpoint BaseParticleStrength = 0.00000005;
/// X size of game field
enum fpoint XFieldSize = 1;
/// Y size of game field
enum fpoint YFieldSize = 1;
/// Target simulation framerate
int TargetFPS = 140;

///InitInteractionsTable will write interactions table to console only if type counts <= this value
size_t MaxTypesWhenWrite = 100;
module atom.settings;
import atom.aliases;

//Percentage of velocity lost each frame
fpoint Friction = 0.00005;
fpoint InteractParticlesDistance = float.infinity;
fpoint NearbyParticlesDistance = 0.1;
fpoint ParticlesRenderSize = 15;
//strength 1 os TOO big, so we silently use this value as 1
fpoint BaseParticleStrength = 0.00000005;
//if distance between 2 particlse <= this, they will repel each other
//currenlty unused, lol
fpoint MinDistance = 0.001;

fpoint XFieldSize = 1;
fpoint YFieldSize = 1;

int TargetFPS = 140;

//InitInteractionsTable will write interactions table to console only if type counts <= this value
size_t MaxTypesWhenWrite = 100;
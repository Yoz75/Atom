module atom.settings.config;
import atom.settings.attributes;
import atom.aliases;
import jsonizer;

/// Global simulation settings instance.
SimulationConfig GlobalSimulationConfig;
SimulationStartInfoConfig GlobalSimulationStartInfoConfig;

/// Alias for GlobalSimulationSettings to avoid long names in code.
alias GSC = GlobalSimulationConfig;
///Alias for GlobalSimulationStartInfoConfig to avoid long names in code.
alias GSIC = GlobalSimulationStartInfoConfig;

/// Simulation settings. Use GlobalSimulationSettings to access it.
struct SimulationConfig
{
    mixin JsonizeMe;    
public:
@jsonize: // Mark ALL symbols after this label as jsonizable

    ///Percentage of velocity lost each frame
    @AskUser("friction of particles") fpoint Friction = 0.00005;

    /// Maximal distance of particles interaction
    //at some reason conv.d thinks that float.max (current fpoint) is not finite
    
    @AskUser("maximal interact distance") fpoint InteractParticlesDistance = XFieldSize + YFieldSize;

    /// Minimal distance between particles before interaction reverse
    @AskUser("minimal distance between particles before interaction reverse") fpoint MinimalParticlesDistance = 0.1;

    /// Particles radius
    @AskUser("particles radius (0..1 where 1 is full screen)") fpoint ParticleRadius = 0.015;

    /// Base interaction strength multiplier
    enum fpoint BaseParticleStrength = 0.00000005;

    /// X size of game field
    enum fpoint XFieldSize = 1;

    /// Y size of game field
    enum fpoint YFieldSize = 1;

    /// Target simulation framerate
    @AskUser("target framerate") int TargetFPS = 140;

    ///InitInteractionsTable will write interactions table to console only if type counts <= this value
    @AskUser("Atom write interactions between types only if there is <= [value] types") size_t MaxTypesWhenWrite = 100;
}

/// Simulation start info (particles count, types count etc.), use 
struct SimulationStartInfoConfig
{
    mixin JsonizeMe;
public:
@jsonize:

    @AskUser("particles count") size_t ParticlesCount = 64;
    @AskUser("particle types count") size_t TypesCount = 2;
    @AskUser("interaction strength multiplier") fpoint StrengthMultiplier = 1;
    @AskUser("particles count before interaction strength reverses") size_t MaxParticlesBeforeReverse = 4;
}
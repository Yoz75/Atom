module atom.particle;
import atom.aliases;
import atom.settings;
import std.math;

//global table for every interactions of every particle type.
//first index is index of self particle type,
//second array's index is index of other type.
//For example "ParticleInteractionsTable[0][5]" describes how particle type 0
//interacts with particle type 5
InteractionInfo[][] ParticleInteractionsTable; 


struct InteractionInfo
{
    public fpoint InteractionStrength;
    public size_t MaxParticlesCount;
}

struct Particle
{
    public fpoint[2] Position_;
    public fpoint[2] Velocity;
    public const size_t Type;

    public this(fpoint[2] position, size_t type)
    {
        Position_ = position;
        Velocity[] = 0;
        Type = type;
    }

    public @property fpoint[2] Position()
    {
        return Position_;
    }

    public static fpoint GetDistance(Particle left, Particle right)
    {
        return sqrt(pow(left.Position[0] - right.Position[0], 2) + pow(left.Position[1] - right.Position[1], 2));
    }

    public void Update(Particle[] nearbyParticles)
    {
        fpoint[2] endVelocity;
        endVelocity[] = 0;

        //this was an associative array for less memory pressure, but at some reason that's brakes
        //"InteractionInfo particleInteractionInfo = ParticleInteractionsTable[Type][particle.Type];" line
        size_t[] perTypeParticlesCount = new size_t[ParticleInteractionsTable.length];

        foreach (Particle particle; nearbyParticles)
        {
            if(GetDistance(this, particle) <= NearbyParticlesDistance)
            {
                perTypeParticlesCount[particle.Type]++;
            }

            InteractionInfo particleInteractionInfo = ParticleInteractionsTable[Type][particle.Type];

            //velocity, if current particle would be the only neighbor particle for us
            fpoint[2] velocityForCurrent;

            //actually this is one thing, but line would be too huge
            //DON'T USE GETDISTANCE() HERE!!!
            velocityForCurrent[] = (Position_[] - particle.Position_[]) * particleInteractionInfo.InteractionStrength;
            velocityForCurrent[] /= pow(GetDistance(this, particle), 2);

            if(perTypeParticlesCount[particle.Type] > particleInteractionInfo.MaxParticlesCount)                
            {
                velocityForCurrent[] = -velocityForCurrent[];
            }

            endVelocity[] += velocityForCurrent[];        
        }

        //particles bounce from the border            
		if(Position_[0] < -XFieldSize || Position_[0] > XFieldSize)
		{
			Velocity[0] = -Velocity[0];
		}

		if(Position_[1] < -YFieldSize || Position_[1] > YFieldSize)
		{
			Velocity[1] = -Velocity[1];
		}

        Velocity[] += endVelocity[];
        Velocity[] -=  Velocity[] * Friction;
        Position_[] += Velocity[];
    }
}

//particleTypesCount is types count (wow)
//maxStrength is maximal strength of attraction or repulsion of particles
//maxPartcles is maximal count of attracting/repulsioning particles at some radius. 
//if the number of particles exceeds the maximum, the strength of particle interactions will be opposite
//(e.g if [maxParticles + n] repulsioning particles will be nearby, they'll start attracting with opposite strength)
//but if any 2 particles are TOO nearby, they'l repulse
public void InitInteractionsTable(size_t particleTypesCount, fpoint maxStrength, size_t maxParticles)
{
    import std.stdio;
    import std.random : uniform, rndGen, unpredictableSeed;
    ParticleInteractionsTable = new InteractionInfo[][particleTypesCount];

    //every particle type contains interaction info with every type including self

    for(size_t i = 0; i < particleTypesCount; i++)
    {
        ParticleInteractionsTable[i] = new InteractionInfo[particleTypesCount];

        foreach (ref InteractionInfo info; ParticleInteractionsTable[i])
        {
            info.InteractionStrength = uniform(-maxStrength, maxStrength);
            info.MaxParticlesCount = uniform(0,  maxParticles);
        }
        if(particleTypesCount <= MaxTypesWhenWrite) writeln(ParticleInteractionsTable[i]);
    }
}
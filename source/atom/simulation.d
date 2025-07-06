module atom.simulation;
import atom.aliases;
import atom.settings;
import atom.particle;
import atom.renderer;
import std.container.slist;

public class Simulation
{
    //user can add particles, so we use linked list to avoidmany gc calls
    private SList!Particle Particles;

    private Renderer Renderer_;

    public void Setup(size_t particlesCount, size_t particleTypesCount, fpoint maxStrength, size_t maxParticles)
    {        
        Particles.clear();
        Renderer_ = new Renderer(800, 600, "wow!", GSS.TargetFPS);
        maxStrength *= GSS.BaseParticleStrength; //see settings.d

        import std.random;

        for(size_t i = 0; i < particleTypesCount; i++)
        {
            Renderer_.AddParticleType(i);
        }

        for(int i = 0; i < particlesCount; i++)
        {
            fpoint[2] position;
            
            position[0] = uniform(-GSS.XFieldSize, GSS.XFieldSize);
            position[1] = uniform(-GSS.YFieldSize, GSS.YFieldSize);

            Particle particle = Particle(position, uniform(0, particleTypesCount));
            Particles.insertFront(particle);
        }
        InitInteractionsTable(particleTypesCount, maxStrength, maxParticles);
    }

    public void Start()
    {
        while(!Renderer_.ShouldClose())
        {
            foreach (ref Particle particle; Particles)
            {
                Particle[] nearbyParticles;
                foreach (Particle candidate; Particles)
                {
                    auto distance = Particle.GetDistance(particle, candidate);
                    if(distance != 0 && distance <= GSS.InteractParticlesDistance)
                    {
                        nearbyParticles ~= candidate;
                    }
                }               
                particle.Update(nearbyParticles);
            }

            Renderer_.Update(Particles);
        }

    }

    public void Cleanup()
    {
        destroy(Renderer_);
    }
}
module atom.renderer;
import atom.particle;
import atom.settings;
import atom.particle;
import atom.math;
import std.container.slist;
import raylib;

class Renderer
{
    private int XRes, YRes;
    private Color*[size_t] Particle2Color;

    private enum Black = Color(0, 0, 0);

    public this(int xRes, int yRes, string title, int targetFPS)
    {
        XRes = xRes;
        YRes = yRes;
        InitWindow(xRes, yRes, title.ptr);
        SetTargetFPS(targetFPS);
    }

    public ~this()
    {
        CloseWindow();
    }

    public bool ShouldClose()
    {
        return WindowShouldClose();
    }

    public void AddParticleType(size_t type)
    {
        import std.format;
        Color** color = type in Particle2Color;
        assert(color is null, format("type %d already added to renderer", type));

        Particle2Color[type] = GenerateRandomColor();
    }

   public void Update(SList!Particle particles)
   {
        BeginDrawing();
        ClearBackground(Black);

        foreach (particle; particles)
        {            
            int xPos = FromRangeToRange(particle.Position_[0], -XFieldSize, XFieldSize, 0, XRes);
            int yPos = FromRangeToRange(particle.Position_[1], -YFieldSize, YFieldSize, 0, YRes);
            int nearParticles = cast(int)(XRes * NearbyParticlesDistance);
            //DrawCircle(xPos, yPos, nearParticles, Color(255, 255, 255, 255));
            DrawCircle(xPos, yPos, ParticlesRenderSize, *Particle2Color[particle.Type]);
        }

        raylib.EndDrawing();
   }
}

private Color* GenerateRandomColor()
{
    import std.random;

    ubyte r = cast(ubyte) uniform(0, 256);
    ubyte g = cast(ubyte) uniform(0, 256);
    ubyte b = cast(ubyte) uniform(0, 256);

    return new Color(r, g, b, 255);
}
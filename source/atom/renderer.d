module atom.renderer;
import atom.particle;
import atom.settings.config;
import atom.particle;
import atom.math;
import std.container.slist;
import raylib;

private template ColorFromHEX(int hex)
{
    public enum Color ColorFromHEX = Color(
        cast(ubyte)((hex >> 16) & 0xFF), // Red
        cast(ubyte)((hex >> 8) & 0xFF),  // Green
        cast(ubyte)(hex & 0xFF),         // Blue
        255                               // Alpha
    );
}

class Renderer
{
    private int XRes, YRes;
    private Color[size_t] Particle2Color;

    private enum Black = Color(0, 0, 0);
    private enum PredefinedTypeColors = 5;

    public this(int xRes, int yRes, string title, int targetFPS)
    {
        XRes = xRes;
        YRes = yRes;
        InitWindow(xRes, yRes, title.ptr);
        SetTargetFPS(targetFPS);

        //Preset standard particle colors for some types (I use ErogeCopper palette)
        Particle2Color[0] = ColorFromHEX!0x74adbb; 
        Particle2Color[1] = ColorFromHEX!0x7bb24e; 
        Particle2Color[2] = ColorFromHEX!0xf0bd77; 
        Particle2Color[3] = ColorFromHEX!0xe89973; 
        Particle2Color[4] = ColorFromHEX!0x7d3840;
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
        /// We don't want to add predefined colors again
        if(type < PredefinedTypeColors) return;

        import std.format;
        Color* color = type in Particle2Color;
        assert(color is null, format("type %d already added to renderer", type));

        Particle2Color[type] = GenerateRandomColor();
    }

   public void Update(SList!Particle particles)
   {
        BeginDrawing();
        ClearBackground(Black);

        foreach (particle; particles)
        {            
            int xPos = FromRangeToRange(particle.Position_[0], -GSC.XFieldSize, GSC.XFieldSize, 0, XRes);
            int yPos = FromRangeToRange(particle.Position_[1], -GSC.YFieldSize, GSC.YFieldSize, 0, YRes);
            DrawCircle(xPos, yPos, GSC.ParticleRadius, Particle2Color[particle.Type]);
        }

        EndDrawing();
   }
}

private Color GenerateRandomColor()
{
    import std.random;

    ubyte r = cast(ubyte) uniform(0, 256);
    ubyte g = cast(ubyte) uniform(0, 256);
    ubyte b = cast(ubyte) uniform(0, 256);

    return Color(r, g, b, 255);
}
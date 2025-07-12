import std.stdio;
import atom.particle;
import atom.simulation;
import atom.aliases;
import atom.settings.manager;
import atom.settings.config;

void main()
{
	ConfigManager configManager;

	configManager.Run();

	Simulation simulation = new Simulation();
	scope(exit) simulation.Cleanup();

	simulation.Setup(GSIC.ParticlesCount, GSIC.TypesCount, GSIC.StrengthMultiplier, GSIC.MaxParticlesBeforeReverse);

	simulation.Start();	
}

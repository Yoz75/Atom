import std.stdio;
import atom.particle;
import atom.simulation;
import atom.aliases;

private T ReadWithPrompt(T)(tstring prompt)
{
	import std.string;
	import std.array;
	import std.conv;

	writeln(prompt);
	return to!T(lineSplitter(readln()).array[0]);
}

void main()
{
	Simulation simulation = new Simulation();
	while(true)
	{
		writeln("\nAtom simulation start menu. Press ctrl + C to exit.\n");
		
		size_t particlesCount = ReadWithPrompt!size_t("write the particles count:");
		size_t typesCount = ReadWithPrompt!size_t("write the types count");
		fpoint force = ReadWithPrompt!fpoint("write the max particle force");
		size_t maxNearParticles = ReadWithPrompt!size_t("write the max nearby particles count before the force \"reversal\"");

		simulation.Setup(particlesCount, typesCount, force, maxNearParticles);

		simulation.Start();
		simulation.Cleanup();
	}
}

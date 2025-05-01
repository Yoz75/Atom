import std.stdio;
import atom.particle;
import atom.simulation;

void main()
{
	Simulation simulation = new Simulation(100, 3, 1, 10);

	simulation.Start();
}

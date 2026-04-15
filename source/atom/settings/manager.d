module atom.settings.manager;

import atom.settings.config;
import atom.aliases;
import atom.settings.attributes;
import std.stdio : readln;
import std.file : exists, isDir, write, mkdir;
import std.path : dirName;
import std.conv : to;
import std.traits : Fields, FieldNameTuple;
import jsonizer : readJSON, toJSONString, writeJSON;
import colorize : fg, color, cwriteln;

/// Read data from stdin with prompt
/// Params:
///   prompt = text prompt
/// Returns: read data
private T ReadWithPrompt(T)(tstring prompt)
{
	import std.string;
	import std.array;

	cwriteln!tstring(prompt);
	return to!T(lineSplitter(readln()).array[0]);
}
/// Ask user about config editing (edit config if user answer == yesAnswer)
/// Params:
///   prompt = text prompt
///   yesAnswer = user "yes" answer
/// Returns: true of user answered yesAnswer, false in other case
private bool AskAboutEditConfig(TConfig, alias configInstance)(tstring prompt, tstring yesAnswer = "y")
{
    bool wantRedactConfig = ReadWithPrompt!tstring(prompt) == yesAnswer;
    if(!wantRedactConfig) return false;
    
    import std.traits : hasUDA, getUDAs;
    static foreach (i, name; FieldNameTuple!TConfig)
    {
        // Only process fields with the AskUser attribute
        static if (hasUDA!(__traits(getMember, TConfig, name), AskUser))
        {
            //for avoid symbols overlapping
            {
                alias member = __traits(getMember, configInstance, name);

                // Get the AskUser attribute instance
                enum attrs = getUDAs!(member, AskUser);
                    
                // There should be only one AskUser attribute per field
                enum description = attrs[0].Description;

                alias FieldType = Fields!TConfig[i];
                auto promptMsg = "Enter value for "~name~" ("~description~"):";
                auto value = ReadWithPrompt!FieldType(promptMsg);
                __traits(getMember, configInstance, name) = value;
            }
        }
    }    
    
    return true;
}

/// Ask user about config saving (save config if user answer == yesAnswer)
/// Params:
///   filePath = save file path
///   prompt = text prompt
///   yesAnswer = user "yes" answer
private static void AskAboutSaveConfig(TConfig, alias configInstance)
(tstring filePath, tstring prompt, tstring yesAnswer = "y")
{
    bool wantSaveConfig = ReadWithPrompt!tstring(prompt) == yesAnswer;
    if(!wantSaveConfig) return;
    writeJSON!TConfig(filePath, configInstance);
}


/// Manages all settings and configurations for Atom
public struct ConfigManager
{
    private enum ConfigsPath = "configs/";
    private enum SimulationConfigPath = ConfigsPath ~ "simulation.json";
    private enum SimulationStartInfoConfigPath = ConfigsPath ~ "simulationStartInfo.json";

    /// Run Config Manager
    public void Run()
    {
        cwriteln("Atom config manager".color(fg.yellow));
        LoadConfigWithFeedback!(SimulationConfig, GSC)(SimulationConfigPath);
        LoadConfigWithFeedback!(SimulationStartInfoConfig, GSIC)(SimulationStartInfoConfigPath);

        if(AskAboutEditConfig!(SimulationConfig, GSC)("Do you want to edit simulation config? (y/n)"))
            AskAboutSaveConfig!(SimulationConfig, GSC)(SimulationConfigPath, "Do you want to save config? (y/n)");

        if(AskAboutEditConfig!(SimulationStartInfoConfig, GSIC)("Do you want to edit simulation start info config? (y/n)"))
            AskAboutSaveConfig!(SimulationStartInfoConfig, GSIC)
                (SimulationStartInfoConfigPath, "Do you want to save config? (y/n)");
    }

    private bool TryLoadConfig(TConfig, alias configInstance)(tstring filePath)
    {
        if (exists(ConfigsPath) && isDir(ConfigsPath))
        {
            if(exists(filePath))
                configInstance = readJSON!TConfig(filePath);
            else 
            {
                write(filePath, toJSONString!TConfig(configInstance));
                return false;
            }
        } 
        else
        {
            mkdir(ConfigsPath);
            write(filePath, toJSONString!SimulationConfig(GSC));
            return false;
        } 

        return true;
    }

    private void LoadConfigWithFeedback(TConfig, alias configInstance)(tstring filePath)
    {
        enum successLoadMessage = "Config loaded successfully.";
        enum loadErrorMessage = "Could not load config. Using default settings.";

        bool couldLoadConfig = TryLoadConfig!(TConfig, configInstance)(filePath);

        if(!couldLoadConfig) cwriteln((loadErrorMessage ~ " " ~ filePath).color(fg.red));        
        else cwriteln(successLoadMessage.color(fg.green));
    }
}
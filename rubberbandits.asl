state("RubberBandits"){}

startup
{
    vars.Log = (Action<object>)((output) => print("[Rubber Bandits ASL] " + output));
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "RubberBandits";
    vars.Helper.LoadSceneManager = true;

    settings.Add("split_stage", true, "Split on stage complete");
    settings.Add("split_chapter", false, "Split on chapter complete");

    vars.FinalSceneName = "TheLastStand_v2 [Client]";
    vars.FirstSceneName = "Dock_Small [Client]";
    vars.ChapterEndScenes = new List<String>() {
        "Dock_Train [Client]", "Airport_Helipad [Client]", 
        "Museum_Art [Client]", "Street_Trucks_2 [Client]", 
        "Bank_Central [Client]"
    };
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var rewardsScreen = mono["RewardsScreen"];
        vars.Helper["rewards"] = rewardsScreen.Make<bool>("RewardScreenActive");
        return true;
    });
    vars.initflag = true;
}

start
{
    return current.scene != old.scene && current.scene == vars.FirstSceneName;
}

update
{
    if (vars.initflag) {
        old.scene = "";
        vars.initflag = false;
    }

    if (vars.Helper.Scenes.Active.Name != "")
    {
        current.scene = vars.Helper.Scenes.Active.Name;
    }

    if (vars.Helper["rewards"].Changed) {
        vars.Log("rewardsScreenActive:" + vars.Helper["rewards"].Current);
    }

    if (current.scene != old.scene) {
        vars.Log(current.scene);
    } 
}

split
{
    var finalScene = current.scene == vars.FinalSceneName;
    if (vars.Helper["rewards"].Current && !vars.Helper["rewards"].Changed) {
        var chapterSplit = settings["split_chapter"] && vars.ChapterEndScenes.Contains(current.scene);
        if (settings["split_stage"] || settings["split_chapter"] || finalScene) {
            return true;
        }
    }
}
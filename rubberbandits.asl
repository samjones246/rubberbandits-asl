state("RubberBandits") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "RubberBandits";
    vars.Helper.LoadSceneManager = true;

    settings.Add("split_stage", true, "Split on stage complete");
    settings.Add("split_chapter", false, "Split on chapter complete");

    vars.FinalSceneName = "TheLastStand_v2 [Client]";
    vars.FirstSceneName = "Dock_Small [Client]";
    vars.ChapterEndScenes = new List<string> {
        "Dock_Train [Client]", "Airport_Helipad [Client]",
        "Museum_Art [Client]", "Street_Trucks_2 [Client]",
        "Bank_Central [Client]"
    };
}

init {
    old.scene = "";
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["rewards"] = mono.Make<bool>("RewardsScreen", "RewardScreenActive");
        return true;
    });
}

start {
    return current.scene != old.scene && current.scene == vars.FirstSceneName;
}

update {
    if (!string.IsNullOrEmpty(vars.Helper.Scenes.Active.Name)) {
        current.scene = vars.Helper.Scenes.Active.Name;
    }

    if (current.rewards != old.rewards) {
        vars.Log("rewardsScreenActive:" + current.rewards);
    }

    if (current.scene != old.scene) {
        vars.Log(current.scene);
    }
}

split {
    var finalScene = current.scene == vars.FinalSceneName;
    if (!old.rewards && current.rewards) {
        var chapterSplit = settings["split_chapter"] && vars.ChapterEndScenes.Contains(current.scene);
        if (settings["split_stage"] || settings["split_chapter"] || finalScene) {
            return true;
        }
    }
}

{
  title = "CoopNet";
  headerStyle = "clean";

  background = {
    # image = ./background.png;
    blur = "xl";
    brightness = 90;
    opacity = 60;
  };

  cardBlur = "sm";

  providers = {
    openweathermap = "openweathermapapikey";
    weatherapi = "weatherapiapikey";
  };

  layout = {
    Networking = { icon = "mdi-network-#FFFFFF"; };
    "Infrastructure and Data" = { icon = "mdi-server-#FFFFFF"; };
    "ARR-Stack" = { icon = "mdi-auto-fix-#FFFFFF"; };
    Utilities = { icon = "mdi-list-status-#FFFFFF"; };
  };

  quicklaunch = {
    searchDescriptions = true;
    hideInternetSearch = true;
    showSearchSuggestions = true;
    hideVisitURL = true;
    provider = "duckduckgo";
  };

  theme = "dark";
  color = "slate";
  disableCollapse = true;
  hideVersion = true;
}

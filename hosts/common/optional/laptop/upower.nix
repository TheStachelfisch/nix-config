{...}: {
  services.upower = {
    enable = true;
    noPollBatteries = true;
    criticalPowerAction = "Hibernate";
  };
}

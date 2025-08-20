{...}: {
  fonts.fontDir.enable = true;
  documentation = {
    dev.enable = true;
    man = {
      man-db.enable = false;
      mandoc.enable = true;
    };
  };
}

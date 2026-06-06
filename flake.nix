{
  description = "A skeleton to allow for Astrolabe integration.";

  nixConfig = {
    allow-import-from-derivation = false;
    extra-experimental-features = ["no-url-literals"];
    sandbox = "relaxed";
    use-registries = false;
  };

  outputs = {...}: {
    overlays = {
      default = final: prev: {};

      haskell = final: prev: hfinal: hprev: {};
    };
  };
}

{ name = "counter"
, dependencies =
  [ "affjax"
  , "affjax-web"
  , "console"
  , "effect"
  , "either"
  , "flame"
  , "maybe"
  , "prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

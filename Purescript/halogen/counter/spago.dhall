{ name = "halogen-project"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "console"
  , "effect"
  , "either"
  , "halogen"
  , "maybe"
  , "prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

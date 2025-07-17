{ name = "second-attempt"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "halogen"
  , "maybe"
  , "prelude"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

{ name = "second-attempt"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "exceptions"
  , "halogen"
  , "maybe"
  , "prelude"
  , "transformers"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

{ name = "counter"
, dependencies =
  [ "affjax"
  , "affjax-web"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "flame"
  , "integers"
  , "maybe"
  , "prelude"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

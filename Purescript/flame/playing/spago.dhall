{ name = "playing"
, dependencies =
  [ "affjax"
  , "affjax-web"
  , "arrays"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "flame"
  , "integers"
  , "maybe"
  , "prelude"
  , "strings"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

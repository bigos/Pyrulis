{ name = "second-attempt"
, dependencies =
  [ "console", "effect", "maybe", "prelude", "web-dom", "web-html" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

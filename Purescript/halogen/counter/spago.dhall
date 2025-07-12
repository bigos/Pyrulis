{ name = "halogen-project"
, dependencies = [ "affjax-web", "console", "effect", "halogen", "prelude" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

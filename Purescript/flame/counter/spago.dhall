{ name = "counter"
, dependencies = [ "console", "effect", "flame", "prelude" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

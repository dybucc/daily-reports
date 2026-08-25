set minimum-version := "1.52.0"
set default-list

alias b := build

typst := require("typst")

# [todo]: add a .env file that sets up the `TYPST_PACKAGE_PATH` variable, read
# it # from just, and test it out. This needs me first setting up a Git
# submodule pointing to another repo where the template is hosted at. Then
# before building, check out the module.

# Build all Typst source files in the list of daily reports, including the
# site's entry point.
build:
    {{ typst }} compile --features=html --format=html ./*.typ

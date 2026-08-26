set minimum-version := "1.56.0"
set unstable
set default-list
set lazy
set no-exit-message
set indentation := "    "
set lists

alias b := build

[macos]
brew := require("brew")

git := require("git")

template_ver := "0.1.4"
template_submod := trim(shell(f'
    mkdir -p ./pkgs/local \
    && {{ git }} clone --depth=1 --filter=blob:none \
    https://github.com/dybucc/scratchpad.git \
    ./pkgs/local/scratchpad/{{ template_ver }} \
    && {{ git }} checkout {{ template_ver }}  \
    && echo "pkgs"
'))

# [todo]: add a .env file that sets up the `TYPST_PACKAGE_PATH` variable, read
# it from just, and test it out. This needs me first setting up a Git
# submodule pointing to another repo where the template is hosted at. Then
# before building, check out the module.

[doc("Compiles Typst files (the reports and the site entry point) to HTML.")]
[env("TYPST_PACKAGE_PATH", f"{{ justfile_dir() / template_submod }}")]
build: _prepare
    @typst info
    typst compile --features=html --format=html ./*.typ

[macos]
_prepare:
    {{ brew }} install -y typst fd
    @echo {{ f"{{ style("bold", "[INFO]") }}: Pre-requisites ready!" }}

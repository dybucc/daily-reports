set minimum-version := "1.56.0"
set default-list
set lazy
set no-exit-message
set indentation := "    "

alias b := build

[macos]
brew := require("brew")

git := require("git")

template_ver := "0.1.4"
template_submod := trim(shell(f'
    mkdir -p ./pkgs/local/scratchpad/{{ template_ver }} \
    && cd ./pkgs/local/scratchpad/{{ template_ver }} \
    && {{ git }} clone --depth=1 --filter=blob:none \
    https://github.com/dybucc/scratchpad.git . \
    && {{ git }} checkout {{ template_ver }}  \
    && echo "pkgs"
'))

[doc("Compiles Typst files (the reports and the site entry point) to HTML.")]
[env("TYPST_PACKAGE_PATH", f"{{ justfile_dir() / template_submod }}")]
build: _prepare
    @echo {{ f"{{ style("bold", "[INFO]") }}: Typst environment:" }}
    @typst info
    for file in ./*.typ \
    do \
        typst compile --features=html --format=html $file \
    done

[macos]
_prepare:
    {{ brew }} install -y typst fd font-maple-mono
    @echo {{ f"{{ style("bold", "[INFO]") }}: Pre-requisites ready!" }}

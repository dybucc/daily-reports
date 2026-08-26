set minimum-version := "1.56.0"
set unstable
set default-list
set lazy
set no-exit-message
set indentation := "    "

alias b := build

git := require("git")
cargo := require("cargo")
typst_ver := "0.15.1"

template_ver := "0.1.4"
template_submod := trim(shell(f'
    mkdir -p ./pkgs/local/scratchpad/{{ template_ver }} \
    && cd ./pkgs/local/scratchpad/{{ template_ver }} \
    && {{ git }} clone --depth=1 --filter=blob:none \
        https://github.com/dybucc/scratchpad.git . \
    && {{ git }} checkout {{ template_ver }}  \
    && echo "pkgs"
'))

info(msg) := f"{{ style("bold", "[INFO]") }}: {{ msg }}"

[doc("Compiles Typst files (the reports and the site entry point) to HTML.")]
[env("TYPST_FEATURES", "html")]
[env("TYPST_FONT_PATHS", f"{{ justfile_dir() / "maple-mono" }}")]
[env("TYPST_PACKAGE_PATH", f"{{ justfile_dir() / template_submod }}")]
build: _prepare
    @echo {{ info("Pre-requisites set up!") }}
    @echo {{ info("Typst environment") }}
    @typst info
    for file in ./*.typ \
    do \
        typst compile --format=html $file \
    done

_prepare:
    {{ cargo }} install \
        --git https://github.com/typst/typst.git --tag {{ "v" + typst_ver }} \
        --locked

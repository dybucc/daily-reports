set minimum-version := "1.56.0"
set unstable
set default-list
set lazy
set no-exit-message
set indentation := "    "
set lists
set guards

alias b := build
alias p := prepare
alias v := typst-version

git := require("git")
cargo := require("cargo")
typst := which("typst")
rg := which("rg")
typst_ver := "0.15.1"

template_ver := trim(```
  rg -N -m 1 -s -e '(?m)^.*\d+\.\d+\.\d+' ./index.typ \
  | rg -N -s -o -e '\d+\.\d+\.\d+'
```)
template_submod := trim(shell(f'
    mkdir -p ./pkgs/local/scratchpad/{{ template_ver }} \
    && cd ./pkgs/local/scratchpad/{{ template_ver }} \
    && {{ git }} clone --depth=1 --filter=blob:none \
        https://github.com/dybucc/scratchpad.git . \
    && {{ git }} checkout {{ template_ver }}  \
    && echo "pkgs"
'))

info(msg) := f"{{ style("bold", "[INFO]") }}: {{ msg }}"

export TYPST_FEATURES := "html"
export TYPST_FONT_PATHS := f"{{ justfile_dir() / "maple-mono" }}"
export TYPST_PACKAGE_PATH := f"{{ justfile_dir() / template_submod }}"

[doc("Compiles Typst files (the reports and the site entry point) to HTML.")]
@build: && _compile
    echo {{ info("Typst environment") }}
    typst info

[doc("Installs typst-cli and ripgrep if not in PATH. Used in CI.")]
@prepare:
    ?{{ if typst { "return 1" } else { "return 0" } }}
    {{ cargo }} install \
        --git https://github.com/typst/typst.git \
        --tag {{ "v" + typst_ver }} \
        --locked \
        typst-cli
    ?{{ if rg { "return 1" } else { "return 0" } }}
    {{ cargo }} install --locked ripgrep

[doc("Reports the Typst compiler version in use. Used in CI.")]
@typst-version:
    echo "version={{ typst_ver }}"

_compile:
    #!/usr/bin/env -S sh
    for file in ./*.typ
    do
        typst compile --format=html $file
    done

image := "janus-identicon-api"
port := "3000"
wasm_crate := "crates/identicon-wasm"
wasm_pkg_dir := wasm_crate + "/pkg"
version := "0.2.2"

# Build and run the API container with Podman.
container:
    podman build -t {{image}} -f Containerfile .
    podman run --rm -p {{port}}:3000 {{image}}

# Build the WASM npm package (wasm-pack via Bun; matches CI bundler target).
wasm:
    rustup target add wasm32-unknown-unknown
    bunx wasm-pack build {{wasm_crate}} --target bundler --release --scope janus-iam
    test -f {{wasm_pkg_dir}}/package.json

release:
    gh workflow run release.yml --ref main -f version={{version}} -f create_github_release=true
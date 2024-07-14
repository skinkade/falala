# falala

[![Package Version](https://img.shields.io/hexpm/v/falala)](https://hex.pm/packages/falala)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/falala/)

```sh
gleam add falala@1
```
```gleam
import falala/fa
import gleam/io
import gleam_community/colour
import lustre/element

// prints:
// <i class="fa-rotate-by fa-2xl fa-solid fa-building" style="--fa-rotate-angle:20deg; color:#75507B;"></i>
pub fn main() {
  fa.building()
  |> fa.set_variant_solid()
  |> fa.set_size_2xl()
  |> fa.set_color(colour.purple)
  |> fa.set_rotation(20)
  |> fa.render()
  |> element.to_string()
  |> io.println()
}
```

Further documentation can be found at <https://hexdocs.pm/falala>.

## Development

```sh
cd generator
gleam run
```

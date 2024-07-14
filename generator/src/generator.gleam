import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regex
import gleam/string
import simplifile

fn read(cwd) {
  let css_path = cwd <> "/../Font-Awesome/css/all.css"
  let css = case simplifile.read(css_path) {
    Error(e) -> {
      io.debug(css_path)
      io.debug(e)
      panic as "Couldn't read CSS file"
    }
    Ok(css) -> css
  }

  let base_path = cwd <> "/src/base.gleam"
  let base = case simplifile.read(base_path) {
    Error(e) -> {
      io.debug(base_path)
      io.debug(e)
      panic as "Couldn't read base file"
    }
    Ok(base) -> base
  }

  #(base, css)
}

fn to_glyph_fn(fa_name) {
  let assert Ok(#(_, name)) = string.split_once(fa_name, "-")
  let name = string.replace(name, "-", "_")

  // some class basenames start with numbers
  let name = case name |> string.slice(0, 1) |> int.parse() {
    Error(_) -> name
    Ok(_) -> "number" <> name
  }

  "pub fn " <> name <> "() -> List(Attribute(a)) {
  [class(\"" <> fa_name <> "\")]
}"
}

fn parse(css) {
  let assert Ok(glyph_regex) =
    regex.from_string("\\.(fa-.*?):{1,2}before\\s\\{\\s*content.*}")
  let matches = regex.scan(content: css, with: glyph_regex)
  matches
  |> list.map(fn(match) {
    let assert [Some(fa_name)] = match.submatches
    fa_name
  })
  |> list.map(to_glyph_fn)
}

pub fn main() {
  let cwd = case simplifile.current_directory() {
    Error(e) -> {
      io.debug(e)
      panic as "Couldn't read current directory"
    }
    Ok(cwd) -> cwd
  }
  let #(base, css) = read(cwd)
  let glyphs = css |> parse() |> string.join("\n\n")
  let content = base <> "\n" <> glyphs

  let source_path = cwd <> "/../src/falala/fa.gleam"
  let assert Ok(_) = simplifile.write(source_path, content)
}

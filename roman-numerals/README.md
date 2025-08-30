# Reading Roman Numerals

## Description

For our first session, we will start with something easy. This challenge will need us to solve file reading and a non-trivial algorithm. Nothing too crazy!

Please remember that our allowed languages are:

- Rust
- Go
- Python
- TypeScript [with Effect.ts](https://effect.website/)
- Erlang/Gleam/Elixir or [any other language running on the BEAM virtual machine](https://github.com/llaisdy/beam_languages)

The goal is simple:

1. Copy your input of Roman numerals and save it into a text file.
2. Read the file and parse the numerals into integers
   - Each line contains a single numeral
   - Be careful! Not all lines are valid numerals. Disregard these lines!
   - Valid numerals use upper case Latin letters (`I`, `V`, `X`, `L`, `C`, `D`, `M`)
   - Valid numbers are between `1` and `3 999`, inclusive
3. The result is a sum of those numerals

#!/bin/bash -eu

BASE_VERSION="$(git describe --tags HEAD)"
BASE_COMMIT="$(git rev-parse HEAD)"

{
  cat <<'_EOT_'
# AC(AtCoder) Library Patched for My Library

This is [AtCoder Library](https://github.com/atcoder/ac-library) patched for [anqooqie](https://github.com/anqooqie)'s library.
No PRs or issues are accepted at this repository.
Instead, contribute to the official one.

## Base version

_EOT_
  printf 'It is based on [%s](https://github.com/atcoder/ac-library/tree/%s) of the official repository.\n' "${BASE_VERSION}" "${BASE_COMMIT}"
  cat <<'_EOT_'
The patch is applied by `patch.sh`, and this branch is rebuilt on the latest official commit and force-pushed every time the base is updated.

## Differences from the official repository

- In `atcoder/lazysegtree.hpp`, the members of `lazy_segtree` are `protected` instead of `private`, and `all_apply` is `virtual`, so that a derived class can implement Segment Tree Beats.
- In `atcoder/convolution.hpp`, `z` is marked `[[maybe_unused]]`, since it is used only in an `assert` and is therefore unused when `NDEBUG` is defined.
- In `atcoder/internal_math.hpp` and `atcoder/internal_type_traits.hpp`, the declarations and the expression that name `__int128` are prefixed with `__extension__`, so that GCC does not warn about them under `-pedantic`.
- `expander.py`, `test` and `tools` are removed, since they are unnecessary for using this repository as a submodule. In particular, `test` has [googletest](https://github.com/google/googletest) and [benchmark](https://github.com/google/benchmark) as its own submodules, which a recursive clone would otherwise fetch.
- This `README.md` replaces the official one.

Nothing else is changed.
_EOT_
} >README.md

sed -r 's/private:/protected:/g' -i atcoder/lazysegtree.hpp
sed -r 's/void all_apply/virtual void all_apply/g' -i atcoder/lazysegtree.hpp

sed -zr 's/(int z = \(int\)internal::bit_ceil[^\n]*\n\s*)assert/[[maybe_unused]] \1assert/g' -i atcoder/convolution.hpp

sed -r 's/\(unsigned __int128\)\(z\)/__extension__ &/g' -i atcoder/internal_math.hpp
sed -zr 's/template <class T>\n(using (is_signed_int128|is_unsigned_int128|make_unsigned_int128) =)/__extension__ template <class T>\n\1/g' -i atcoder/internal_type_traits.hpp

rm -rf expander.py test tools

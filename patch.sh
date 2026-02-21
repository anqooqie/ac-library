#!/bin/bash -eu

cat <<'_EOT_' >README.md
# AC(AtCoder) Library Patched for My Library

This is [AtCoder Library](https://github.com/atcoder/ac-library) patched for [anqooqie](https://github.com/anqooqie)'s library.
No PRs or issues are accepted at this repository.
Instead, contribute to the official one.
_EOT_

cp atcoder/all atcoder/all.hpp
while IFS= read -r FILE_PATH; do
  sed -r 's/#include "atcoder\/([^"]*)"/#include "atcoder\/\1.hpp"/g' -i "${FILE_PATH}"
  rm "${FILE_PATH%.hpp}"
done < <(find atcoder -type f -name '*.hpp')

sed -r 's/private:/protected:/g' -i atcoder/lazysegtree.hpp
sed -r 's/void all_apply/virtual void all_apply/g' -i atcoder/lazysegtree.hpp

sed -zr 's/(int z = \(int\)internal::bit_ceil[^\n]*\n\s*)assert/[[maybe_unused]] \1assert/g' -i atcoder/convolution.hpp

rm -rf expander.py test tools

tmpdir=$(mktemp -d ./tex-refresh.XXXXXX) || exit 1
shopt -s nullglob
files=(*.tex)

((${#files[@]})) || {
    echo "No .tex files found."
    rmdir "$tmpdir"
    exit 1
}

for f in "${files[@]}"; do
    cp -- "$f" "$tmpdir/$f" || exit 1
    cmp -s -- "$f" "$tmpdir/$f" || {
        echo "Temporary copy failed: $f"
        exit 1
    }
done

for f in "${files[@]}"; do
    rm -- "$f" || exit 1
    cat -- "$tmpdir/$f" > "$f" || {
        echo "Could not recreate: $f"
        echo "Recovery copies remain in: $tmpdir"
        exit 1
    }
done

rm -r -- "$tmpdir"
echo "All .tex files recreated successfully."

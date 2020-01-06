#!/bin/bash
# Tested with spring-boot 1.5.10 jar, on both MacOS and Ubuntu.

set -eo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: ./reproducible-jar.sh INPUT_JAR [OUTPUT_JAR]"
    exit 1
fi

pwd_dir="$(pwd)"
input_jar="$1"
if [[ $# -eq 1 ]]; then
    output_jar="$input_jar"
else
    output_jar="$2"
fi

# unzip the input jar
zip_dir="$(dirname $output_jar)/tmp"
rm -rf "$zip_dir"
mkdir -p "$zip_dir"
unzip -q "$input_jar" -d "$zip_dir"

cd "$zip_dir"

# rm pom.properties, because it contains lines that are unreproducible
find ./META-INF/maven -name "pom.properties" | xargs rm

# modify MANIFEST.MF, because it contains lines that are unreproducible
mf="./META-INF/MANIFEST.MF"
cat "$mf" \
    | grep -v "^Implementation-Version:" \
    | grep -v "^Built-By:" \
    | grep -v "^Created-By:" \
    | grep -v "^Build-Jdk:" \
    | tr -d $'\r' \
    > "${mf}.tmp"
mv -f "${mf}.tmp" "$mf"

# list files and sort it in a fixed order
wont_compress_dir="./BOOT-INF/lib"
if [[ -d $wont_compress_dir ]]; then
    wont_compress_files="$(find $wont_compress_dir -print | LC_ALL=C sort)"
fi
need_compress_files="$(find . -path $wont_compress_dir -prune -o -print | LC_ALL=C sort | tail -n +2)"

# create jar
zip_file="tmp.jar"
echo "$need_compress_files" | xargs touch -h -t "199901010000.00"
echo "$need_compress_files" | xargs zip -qoX6@ "$zip_file"
if [[ -d $wont_compress_dir ]]; then
    echo "$wont_compress_files" | xargs touch -h -t "199901010000.00"
    echo "$wont_compress_files" | xargs zip -qoX0@ "$zip_file"
fi

# move jar to destination
cd "$pwd_dir"
if [[ "$input_jar" = "$output_jar" ]]; then
    mv -f "$input_jar" "${input_jar}.unreproducible.jar"
fi
mv -f "$zip_dir/$zip_file" "$output_jar"
rm -rf "$zip_dir"

# print md5 of the output jar for debug
print_md5() {
    os="$(uname -s)"
    if [[ "$os" = "Darwin" ]]; then
        md5 "$1"
    elif [[ "$os" = "Linux" ]]; then
        md5sum --tag "$1"
    else
        echo "Err: cannot show md5!"
    fi
}

# print_md5 "$output_jar"


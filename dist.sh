#!/usr/bin/env bash

function append {
    echo -e "//File: $1\n\n" >> backdrop.swift
    cat $1 >> backdrop.swift
    echo -e "\n\n\n" >> backdrop.swift
}

echo "#!/usr/bin/swift" > backdrop.swift

for f in source/CommandLine/*.swift; do append $f; done
for f in source/Utils/*.swift; do append $f; done
for f in source/*.swift; do append $f; done
for f in source/Main/*.swift; do append $f; done

chmod +x backdrop.swift

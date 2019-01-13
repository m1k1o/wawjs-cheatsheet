#!/bin/bash
perl -pe 's/\(.*\.md\)/"(#anchor_" . ++$n . ")"/ge' text/README.md > cheatsheet.md && perl -pe 's/^#\s/$& . "\<a name=\"anchor_" . ++$n . "\"\>\<\/a\> " . $n . " "/ge' text/0* >> cheatsheet.md

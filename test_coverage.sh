#!/bin/bash
flutter test --coverage
lcov --remove coverage/lcov.info \
'lib/main.dart' \
'lib/*/*.g.dart' \
'lib/app/app.dart' \
-o coverage/lcov.info
genhtml coverage/lcov.info -o coverage
open coverage/index.html

export JAVA_HOME=$(find "$(brew --prefix)/Cellar/openjdk@17" -mindepth 1 -maxdepth 1 >/dev/null | sort | tail -1)/libexec/openjdk.jdk/Contents/Home

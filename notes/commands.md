# Commands

Quick command reference for VS Code User Build, Git, USS, Zowe, and DBB work.

## Git

```sh
git remote -v
git branch -vv
git status --short
```

## User Build Logs

```sh
find "$HOME/Library/Application Support/Code/logs" -name 'userbuild-*.log' -print
```

## USS Checks

```sh
ls -rlt /z/z88589/userbuild/MortgageApplication/samples/MortgageApplication/application-conf
```

## Local Checks

```sh
ruby -rjson -e 'JSON.parse(File.read(".vscode/settings.json")); puts "settings.json OK"'
ruby -e 'require "yaml"; YAML.load_file("zapp.yaml"); puts "zapp.yaml OK"'
```


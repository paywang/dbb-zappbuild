# Known Good

Record working settings, commands, paths, and build output here.

## VS Code Workspace Settings

```json
{
  "zopeneditor.zowe.maximumParallelFileUploads": 1,
  "zopeneditor.userbuild.userSettings": {
    "dbbHlq": "PEI.VSCODE.USERBLD",
    "dbbWorkspace": "/z/z88589/userbuild",
    "dbbLogDir": "/z/z88589/vscode.logs",
    "dbbDefaultZappProfile": "dbb-build",
    "localLogDir": "/Users/peiwang/poc/mainframe/userbuild"
  }
}
```

## ZAPP Profile Shape

```yaml
profiles:
  - name: dbb-build
    type: dbb
    settings:
      application: MortgageApplication
      command: "/z/z88589/run-dbb.sh"
      buildScriptPath: "/z/z88589/poc/dbb-zappbuild/build.groovy"
      buildScriptArgs:
        - "--userBuild"
        - "--workspace ${zopeneditor.userbuild.userSettings.dbbWorkspace}"
        - "--application ${application}/samples/MortgageApplication"
        - "--hlq ${zopeneditor.userbuild.userSettings.dbbHlq}"
        - "--outDir ${zopeneditor.userbuild.userSettings.dbbLogDir}"
        - "--verbose"
        - "--dependencyFile ${dependencyFile}"
```

## USS Layout

```text
/z/z88589/userbuild/MortgageApplication/samples/MortgageApplication/
```


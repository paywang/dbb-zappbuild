# VS Code User Build Setup

This note records the setup used to run IBM User Build from VS Code for the local `dbb-zappbuild` workspace.

## 1. Open the Local Workspace

Workspace root:

```text
/Users/peiwang/poc/mainframe/dbb-zappbuild
```

IBM User Build identified this as the local root workspace path.

## 2. Use Workspace Settings for This Repo

Workspace settings are stored in:

```text
.vscode/settings.json
```

Workspace settings take precedence over VS Code user settings for this repo. This was confirmed by the User Build log showing the workspace override:

```text
maximum of 1 parallel uploads
```

Current workspace settings:

```json
{
  "zopeneditor.zowe.maximumParallelFileUploads": 1,
  "zopeneditor.userbuild.userSettings": {
    "dbbHlq": "PEI.VSCODE.USERBLD",
    "dbbWorkspace": "/z/z88589/userbuild",
    "dbbLogDir": "/z/z88589/vscode.logs",
    "dbbDefaultZappProfile": "dbb-build",
    "localLogDir": "/Users/peiwang/poc/mainframe/userbuild",
    "additionalDependencies": "samples/MortgageApplication/application-conf"
  }
}
```

Notes:

- `dbbWorkspace` is the USS workspace root used by User Build.
- `dbbHlq` is the HLQ used for build output datasets.
- `dbbLogDir` is where build logs and reports are written on USS.
- `localLogDir` is where downloaded logs are stored locally.
- `dbbDefaultZappProfile` selects the `dbb-build` profile in `zapp.yaml`.
- `zopeneditor.zowe.maximumParallelFileUploads` is set to `1` to make uploads serial and easier to debug.

## 3. Configure the ZAPP Profile

ZAPP file:

```text
zapp.yaml
```

Active profile:

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
      additionalDependencies:
        - "samples/MortgageApplication/application-conf"
      logFilePatterns:
        - "${buildFile.basename}.log"
        - "BuildReport.*"
```

Important path behavior:

- `application: MortgageApplication` is used by IBM User Build as the remote upload prefix.
- `--application ${application}/samples/MortgageApplication` tells zAppBuild where the application is under the USS workspace.
- With the current setup, the expected USS application path is:

```text
/z/z88589/userbuild/MortgageApplication/samples/MortgageApplication
```

## 4. Add Additional Dependencies

The application configuration directory must be uploaded before zAppBuild runs:

```yaml
additionalDependencies:
  - "samples/MortgageApplication/application-conf"
```

This uploads local files from:

```text
samples/MortgageApplication/application-conf
```

to USS under:

```text
/z/z88589/userbuild/MortgageApplication/samples/MortgageApplication/application-conf
```

Do not use this unsupported form in `additionalDependencies`:

```yaml
- "${zopeneditor.userbuild.userSettings.additionalDependencies}"
```

That caused:

```text
CRRZG5354E Found an invalid zapp parameter
```

## 5. Use Full Upload When Needed

Use **Run IBM User Build with full upload** after changing:

- `zapp.yaml`
- `additionalDependencies`
- `.vscode/settings.json`
- application configuration files under `application-conf`

Regular **Run IBM User Build** may not re-upload all additional dependencies.

## 6. Confirm Uploads on USS

Check the USS application configuration directory:

```sh
ls -rlt /z/z88589/userbuild/MortgageApplication/samples/MortgageApplication/application-conf
```

Expected important files include:

```text
application.properties
file.properties
BMS.properties
Cobol.properties
LinkEdit.properties
CRB.properties
languageConfigurationMapping.properties
README.md
```

## 7. Validate Local Configuration

Validate workspace settings:

```sh
ruby -rjson -e 'JSON.parse(File.read(".vscode/settings.json")); puts "settings.json OK"'
```

Validate ZAPP YAML:

```sh
ruby -e 'require "yaml"; YAML.load_file("zapp.yaml"); puts "zapp.yaml OK"'
```

Run local helper checks:

```sh
scripts/check-env.sh
scripts/check-dbb.sh
```

## 8. Current Build Status

The upload and path mapping issues were resolved. The build now reaches zAppBuild required property validation.

Current known remaining issue:

```text
Missing required build property 'SDFHCOB'
```

The required site dataset properties need real values in:

```text
build-conf/datasets.properties
```

Common required COBOL-related properties:

```text
SCEELKED
SIGYCOMP_V6
SDFHLOAD
SDFHCOB
SDSNLOAD
```


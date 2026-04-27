# Troubleshooting

## Invalid ZAPP Parameter

Symptom:

```text
CRRZG5354E Found an invalid zapp parameter
```

Fix:

- Do not use unsupported `${zopeneditor.userbuild.userSettings.*}` substitutions in `additionalDependencies`.
- Use a concrete path in `zapp.yaml`.

## Missing Additional Dependency on USS

Symptom:

```text
The specified .../application-conf/Cobol.properties does not exist.
```

Checks:

```sh
ls -rlt /z/z88589/userbuild/MortgageApplication/samples/MortgageApplication/application-conf
```

Fix:

- Run **Run IBM User Build with full upload**.
- Set `"zopeneditor.zowe.maximumParallelFileUploads": 1` to make uploads serial.

## Missing Required Build Property

Symptom:

```text
Missing required build property 'SDFHCOB'
```

Fix:

- Populate required site datasets in `build-conf/datasets.properties`.
- Common required COBOL values include `SDFHCOB`, `SDFHLOAD`, `SDSNLOAD`, `SCEELKED`, and `SIGYCOMP_V6`.

## Unable to Resolve RepositoryClient

Symptom:

```text
/Z/z88589/poc/dbb-zappbuild/build.groovy: 23: unable to resolve class RepositoryClient
 @ line 23, column 25.
 @Field RepositoryClient repositoryClient
```

Fix:

- This happens when using an older zAppBuild version.
- Check out the `main` branch, not a `2.xxx` branch.

## Missing Required Build Property buildOrder

Symptom:

```text
Missing required build property 'buildOrder'
```

Fix:

- Add `additionalDependencies` in `zapp.yaml` so User Build uploads the application properties under `application-conf`.
- Run **Run IBM User Build with full upload** after changing `additionalDependencies`.

# File Property Management Notes

## Which Method Should You Use?

Practical guide:

| Situation | Best approach |
| - | - |
| Most files use the same options | Use default language properties |
| A group of files needs one special flag | Use `file.properties` with a wildcard pattern |
| One file needs one small override | Use `file.properties` |
| One file has many special overrides | Use an individual artifact `.properties` file |
| Many files belong to reusable build categories | Use language configuration mapping |
| You are migrating from ChangeMan/Endevor processor groups | Language configuration mapping may be easiest to understand |

Client project recommendation:

Start with language configuration mapping if the client already thinks in terms of build types, processor groups, or application artifact types.

Use `file.properties` for simple overrides.

Use individual artifact properties files only for truly special cases, because too many per-file property files can become hard to govern.

## The Most Important Concept

The document is really about this:

zAppBuild separates source code from build behavior.

Your COBOL source file may just be:

```text
CUSTOMER.cbl
```

But zAppBuild needs to know:

- Is it batch or CICS?
- Does it use DB2?
- What compile options does it need?
- What link-edit stream does it need?
- What deploy type does it produce?
- Does it need bind processing?
- Does it have special runtime libraries?

File properties are the mechanism for answering those questions.

## Why This Matters For DBB/zAppBuild Assessment

When assessing a client's mainframe DevOps process, do not only ask:

> Can we compile the COBOL?

Ask:

> Where is the build knowledge stored today?

The real build knowledge may be hidden in:

- ChangeMan build procedures
- Endevor processors
- JCL
- ISPF panels
- Naming conventions
- PDS structures
- Copybook libraries
- Link-edit control cards
- DB2 bind jobs
- Tribal knowledge

This document explains how to capture that knowledge in zAppBuild.

## Client Questions

- Do different COBOL programs require different compile options?
- Which programs are batch, CICS, DB2, MQ, or mixed?
- Do you currently classify programs by type, processor group, or build category?
- Are link-edit options different by program or application group?
- Are DB2 bind options different by program?
- Are there special one-off programs with custom compile or link behavior?
- Are build rules stored in ChangeMan, Endevor, JCL, or somewhere else?
- Can you provide the current artifact types, processor groups, and build processors used by this application, including which source members are assigned to each?
- Can we map current processor groups to zAppBuild language configurations?
- Which build settings should be application-owned versus centrally governed?
- How will changes to file properties be reviewed and approved?

## Bottom Line

File Property Management is how zAppBuild turns a generic build framework into a client-specific mainframe build system. It is the bridge between "we have COBOL in Git" and "we can reliably build this application the same way the legacy toolchain did."

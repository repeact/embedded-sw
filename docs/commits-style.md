<!-- 
AI written documentation based on Angular conventionnal commits.
Covered topics and rules defined and reviewed by developpers
-->

# Commit Convention

This project follows the [Conventional Commits](https://www.conventionalcommits.org/) specification, based on [Angular commit message guidelines](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines).

## Format

```
<type>(<scope>): <subject>
```

The `scope` is optional.  
The `subject` must be in lowercase and not end with a period.

## Types

| Type       | Description                                                                                            |
| ---------- | ------------------------------------------------------------------------------------------------------ |
| `feat`     | A new feature                                                                                          |
| `fix`      | A bug fix                                                                                              |
| `refactor` | A code change that neither fixes a bug nor adds a feature                                              |
| `style`    | Changes that do not affect the meaning of the code (whitespace, formatting, missing semi-colons, etc.) |
| `perf`     | A code change that improves performance                                                                |
| `test`     | Adding missing tests or correcting existing tests                                                      |
| `docs`     | Documentation only changes                                                                             |
| `ci`       | Changes to CI configuration files and scripts                                                          |
| `build`    | Changes that affect the build system or external dependencies                                          |
| `chore`    | Other changes that don't modify source or test files                                                   |

## Scopes

Scopes map to the physical components of the project.  
Use a scope whenever it adds information the type alone does not carry.

| Scope    | Maps to        | Notes                                                                                                      |
| -------- | -------------- | ---------------------------------------------------------------------------------------------------------- |
| `tools`  | `scripts/`     | Any script (install, uninstall, setup, start, stop, rec, …). Name the specific script in the subject line. |
| `lib`    | `scripts/lib/` | Shared library: `common`, `const`, `errors`                                                                |
| `config` | `config/`      | Project configuration files                                                                                |
| `arch`   | `docs/arch/`   | Architecture and design diagrams                                                                           |
| `deploy` | `deploy/`      | System integration units: udev rules, systemd services, etc. installed on target                           |

### When to omit the scope

Some types are self-scoping and rarely need a scope qualifier:

- `docs` — the type already implies documentation. Add a scope only if targeting a specific subsystem (e.g. `docs(arch):`).
- `ci` — add a scope only if you have multiple distinct workflows to distinguish (e.g. `ci(release):`).
- `test` — use the component being tested as the scope: `test(tools):`, `test(lib):`.

## Examples

```
feat(tools):   implement uninstall script
fix(tools):    patch recording stop condition
refactor(lib): remove shebangs from sourced files
refactor(lib): reorder error codes by script range
feat(tools):   add upgrade and update flags to install
test(tools):   remove dead exit code in install test
test(lib):     fix test depending on installed sources
docs:          update setup guide
docs(arch):    add stop script design
ci(release):   change workflow trigger to manual
chore(config): add edid configuration file
```

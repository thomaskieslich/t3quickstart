# AGENTS.md – t3quickstart

## Project Overview
Bash-based tooling to scaffold and tear down TYPO3 projects via DDEV. Supports TYPO3 10–14.

**Key files:**
- `t3quickstart` – Main entry script (install/delete)
- `.env.<version>` – Version-specific defaults (10–14)
- `.env.local.dist` – Template for local overrides
- `.env.local` – Local overrides (not versioned)

## Commands

### Running the tool
```bash
./t3quickstart install <version> [project-name]   # Create TYPO3 project
./t3quickstart delete <version> [project-name]    # Remove TYPO3 project
```

### Linting & Formatting
```bash
shellcheck t3quickstart          # Static analysis (install: brew install shellcheck)
shfmt -w -i 2 -ci t3quickstart   # Format (install: brew install shfmt)
```

### DDEV Commands (inside a generated project)
```bash
ddev start                       # Start containers
ddev stop                        # Stop containers
ddev delete --omit-snapshot      # Remove instance
ddev composer require <package>  # Add Composer dependency
ddev typo3 cache:flush           # Clear TYPO3 caches
```

### Docker Cleanup
```bash
docker builder prune -f          # Reclaim builder cache
docker system prune -f           # Remove unused containers/images/volumes
```

## Code Style Guidelines

### Bash Conventions
- **Shebang**: `#!/bin/bash`
- **Strict mode**: `set -euo pipefail` at the top of every script
- **Indentation**: 2 spaces (no tabs)
- **Variable naming**: `UPPER_SNAKE_CASE` for environment/config vars, `lower_snake_case` for locals
- **Quoting**: Always quote variables: `"$var"`, `"${array[@]}"`
- **Functions**: `lowerCamelCase`, use `local` for all internal variables
- **Error messages**: Use color codes: `\033[33m` (yellow warnings), `\033[31m` (red errors)
- **Comments**: `## Section headers`, `# inline explanations`

### Environment Files
- `.env.<version>` contains version-specific defaults (PHP, DB, extension versions)
- `.env.local` overrides everything; never commit secrets
- Always use `${VAR:-default}` syntax for optional vars
- New variables must be added to `.env.local.dist` as documentation

### DDEV Configuration
- Project type: `typo3`
- Web server: `apache-fpm`
- Docroot: `public`
- Timezone: `Europe/Berlin`
- Upload dirs: `../.ddev/backup,fileadmin`

### TYPO3 Version Handling
- Use `case` statements for version-specific logic (never hardcode version checks)
- CLI commands differ: v10/11 use `install:*`, v12+ use `setup`
- Package names change: `cms-recordlist` (v11 only), `cms-t3editor` (v11+), `cms-reactions` (v12+)
- Branch mapping: 10→`10.4`, 11→`11.5`, 12→`12.4`, 13→`13.4`, 14→`14.1`

### Error Handling
- `set -euo pipefail` catches most errors automatically
- DDEV commands use `2>/dev/null || true` for cleanup operations that may fail on stopped instances
- Exit with `exit 1` on fatal errors, print message first
- Never suppress errors in critical paths (composer install, TYPO3 setup)

### Security
- Never commit `.env.local` (contains admin credentials)
- Database credentials in `.env.<version>` are DDEV defaults (`db`/`db`)
- Admin credentials must come from `.env.local`
- Use `ddev exec` for commands inside containers, never run as host root

### Adding New Features
1. Add config vars to `.env.local.dist` with defaults
2. Implement version-specific logic in `case` blocks
3. Test with at least two TYPO3 versions (e.g., 12 and 14)
4. Update README.md with new commands/options
5. Run `shellcheck` before committing

### Packages Directory (Optional)
- `CREATE_PACKAGES_DIR=1`: Erstellt lokalen `packages/` Ordner im Projekt
- `CREATE_PACKAGES_DIR=2`: Shared `packages/` via Docker Volume Mount
- Wird nur bei Bedarf aktiviert, existiert nicht standardmäßig



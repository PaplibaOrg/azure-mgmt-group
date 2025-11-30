# Commitlint and Husky Setup Instructions

All repositories in this organization must have commitlint and husky configured to enforce conventional commit messages.

## Required Setup

Every new repository must include:
1. **Husky** - Git hooks manager
2. **Commitlint** - Commit message linter with conventional commit rules

## Installation Steps

### 1. Initialize npm (if not already done)
```bash
npm init -y
```

### 2. Install Dependencies
```bash
npm install --save-dev husky @commitlint/cli @commitlint/config-conventional
```

### 3. Initialize Husky
```bash
npx husky init
```

### 4. Create Commitlint Config
Create `commitlint.config.js` in the repo root:
```javascript
module.exports = {
  extends: ['@commitlint/config-conventional'],
};
```

### 5. Create Commit-msg Hook
Create `.husky/commit-msg`:
```bash
npx --no -- commitlint --edit $1
```

## Commit Message Format

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>
```

### Allowed Types
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes
- `refactor` - Code refactoring
- `perf` - Performance improvements
- `test` - Adding or updating tests
- `build` - Build system or external dependencies
- `ci` - CI/CD configuration changes
- `chore` - Other changes (maintenance tasks)
- `revert` - Reverting a previous commit

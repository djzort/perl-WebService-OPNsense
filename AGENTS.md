# WebService::OPNsense

Perl client library for OPNsense REST API

Link: https://docs.opnsense.org/development/api.html

## Build

```bash
dzil build
```

## Test

```bash
dzil test
AUTHOR_TESTING=1 dzil test
prove -lvr t/
```

## Dependencies

- Perl v5.24+
- `WebService::Client` (HTTP client base role)
- `Moo` (OO framework)
- `strictures 2`
- `namespace::clean`
- `Ref::Util`
- `URI::Escape`
- `URI::Template`
- `Carp`
- `Const::Fast`
- `Exporter::Shiny` / `Exporter::Tiny`
- `JSON::MaybeXS`
- `UUID::Tiny`
- `Scalar::Util`
- `English`

## Structure

```
lib/
  WebService/
    OPNsense.pm             # Main class: consumes WebService::Client, 53 lazy accessors
    OPNsense/
      Constants.pm          # General-purpose enums via Const::Fast + Exporter::Tiny
      Normalize.pm          # IP normalization + UUID validation via Exporter::Shiny
      Exception.pm          # Structured exception (throw/croak)
      Object.pm             # Hash-based result object with nested conversion
      Backup.pm             # Configuration backups / restore
      HASync.pm             # High Availability sync
      Firewall.pm           # Firewall namespace (aggregator: filter, alias, category, d_nat, one_to_one, source_nat, npt)
      Firewall/
        Filter.pm, Alias.pm, Category.pm, DNat.pm, OneToOne.pm, SourceNat.pm, Npt.pm
      System.pm             # System status/info + firmware/logging/reboot
      Diagnostics.pm        # Diagnostics (ping, traceroute, pf stats, interface stats, etc.)
      Routes.pm             # Static routes CRUD
      Interfaces.pm         # Interface overview/get/settings
      Kea/
        Dhcpv4.pm, Dhcpv6.pm, Leases.pm, Ddns.pm, CtrlAgent.pm, Service.pm
      Dnsmasq/
        Settings.pm, Leases.pm, Service.pm
      OpenVPN/
        Instances.pm, ClientOverwrites.pm, Service.pm, Export.pm
      IPsec/
        Connections.pm, Tunnel.pm, Sessions.pm, Sad.pm, Spd.pm, Pools.pm,
        PreSharedKeys.pm, KeyPairs.pm, Vti.pm, ManualSpd.pm, Leases.pm,
        Settings.pm, Service.pm
      CaptivePortal/
        Settings.pm, Session.pm, Access.pm, Voucher.pm, Service.pm
      TrafficShaper/
        Settings.pm, Service.pm
      IDS/
        Settings.pm, Service.pm
      Unbound/
        Settings.pm, Overview.pm, Diagnostics.pm, Service.pm
      Cron/
        Settings.pm, Service.pm
      Role/
        APIPath.pm, Crud.pm, ItemCrud.pm, KeaItemCrud.pm, Service.pm, Settings.pm
      Firewall/
        Role/
          NAT.pm
  t/
    basic.t (67 module load tests), constants.t, normalize.t, exception.t, object.t
  .perlcriticrc
dist.ini, weaver.ini, Changes, README.md, AGENTS.md
.gitignore, .editorconfig, .perltidyrc
```

## Conventions

- **Module code template**:
  ```perl
  # ABSTRACT: <one-line description>
  # PODNAME: Module::Name
  use strictures 2;

  package Module::Name;

  use Moo;
  use Carp          qw( croak );
  use Ref::Util     qw( is_plain_hashref is_plain_arrayref );
  use namespace::clean;
  ```
  No `use v5.24;`. `strictures 2` enforces the minimum version.
  Place `use namespace::clean` before any `sub` declarations that need to
  survive cleanup (see `namespace::clean` convention below).
- **EditorConfig**: Follow `.editorconfig`. 4-space indentation for Perl files,
  spaces over tabs, UTF-8, LF line endings, trim trailing whitespace, final
  newline on every file.

### Perl Code Style

- **Cuddled else/elsif**: Never cuddle. Use `}\nelse {` and `}\nelsif {` on
  their own lines, not `} else {`.
- **Regex delimiters**: Always use `m//` for match operators, never bare `//`.
- **Character classes**: Use `[0-9]` instead of `\d`, `[a-z]` instead of `\w`,
  `[ \t]` instead of `\s`. Be explicit about which characters are matched.
- **Alphabetical order**: Imports (`use` statements), variable declarations,
  and hash-key literals should all be in alphabetical order when the order is
  not semantically important.  Exception: C<use namespace::clean> must always
  be the last C<use> statement (so it sees and cleans every imported
  function).  Mark it with a comment when deviating from alphabetical order.
- **`namespace::clean` before `with`**: Place `use namespace::clean` before
  `with` so user-defined subs stay visible at runtime.  `namespace::clean`
  snapshots the symbol table at compile time and removes those symbols at
  scope end, before any runtime code (including `with`) executes.  Subs
  defined after the snapshot survive cleanup because they are not in the
  snapshot.  Exception: `WebService::OPNsense.pm` places
  `with 'WebService::Client'` before `namespace::clean` because
  `WebService::Client` exports (`GET`, `POST`, `PUT`, `DELETE`) arrive
  after `namespace::clean`'s scope-end cleanup.  The
  `[Test::CleanNamespaces]` config in `dist.ini` skips the main module for
  this reason.
- **Alignment**: Align `=>` fat commas and closing braces `}` on the
  right-hand side of hash/attribute declarations for readability.
- **Ref::Util**: Use `is_plain_hashref($x)`, `is_plain_arrayref($x)`,
  `is_plain_coderef($x)` from `Ref::Util` instead of `ref $x eq 'HASH'`,
  `ref $x eq 'ARRAY'`, `ref $x eq 'CODE'`.
- **Exception testing**: Use `dies { ... }` / `lives { ... }` from
  `Test2::Tools::Exception` (wrapped in `ok()`) instead of `dies_ok` / `lives_ok`.
- **Deep comparison**: Use `is()` from `Test2::V1` instead of `is_deeply`;
  `is()` in Test2 performs deep structural comparison by default.
- **`isa_ok`**: Use `ok( $obj->isa('Class'), 'description' )` instead of
  `isa_ok($obj, 'Class', 'description')`. Test2::V1's `isa_ok` does not
  accept a description argument.
- **Quoting**: Use single quotes `'...'` for all strings that do not require
  interpolation.  When a string contains a literal single quote character, use
  the `q()` operator rather than escaping inside single quotes.
- **Empty string constant**: Define `$EMPTY_STR = q();` at the top of any file
  that assigns empty strings.  Reuse `$EMPTY_STR` throughout instead of writing
  `''` or `""`.
- **Magic values**: Define magic strings and magic numbers as regular `my`
  variables in `ALL_CAPS` at the top of the file.  Reference the variable
  in place of the literal throughout.
- **Topic variable `$_`**: Never use `$_` in `for` loops.  It is acceptable with
  `grep` and `map` only when the expression is used at most twice.  Otherwise
  assign to a named variable first.
- **Shebang lines**: `.pm` files use `#!/bin/false` to prevent direct execution
  (allowed by `ProhibitModuleShebang`'s `allow_bin_false` default).  `.pl` and
  `.t` files use `#!perl`.  Every `.pm` file must have `# ABSTRACT:` and
  `# PODNAME:` lines after the shebang.
- **Type constraints**: Use C<isa => Bool> from L<Types::Standard> for boolean
  Moo attributes (e.g. C<has allow_http => (is => 'ro', default => 0, isa => Bool)>).
  Import with C<use Types::Standard qw( Bool )> and keep in alphabetical order
  among other imports.  Note: C<Types::Standard> is not currently a runtime
  dependency. Only use if the project adds it to C<dist.ini>.
- **JSON configuration**: Override C<+json> from L<WebService::Client> with a
  custom L<JSON::MaybeXS> object to control encoding/decoding options:
  C<has '+json' => (is => 'ro', lazy => 1, default => sub { require JSON::MaybeXS;
  JSON::MaybeXS->new( pretty => 0, utf8 => 1 ) })>.  Use runtime C<require>
  rather than C<use> to defer loading.
- **Exporter mechanism for Moo classes**: Use C<use Exporter::Shiny qw( ... );>
  to export functions/constants from Moo classes.  This pushes Exporter::Tiny
  onto C<@ISA> and is safe with bare C<use namespace::clean;> (the imported
  C<import> method is inherited via C<@ISA>, not a direct symbol-table entry).
  For non-Moo packages (e.g. C<Constants.pm>), use
  C<use parent qw( Exporter::Tiny );> directly with C<@EXPORT_OK>.
- **General-purpose constants**: Use C<use Const::Fast qw( const );> for
  readonly variable creation and C<use parent qw( Exporter::Tiny );> for the
  export mechanism.  List all constants in C<@EXPORT_OK> (one per line,
  vertical layout).  Export nothing by default; no C<%EXPORT_TAGS>.
- **Method call extraction**: Store the result of a method call in a variable
  before passing it as an argument to another method (or before interpolation).
  Avoid inline/nested method calls like
  `$self->client->get( $self->_path(...) )`; instead write
  `my $uri = $self->_path(...); $self->client->get($uri)`.
  This convention is applied across the full codebase (262 extractions in 30 files).
- **Multi-line argument lists and data structures**: When calling a method with
  multiple arguments, place each argument on its own line for diff and
  C<git blame> friendliness:
  `my $result = $obj->method(` newline `param1 => 'value1',` newline
  `param2 => 'value2',` newline `);`.  Single-argument calls may stay on one line.
  Apply the same vertical layout to hashrefs, arrayrefs, and other composite
  data structures — every element on its own line.
- **Prefer C<qw()> for list literals**: When a list contains simple bareword
  strings (including C<$>‑prefixed constant names), use C<qw()> rather than
  comma‑separated quoted strings.  C<qw()> is more compact, visually distinct,
  and produces cleaner diffs when items are added or removed.
- **Helper subs for repeating idioms**: Extract repeated code patterns into
  helper subroutines (typically at the bottom of the file, ordered
  alphabetically).  This applies to any three-or-more-line stanza that appears
  more than once, or any inline transformation used in three or more places.
  Name helpers clearly, preferring verbs or verb-object phrases.  Never duplicate
  the same logic in multiple places, even if each instance is small.

## Design Principles

These principles drive the codebase and could apply to any Perl project:

- **Explicit over implicit**: Every import, export, and dependency is spelled out.
  No `:all` shortcuts, no default exports, no bare `//` regexes, no inline
  method calls.  What you see is exactly what happens.
- **Convention over configuration**: Consistent patterns for every decision —
  alphabetical ordering, namespace::clean placement, variable naming, POD
  structure, method signatures.  Once you know one module, you know them all.
- **DRY through roles**: Extract shared logic into composable roles, not base
  classes.  Single inheritance for behavior is a last resort.  262 `_path`
  extractions, 20 Kea methods consolidated into one role, 5 service methods
  shared across 6 consumers.
- **Readability for diff and blame**: Each statement declares one thing.
  Method calls are extracted to variables.  Multi-arg calls get one argument
  per line.  Alignment aids scanning.  Code is written for the next person
  reading a `git diff`.
- **Zero policy violations**: `perlcritic` is run on every change.  No
  exceptions, no annotations, no noise.  If a policy fires, fix the code or
  adjust the config project-wide.
- **Document everything for the user**: Every method has POD.  Full
  descriptions are copied into every consumer (not just `L<...>` links).
  No `=for Pod::Coverage` directives — they conceal undocumented methods.
- **Test the contract, not the implementation**: Tests use `dies {}`,
  `is()` for deep comparison, `ok( $obj->isa(...) )` — they verify behavior,
  not internal structure.  No test tools that lock in implementation details.
- **Organise tests in subtests**: Wrap related assertions in `subtest`
  blocks.  Each subtest has a clear description, a focused scope, and
  produces one top-level pass/fail.  This makes failures immediately
  locatable and allows targeted re-execution.
- **Extract helper subs to avoid test duplication**: When the same setup,
  teardown, or assertion pattern appears in multiple subtests or files,
  extract it into a helper subroutine.  This keeps tests readable and
  consistent without sacrificing explicitness.
- **Be explicit about what you match**: `[0-9]` not `\d`, `[a-z]` not `\w`,
  `[ \t]` not `\s`.  Regex magic shortcuts hide intent.  Name the characters
  you actually mean.
- **Guard early, return clearly**: Validate inputs at the top of methods.
  Return `undef` for 404s rather than throwing.  Use `is_plain_hashref`
  without redundant guards.  Every path is intentional.

## Design Decisions

- **Role hierarchy**: `Role::APIPath` is the base role providing `_path($endpoint, %vars)`
  via `URI::Template`. All other shared roles (`Crud`, `ItemCrud`, `KeaItemCrud`,
  `Service`, `Settings`, `Firewall::Role::NAT`) consume it. Consumers compose via
  `with` and never implement `_path` themselves.
- **namespace::clean ordering**: Place `use namespace::clean` before `with` and
  before `sub` declarations so user-defined subs survive the snapshot. Exception:
  `WebService::OPNsense.pm` places `with 'WebService::Client'` first because
  `WebService::Client` exports (`GET`, `POST`, `PUT`, `DELETE`) arrive after
  `namespace::clean`'s scope-end cleanup.
- **Constants export**: `Constants.pm` uses `Const::Fast` for readonly variable
  creation and `parent qw( Exporter::Tiny )` for exports (not `Const::Fast::Exporter`,
  not `Exporter::Shiny`). Exports only via `@EXPORT_OK` — nothing by default, no
  `%EXPORT_TAGS`, no `:all` shortcut. Every consumer lists every constant explicitly.
- **Constant naming**: `$OPN_ENABLED`/`$OPN_DISABLED` prefix avoids namespace
  collisions in user code.
- **Method call extraction**: Always `my $uri = $self->_path(...);` then
  `$self->client->$method($uri)` — never inline. 262 extractions across 30 files.
- **POD documentation**: Full method descriptions copied from roles into every
  consumer (not `L<...>` links) for user convenience. No `=for Pod::Coverage`
  directives anywhere — all methods are documented or are Moo lifecycle methods.
- **`is_plain_hashref` guard**: Returns false for `undef`/`0`/`''`, so
  `$params && is_plain_hashref($params)` is redundant. Use bare
  `is_plain_hashref($params)`.
- **HTTP 404 guard**: `defined $res or return;` in `OPNsense.pm` to safely
  return `undef` when the API returns 404.
- **Perlcritic config**: `allow = _api_path _path` in
  `ProhibitUnusedPrivateSubroutines` replaces 36 `## no critic` annotations.
- **Test conventions**: `dies { ... }` / `lives { ... }` with `ok()` wrapper
  (not `dies_ok`/`lives_ok`); `is()` for deep comparison (not `is_deeply`);
  `ok( $obj->isa('Class'), 'description' )` instead of `isa_ok`.
- **Branch**: `trunk` (not `master`). Single squashed commit per feature phase.
- **Tarball exclusion**: `AGENTS.md` excluded from CPAN tarball via
  `[PruneFiles]` in `dist.ini`. `PLAN.md` is gitignored.
- **Dist::Zilla dependency sections**: Runtime dependencies go in `[Prereqs]`,
  test-only dependencies in `[Prereqs / TestRequires]`, and development-only
  (author) dependencies in `[Prereqs / DevelopRequires]`. Every new module
  import (`use` in production code or `use`/`require` in test files) must be
  declared in the correct section of `dist.ini`.  Determine the section by
  file path: files under `lib/` → `[Prereqs]`; files under `t/` →
  `[Prereqs / TestRequires]`; generated or helper scripts under `bin/`,
  `eg/`, `examples/`, `xt/`, `author/`, or `utils/` → `[Prereqs / DevelopRequires]`
  (or omit if the dependency is already listed elsewhere).

## Status

- **Tests**: 65 pass (10 files, subtests); 788 pass (`dzil test --release`, 25 files)
- **Perl::Critic**: 0 violations in `lib/` and `t/` with `--profile t/.perlcriticrc`
- **`## no critic` annotations**: 0 in `lib/`, 3 in `t/` (1 `ProhibitNoStrict` + 1 `ProtectPrivateSubs` block + 1 `RequireTrailingCommaAtNewline` block)

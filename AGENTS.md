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
- `Const::Fast` / `Const::Fast::Exporter`
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
      Constants.pm          # Cross-cutting enums via Const::Fast::Exporter
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
        APIPath.pm, Crud.pm, ItemCrud.pm, Service.pm, Settings.pm
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
- **Cross-cutting constants**: Use C<use Const::Fast::Exporter qw( const );>
  for constants shared across multiple controllers.  These auto-export and
  don't interact with C<namespace::clean>.
- **Method call extraction**: Store the result of a method call in a variable
  before passing it as an argument to another method (or before interpolation).
  Avoid inline/nested method calls like
  `$self->client->get( $self->_mkuri(...) )`; instead write
  `my $uri = $self->_mkuri(...); $self->client->get($uri)`.
- **Multi-line argument lists**: When calling a method with multiple arguments,
  place each argument on its own line for diff and C<git blame> friendliness:
  `my $result = $obj->method(` newline `param1 => 'value1',` newline
  `param2 => 'value2',` newline `);`.  Single-argument calls may stay on one line.
- **Helper subs for repeating idioms**: Extract repeated code patterns into
  helper subroutines (typically at the bottom of the file, ordered
  alphabetically).  This applies to any three-or-more-line stanza that appears
  more than once, or any inline transformation used in three or more places.
  Name helpers clearly, preferring verbs or verb-object phrases.  Never duplicate
  the same logic in multiple places, even if each instance is small.

## Status

- **Tests**: 676 pass across 10 files
- **Perl::Critic**: 0 violations in `lib/` with `--profile t/.perlcriticrc`
- **`## no critic` annotations**: 0 in `lib/`, 1 in `t/` (intentional `no strict` in constants test)

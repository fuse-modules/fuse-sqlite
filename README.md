Fuse SQLite bindings
====================

[![NPM package](https://img.shields.io/npm/v/fuse-sqlite.svg?style=flat-square)](https://www.npmjs.com/package/fuse-sqlite)
[![License: MIT](https://img.shields.io/github/license/fuse-open/fuse-sqlite.svg?style=flat-square)](LICENSE)

Library to use [SQLite](https://www.sqlite.org/) in [Fuse](https://fuseopen.com/).

Currently supports `ios`, `android` and `dotnet` (Fuse Preview).

Issues, feature requests and pull requests are welcome.

## Install

Using [npm](https://www.npmjs.com/)

    $ npm install fuse-sqlite

(Legacy) Using [fusepm](https://github.com/bolav/fusepm)

    $ fusepm install https://github.com/fuse-open/fuse-sqlite

## Usage:

> Check out the [example app](example/) for a complete example project using TypeScript.

### UX

```xml
<SQLite ux:Global="SQLite" />`
```

### JS or TypeScript

```js
import sqlite from "SQLite";
```

```js
const db = sqlite.open("file.sqlite");
db.execute("create table if not exists ids (id integer primary key)");
db.execute("insert into ids values (?)",2);
const r = db.query("select * from ids");
console.log(JSON.stringify(r));
```

It returns an array:
```js
[
	{"field1":"value1","field2":"value2"},
	{"field1":"value1","field2":"value2"}
]
```

API
----

### import

```js
import sqlite from "SQLite";
```

### require (legacy)

```js
const sqlite = require('SQLite');
```

### sqlite.open

Opens a file that contains a SQLite database

```js
const db = sqlite.open(filename);
```

### sqlite.openFromBundle

Opens a file that contains a SQLite database, possibly from the bundle

```js
const db = sqlite.openFromBundle(filename);
```

And in the `unoproj`:

```json
"Packages": [
  "Fuse",
  "FuseJS",
  "SQLite"
],
"Includes": [
  "*.ts",
  "*.ux",
  "bundle.sqlite:Bundle"
]
```

### db.execute

Executes a query. Does not return anything.

```js
db.execute(sql_statement);
db.execute(sql_statement, var1, var2, var3);
```

### db.query

Executes a query. Returns an array of hashes with the result.

```js
const result = db.query(sql_statement);
const result = db.query(sql_statement, var1, var2, var3);
```

### db.prepare

Prepares a query. Returns a prepared statement.

```js
const statement = db.prepare(sql_statement);
statement.execute(var1,var2,var3);
```

### db.close

Closes the database.

```js
db.close();
```

### Possible future functionality

* Cursor support
* Async support
* Bundled pre-made databases

### Known Issues

* Error messages is a bit different between the targets
* Support for JavaScript and CMake Fuse targets is not planned.

### Windows

* The sqlite3.dll is downloaded from http://www.sqlite.org/download.html
* Mono.Data.Sqlite.dll is included from Mono.

### Errors:

* `Failed to load assembly . . . have caused the assembly to be sandboxed . . .`

    You need to Unblock dll's that you downloaded.

    * https://navbis.wordpress.com/2014/03/17/what-to-do-if-the-dll-assemblies-are-blocked-by-windows/
    * http://superuser.com/questions/38476/this-file-came-from-another-computer-how-can-i-unblock-all-the-files-in-a

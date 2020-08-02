/**
 * Module to use SQLite in Fuse.
 */
declare module "SQLite" {

    interface SQLiteStatement {
        /**
         * Executes a query. Does not return anything.
         */
        execute(...args: string[]): any;
    }

    interface SQLiteDb {
        /**
         * Executes a query. Does not return anything.
         */
        execute(sql_statement: string, ...args: string[]): any;

        /**
         * Executes a query. Returns an array of hashes with the result.
         */
        query(sql_statement: string, ...args: string[]): any;

        /**
         * Prepares a query. Returns a prepared statement.
         */
        prepare(sql_statement: string): SQLiteStatement;

        /**
         * Closes the database.
         */
        close(): void;
    }

    /**
     * Opens a file that contains a SQLite database
     */
    function open(value: string): SQLiteDb;

    /**
     * Opens a file that contains a SQLite database, possibly from the bundle
     */
    function openFromBundle(value: string): SQLiteDb;
}

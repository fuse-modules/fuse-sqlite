import sqlite from "SQLite";

export default class Model {
    result = "";
    insert_id = "";
    select_id = "";
    prepare_id = "";

    db = sqlite.openFromBundle("bundle.sqlite");

    init_db() {
        this.db.execute("create table if not exists ids (id integer primary key)");
    }

    insert_value() {
        try {
            this.db.execute("insert into ids values (?)", this.insert_id);
            this.result = "Insert successful";
        }
        catch (e) {
            this.result = "Error inserting " + e;
        }
    }

    select_values() {
        let r = "";
        if (this.select_id != "") {
            console.log("SELECT * WHERE id = " + this.select_id);
            r = this.db.query("select * from ids WHERE id = ?", this.select_id);
        }
        else {
            console.log("select * from ids");
            r = this.db.query("select * from ids");
        }
        this.result = JSON.stringify(r);
        console.log(JSON.stringify(r));
    }

    prepare_values() {
        let r = "";
        if (this.prepare_id != "") {
            const stmnt = this.db.prepare("select * from ids WHERE id = ?")
            r = stmnt.execute(this.prepare_id);
        }
        else {
            console.log("select * from ids");
            const stmnt = this.db.prepare("select * from ids");
            r = stmnt.execute();
        }
        this.result = JSON.stringify(r);
        console.log(JSON.stringify(r));
    }
}

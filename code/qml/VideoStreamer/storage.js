/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

// First, let's create a short helper function to get the database connection.
function getDatabase() {
     return openDatabaseSync("QMLVideoStreamer", "1.0", "VideoStreamer SettingsDB", 5000);
}

function initialize() {
    var db = getDatabase();

    db.transaction(function(tx) {
            // Create the settings table if it doesn't already exist.
            // If the table exists, this is skipped.
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
        });
}

// This function is used to write a setting into the database.
function setSetting(setting, value) {
    // setting: string representing the setting name (eg: “username”)
    // value: string representing the value of the setting (eg: “myUsername”)
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);',
                               [setting, value]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't.
    return res;
}

// This function is used to retrieve a setting from the database
function getSetting(setting) {
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;',
                               [setting]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).value;
        } else {
            res = "Unknown";
        }
    });
    // The function returns “Unknown” if the setting was not found in the database.
    return res;
}

/*
    This script inserts a default administrator with username 'admin' into the table 'medusa_admin'.
*/

INSERT INTO medusa_admin (username,
                          givenname,
                          surname,
                          roles,
                          pwd_hash,
                          pwd_next_chg,
                          pwd_chg_enf)
VALUES ('admin',
        'IAM',
        'Administrator',
        'superadmin',
        'MedusaPwdHistoryAAAARjE2Mzg0fF1jjOhya0ZuJ5OrHXgSXznOBBLl6eJ70PTdFYerSYPwgrlK1uq6UCzc5cvN8t1xtgc+YBQO8UgWBYhzDgpkQGM=',
        0, /* Password change on next sign-in is disabled */
        0 /* Enforced password change is disabled */
       ) ON DUPLICATE KEY UPDATE username=username;

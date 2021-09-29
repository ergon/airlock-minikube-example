/*
    This script inserts default users into the table 'medusa_user'.
*/

INSERT INTO `medusa_user` (username,
                           givenname,
                           surname,
                           auth_method,
                           valid,
                           failed_token_counts,
                           pwd_hash,
                           pwd_chg_enf,
                           roles)

VALUES ('user',
        'Airlock',
        'Secure Access Hub',
        'PASSWORD',
        1,
        '{}',
        'MedusaPwdHistoryAAAARjE2Mzg0fEk61Xwi7Q16p0tt9fakb+j9EcLtch4QXhWuGnQzczaRue8NSY6TZIgCGll6+x7ZwT4ujRO3dNvAxBNRM6dZbNY=',
        0, /* Enforced password change is disabled */
        'customer'
       ),
       ('customer1',
        'Airlock',
        'Secure Access Hub',
        'PASSWORD',
        1,
        '{}',
        'MedusaPwdHistoryAAAARjE2Mzg0fEk61Xwi7Q16p0tt9fakb+j9EcLtch4QXhWuGnQzczaRue8NSY6TZIgCGll6+x7ZwT4ujRO3dNvAxBNRM6dZbNY=',
        0, /* Enforced password change is disabled */
        'customer'
       ),
       ('customer2',
        'Airlock',
        'Secure Access Hub',
        'PASSWORD',
        1,
        '{}',
        'MedusaPwdHistoryAAAARjE2Mzg0fEk61Xwi7Q16p0tt9fakb+j9EcLtch4QXhWuGnQzczaRue8NSY6TZIgCGll6+x7ZwT4ujRO3dNvAxBNRM6dZbNY=',
        0, /* Enforced password change is disabled */
        'customer'
       ),
       ('customer3',
        'Airlock',
        'Secure Access Hub',
        'PASSWORD',
        1,
        '{}',
        'MedusaPwdHistoryAAAARjE2Mzg0fEk61Xwi7Q16p0tt9fakb+j9EcLtch4QXhWuGnQzczaRue8NSY6TZIgCGll6+x7ZwT4ujRO3dNvAxBNRM6dZbNY=',
        0, /* Enforced password change is disabled */
        'customer'
       ),
       ('customer4',
        'Airlock',
        'Secure Access Hub',
        'PASSWORD',
        1,
        '{}',
        'MedusaPwdHistoryAAAARjE2Mzg0fEk61Xwi7Q16p0tt9fakb+j9EcLtch4QXhWuGnQzczaRue8NSY6TZIgCGll6+x7ZwT4ujRO3dNvAxBNRM6dZbNY=',
        0, /* Enforced password change is disabled */
        'customer'
       ),
       ('customer5',
        'Airlock',
        'Secure Access Hub',
        'PASSWORD',
        1,
        '{}',
        'MedusaPwdHistoryAAAARjE2Mzg0fEk61Xwi7Q16p0tt9fakb+j9EcLtch4QXhWuGnQzczaRue8NSY6TZIgCGll6+x7ZwT4ujRO3dNvAxBNRM6dZbNY=',
        0, /* Enforced password change is disabled */
        'customer'
       ) ON DUPLICATE KEY UPDATE username=username;

/*
    This script inserts a default Airlock 2FA user with username '2fa' into the table 'medusa_user'.
*/

INSERT INTO `medusa_user` (username,
                           givenname,
                           surname,
                           auth_method,
                           valid,
                           failed_token_counts,
                           pwd_hash,
                           pwd_chg_enf)

VALUES ('user',
        'Airlock',
        'Minikube Example',
        'PASSWORD',
        1,
        '{}',
        'MedusaPwdHistoryAAAARjE2Mzg0fEk61Xwi7Q16p0tt9fakb+j9EcLtch4QXhWuGnQzczaRue8NSY6TZIgCGll6+x7ZwT4ujRO3dNvAxBNRM6dZbNY=',
        0 /* Enforced password change is disabled */
       ) ON DUPLICATE KEY UPDATE username=username;
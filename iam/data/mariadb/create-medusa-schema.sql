/*
    This script creates the Airlock IAM default schema for MariaDB.

    Please use spaces instead of tabs in this file to allow copy/pasting the
    SQL statements directly in the console (1 tab = 4 spaces)

    Please ensure that the database uses 'utf8mb4' character encoding and InnoDB as storage engine.
**/

/*
    This table contains the authentication information about the
    end users.
*/
CREATE TABLE IF NOT EXISTS medusa_user
(
    -- General authentication information fields

    username                      VARCHAR(100)      NOT NULL,

    auth_method                   VARCHAR(50),
    next_auth_method              VARCHAR(50),
    auth_migration_date           DATETIME(6),
    locked                        INTEGER DEFAULT 0 NOT NULL,
    lock_reason                   VARCHAR(50),
    lock_date                     DATETIME(6),
    valid                         INTEGER DEFAULT 1 NOT NULL,
    not_valid_before              DATETIME(6),
    not_valid_after               DATETIME(6),

    -- Statistic data
    failed_logins                 INTEGER,
    failed_logins_before          INTEGER,
    failed_stepup_attempts        INTEGER,
    failed_token_counts           TEXT,
    total_logins                  INTEGER,
    lat_succ_login                DATETIME(6),
    lat_succ_login2               DATETIME(6),
    lat_login_attempt             DATETIME(6),
    first_login                   DATETIME(6),
    unlock_attempts               INTEGER,
    lat_unlock_attempt            DATETIME(6),

    -- self-registration data
    self_registered               INTEGER DEFAULT 0 NOT NULL,
    self_registration_date        DATETIME(6),
    inactivity_reminder_sent_date DATETIME(6),
    channel_verification_resends  INTEGER,

    -- Role settings
    roles                         VARCHAR(1000),

    -- User context data
    salutation                    VARCHAR(50),
    givenname                     VARCHAR(50),
    surname                       VARCHAR(50),
    street                        VARCHAR(100),
    streetNumber                  VARCHAR(20),
    address2                      VARCHAR(100),
    zipcode                       VARCHAR(12),
    town                          VARCHAR(50),
    state                         VARCHAR(50),
    country                       VARCHAR(50),
    company                       VARCHAR(75),
    email                         VARCHAR(100),
    new_email                     VARCHAR(100),
    language                      CHAR(2),
    birthdate                     DATE,
    allowedIPs                    VARCHAR(500),
    disclaimer_tag                VARCHAR(1024),
    remember_me_secret            VARCHAR(1024),
    remember_me_gen_date          DATETIME(6),

    -- Technical database fields
    rowVersionId                  INTEGER DEFAULT 0 NOT NULL,
    rowInsertDate                 DATETIME(6),
    rowInsertUser                 VARCHAR(20),
    rowUpdateDate                 DATETIME(6),
    rowUpdateUser                 VARCHAR(20),
    deleted                       INTEGER DEFAULT 0 NOT NULL,

    -- Password related fields
    pwd_hash                      VARCHAR(4000),
    pwd_chg_enf                   INTEGER DEFAULT 0 NOT NULL,
    pwd_lat_del                   DATETIME(6),
    pwd_lat_gen                   DATETIME(6),
    pwd_lat_chg                   DATETIME(6),
    pwd_next_chg                  DATETIME(6),
    pwd_order_new                 INTEGER DEFAULT 0 NOT NULL,
    pwd_order_user                VARCHAR(100),
    pwd_order_date                DATETIME(6),
    pwd_failed_resets             INTEGER DEFAULT 0 NOT NULL,

    -- MTAN (SMS) related fields (including IAK)
    mtan_number                   VARCHAR(25),
    mtan_del_date                 DATETIME(6),
    mtan_ass_date                 DATETIME(6),
    mtan_order_new                INTEGER DEFAULT 0 NOT NULL,
    mtan_order_user               VARCHAR(100),
    mtan_order_date               DATETIME(6),
    mtan_iak                      TEXT,

    -- Certificate related fields (including IAK and self registration)
    cert_subject_cn               VARCHAR(200),
    cert_x509_data                TEXT,
    cert_serial                   VARCHAR(20),
    cert_del_date                 DATETIME(6),
    cert_ass_date                 DATETIME(6),
    cert_order_new                INTEGER DEFAULT 0 NOT NULL,
    cert_order_user               VARCHAR(100),
    cert_order_date               DATETIME(6),
    cert_iak                      TEXT,

    -- OATH OTP related fields
    oathotp_data                  VARCHAR(200),
    oathotp_serial                VARCHAR(20),
    oathotp_del_date              DATETIME(6),
    oathotp_gen_date              DATETIME(6),
    oathotp_order_new             INTEGER DEFAULT 0 NOT NULL,
    oathotp_order_user            VARCHAR(100),
    oathotp_order_date            DATETIME(6),

    -- SecurID related fields
    securid_user                  VARCHAR(25),
    securid_serial                VARCHAR(20),
    securid_pin                   VARCHAR(20),

    -- SecovID related fields
    secovid_data                  VARCHAR(50),
    secovid_serial                VARCHAR(20),

    -- Matrix cards (TAN lists) related fields
    matrix_current_list           BLOB,
    matrix_next_list              BLOB,
    matrix_del_date               DATETIME(6),
    matrix_gen_date               DATETIME(6),
    matrix_order_new              INTEGER DEFAULT 0 NOT NULL,
    matrix_order_user             VARCHAR(100),
    matrix_order_date             DATETIME(6),
    matrix_chal_open_since        DATETIME(6),
    matrix_open_chals             INTEGER DEFAULT 0 NOT NULL,

    -- Only one login possible
    last_gsid_date                DATETIME(6),
    last_gsid_value               VARCHAR(50),

    -- Secret questions features per user
    secret_questions_enabled      INTEGER DEFAULT 0 NOT NULL,

    PRIMARY KEY (username)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;

/*
    This table contains the authentication information about a users accessing the admin GUI.
*/
CREATE TABLE IF NOT EXISTS medusa_admin
(
    -- General authentication information fields
    username                     VARCHAR(100)      NOT NULL,

    locked                       INTEGER DEFAULT 0 NOT NULL,
    lock_reason                  VARCHAR(50),
    lock_date                    DATETIME(6),
    not_valid_before             DATETIME(6),
    not_valid_after              DATETIME(6),

    -- Statistic data
    failed_logins                INTEGER,
    failed_logins_before         INTEGER,
    failed_first_factor_attempts INTEGER,
    failed_stepup_attempts       INTEGER,
    total_logins                 INTEGER,
    lat_succ_login               DATETIME(6),
    lat_succ_login2              DATETIME(6),
    lat_login_attempt            DATETIME(6),
    first_login                  DATETIME(6),

    -- Role settings
    roles                        VARCHAR(1000),

    -- User context data
    givenname                    VARCHAR(50),
    surname                      VARCHAR(50),
    email                        VARCHAR(100),

    -- Technical database fields
    rowVersionId                 INTEGER DEFAULT 0 NOT NULL,
    rowInsertDate                DATETIME(6),
    rowInsertUser                VARCHAR(20),
    rowUpdateDate                DATETIME(6),
    rowUpdateUser                VARCHAR(20),
    deleted                      INTEGER DEFAULT 0 NOT NULL,

    -- Password related fields
    pwd_hash                     VARCHAR(4000),
    pwd_chg_enf                  INTEGER DEFAULT 0 NOT NULL,
    pwd_lat_del                  DATETIME(6),
    pwd_lat_gen                  DATETIME(6),
    pwd_lat_chg                  DATETIME(6),
    pwd_next_chg                 DATETIME(6),
    pwd_order_new                INTEGER DEFAULT 0 NOT NULL,

    PRIMARY KEY (username)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;

/*
    This table contains the basic information of maintenance messages.
*/
CREATE TABLE IF NOT EXISTS medusa_maint_msg
(
    name             VARCHAR(255)      NOT NULL,
    system_available INTEGER DEFAULT 1 NOT NULL,
    active           INTEGER DEFAULT 1 NOT NULL,
    valid_from       DATETIME(6)       NOT NULL,
    valid_to         DATETIME(6)       NOT NULL,
    location         VARCHAR(50),
    -- Technical database fields
    rowVersionId     INTEGER DEFAULT 0 NOT NULL,
    rowInsertDate    DATETIME(6),
    rowInsertUser    VARCHAR(20),
    rowUpdateDate    DATETIME(6),
    rowUpdateUser    VARCHAR(20),
    deleted          INTEGER DEFAULT 0 NOT NULL,

    PRIMARY KEY (name)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;

/*
    This table contains the translations of maintenance messages.
*/
CREATE TABLE IF NOT EXISTS medusa_maint_msg_tnsl
(
    message_ref   VARCHAR(255)      NOT NULL,
    language      VARCHAR(2)        NOT NULL,
    message       VARCHAR(4000)     NOT NULL,
    -- Technical database fields
    rowVersionId  INTEGER DEFAULT 0 NOT NULL,
    rowInsertDate DATETIME(6),
    rowInsertUser VARCHAR(20),
    rowUpdateDate DATETIME(6),
    rowUpdateUser VARCHAR(20),
    deleted       INTEGER DEFAULT 0 NOT NULL,

    PRIMARY KEY (message_ref, language)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;

CREATE TABLE IF NOT EXISTS token
(
    token_id                INTEGER           NOT NULL AUTO_INCREMENT,
    type                    VARCHAR(20),
    serial_id               VARCHAR(50),
    active                  INTEGER DEFAULT 0 NOT NULL,
    activation_date         DATETIME(6),
    obsoletes_token_id      INTEGER,
    validity_range_lower    DATETIME(6),
    validity_range_upper    DATETIME(6),
    generation_date         DATETIME(6),
    first_usage_date        DATETIME(6),
    latest_usage_date       DATETIME(6),
    total_usages            INTEGER DEFAULT 0 NOT NULL,
    token_data              TEXT,
    activates_token_id      INTEGER,
    tracking_id             TEXT,
    generic_data_element_1  TEXT,
    generic_data_element_2  TEXT,
    generic_data_element_3  TEXT,
    generic_data_element_4  TEXT,
    generic_data_element_5  TEXT,
    generic_data_element_6  TEXT,
    generic_data_element_7  TEXT,
    generic_data_element_8  TEXT,
    generic_data_element_9  TEXT,
    generic_data_element_10 TEXT,
    generic_data_element_11 TEXT,
    generic_data_element_12 TEXT,

    CONSTRAINT fk_obsoletes_token_id FOREIGN KEY (obsoletes_token_id) REFERENCES token (token_id),
    CONSTRAINT fk_activates_token_id FOREIGN KEY (activates_token_id) REFERENCES token (token_id),

    PRIMARY KEY (token_id)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE INDEX IF NOT EXISTS token_type_index
    ON token (type);
CREATE INDEX IF NOT EXISTS token_serial_id_index
    ON token (serial_id);
CREATE INDEX IF NOT EXISTS activates_token_id_index
    ON token (activates_token_id);
CREATE INDEX IF NOT EXISTS generic_data_element_1_idx
    ON token (generic_data_element_1(40));
CREATE INDEX IF NOT EXISTS generic_data_element_2_idx
    ON token (generic_data_element_2(40));
CREATE INDEX IF NOT EXISTS generic_data_element_3_idx
    ON token (generic_data_element_3(40));
CREATE INDEX IF NOT EXISTS generic_data_element_4_idx
    ON token (generic_data_element_4(40));
CREATE INDEX IF NOT EXISTS generic_data_element_6_idx
    ON token (generic_data_element_6(40));
CREATE INDEX IF NOT EXISTS generic_data_element_7_idx
    ON token (generic_data_element_7(40));
CREATE INDEX IF NOT EXISTS obsoletes_token_id_idx
    ON token (obsoletes_token_id);

CREATE TABLE IF NOT EXISTS token_assignment
(
    ta_token_id               INTEGER           NOT NULL,
    ta_user                   VARCHAR(100)      NOT NULL,
    ta_assignment_date        DATETIME(6)       NOT NULL,
    ta_assignment_user        VARCHAR(100)      NOT NULL,
    ta_order_new              INTEGER DEFAULT 0 NOT NULL,
    ta_order_new_date         DATETIME(6),
    ta_order_new_user         VARCHAR(100),
    ta_order_options          VARCHAR(250),
    ta_additional_information VARCHAR(250),
    ta_comment                TEXT,

    CONSTRAINT fk_ta_token_id FOREIGN KEY (ta_token_id) REFERENCES token (token_id),

    PRIMARY KEY (ta_token_id, ta_user)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE INDEX IF NOT EXISTS ta_index
    ON token_assignment (ta_user, ta_token_id);

/*
    Table for password self service token.
*/
CREATE TABLE IF NOT EXISTS medusa_pwd_selfservice_token
(
    token_id           VARCHAR(100),
    username           VARCHAR(100),
    issued_timestamp   DATETIME(6),
    consumed           INTEGER DEFAULT 0 NOT NULL,
    consumed_timestamp DATETIME(6),
    failed_attempts    INTEGER,
    valid              INTEGER DEFAULT 0 NOT NULL,
    context_data       VARCHAR(4000),

    -- Technical database fields
    deleted            INTEGER DEFAULT 0 NOT NULL,
    rowVersionId       INTEGER,
    rowInsertDate      DATETIME(6),
    rowInsertUser      VARCHAR(100),
    rowUpdateDate      DATETIME(6),
    rowUpdateUser      VARCHAR(100),

    PRIMARY KEY (token_id)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;

CREATE TABLE IF NOT EXISTS login_history
(
    id                     INTEGER      NOT NULL AUTO_INCREMENT,
    username               VARCHAR(100) NOT NULL,
    login_timestamp        DATETIME(6)  NOT NULL,
    ip                     VARCHAR(45)  NOT NULL,
    header_user_agent      VARCHAR(512),
    header_accept_encoding VARCHAR(512),
    header_accept_language VARCHAR(512),
    geoloc_present         INTEGER      NOT NULL,
    geoloc_continent       CHAR(2),
    geoloc_country         CHAR(2),
    geoloc_subdivision     CHAR(3),
    geoloc_city            VARCHAR(256),
    geoloc_zip             VARCHAR(32),
    geoloc_timezone        VARCHAR(128),
    geoloc_latitude        VARCHAR(16),
    geoloc_longitude       VARCHAR(16),

    PRIMARY KEY (id)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE INDEX IF NOT EXISTS login_history_idx
    ON login_history (username);

CREATE TABLE IF NOT EXISTS account_link
(
    link_id        INTEGER      NOT NULL AUTO_INCREMENT,
    username       VARCHAR(100) NOT NULL,
    provider_id    VARCHAR(20)  NOT NULL,
    account_sub    VARCHAR(255) NOT NULL,
    account_info   VARCHAR(255),
    established_at DATETIME(6)  NOT NULL,
    tenant_id      VARCHAR(50)  NOT NULL,

    PRIMARY KEY (link_id)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE INDEX IF NOT EXISTS account_link_idx_username
    ON account_link (username, tenant_id);
CREATE INDEX IF NOT EXISTS account_link_idx_usr_prov
    ON account_link (username, provider_id, tenant_id);
CREATE UNIQUE INDEX IF NOT EXISTS account_link_idx_unique
    ON account_link (account_sub, provider_id, tenant_id);


CREATE TABLE IF NOT EXISTS user_consent
(
    consent_id    INTEGER      NOT NULL AUTO_INCREMENT,
    username      VARCHAR(100) NOT NULL,
    consent_key   VARCHAR(50)  NOT NULL,
    state         VARCHAR(10)  NOT NULL,
    display_title VARCHAR(255),
    display_text  VARCHAR(1000),
    given_at      DATETIME(6)  NOT NULL,
    tenant_id     VARCHAR(50)  NOT NULL,

    PRIMARY KEY (consent_id)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE INDEX IF NOT EXISTS user_consent_idx_username
    ON user_consent (username, tenant_id);
CREATE UNIQUE INDEX IF NOT EXISTS user_consent_idx_unique
    ON user_consent (username, consent_key, tenant_id);

CREATE TABLE IF NOT EXISTS subscription
(
    pk           INTEGER                               NOT NULL AUTO_INCREMENT,
    id           VARCHAR(36) COLLATE latin1_nopad_bin  NOT NULL,
    display_name VARCHAR(100)                          NOT NULL,
    tenant_id    VARCHAR(50) COLLATE utf8mb4_nopad_bin NOT NULL,

    PRIMARY KEY (pk)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_520_nopad_ci;
CREATE UNIQUE INDEX IF NOT EXISTS subscription_id_idx_unique
    ON subscription (id);

CREATE TABLE IF NOT EXISTS principal
(
    pk              INTEGER           NOT NULL AUTO_INCREMENT,
    id              VARCHAR(36)       NOT NULL,
    display_name    VARCHAR(100)      NOT NULL,
    locked          INTEGER DEFAULT 0 NOT NULL,
    lock_reason     VARCHAR(100),
    lock_date       DATETIME(6),
    creation_date   DATETIME(6)       NOT NULL,
    tenant_id       VARCHAR(50)       NOT NULL,
    description     VARCHAR(100),
    label           VARCHAR(100),
    subscription_pk INTEGER,

    PRIMARY KEY (pk),
    CONSTRAINT fk_subscription_pk FOREIGN KEY (subscription_pk) REFERENCES subscription (pk)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE UNIQUE INDEX IF NOT EXISTS principal_id_idx_unique
    ON principal (id);
CREATE INDEX IF NOT EXISTS tenant_id_idx
    ON principal (tenant_id);
CREATE INDEX IF NOT EXISTS subscription_idx
    ON principal (subscription_pk);

CREATE TABLE IF NOT EXISTS oauth2_attributes
(
    pk                         INTEGER     NOT NULL AUTO_INCREMENT,
    principal_pk               INTEGER     NOT NULL,
    authorization_server_id    VARCHAR(50) NOT NULL,
    client_id                  VARCHAR(50) NOT NULL,
    client_secret              VARCHAR(450),
    client_id_issued_at        DATETIME(6) NOT NULL,
    client_secret_expires_at   DATETIME(6),
    redirect_uris              TEXT,
    token_endpoint_auth_method VARCHAR(50),
    grant_types                VARCHAR(200),
    response_types             VARCHAR(50),
    client_name                VARCHAR(200),
    client_uri                 VARCHAR(200),
    logo_uri                   VARCHAR(200),
    scopes                     VARCHAR(200),
    contacts                   TEXT,
    tos_uri                    VARCHAR(200),
    policy_uri                 VARCHAR(200),
    jwks_uri                   VARCHAR(200),
    software_id                VARCHAR(50),
    software_version           VARCHAR(50),
    cert_issuer                VARCHAR(450),
    cert_subject               VARCHAR(450),
    tenant_id                  VARCHAR(50) NOT NULL,

    PRIMARY KEY (pk),
    CONSTRAINT fk_oa_principal_pk FOREIGN KEY (principal_pk) REFERENCES principal (pk) ON DELETE CASCADE
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE UNIQUE INDEX IF NOT EXISTS oa2_attrs_principal_idx_unique
    ON oauth2_attributes (principal_pk);
CREATE UNIQUE INDEX IF NOT EXISTS oa2_attrs_as_cid_idx_unique
    ON oauth2_attributes (authorization_server_id, client_id, tenant_id);

CREATE TABLE IF NOT EXISTS oauth2_attribute_translation
(
    oauth2_attributes_pk INTEGER NOT NULL,
    attribute_name       VARCHAR(20),
    locale               VARCHAR(20),
    text                 VARCHAR(200),

    CONSTRAINT fk_oauth2_attributes_pk FOREIGN KEY (oauth2_attributes_pk) REFERENCES oauth2_attributes (pk) ON DELETE CASCADE
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE INDEX IF NOT EXISTS oauth2_attributes_pk_idx
    ON oauth2_attribute_translation (oauth2_attributes_pk);
CREATE UNIQUE INDEX IF NOT EXISTS oauth2_translation_idx_unique
    ON oauth2_attribute_translation (oauth2_attributes_pk, attribute_name, locale);

CREATE TABLE IF NOT EXISTS client_cert_credential
(
    id           VARCHAR(36)                      NOT NULL,
    principal_pk INTEGER                          NOT NULL,
    serial       VARCHAR(50)                      NOT NULL,
    issuer       VARCHAR(450)                     NOT NULL,
    subject      VARCHAR(450)                     NOT NULL,
    not_before   DATETIME(6)                      NOT NULL,
    not_after    DATETIME(6)                      NOT NULL,
    certificate  TEXT                             NOT NULL,
    fingerprint  VARCHAR(200) COLLATE utf8mb4_bin NOT NULL,
    tenant_id    VARCHAR(50)                      NOT NULL,

    CONSTRAINT fk_ccc_principal_pk FOREIGN KEY (principal_pk) REFERENCES principal (pk) ON DELETE CASCADE
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_nopad_ci;
CREATE UNIQUE INDEX IF NOT EXISTS ccc_id_idx_unique
    ON client_cert_credential (id);
CREATE INDEX IF NOT EXISTS principal_pk_idx
    ON client_cert_credential (principal_pk);
CREATE UNIQUE INDEX IF NOT EXISTS fingerprint_idx_unique
    ON client_cert_credential (fingerprint, tenant_id);
CREATE INDEX IF NOT EXISTS ccc_subject_idx
    ON client_cert_credential (subject);

CREATE TABLE IF NOT EXISTS airlock_2fa_user
(
    pk                  INTEGER                                NOT NULL AUTO_INCREMENT,
    iam_user_id         VARCHAR(100) COLLATE utf8mb4_nopad_bin NOT NULL,
    airlock_2fa_user_id VARCHAR(50) COLLATE latin1_nopad_bin   NOT NULL,
    tenant_id           VARCHAR(50) COLLATE utf8mb4_nopad_bin  NOT NULL,

    PRIMARY KEY (pk)
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_520_nopad_ci;
CREATE UNIQUE INDEX IF NOT EXISTS a2fa_iam_user_id_idx_unique
    ON airlock_2fa_user (iam_user_id, tenant_id);
CREATE UNIQUE INDEX IF NOT EXISTS a2fa_user_id_idx_unique
    ON airlock_2fa_user (airlock_2fa_user_id);

CREATE TABLE IF NOT EXISTS airlock_2fa_activation_letter
(
    pk                  INTEGER                                NOT NULL AUTO_INCREMENT,
    id                  VARCHAR(36) COLLATE latin1_nopad_bin   NOT NULL,
    activation_code     VARCHAR(750) COLLATE latin1_nopad_bin  NOT NULL,
    airlock_2fa_user_pk INTEGER                                NOT NULL,
    creator             VARCHAR(100) COLLATE utf8mb4_nopad_bin NOT NULL,

    PRIMARY KEY (pk),
    CONSTRAINT fk_activation_letter_user_pk FOREIGN KEY (airlock_2fa_user_pk) REFERENCES airlock_2fa_user (pk) ON DELETE CASCADE
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_520_nopad_ci;

CREATE UNIQUE INDEX IF NOT EXISTS a2fa_letter_id_idx_unique
    ON airlock_2fa_activation_letter (id);

CREATE TABLE IF NOT EXISTS api_key
(
    id            VARCHAR(36) COLLATE latin1_nopad_bin  NOT NULL,
    principal_pk  INTEGER                               NOT NULL,
    fingerprint   VARCHAR(30) COLLATE latin1_nopad_bin  NOT NULL,
    secret        VARCHAR(450) COLLATE latin1_nopad_bin NOT NULL,
    description   VARCHAR(100),
    valid_from    DATETIME(6),
    valid_to      DATETIME(6),
    locked        INTEGER DEFAULT 0                     NOT NULL,
    creation_date DATETIME(6)                           NOT NULL,
    tenant_id     VARCHAR(50) COLLATE utf8mb4_nopad_bin NOT NULL,

    CONSTRAINT fk_api_key_principal_pk FOREIGN KEY (principal_pk) REFERENCES principal (pk) ON DELETE CASCADE
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_520_nopad_ci;
CREATE UNIQUE INDEX IF NOT EXISTS api_key_id_idx_unique
    ON api_key (id);

CREATE UNIQUE INDEX IF NOT EXISTS api_key_fp_idx_unique
    ON api_key (fingerprint, tenant_id);

CREATE TABLE IF NOT EXISTS plan_usage
(
    id              VARCHAR(36) COLLATE latin1_nopad_bin NOT NULL,
    subscription_pk INTEGER                              NOT NULL,
    name            VARCHAR(100)                         NOT NULL,
    rate_limit      INTEGER,

    CONSTRAINT fk_plan_usage_subscription_pk FOREIGN KEY (subscription_pk) REFERENCES subscription (pk) ON DELETE CASCADE
) CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_520_nopad_ci;
CREATE UNIQUE INDEX IF NOT EXISTS plan_usage_subscr_idx_unique
    ON plan_usage (name, subscription_pk);
CREATE UNIQUE INDEX IF NOT EXISTS plan_usage_id_idx_unique
    ON plan_usage (id);


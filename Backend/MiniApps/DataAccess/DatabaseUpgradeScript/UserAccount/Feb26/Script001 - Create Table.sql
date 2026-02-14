CREATE TABLE IF NOT EXISTS com_roles (
    uuid varchar(100) PRIMARY KEY,
    rolename varchar(100) NOT NULL,
    createdby varchar(100) NOT NULL,
    createdat timestamp NOT NULL,
    updatedby varchar(100) NOT NULL,
    updatedat timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS com_useraccount (
    uuid varchar(100) PRIMARY KEY,
    emailaddress varchar(100) NOT NULL UNIQUE,
    firstname varchar(100) NOT NULL,
    lastname varchar(100) NOT NULL,
    timezoneid varchar(100) NOT NULL,
    isarchived boolean NOT NULL,
    createdby varchar(100) NOT NULL,
    createdat timestamp NOT NULL,
    updatedby varchar(100) NOT NULL,
    updatedat timestamp NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_useraccount_email
    ON com_useraccount (emailaddress);

CREATE TABLE IF NOT EXISTS com_userinrole (
    uuid varchar(100) PRIMARY KEY,
    useruuid varchar(100) NOT NULL,
    roleuuid varchar(100) NOT NULL,
    createdby varchar(100) NOT NULL,
    createdat timestamp NOT NULL,
    updatedby varchar(100) NOT NULL,
    updatedat timestamp NOT NULL,
    CONSTRAINT fk_userinrole_role
        FOREIGN KEY (roleuuid)
        REFERENCES com_roles(uuid)
        ON DELETE CASCADE,
    CONSTRAINT fk_userinrole_user
        FOREIGN KEY (useruuid)
        REFERENCES com_useraccount(uuid)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS com_usermembership (
    uuid varchar(100) PRIMARY KEY,
    useruuid varchar(100) NOT NULL,
    password varchar(200) NOT NULL,
    createdby varchar(100) NOT NULL,
    createdat timestamp NOT NULL,
    updatedby varchar(100) NOT NULL,
    updatedat timestamp NOT NULL,
    CONSTRAINT fk_membership_user
        FOREIGN KEY (useruuid)
        REFERENCES com_useraccount(uuid)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS com_userrefreshtoken (
    uuid varchar(100) PRIMARY KEY,
    useruuid varchar(100) NOT NULL,
    refreshtoken text NOT NULL,
    createdby varchar(100) NOT NULL,
    createdat timestamp NOT NULL,
    updatedby varchar(100) NOT NULL,
    updatedat timestamp NOT NULL,
    CONSTRAINT fk_refreshtoken_user
        FOREIGN KEY (useruuid)
        REFERENCES com_useraccount(uuid)
        ON DELETE CASCADE
);
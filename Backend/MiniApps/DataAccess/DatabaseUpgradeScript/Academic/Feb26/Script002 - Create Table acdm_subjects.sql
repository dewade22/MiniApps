CREATE TABLE acdm_subjects (
    uuid VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    createdby varchar(100) NOT NULL,
    createdat timestamp with time zone NOT NULL,
    updatedby varchar(100) NOT NULL,
    updatedat timestamp with time zone NOT NULL
);
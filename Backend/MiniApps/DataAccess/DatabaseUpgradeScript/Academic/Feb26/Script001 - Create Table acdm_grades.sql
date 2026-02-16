DROP TABLE IF EXISTS acdm_grades;

CREATE TABLE acdm_grades (
    uuid VARCHAR(100) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    createdby varchar(100) NOT NULL,
    createdat timestamp with time zone NOT NULL,
    updatedby varchar(100) NOT NULL,
    updatedat timestamp with time zone NOT NULL
);
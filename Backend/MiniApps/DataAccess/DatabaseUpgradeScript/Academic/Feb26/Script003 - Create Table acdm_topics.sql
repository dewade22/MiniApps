CREATE TABLE acdm_topics (
    uuid VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    subject_uuid VARCHAR(100) REFERENCES acdm_subjects(uuid) ON DELETE CASCADE,
    createdby varchar(100) NOT NULL,
    createdat timestamp with time zone NOT NULL,
    updatedby varchar(100) NOT NULL,
    updatedat timestamp with time zone NOT NULL
);
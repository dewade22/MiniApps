CREATE TABLE acdm_question_option (
    uuid            VARCHAR(100) PRIMARY KEY,
    question_uuid   VARCHAR(100) NOT NULL REFERENCES acdm_question(uuid) ON DELETE CASCADE,
    label           VARCHAR(1) NOT NULL,
    option_text     TEXT NOT NULL,
    createdby       VARCHAR(100) NOT NULL,
    createdat       TIMESTAMP WITH TIME ZONE NOT NULL,
    updatedby       VARCHAR(100) NOT NULL,
    updatedat       TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_question_option_question ON acdm_question_option(question_uuid);

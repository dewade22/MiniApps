CREATE TABLE acdm_question (
    uuid            VARCHAR(100) PRIMARY KEY,
    question_text   TEXT NOT NULL,
    topic_uuid      VARCHAR(100) REFERENCES acdm_topics(uuid) ON DELETE CASCADE,
    correct_option  VARCHAR(1) NOT NULL,
    createdby       VARCHAR(100) NOT NULL,
    createdat       TIMESTAMP WITH TIME ZONE NOT NULL,
    updatedby       VARCHAR(100) NOT NULL,
    updatedat       TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_question_topic ON acdm_question(topic_uuid);

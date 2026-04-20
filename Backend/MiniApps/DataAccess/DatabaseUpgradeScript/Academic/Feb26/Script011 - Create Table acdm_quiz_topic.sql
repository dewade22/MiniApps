CREATE TABLE IF NOT EXISTS acdm_quiz_topic (
    uuid        VARCHAR(100) NOT NULL,
    quiz_uuid   VARCHAR(100) NOT NULL,
    topic_uuid  VARCHAR(100) NOT NULL,
    createdby   VARCHAR(100) NOT NULL,
    createdat   TIMESTAMP WITH TIME ZONE NOT NULL,
    updatedby   VARCHAR(100) NOT NULL,
    updatedat   TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT acdm_quiz_topic_pkey  PRIMARY KEY (uuid),
    CONSTRAINT fk_quiztopic_quiz     FOREIGN KEY (quiz_uuid)  REFERENCES acdm_quiz(uuid)   ON DELETE CASCADE,
    CONSTRAINT fk_quiztopic_topic    FOREIGN KEY (topic_uuid) REFERENCES acdm_topics(uuid) ON DELETE CASCADE,
    CONSTRAINT uq_quiztopic          UNIQUE (quiz_uuid, topic_uuid)
);

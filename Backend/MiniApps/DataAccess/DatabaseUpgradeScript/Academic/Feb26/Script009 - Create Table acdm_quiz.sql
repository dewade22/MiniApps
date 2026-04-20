CREATE TABLE IF NOT EXISTS acdm_quiz (
    uuid                VARCHAR(100)  NOT NULL,
    title               VARCHAR(200)  NOT NULL,
    subject_uuid        VARCHAR(100)  REFERENCES acdm_subjects(uuid) ON DELETE SET NULL,
    topic_uuid          VARCHAR(100)  REFERENCES acdm_topics(uuid)   ON DELETE SET NULL,
    grade_uuid          VARCHAR(100)  NOT NULL REFERENCES acdm_grades(uuid) ON DELETE RESTRICT,
    question_count      INTEGER       NOT NULL,
    time_limit_seconds  INTEGER       NOT NULL,
    min_time_seconds    INTEGER       NOT NULL DEFAULT 0,
    time_very_easy      INTEGER       NOT NULL DEFAULT 30,
    time_easy           INTEGER       NOT NULL DEFAULT 45,
    time_medium         INTEGER       NOT NULL DEFAULT 60,
    time_hard           INTEGER       NOT NULL DEFAULT 90,
    time_very_hard      INTEGER       NOT NULL DEFAULT 120,
    createdby           VARCHAR(100)  NOT NULL,
    createdat           TIMESTAMP WITH TIME ZONE NOT NULL,
    updatedby           VARCHAR(100)  NOT NULL,
    updatedat           TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT acdm_quiz_pkey PRIMARY KEY (uuid)
);

CREATE INDEX IF NOT EXISTS idx_quiz_grade   ON acdm_quiz(grade_uuid);
CREATE INDEX IF NOT EXISTS idx_quiz_subject ON acdm_quiz(subject_uuid);
CREATE INDEX IF NOT EXISTS idx_quiz_topic   ON acdm_quiz(topic_uuid);

CREATE TABLE IF NOT EXISTS acdm_quiz_question (
    uuid            VARCHAR(100) NOT NULL,
    quiz_uuid       VARCHAR(100) NOT NULL REFERENCES acdm_quiz(uuid)     ON DELETE CASCADE,
    question_uuid   VARCHAR(100) NOT NULL REFERENCES acdm_question(uuid) ON DELETE CASCADE,
    question_order  INTEGER      NOT NULL DEFAULT 0,
    createdby       VARCHAR(100) NOT NULL,
    createdat       TIMESTAMP WITH TIME ZONE NOT NULL,
    updatedby       VARCHAR(100) NOT NULL,
    updatedat       TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT acdm_quiz_question_pkey   PRIMARY KEY (uuid),
    CONSTRAINT acdm_quiz_question_unique UNIQUE (quiz_uuid, question_uuid)
);

CREATE INDEX IF NOT EXISTS idx_quiz_question_quiz ON acdm_quiz_question(quiz_uuid);

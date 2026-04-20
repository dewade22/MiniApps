ALTER TABLE acdm_subjects DROP COLUMN IF EXISTS grade_uuid;

CREATE TABLE IF NOT EXISTS acdm_question_grade (
    uuid            VARCHAR(100) NOT NULL,
    question_uuid   VARCHAR(100) NOT NULL,
    grade_uuid      VARCHAR(100) NOT NULL,
    difficulty      VARCHAR(10)  NOT NULL DEFAULT 'medium',
    createdby       VARCHAR(100) NOT NULL,
    createdat       TIMESTAMP WITH TIME ZONE NOT NULL,
    updatedby       VARCHAR(100) NOT NULL,
    updatedat       TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT acdm_question_grade_pkey PRIMARY KEY (uuid),
    CONSTRAINT acdm_question_grade_question_fkey FOREIGN KEY (question_uuid)
        REFERENCES acdm_question (uuid) ON DELETE CASCADE,
    CONSTRAINT acdm_question_grade_grade_fkey FOREIGN KEY (grade_uuid)
        REFERENCES acdm_grades (uuid) ON DELETE CASCADE,
    CONSTRAINT acdm_question_grade_unique UNIQUE (question_uuid, grade_uuid)
);

CREATE INDEX IF NOT EXISTS idx_question_grade_question ON acdm_question_grade(question_uuid);
CREATE INDEX IF NOT EXISTS idx_question_grade_grade ON acdm_question_grade(grade_uuid);

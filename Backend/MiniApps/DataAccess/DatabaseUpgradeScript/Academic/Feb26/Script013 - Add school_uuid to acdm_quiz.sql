ALTER TABLE acdm_quiz
    ADD COLUMN school_uuid VARCHAR(100) NULL;

ALTER TABLE acdm_quiz
    ADD CONSTRAINT acdm_quiz_school_uuid_fkey
    FOREIGN KEY (school_uuid) REFERENCES acdm_school(uuid)
    ON DELETE SET NULL;

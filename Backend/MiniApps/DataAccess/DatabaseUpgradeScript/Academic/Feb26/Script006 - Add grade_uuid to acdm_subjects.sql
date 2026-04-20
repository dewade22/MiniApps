ALTER TABLE acdm_subjects
ADD COLUMN grade_uuid VARCHAR(100) REFERENCES acdm_grades(uuid) ON DELETE SET NULL;

CREATE INDEX idx_subject_grade ON acdm_subjects(grade_uuid);

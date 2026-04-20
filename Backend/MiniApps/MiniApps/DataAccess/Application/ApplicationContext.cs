using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace MiniApps.DataAccess.Application;

public partial class ApplicationContext : DbContext
{
    public ApplicationContext()
    {
    }

    public ApplicationContext(DbContextOptions<ApplicationContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AcdmGrade> AcdmGrades { get; set; }

    public virtual DbSet<AcdmSubject> AcdmSubjects { get; set; }

    public virtual DbSet<AcdmTopic> AcdmTopics { get; set; }

    public virtual DbSet<AcdmQuestion> AcdmQuestions { get; set; }

    public virtual DbSet<AcdmQuestionOption> AcdmQuestionOptions { get; set; }

    public virtual DbSet<AcdmQuestionGrade> AcdmQuestionGrades { get; set; }

    public virtual DbSet<AcdmQuiz> AcdmQuizzes { get; set; }

    public virtual DbSet<AcdmQuizQuestion> AcdmQuizQuestions { get; set; }

    public virtual DbSet<AcdmQuizTopic> AcdmQuizTopics { get; set; }

    public virtual DbSet<AcdmSchool> AcdmSchools { get; set; }

    public virtual DbSet<ComRole> ComRoles { get; set; }

    public virtual DbSet<ComUseraccount> ComUseraccounts { get; set; }

    public virtual DbSet<ComUserinrole> ComUserinroles { get; set; }

    public virtual DbSet<ComUsermembership> ComUsermemberships { get; set; }

    public virtual DbSet<ComUserrefreshtoken> ComUserrefreshtokens { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AcdmGrade>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_grades_pkey");

            entity.ToTable("acdm_grades");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");
        });

        modelBuilder.Entity<AcdmSubject>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_subjects_pkey");

            entity.ToTable("acdm_subjects");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");
        });

        modelBuilder.Entity<AcdmTopic>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_topics_pkey");

            entity.ToTable("acdm_topics");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.SubjectUuid)
                .HasMaxLength(100)
                .HasColumnName("subject_uuid");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");

            entity.HasOne(d => d.SubjectUu).WithMany(p => p.AcdmTopics)
                .HasForeignKey(d => d.SubjectUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("acdm_topics_subject_uuid_fkey");
        });

        modelBuilder.Entity<AcdmQuestion>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_question_pkey");

            entity.ToTable("acdm_question");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.QuestionText)
                .HasColumnName("question_text");
            entity.Property(e => e.TopicUuid)
                .HasMaxLength(100)
                .HasColumnName("topic_uuid");
            entity.Property(e => e.CorrectOption)
                .HasColumnName("correct_option");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");

            entity.HasOne(d => d.TopicUu).WithMany(p => p.AcdmQuestions)
                .HasForeignKey(d => d.TopicUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("acdm_question_topic_uuid_fkey");
        });

        modelBuilder.Entity<AcdmQuestionOption>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_question_option_pkey");

            entity.ToTable("acdm_question_option");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.QuestionUuid)
                .HasMaxLength(100)
                .HasColumnName("question_uuid");
            entity.Property(e => e.Label)
                .HasMaxLength(1)
                .HasColumnName("label");
            entity.Property(e => e.OptionText)
                .HasColumnName("option_text");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");

            entity.HasOne(d => d.QuestionUu).WithMany(p => p.AcdmQuestionOptions)
                .HasForeignKey(d => d.QuestionUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("acdm_question_option_question_uuid_fkey");
        });

        modelBuilder.Entity<AcdmQuestionGrade>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_question_grade_pkey");

            entity.ToTable("acdm_question_grade");

            entity.HasIndex(e => new { e.QuestionUuid, e.GradeUuid })
                .IsUnique()
                .HasDatabaseName("acdm_question_grade_unique");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.QuestionUuid)
                .HasMaxLength(100)
                .HasColumnName("question_uuid");
            entity.Property(e => e.GradeUuid)
                .HasMaxLength(100)
                .HasColumnName("grade_uuid");
            entity.Property(e => e.Difficulty)
                .HasMaxLength(10)
                .HasDefaultValue("medium")
                .HasColumnName("difficulty");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");

            entity.HasOne(d => d.QuestionUu).WithMany(p => p.AcdmQuestionGrades)
                .HasForeignKey(d => d.QuestionUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("acdm_question_grade_question_fkey");

            entity.HasOne(d => d.GradeUu).WithMany(p => p.AcdmQuestionGrades)
                .HasForeignKey(d => d.GradeUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("acdm_question_grade_grade_fkey");
        });

        modelBuilder.Entity<AcdmQuiz>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_quiz_pkey");
            entity.ToTable("acdm_quiz");

            entity.Property(e => e.Uuid).HasMaxLength(100).HasColumnName("uuid");
            entity.Property(e => e.Title).HasMaxLength(200).HasColumnName("title");
            entity.Property(e => e.SubjectUuid).HasMaxLength(100).HasColumnName("subject_uuid");
            entity.Property(e => e.TopicUuid).HasMaxLength(100).HasColumnName("topic_uuid");
            entity.Property(e => e.GradeUuid).HasMaxLength(100).HasColumnName("grade_uuid");
            entity.Property(e => e.QuestionCount).HasColumnName("question_count");
            entity.Property(e => e.TimeLimitSeconds).HasColumnName("time_limit_seconds");
            entity.Property(e => e.MinTimeSeconds).HasColumnName("min_time_seconds");
            entity.Property(e => e.TimeVeryEasy).HasDefaultValue(30).HasColumnName("time_very_easy");
            entity.Property(e => e.TimeEasy).HasDefaultValue(45).HasColumnName("time_easy");
            entity.Property(e => e.TimeMedium).HasDefaultValue(60).HasColumnName("time_medium");
            entity.Property(e => e.TimeHard).HasDefaultValue(90).HasColumnName("time_hard");
            entity.Property(e => e.TimeVeryHard).HasDefaultValue(120).HasColumnName("time_very_hard");
            entity.Property(e => e.AssessmentType).HasMaxLength(30).HasDefaultValue("quiz").HasColumnName("assessment_type");
            entity.Property(e => e.ShowScoreImmediately).HasDefaultValue(true).HasColumnName("show_score_immediately");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby).HasMaxLength(100).HasColumnName("createdby");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby).HasMaxLength(100).HasColumnName("updatedby");

            entity.HasOne(d => d.GradeUu).WithMany()
                .HasForeignKey(d => d.GradeUuid)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("acdm_quiz_grade_fkey");

            entity.HasOne(d => d.SubjectUu).WithMany()
                .HasForeignKey(d => d.SubjectUuid)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("acdm_quiz_subject_fkey");

            entity.HasOne(d => d.TopicUu).WithMany()
                .HasForeignKey(d => d.TopicUuid)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("acdm_quiz_topic_fkey");

            entity.Property(e => e.SchoolUuid).HasMaxLength(100).HasColumnName("school_uuid");
            entity.HasOne(d => d.SchoolUu).WithMany(p => p.AcdmQuizzes)
                .HasForeignKey(d => d.SchoolUuid)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("acdm_quiz_school_uuid_fkey");
        });

        modelBuilder.Entity<AcdmQuizQuestion>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_quiz_question_pkey");
            entity.ToTable("acdm_quiz_question");

            entity.HasIndex(e => new { e.QuizUuid, e.QuestionUuid })
                .IsUnique()
                .HasDatabaseName("acdm_quiz_question_unique");

            entity.Property(e => e.Uuid).HasMaxLength(100).HasColumnName("uuid");
            entity.Property(e => e.QuizUuid).HasMaxLength(100).HasColumnName("quiz_uuid");
            entity.Property(e => e.QuestionUuid).HasMaxLength(100).HasColumnName("question_uuid");
            entity.Property(e => e.QuestionOrder).HasColumnName("question_order");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby).HasMaxLength(100).HasColumnName("createdby");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby).HasMaxLength(100).HasColumnName("updatedby");

            entity.HasOne(d => d.QuizUu).WithMany(p => p.AcdmQuizQuestions)
                .HasForeignKey(d => d.QuizUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("acdm_quiz_question_quiz_fkey");

            entity.HasOne(d => d.QuestionUu).WithMany()
                .HasForeignKey(d => d.QuestionUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("acdm_quiz_question_question_fkey");
        });

        modelBuilder.Entity<AcdmQuizTopic>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_quiz_topic_pkey");
            entity.ToTable("acdm_quiz_topic");

            entity.HasIndex(e => new { e.QuizUuid, e.TopicUuid })
                .IsUnique()
                .HasDatabaseName("uq_quiztopic");

            entity.Property(e => e.Uuid).HasMaxLength(100).HasColumnName("uuid");
            entity.Property(e => e.QuizUuid).HasMaxLength(100).HasColumnName("quiz_uuid");
            entity.Property(e => e.TopicUuid).HasMaxLength(100).HasColumnName("topic_uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby).HasMaxLength(100).HasColumnName("createdby");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby).HasMaxLength(100).HasColumnName("updatedby");

            entity.HasOne(d => d.QuizUu).WithMany(p => p.AcdmQuizTopics)
                .HasForeignKey(d => d.QuizUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("fk_quiztopic_quiz");

            entity.HasOne(d => d.TopicUu).WithMany()
                .HasForeignKey(d => d.TopicUuid)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("fk_quiztopic_topic");
        });

        modelBuilder.Entity<AcdmSchool>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("acdm_school_pkey");
            entity.ToTable("acdm_school");

            entity.HasIndex(e => e.Code).IsUnique().HasDatabaseName("acdm_school_code_unique");

            entity.Property(e => e.Uuid).HasMaxLength(100).HasColumnName("uuid");
            entity.Property(e => e.Name).HasMaxLength(200).HasColumnName("name");
            entity.Property(e => e.Code).HasMaxLength(20).HasColumnName("code");
            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.City).HasMaxLength(100).HasColumnName("city");
            entity.Property(e => e.Province).HasMaxLength(100).HasColumnName("province");
            entity.Property(e => e.PostalCode).HasMaxLength(10).HasColumnName("postal_code");
            entity.Property(e => e.Phone).HasMaxLength(20).HasColumnName("phone");
            entity.Property(e => e.Email).HasMaxLength(150).HasColumnName("email");
            entity.Property(e => e.Website).HasMaxLength(200).HasColumnName("website");
            entity.Property(e => e.PrincipalName).HasMaxLength(150).HasColumnName("principal_name");
            entity.Property(e => e.Accreditation).HasMaxLength(20).HasDefaultValue("Not Yet").HasColumnName("accreditation");
            entity.Property(e => e.SchoolType).HasMaxLength(20).HasDefaultValue("Public").HasColumnName("school_type");
            entity.Property(e => e.EducationLevel).HasMaxLength(10).HasColumnName("education_level");
            entity.Property(e => e.IsActive).HasDefaultValue(true).HasColumnName("is_active");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby).HasMaxLength(100).HasColumnName("createdby");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby).HasMaxLength(100).HasColumnName("updatedby");
        });

        modelBuilder.Entity<ComRole>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("com_roles_pkey");

            entity.ToTable("com_roles");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Rolename)
                .HasMaxLength(100)
                .HasColumnName("rolename");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");
        });

        modelBuilder.Entity<ComUseraccount>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("com_useraccount_pkey");

            entity.ToTable("com_useraccount");

            entity.HasIndex(e => e.Emailaddress, "com_useraccount_emailaddress_key").IsUnique();

            entity.HasIndex(e => e.Emailaddress, "idx_useraccount_email");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Emailaddress)
                .HasMaxLength(100)
                .HasColumnName("emailaddress");
            entity.Property(e => e.Firstname)
                .HasMaxLength(100)
                .HasColumnName("firstname");
            entity.Property(e => e.Isarchived).HasColumnName("isarchived");
            entity.Property(e => e.Lastname)
                .HasMaxLength(100)
                .HasColumnName("lastname");
            entity.Property(e => e.Timezoneid)
                .HasMaxLength(100)
                .HasColumnName("timezoneid");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");
        });

        modelBuilder.Entity<ComUserinrole>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("com_userinrole_pkey");

            entity.ToTable("com_userinrole");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Roleuuid)
                .HasMaxLength(100)
                .HasColumnName("roleuuid");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");
            entity.Property(e => e.Useruuid)
                .HasMaxLength(100)
                .HasColumnName("useruuid");

            entity.HasOne(d => d.Roleuu).WithMany(p => p.ComUserinroles)
                .HasForeignKey(d => d.Roleuuid)
                .HasConstraintName("fk_userinrole_role");

            entity.HasOne(d => d.Useruu).WithMany(p => p.ComUserinroles)
                .HasForeignKey(d => d.Useruuid)
                .HasConstraintName("fk_userinrole_user");
        });

        modelBuilder.Entity<ComUsermembership>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("com_usermembership_pkey");

            entity.ToTable("com_usermembership");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Password)
                .HasMaxLength(200)
                .HasColumnName("password");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");
            entity.Property(e => e.Useruuid)
                .HasMaxLength(100)
                .HasColumnName("useruuid");

            entity.HasOne(d => d.Useruu).WithMany(p => p.ComUsermemberships)
                .HasForeignKey(d => d.Useruuid)
                .HasConstraintName("fk_membership_user");
        });

        modelBuilder.Entity<ComUserrefreshtoken>(entity =>
        {
            entity.HasKey(e => e.Uuid).HasName("com_userrefreshtoken_pkey");

            entity.ToTable("com_userrefreshtoken");

            entity.Property(e => e.Uuid)
                .HasMaxLength(100)
                .HasColumnName("uuid");
            entity.Property(e => e.Createdat).HasColumnName("createdat");
            entity.Property(e => e.Createdby)
                .HasMaxLength(100)
                .HasColumnName("createdby");
            entity.Property(e => e.Refreshtoken).HasColumnName("refreshtoken");
            entity.Property(e => e.Updatedat).HasColumnName("updatedat");
            entity.Property(e => e.Updatedby)
                .HasMaxLength(100)
                .HasColumnName("updatedby");
            entity.Property(e => e.Useruuid)
                .HasMaxLength(100)
                .HasColumnName("useruuid");

            entity.HasOne(d => d.Useruu).WithMany(p => p.ComUserrefreshtokens)
                .HasForeignKey(d => d.Useruuid)
                .HasConstraintName("fk_refreshtoken_user");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

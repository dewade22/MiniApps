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

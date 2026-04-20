using System;
using System.Collections.Generic;

namespace MiniApps.DataAccess.Application;

public partial class AcdmQuiz
{
    public string Uuid { get; set; } = null!;
    public string Title { get; set; } = null!;

    public string? SubjectUuid { get; set; }
    public string? TopicUuid { get; set; }
    public string GradeUuid { get; set; } = null!;

    /// <summary>null = global (admin-created); non-null = school-specific (teacher-created)</summary>
    public string? SchoolUuid { get; set; }

    public int QuestionCount { get; set; }
    public int TimeLimitSeconds { get; set; }
    public int MinTimeSeconds { get; set; }

    public int TimeVeryEasy { get; set; } = 30;
    public int TimeEasy { get; set; } = 45;
    public int TimeMedium { get; set; } = 60;
    public int TimeHard { get; set; } = 90;
    public int TimeVeryHard { get; set; } = 120;

    /// <summary>"quiz" | "daily_test" | "semester_test"</summary>
    public string AssessmentType { get; set; } = "quiz";
    public bool ShowScoreImmediately { get; set; } = true;

    public string Createdby { get; set; } = null!;
    public DateTime Createdat { get; set; }
    public string Updatedby { get; set; } = null!;
    public DateTime Updatedat { get; set; }

    public virtual AcdmSubject? SubjectUu { get; set; }
    public virtual AcdmTopic? TopicUu { get; set; }
    public virtual AcdmGrade GradeUu { get; set; } = null!;
    public virtual AcdmSchool? SchoolUu { get; set; }

    public virtual ICollection<AcdmQuizQuestion> AcdmQuizQuestions { get; set; } = new List<AcdmQuizQuestion>();
    public virtual ICollection<AcdmQuizTopic> AcdmQuizTopics { get; set; } = new List<AcdmQuizTopic>();
}

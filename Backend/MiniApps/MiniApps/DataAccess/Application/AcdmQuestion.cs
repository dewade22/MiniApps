using System;
using System.Collections.Generic;

namespace MiniApps.DataAccess.Application;

public partial class AcdmQuestion
{
    public string Uuid { get; set; } = null!;

    public string QuestionText { get; set; } = null!;

    public string? TopicUuid { get; set; }

    public string CorrectOption { get; set; } = null!;

    public string Createdby { get; set; } = null!;

    public DateTime Createdat { get; set; }

    public string Updatedby { get; set; } = null!;

    public DateTime Updatedat { get; set; }

    public virtual AcdmTopic? TopicUu { get; set; }

    public virtual ICollection<AcdmQuestionOption> AcdmQuestionOptions { get; set; } = new List<AcdmQuestionOption>();

    public virtual ICollection<AcdmQuestionGrade> AcdmQuestionGrades { get; set; } = new List<AcdmQuestionGrade>();
}

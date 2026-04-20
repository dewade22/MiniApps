using System;

namespace MiniApps.DataAccess.Application;

public partial class AcdmQuizQuestion
{
    public string Uuid { get; set; } = null!;
    public string QuizUuid { get; set; } = null!;
    public string QuestionUuid { get; set; } = null!;
    public int QuestionOrder { get; set; }

    public string Createdby { get; set; } = null!;
    public DateTime Createdat { get; set; }
    public string Updatedby { get; set; } = null!;
    public DateTime Updatedat { get; set; }

    public virtual AcdmQuiz QuizUu { get; set; } = null!;
    public virtual AcdmQuestion QuestionUu { get; set; } = null!;
}

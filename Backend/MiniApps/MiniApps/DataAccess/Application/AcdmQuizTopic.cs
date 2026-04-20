using System;

namespace MiniApps.DataAccess.Application;

public partial class AcdmQuizTopic
{
    public string Uuid { get; set; } = null!;
    public string QuizUuid { get; set; } = null!;
    public string TopicUuid { get; set; } = null!;

    public string Createdby { get; set; } = null!;
    public DateTime Createdat { get; set; }
    public string Updatedby { get; set; } = null!;
    public DateTime Updatedat { get; set; }

    public virtual AcdmQuiz QuizUu { get; set; } = null!;
    public virtual AcdmTopic TopicUu { get; set; } = null!;
}

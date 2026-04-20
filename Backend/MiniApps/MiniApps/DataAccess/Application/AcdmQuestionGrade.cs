using System;

namespace MiniApps.DataAccess.Application;

public partial class AcdmQuestionGrade
{
    public string Uuid { get; set; } = null!;

    public string QuestionUuid { get; set; } = null!;

    public string GradeUuid { get; set; } = null!;

    /// <summary>easy | medium | hard</summary>
    public string Difficulty { get; set; } = "medium";

    public string Createdby { get; set; } = null!;

    public DateTime Createdat { get; set; }

    public string Updatedby { get; set; } = null!;

    public DateTime Updatedat { get; set; }

    public virtual AcdmQuestion QuestionUu { get; set; } = null!;

    public virtual AcdmGrade GradeUu { get; set; } = null!;
}

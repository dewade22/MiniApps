using System;

namespace MiniApps.DataAccess.Application;

public partial class AcdmQuestionOption
{
    public string Uuid { get; set; } = null!;

    public string QuestionUuid { get; set; } = null!;

    public string Label { get; set; } = null!;

    public string OptionText { get; set; } = null!;

    public string Createdby { get; set; } = null!;

    public DateTime Createdat { get; set; }

    public string Updatedby { get; set; } = null!;

    public DateTime Updatedat { get; set; }

    public virtual AcdmQuestion QuestionUu { get; set; } = null!;
}

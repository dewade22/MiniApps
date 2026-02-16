using System;
using System.Collections.Generic;

namespace MiniApps.DataAccess.Application;

public partial class AcdmGrade
{
    public string Uuid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Createdby { get; set; } = null!;

    public DateTime Createdat { get; set; }

    public string Updatedby { get; set; } = null!;

    public DateTime Updatedat { get; set; }
}

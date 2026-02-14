using System;
using System.Collections.Generic;

namespace MiniApps.DataAccess.Application;

public partial class ComUsermembership
{
    public string Uuid { get; set; } = null!;

    public string Useruuid { get; set; } = null!;

    public string Password { get; set; } = null!;

    public string Createdby { get; set; } = null!;

    public DateTime Createdat { get; set; }

    public string Updatedby { get; set; } = null!;

    public DateTime Updatedat { get; set; }

    public virtual ComUseraccount Useruu { get; set; } = null!;
}

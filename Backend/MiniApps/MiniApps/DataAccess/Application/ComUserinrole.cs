using System;
using System.Collections.Generic;

namespace MiniApps.DataAccess.Application;

public partial class ComUserinrole
{
    public string Uuid { get; set; } = null!;

    public string Useruuid { get; set; } = null!;

    public string Roleuuid { get; set; } = null!;

    public string Createdby { get; set; } = null!;

    public DateTime Createdat { get; set; }

    public string Updatedby { get; set; } = null!;

    public DateTime Updatedat { get; set; }

    public virtual ComRole Roleuu { get; set; } = null!;

    public virtual ComUseraccount Useruu { get; set; } = null!;
}
